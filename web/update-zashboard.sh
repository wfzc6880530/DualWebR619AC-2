#!/bin/sh
# Update the independently hosted Zashboard static frontend from its official release.
set -eu
URL="https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip"
DEST="/www/dualweb/zashboard"
TMP="/tmp/zashboard-update.$$"
BACKUP="/www/dualweb/zashboard.previous"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT HUP INT TERM

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "ERROR: unzip is required." >&2; exit 1; }
mkdir -p "$TMP/unpacked"
echo "[1/5] Downloading official Zashboard release..."
curl -fL --retry 3 --connect-timeout 15 "$URL" -o "$TMP/dist.zip"
unzip -tq "$TMP/dist.zip"
unzip -q "$TMP/dist.zip" -d "$TMP/unpacked"
INDEX="$(find "$TMP/unpacked" -type f -name index.html -print -quit)"
[ -n "$INDEX" ] || { echo "ERROR: archive contains no index.html; existing panel untouched." >&2; exit 1; }
SOURCE_DIR="$(dirname "$INDEX")"
mkdir -p "$TMP/new"
cp -a "$SOURCE_DIR/." "$TMP/new/"
test -s "$TMP/new/index.html"

echo "[2/5] Staging new dashboard..."
rm -rf "$BACKUP"
[ ! -d "$DEST" ] || mv "$DEST" "$BACKUP"
if ! mv "$TMP/new" "$DEST"; then
    [ ! -d "$BACKUP" ] || mv "$BACKUP" "$DEST"
    echo "ERROR: install failed; previous dashboard restored." >&2
    exit 1
fi

echo "[3/5] Validating Nginx..."
if ! nginx -t; then
    rm -rf "$DEST"
    [ ! -d "$BACKUP" ] || mv "$BACKUP" "$DEST"
    /etc/init.d/nginx restart >/dev/null 2>&1 || true
    echo "ERROR: Nginx validation failed; previous dashboard restored." >&2
    exit 1
fi

echo "[4/5] Reloading Nginx..."
/etc/init.d/nginx reload || /etc/init.d/nginx restart
echo "[5/5] Update complete. Open http://192.168.5.254/ and select OpenClash 代理面板."
echo "Backup retained at $BACKUP; remove it after confirming the dashboard works."
