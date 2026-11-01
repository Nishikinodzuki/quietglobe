#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
APP="$ROOT/QuietGlobe.app"

rm -rf "$BUILD" "$APP"
mkdir -p "$BUILD/arm64" "$BUILD/x86_64" "$APP/Contents/MacOS" "$APP/Contents/Resources"

build_arch() {
  local arch="$1"
  local out="$2"
  swiftc -O \
    -target "${arch}-apple-macos13.0" \
    "$ROOT"/Sources/*.swift \
    -o "$out" \
    -framework Carbon \
    -framework CoreGraphics \
    -framework AppKit \
    -framework ApplicationServices \
    -framework ServiceManagement
}

build_arch arm64 "$BUILD/arm64/QuietGlobe"
build_arch x86_64 "$BUILD/x86_64/QuietGlobe"

lipo -create \
  "$BUILD/arm64/QuietGlobe" \
  "$BUILD/x86_64/QuietGlobe" \
  -output "$APP/Contents/MacOS/QuietGlobe"

cp "$ROOT/Resources/Info.plist" "$APP/Contents/Info.plist"
cp "$ROOT/Resources/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
printf 'APPL????' > "$APP/Contents/PkgInfo"

IDENTITY="${CODESIGN_IDENTITY:--}"
codesign --force --deep --sign "$IDENTITY" "$APP"

echo "Built $APP"
