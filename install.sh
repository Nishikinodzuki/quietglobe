#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SHA256="0529ccf32617804cdd245a7a61615f8e5a4236a7712d84ea9c377b2cf583e180"
URL="https://github.com/Nishikinodzuki/quietglobe/releases/download/v${VERSION}/QuietGlobe-${VERSION}.zip"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading QuietGlobe ${VERSION}..."
curl -fL --retry 3 -o "$tmp/QuietGlobe.zip" "$URL"

echo "${SHA256}  $tmp/QuietGlobe.zip" | shasum -a 256 -c -

ditto -x -k "$tmp/QuietGlobe.zip" "$tmp/unpacked"
app="$tmp/unpacked/QuietGlobe.app"
test -d "$app"

if [ -n "${INSTALL_DIR:-}" ]; then
  dest="$INSTALL_DIR"
  mkdir -p "$dest"
elif [ -w /Applications ]; then
  dest="/Applications"
else
  dest="$HOME/Applications"
  mkdir -p "$dest"
fi

if [ -z "${INSTALL_DIR:-}" ]; then
  osascript -e 'tell application "QuietGlobe" to quit' >/dev/null 2>&1 || true
fi

rm -rf "$dest/QuietGlobe.app"
ditto "$app" "$dest/QuietGlobe.app"
xattr -dr com.apple.quarantine "$dest/QuietGlobe.app" 2>/dev/null || true

echo "Installed: $dest/QuietGlobe.app"
echo
echo "Next:"
echo "1. Grant Accessibility in System Settings → Privacy & Security → Accessibility."
echo "2. Set the Globe key to \"Change Input Source\" in System Settings → Keyboard."
echo "3. Press 🌐."
echo
echo "If macOS blocks the app: System Settings → Privacy & Security → Open Anyway."

if [ -z "${NO_OPEN:-}" ]; then
  open "$dest/QuietGlobe.app"
fi
