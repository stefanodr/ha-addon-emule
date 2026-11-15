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

RESOLUTION="$(opt resolution 1600x900)"
DOWNLOAD_ROOT="$(opt download_path /media/emule)"
INSTALL_VCREDIST="$(opt install_vcredist false)"

export DISPLAY=:0
export WINEPREFIX=/data/wine
export WINEARCH=win64
export WINEDEBUG=-all
export WINE=/usr/lib/wine/wine64
WINESERVER="$(command -v wineserver || echo /usr/lib/wine/wineserver64)"

CONFIG_DIR=/data/emule-config
INCOMING_DIR="${DOWNLOAD_ROOT}/Incoming"
TEMP_DIR="${DOWNLOAD_ROOT}/Temp"

mkdir -p "$CONFIG_DIR" "$INCOMING_DIR" "$TEMP_DIR" "$WINEPREFIX"

# ---------------------------------------------------------------- display
log "Starting virtual display (${RESOLUTION})"
Xvfb :0 -screen 0 "${RESOLUTION}x24" -nolisten tcp &
for _ in $(seq 1 50); do
    [ -e /tmp/.X11-unix/X0 ] && break
    sleep 0.2
done

openbox &
x11vnc -display :0 -localhost -nopw -forever -shared -rfbport 5900 -noxdamage -quiet &
websockify --web /opt/novnc 8099 localhost:5900 &

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

# ---------------------------------------------------------------- run eMule
STOP=0
cleanup() {
    STOP=1
    log "Stopping"
    pkill -TERM -f emule.exe 2>/dev/null || true
    "$WINESERVER" -k 2>/dev/null || true
}
trap cleanup TERM INT

while [ "$STOP" -eq 0 ]; do
    log "Starting eMule"
    "$WINE" /opt/emule/emule.exe -c "$(win_path "$CONFIG_DIR")" &
    EMULE_PID=$!
    wait "$EMULE_PID" || true
    [ "$STOP" -eq 1 ] && break
    log "eMule exited, restarting in 5 seconds"
    sleep 5
done
