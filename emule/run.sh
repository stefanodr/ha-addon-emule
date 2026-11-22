#!/usr/bin/env bash
set -euo pipefail

OPTIONS=/data/options.json

log() { echo "[emule-addon] $*"; }

opt() {
    jq -r --arg k "$1" --arg d "$2" '.[$k] // $d' "$OPTIONS" 2>/dev/null || echo "$2"
}

# Convert a Linux path to the Wine drive Z: (e.g. /media/emule -> Z:\media\emule)
win_path() {
    local p="${1//\//\\}"
    printf 'Z:%s' "$p"
}

# set_ini FILE SECTION KEY VALUE: set a key in a Windows-style ini file.
# Creates the section/key when missing and keeps CRLF line endings.
set_ini() {
    local f="$1" sec="$2" key="$3" val="$4" tmp
    tmp="$(mktemp)"
    awk -v sec="[$sec]" -v key="$key" -v val="$val" '
    {
        raw = $0
        eol = (raw ~ /\r$/) ? "\r" : ""
        le = eol
        line = raw; sub(/\r$/, "", line); sub(/^\357\273\277/, "", line)
        if (line ~ /^\[.*\]$/) {
            if (insec && !done) { print key "=" val eol; done = 1 }
            insec = (tolower(line) == tolower(sec))
            if (insec) found = 1
            print raw; next
        }
        if (insec && !done && index(line, "=") > 0) {
            k = line; sub(/=.*/, "", k); gsub(/^[ \t]+|[ \t]+$/, "", k)
            if (tolower(k) == tolower(key)) { print key "=" val eol; done = 1; next }
        }
        print raw
    }
    END {
        if (insec && !done) print key "=" val le
        else if (!found) { print sec le; print key "=" val le }
    }' "$f" > "$tmp" && cat "$tmp" > "$f"
    rm -f "$tmp"
}

# get_ini FILE SECTION KEY: print the value, nothing if missing.
get_ini() {
    awk -v sec="[$2]" -v key="$3" '
    { line = $0; sub(/\r$/, "", line); sub(/^\357\273\277/, "", line)
      if (line ~ /^\[.*\]$/) { insec = (tolower(line) == tolower(sec)); next }
      if (insec && index(line, "=") > 0) {
        k = line; sub(/=.*/, "", k); gsub(/^[ \t]+|[ \t]+$/, "", k)
        if (tolower(k) == tolower(key)) { v = line; sub(/^[^=]*=/, "", v); print v; exit }
      } }' "$1"
}

RESOLUTION="$(opt resolution 1600x900)"
DOWNLOAD_ROOT="$(opt download_path /media/emule)"
INSTALL_VCREDIST="$(opt install_vcredist false)"
REQUIRE_EXTERNAL_DISK="$(opt require_external_disk false)"
NICKNAME="$(opt nickname '')"
WEB_SERVER="$(opt web_server false)"
WEB_PASSWORD="$(opt web_password '')"
WATCHDOG="$(opt watchdog true)"

export DISPLAY=:0
export WINEPREFIX=/data/wine
export WINEARCH=win64
export WINEDEBUG=-all
export WINE=/usr/lib/wine/wine64
WINESERVER="$(command -v wineserver || echo /usr/lib/wine/wineserver64)"

CONFIG_DIR=/data/emule-config
INCOMING_DIR="${DOWNLOAD_ROOT}/Incoming"
TEMP_DIR="${DOWNLOAD_ROOT}/Temp"

# Optional safety check: when the download folder is meant to live on a separate
# disk (for example a USB drive shown under /media), refuse to start if that disk
# is missing. Otherwise mkdir would silently create the folders on the system disk.
if [ "$REQUIRE_EXTERNAL_DISK" = "true" ]; then
    BASE_DIR="/$(printf '%s' "$DOWNLOAD_ROOT" | cut -d/ -f2)"     # e.g. /media
    MOUNT_DIR="$(printf '%s' "$DOWNLOAD_ROOT" | cut -d/ -f1-3)"   # e.g. /media/Volume

    disk_ready() {
        # listing the folder also triggers a systemd automount, if there is one
        ls -A "$MOUNT_DIR" >/dev/null 2>&1 || return 1
        [ "$(stat -c %d "$MOUNT_DIR")" != "$(stat -c %d "$BASE_DIR")" ] || return 1
        [ "$(stat -f -c %T "$MOUNT_DIR")" != "autofs" ] || return 1
    }

    log "Checking that $MOUNT_DIR is a separate disk"
    tries=0
    until disk_ready; do
        tries=$((tries + 1))
        if [ "$tries" -ge 36 ]; then
            log "ERROR: $MOUNT_DIR is not a separate mounted disk."
            log "Not starting, so that downloads do not fill the system disk."
            log "Connect the disk (it must be listed under Settings > System > Storage) and restart the add-on,"
            log "or turn off 'require_external_disk' if this folder is meant to be on the system disk."
            exit 1
        fi
        sleep 5
    done
    log "Disk found at $MOUNT_DIR"
fi

mkdir -p "$CONFIG_DIR" "$INCOMING_DIR" "$TEMP_DIR" "$WINEPREFIX"

# ---------------------------------------------------------------- display
log "Starting virtual display (${RESOLUTION})"
Xvfb :0 -screen 0 "${RESOLUTION}x24" -nolisten tcp &
for _ in $(seq 1 50); do
    [ -e /tmp/.X11-unix/X0 ] && break
    sleep 0.2
done

openbox &
# Rely on the X DAMAGE extension and slow polling when idle to keep CPU usage low
start_vnc() {
    x11vnc -display :0 -localhost -nopw -forever -shared -rfbport 5900 \
        -wait 50 -defer 50 -nap -quiet &
    VNC_PID=$!
}
start_novnc() {
    websockify --web /opt/novnc 8099 localhost:5900 &
    NOVNC_PID=$!
}
start_vnc
start_novnc

# ---------------------------------------------------------------- wine prefix
if [ ! -f /data/.wine-initialized ]; then
    log "Creating Wine prefix (first start, this can take a minute)"
    "$WINE" wineboot --init || log "wineboot reported an error, continuing"
    touch /data/.wine-initialized
fi

if [ "$INSTALL_VCREDIST" = "true" ] && [ ! -f /data/.vcredist-installed ]; then
    log "Installing Visual C++ runtime with winetricks"
    if winetricks -q vcrun2019; then
        touch /data/.vcredist-installed
    else
        log "winetricks failed, eMule will start anyway"
    fi
fi

# ---------------------------------------------------------------- eMule config
if [ ! -f "$CONFIG_DIR/preferences.ini" ]; then
    log "First start: seeding default eMule configuration"
    cp -an /opt/emule/config/. "$CONFIG_DIR"/
    cat > "$CONFIG_DIR/preferences.ini" <<EOF
[eMule]
IncomingDir=$(win_path "$INCOMING_DIR")
TempDir=$(win_path "$TEMP_DIR")
Port=4662
UDPPort=4672
Autoconnect=1
EOF
fi

# eMule may ignore -c and fall back to folders next to emule.exe (inside the
# container, lost on update). Point those defaults to persistent locations.
link_dir() {
    local target="$1" link="$2"
    if [ -e "$link" ] && [ ! -L "$link" ]; then
        rm -rf "$link"
    fi
    ln -sfn "$target" "$link"
}
link_dir "$CONFIG_DIR" /opt/emule/config
link_dir "$INCOMING_DIR" /opt/emule/incoming
link_dir "$TEMP_DIR" /opt/emule/temp

# ---------------------------------------------------------------- options -> preferences.ini
PREFS="$CONFIG_DIR/preferences.ini"
if [ -n "$NICKNAME" ]; then
    set_ini "$PREFS" eMule Nick "$NICKNAME"
    log "Nickname set to '$NICKNAME'"
fi
if [ "$WEB_SERVER" = "true" ]; then
    if [ -z "$WEB_PASSWORD" ]; then
        PWFILE=/data/web-password
        if [ ! -s "$PWFILE" ]; then
            head -c 12 /dev/urandom | base64 | tr -d '/+=' > "$PWFILE"
            chmod 600 "$PWFILE"
        fi
        WEB_PASSWORD="$(cat "$PWFILE")"
        log "No web_password set: using a generated one, kept in the add-on data folder."
        log "Web interface password: $WEB_PASSWORD  (set 'web_password' in the options to choose your own)"
    fi
    set_ini "$PREFS" WebServer Enabled 1
    set_ini "$PREFS" WebServer Port 4711
    set_ini "$PREFS" WebServer Password "$(printf '%s' "$WEB_PASSWORD" | md5sum | cut -d' ' -f1)"
    log "eMule web server enabled on port 4711 (set a host port for 4711/tcp in the Network tab to reach it)"
fi

# ---------------------------------------------------------------- watchdog
# Every minute: restart the remote-desktop helpers if they died, and restart
# eMule if it is running but its TCP port has not been listening for 5 checks.
port_listening() {
    local hex
    hex="$(printf '%04X' "$1")"
    grep -qiE ":${hex} .* 0A " /proc/net/tcp /proc/net/tcp6 2>/dev/null
}

watchdog() {
    local bad=0 up=0 port
    while sleep 60; do
        kill -0 "$VNC_PID" 2>/dev/null || { log "Watchdog: restarting x11vnc"; start_vnc; }
        kill -0 "$NOVNC_PID" 2>/dev/null || { log "Watchdog: restarting the remote desktop proxy"; start_novnc; }
        if pgrep -f emule.exe >/dev/null 2>&1; then
            up=$((up + 1))
            [ "$up" -lt 5 ] && continue            # grace period after start
            port="$(get_ini "$PREFS" eMule Port | tr -dc '0-9')"
            [ -n "$port" ] || continue
            if port_listening "$port"; then
                bad=0
            else
                bad=$((bad + 1))
                if [ "$bad" -ge 5 ]; then
                    log "Watchdog: eMule is not listening on port $port, restarting it"
                    pkill -TERM -f emule.exe 2>/dev/null || true
                    "$WINESERVER" -k 2>/dev/null || true
                    bad=0; up=0
                fi
            fi
        else
            up=0; bad=0
        fi
    done
}

# ---------------------------------------------------------------- run eMule
STOP=0
cleanup() {
    STOP=1
    log "Stopping"
    [ -n "$WATCHDOG_PID" ] && kill "$WATCHDOG_PID" 2>/dev/null || true
    pkill -TERM -f emule.exe 2>/dev/null || true
    "$WINESERVER" -k 2>/dev/null || true
}
trap cleanup TERM INT

WATCHDOG_PID=""
if [ "$WATCHDOG" = "true" ]; then
    watchdog &
    WATCHDOG_PID=$!
fi

while [ "$STOP" -eq 0 ]; do
    log "Starting eMule"
    # Low priority: eMule is a background downloader, other services come first
    nice -n 10 "$WINE" /opt/emule/emule.exe -c "$(win_path "$CONFIG_DIR")" &
    EMULE_PID=$!
    # wineserver is started on demand by Wine: give it the same priority
    (
        sleep 5
        for p in $(pgrep -f wineserver 2>/dev/null); do
            renice -n 10 -p "$p" >/dev/null 2>&1 || true
        done
    ) &
    wait "$EMULE_PID" || true
    [ "$STOP" -eq 1 ] && break
    log "eMule exited, restarting in 5 seconds"
    sleep 5
done
