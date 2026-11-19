#!/usr/bin/env bash
set -euo pipefail

# Paths and options can be overridden for tests outside Home Assistant.
OPTIONS="${AMULE_OPTIONS:-/data/options.json}"
DATA_DIR="${AMULE_DATA_DIR:-/data}"
WAIT_TRIES="${AMULE_WAIT_TRIES:-36}"

log() { echo "[amule-addon] $*"; }

opt() {
    jq -r --arg k "$1" --arg d "$2" '.[$k] // $d' "$OPTIONS" 2>/dev/null || echo "$2"
}

DOWNLOAD_ROOT="$(opt download_path /media/amule)"
REQUIRE_EXTERNAL_DISK="$(opt require_external_disk false)"
NICK="$(opt nickname HAmule)"
WEB_PASSWORD="$(opt web_password '')"

CONFIG_DIR="$DATA_DIR/amule"
INCOMING_DIR="${DOWNLOAD_ROOT}/Incoming"
TEMP_DIR="${DOWNLOAD_ROOT}/Temp"
CONF="$CONFIG_DIR/amule.conf"

# Only accept folders under /media or /share
case "$DOWNLOAD_ROOT" in
    /media/*|/share/*) ;;
    *) log "ERROR: download_path must be inside /media or /share"; exit 1 ;;
esac
case "$DOWNLOAD_ROOT" in
    *..*|*$'\n'*) log "ERROR: invalid download_path"; exit 1 ;;
esac

# Optional safety check: refuse to start when the folder should be on a separate
# disk that is not connected, instead of filling the system disk.
if [ "$REQUIRE_EXTERNAL_DISK" = "true" ]; then
    BASE_DIR="/$(printf '%s' "$DOWNLOAD_ROOT" | cut -d/ -f2)"
    MOUNT_DIR="$(printf '%s' "$DOWNLOAD_ROOT" | cut -d/ -f1-3)"

    disk_ready() {
        ls -A "$MOUNT_DIR" >/dev/null 2>&1 || return 1
        [ "$(stat -c %d "$MOUNT_DIR")" != "$(stat -c %d "$BASE_DIR")" ] || return 1
        [ "$(stat -f -c %T "$MOUNT_DIR")" != "autofs" ] || return 1
    }

    log "Checking that $MOUNT_DIR is a separate disk"
    tries=0
    until disk_ready; do
        tries=$((tries + 1))
        if [ "$tries" -ge "$WAIT_TRIES" ]; then
            log "ERROR: $MOUNT_DIR is not a separate mounted disk."
            log "Not starting, so that downloads do not fill the system disk."
            log "Connect the disk (Settings > System > Storage) and restart the add-on,"
            log "or turn off 'require_external_disk' if this folder is on the system disk."
            exit 1
        fi
        sleep 5
    done
    log "Disk found at $MOUNT_DIR"
fi

mkdir -p "$CONFIG_DIR" "$INCOMING_DIR" "$TEMP_DIR"

# Web password: the one in the options, otherwise a random one kept in the data folder
if [ -z "$WEB_PASSWORD" ]; then
    PWFILE="$DATA_DIR/web-password"
    if [ ! -s "$PWFILE" ]; then
        head -c 12 /dev/urandom | base64 | tr -d '/+=' > "$PWFILE"
        chmod 600 "$PWFILE"
        log "No web_password set: generated one and saved it in the add-on data folder."
    fi
    WEB_PASSWORD="$(cat "$PWFILE")"
    log "Web interface password: $WEB_PASSWORD  (set 'web_password' in the options to choose your own)"
fi
PW_HASH="$(printf '%s' "$WEB_PASSWORD" | md5sum | cut -d' ' -f1)"

# aMule rewrites amule.conf when it stops, so seed it once and then only enforce
# the few settings this add-on controls.
[ -f "$CONF" ] || { : > "$CONF"; log "First start: creating the aMule configuration"; }
set_conf() { crudini --set "$CONF" "$1" "$2" "$3"; }
seed_conf() { crudini --get "$CONF" "$1" "$2" >/dev/null 2>&1 || set_conf "$1" "$2" "$3"; }

seed_conf eMule Autoconnect 1
seed_conf eMule ConnectToKad 1
seed_conf eMule ConnectToED2K 1
seed_conf eMule UPnPEnabled 0
set_conf eMule Nick "$NICK"
set_conf eMule Port 4662
set_conf eMule UDPPort 4672
set_conf eMule IncomingDir "$INCOMING_DIR"
set_conf eMule TempDir "$TEMP_DIR"
set_conf ExternalConnect AcceptExternalConnections 1
set_conf ExternalConnect ECAddress 127.0.0.1
set_conf ExternalConnect ECPort 4712
set_conf ExternalConnect ECPassword "$PW_HASH"
set_conf WebServer Enabled 1
set_conf WebServer Port 4721
set_conf WebServer Password "$PW_HASH"
set_conf WebServer PasswordLow ""
set_conf WebServer UseGzip 0

PIDS=""
cleanup() {
    log "Stopping"
    # shellcheck disable=SC2086
    [ -n "$PIDS" ] && kill -TERM $PIDS 2>/dev/null || true
    wait 2>/dev/null || true
    exit 0
}
trap cleanup TERM INT

log "Starting aMule daemon and web interface on port 4721 (low priority)"
# amuled starts amuleweb itself because [WebServer] Enabled=1
nice -n 10 amuled -c "$CONFIG_DIR" -o &
PIDS="$!"

wait "$PIDS" || true
log "aMule stopped, exiting so that Home Assistant restarts the add-on"
exit 1
