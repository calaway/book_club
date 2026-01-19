#!/usr/bin/env bash
# Nextcloud backup from Raspberry Pi → Mac (run on your Mac)
# - Enables maintenance mode on the Pi (snap install)
# - Rsyncs the data directory to local destination
# - Disables maintenance mode (even on errors)
# - Logs everything to a timestamped file

set -euo pipefail

### ====== USER SETTINGS ======
# Remote (Pi)
REMOTE_USER="calaway"
REMOTE_HOST="rphs"
SSH_PORT="22"                   # change if non-standard
SSH_KEY=""                      # optional, e.g. "$HOME/.ssh/id_ed25519"
REMOTE_DATA_DIR="/mnt/calaway_1tb/nextcloud/data/"  # trailing slash IMPORTANT

# Local (Mac)
LOCAL_DEST="$HOME/Backups/Nextcloud/data/"          # trailing slash recommended
LOG_DIR="$HOME/Backups/Nextcloud/logs"

# Behavior
DELETE_ON_DEST="true"          # mirror deletions (set "false" to keep extras)
USE_COMPRESSION="true"         # -z compression (helpful over Wi-Fi)
PRESERVE_HARDLINKS="true"      # --hard-links
DRY_RUN="false"                # "true" → show what would happen, no changes
### ===========================

# Build convenience strings
timestamp() { date +"%Y-%m-%d_%H-%M-%S"; }
LOG_FILE="${LOG_DIR}/backup_${HOSTNAME}_$(timestamp).log"

mkdir -p "$LOG_DIR" "$LOCAL_DEST"

# Command availability checks
command -v ssh >/dev/null 2>&1 || { echo "ssh not found"; exit 1; }
command -v rsync >/dev/null 2>&1 || { echo "rsync not found"; exit 1; }

# SSH options
SSH_OPTS=(-p "$SSH_PORT" -o BatchMode=yes -o StrictHostKeyChecking=accept-new)
[[ -n "$SSH_KEY" ]] && SSH_OPTS+=(-i "$SSH_KEY")

# Helper to run a remote command on the Pi
remote() {
  ssh "${SSH_OPTS[@]}" "${REMOTE_USER}@${REMOTE_HOST}" "$@"
}

echo "=== Nextcloud rsync backup started: $(date) ===" | tee -a "$LOG_FILE"

# Determine initial maintenance mode state
echo "[*] Checking maintenance mode status on remote..." | tee -a "$LOG_FILE"
MAINT_STATUS="$(remote "sudo nextcloud.occ config:system:get maintenance 2>&1" || true)"
echo "Maintenance mode status: $MAINT_STATUS" | tee -a "$LOG_FILE"
WAS_MAINT_ENABLED="false"
if [[ "$MAINT_STATUS" == "true" ]] || [[ "$MAINT_STATUS" == "1" ]]; then
  WAS_MAINT_ENABLED="true"
  echo "[i] Maintenance mode already enabled on remote." | tee -a "$LOG_FILE"
fi

# Ensure we turn maintenance OFF if we turned it ON
CLEANUP_NEEDED="false"
cleanup() {
  # Always attempt to turn maintenance mode off only if we enabled it
  if [[ "$CLEANUP_NEEDED" == "true" ]]; then
    echo "[*] Disabling maintenance mode on remote (cleanup)..." | tee -a "$LOG_FILE"
    if remote "sudo nextcloud.occ maintenance:mode --off"; then
      echo "[✓] Maintenance mode disabled (cleanup)." | tee -a "$LOG_FILE"
    else
      echo "[!] Failed to disable maintenance mode during cleanup." | tee -a "$LOG_FILE"
    fi
  fi
  echo "=== Backup finished: $(date) ===" | tee -a "$LOG_FILE"
}
trap cleanup EXIT

# Enable maintenance mode if not already enabled
if [[ "$WAS_MAINT_ENABLED" == "false" ]]; then
  echo "[*] Enabling maintenance mode on remote..." | tee -a "$LOG_FILE"
  remote "sudo nextcloud.occ maintenance:mode --on" | tee -a "$LOG_FILE"
  CLEANUP_NEEDED="true"
fi

# Assemble rsync flags
RSYNC_FLAGS=(--archive --no-owner --no-group --info=progress2)
[[ "$USE_COMPRESSION" == "true" ]] && RSYNC_FLAGS+=(--compress)
[[ "$PRESERVE_HARDLINKS" == "true" ]] && RSYNC_FLAGS+=(--hard-links)
[[ "$DELETE_ON_DEST" == "true" ]] && RSYNC_FLAGS+=(--delete)
[[ "$DRY_RUN" == "true" ]] && RSYNC_FLAGS+=(--dry-run --verbose)

# Compose remote shell and rsync path (sudo on remote)
RSYNC_RSH=("ssh" "${SSH_OPTS[@]}")
RSYNC_PATH="sudo rsync"

echo "[*] Starting rsync..." | tee -a "$LOG_FILE"
echo "    Source:      ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DATA_DIR}" | tee -a "$LOG_FILE"
echo "    Destination: ${LOCAL_DEST}" | tee -a "$LOG_FILE"
echo "    Log:         ${LOG_FILE}" | tee -a "$LOG_FILE"

# Run rsync
rsync \
  "${RSYNC_FLAGS[@]}" \
  --rsh="$(printf '%q ' "${RSYNC_RSH[@]}")" \
  --rsync-path="$RSYNC_PATH" \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DATA_DIR}" \
  "$LOCAL_DEST" \
  2>&1 | tee -a "$LOG_FILE"

echo "[✓] Rsync completed." | tee -a "$LOG_FILE"

# Turn off maintenance mode if we turned it on
if [[ "$CLEANUP_NEEDED" == "true" ]]; then
  echo "[*] Disabling maintenance mode on remote..." | tee -a "$LOG_FILE"
  remote "sudo nextcloud.occ maintenance:mode --off" | tee -a "$LOG_FILE"
  CLEANUP_NEEDED="false"
fi
