#!/usr/bin/env bash
set -euo pipefail

# The two variables below can be overridden only for local testing
OPTIONS="${HAMEDIA_OPTIONS:-/data/options.json}"
DATA_DIR="${HAMEDIA_DATA_DIR:-/data}"
WAIT_TRIES="${HAMEDIA_WAIT_TRIES:-36}"

log() { echo "[hamedia-addon] $*"; }

opt() {
    jq -r --arg k "$1" --arg d "$2" '.[$k] // $d' "$OPTIONS" 2>/dev/null || echo "$2"
}

SERVER_NAME="$(opt server_name HaMedia)"
PORT="$(opt port 8200)"
MEDIA_TYPE="$(opt media_type all)"
REQUIRE_EXTERNAL_DISK="$(opt require_external_disk false)"
RESCAN_ON_START="$(opt rescan_on_start true)"
mapfile -t MEDIA_DIRS < <(jq -r '.media_dirs[]? // empty' "$OPTIONS" 2>/dev/null || true)

# friendly_name: single line, at most 64 characters
SERVER_NAME="$(printf '%s' "$SERVER_NAME" | tr -d '\r\n' | cut -c1-64)"
[ -n "$SERVER_NAME" ] || SERVER_NAME="HaMedia"

case "$MEDIA_TYPE" in
    video)    PREFIX="V," ;;
    audio)    PREFIX="A," ;;
    pictures) PREFIX="P," ;;
    *)        PREFIX="" ;;
esac

# ---------------------------------------------------------------- folders
# Only folders under /media or /share are allowed, so the rest of the
# container (including the add-on data) can never be published by mistake.
VALID_DIRS=()
for d in "${MEDIA_DIRS[@]}"; do
    d="${d%/}"
    case "$d" in
        *..*|*$'\n'*|*$'\r'*)
            log "Ignoring '$d': not a valid path"
            continue ;;
        /media|/media/*|/share|/share/*) ;;
        *)
            log "Ignoring '$d': only folders under /media or /share are allowed"
            continue ;;
    esac
    VALID_DIRS+=("$d")
done

if [ "${#VALID_DIRS[@]}" -eq 0 ]; then
    log "ERROR: no valid folder in 'media_dirs'. Set at least one folder under /media or /share."
    exit 1
fi

# ---------------------------------------------------------------- disk check
# Optional: wait for the external disk (a separate mounted disk under /media)
# before starting, so the library is not built from an empty mount point.
disk_ready() {
    local mount_dir="$1" base_dir="$2"
    # listing the folder also triggers a systemd automount, if there is one
    ls -A "$mount_dir" >/dev/null 2>&1 || return 1
    [ "$(stat -c %d "$mount_dir")" != "$(stat -c %d "$base_dir")" ] || return 1
    [ "$(stat -f -c %T "$mount_dir")" != "autofs" ] || return 1
}

if [ "$REQUIRE_EXTERNAL_DISK" = "true" ]; then
    for d in "${VALID_DIRS[@]}"; do
        base_dir="/$(printf '%s' "$d" | cut -d/ -f2)"     # e.g. /media
        mount_dir="$(printf '%s' "$d" | cut -d/ -f1-3)"   # e.g. /media/Volume
        log "Checking that $mount_dir is a separate disk"
        tries=0
        until disk_ready "$mount_dir" "$base_dir"; do
            tries=$((tries + 1))
            if [ "$tries" -ge "$WAIT_TRIES" ]; then
                log "ERROR: $mount_dir is not a separate mounted disk."
                log "Connect the disk (it must be listed under Settings > System > Storage) and restart the add-on,"
                log "or turn off 'require_external_disk' if this folder is on the system disk."
                exit 1
            fi
            sleep 5
        done
        log "Disk found at $mount_dir"
    done
fi

# ---------------------------------------------------------------- config
mkdir -p "$DATA_DIR/db"
CONF="$DATA_DIR/minidlna.conf"

{
    echo "port=$PORT"
    echo "friendly_name=$SERVER_NAME"
    echo "db_dir=$DATA_DIR/db"
    echo "inotify=yes"
    echo "notify_interval=300"
    echo "strict_dlna=no"
    for d in "${VALID_DIRS[@]}"; do
        if [ -d "$d" ]; then
            echo "media_dir=${PREFIX}${d}"
            log "Publishing $d (${MEDIA_TYPE})" >&2
        else
            log "WARNING: $d does not exist, skipping it" >&2
        fi
    done
} > "$CONF"

if ! grep -q '^media_dir=' "$CONF"; then
    log "ERROR: none of the configured folders exists. Check 'media_dirs' and that the disk is mounted."
    exit 1
fi

RESCAN=""
[ "$RESCAN_ON_START" = "true" ] && RESCAN="-r"

log "Starting MiniDLNA as '$SERVER_NAME' on port $PORT"
log "Status page: http://<IP-of-Home-Assistant>:$PORT/"
# exec: MiniDLNA becomes the main process and receives stop signals directly
exec minidlnad -S -f "$CONF" -P /run/minidlna.pid $RESCAN
