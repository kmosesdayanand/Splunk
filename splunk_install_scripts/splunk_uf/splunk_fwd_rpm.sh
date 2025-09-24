#!/bin/bash
# Splunk Universal Forwarder Installation Script (with sudoers-fix)
# Must run as root. Ensures /etc/sudoers.d files have correct perms before installing fragment.
# Author: Moses Dayanand + modifications by Jarvis

set -euo pipefail

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] This script must be run as root."
    exit 1
fi

PARENT_DIR="$(pwd)"
RPM_FILE="$PARENT_DIR/splunkforwarder-9.2.0-1fff88043d5f.x86_64.rpm"
SPLUNK_HOME="/opt/splunkforwarder"
APP_SRC="$PARENT_DIR/apps"
SUDOERS_SRC="$PARENT_DIR/splunkfwd"            # your sudoers fragment in working directory
SUDOERS_DST="/etc/sudoers.d/splunkfwd"

echo "[STEP 0a] Fixing permissions in /etc/sudoers.d if any bad ones exist..."
for f in /etc/sudoers.d/*; do
    [ -f "$f" ] || continue
    mode=$(stat -c "%a" "$f")
    if [ "$mode" != "440" ]; then
        echo "  Fixing $f (mode $mode → 0440, owner root:root)"
        chown root:root "$f"
        chmod 0440 "$f"
    fi
done

echo "[STEP 0b] Validating global sudoers (after fixes)..."
if ! visudo -c >/dev/null 2>&1; then
    echo "[ERROR] visudo global check failed even after fixing existing files."
    visudo -c || true
    exit 1
fi
echo "[OK] Existing sudoers fragments have correct permissions."

echo "[STEP 0] Validate sudoers fragment (if present at $SUDOERS_SRC)..."
if [ -f "$SUDOERS_SRC" ]; then
    if ! visudo -c -f "$SUDOERS_SRC" >/dev/null 2>&1; then
        echo "[ERROR] Syntax error in sudoers fragment $SUDOERS_SRC. Aborting."
        visudo -c -f "$SUDOERS_SRC" || true
        exit 1
    fi
    echo "[OK] Fragment syntax looks good."
else
    echo "[WARN] No sudoers fragment found at $SUDOERS_SRC — skipping sudoers install."
fi

echo "[STEP 1] Checking if Splunk is already installed..."
if [ -d "$SPLUNK_HOME" ]; then
    echo "[WARN] Splunk already exists at $SPLUNK_HOME"
    exit 1
fi

echo "[STEP 2] Copying Splunk RPM into /opt..."
cp "$RPM_FILE" /opt/ || { echo "[ERROR] Failed to copy RPM"; exit 1; }

echo "[STEP 3] Installing Splunk UF..."
rpm -i /opt/"$(basename "$RPM_FILE")" || { echo "[ERROR] RPM installation failed"; exit 1; }

echo "[STEP 4] Copying apps into Splunk apps directory..."
cp -r "$APP_SRC"/* "$SPLUNK_HOME/etc/apps/" || { echo "[ERROR] Failed to copy apps"; exit 1; }

echo "[STEP 5] Setting ownership to splunkfwd user..."
chown -R splunkfwd:splunkfwd "$SPLUNK_HOME"

if [ -f "$SUDOERS_SRC" ]; then
    echo "[STEP 6] Installing sudoers fragment to $SUDOERS_DST..."

    mkdir -p /etc/sudoers.d

    tmp_dest="${SUDOERS_DST}.tmp"
    cp "$SUDOERS_SRC" "$tmp_dest" || { echo "[ERROR] Failed to copy fragment to tmp"; exit 1; }

    chown root:root "$tmp_dest"
    chmod 0440 "$tmp_dest"

    if ! visudo -c -f "$tmp_dest" >/dev/null 2>&1; then
        echo "[ERROR] visudo reports syntax error in fragment. Aborting."
        visudo -c -f "$tmp_dest" || true
        rm -f "$tmp_dest"
        exit 1
    fi

    mv "$tmp_dest" "$SUDOERS_DST"
    chown root:root "$SUDOERS_DST"
    chmod 0440 "$SUDOERS_DST"

    if ! visudo -c >/dev/null 2>&1; then
        echo "[ERROR] visudo global check failed after installing $SUDOERS_DST. Reverting."
        rm -f "$SUDOERS_DST"
        visudo -c || true
        exit 1
    fi

    echo "[OK] Sudoers fragment installed and validated."
else
    echo "[STEP 6] No sudoers fragment to install — skipping."
fi

echo "[STEP 7] Starting Splunk as splunkfwd user (with seeded credentials)..."
sudo -u splunkfwd "$SPLUNK_HOME/bin/splunk" start --accept-license --answer-yes

echo "[STEP 8] Waiting 60 seconds for Splunk to stabilize..."
sleep 60

echo "[STEP 9] Stopping Splunk before boot-start..."
sudo -u splunkfwd "$SPLUNK_HOME/bin/splunk" stop

echo "[STEP 10] Enabling boot-start for splunkfwd user..."
"$SPLUNK_HOME/bin/splunk" enable boot-start -systemd-managed 1 -user splunkfwd -group splunkfwd

echo "[STEP 11] Starting Splunk via systemctl..."
sudo systemctl daemon-reload || true
sudo systemctl start SplunkForwarder || { echo "[ERROR] Failed to start SplunkForwarder"; exit 1; }

echo "[STEP 12] Waiting 60 seconds for Splunk to stabilize..."
sleep 60

echo "[STEP 13] Collecting Splunk info..."
STATUS=$(systemctl is-active SplunkForwarder.service || echo "unknown")
VERSION=$(sudo -u splunkfwd "$SPLUNK_HOME/bin/splunk" version 2>&1 | grep -v "Attempting to revert the SPLUNK_HOME ownership")
APP_NAMES=$(ls -1 "$SPLUNK_HOME/etc/apps" || true)

echo -e "\n==== Splunk Installation Summary ===="
printf "%-20s %-40s\n" "Status:" "$STATUS"
printf "%-20s %-40s\n" "Version:" "$VERSION"
printf "%-20s\n" "Installed Apps:"
echo "$APP_NAMES" | sed 's/^/  - /'
echo "====================================="

echo -
