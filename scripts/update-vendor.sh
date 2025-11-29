#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENDOR_DIR="$REPO_ROOT/lib/rpi-rgb-led-matrix"
UPSTREAM_URL="https://github.com/hzeller/rpi-rgb-led-matrix"
TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Cloning latest rpi-rgb-led-matrix..."
git clone --depth 1 "$UPSTREAM_URL" "$TMP_DIR"

echo "Removing old vendored files..."
rm -rf "$VENDOR_DIR"
mkdir -p "$VENDOR_DIR"

# Remove old source files from package root
rm -f "$REPO_ROOT"/*.cc "$REPO_ROOT"/hardware-mapping.c
rm -f "$REPO_ROOT"/framebuffer-internal.h "$REPO_ROOT"/gpio-bits.h "$REPO_ROOT"/gpio.h
rm -f "$REPO_ROOT"/hardware-mapping.h "$REPO_ROOT"/multiplex-mappers-internal.h "$REPO_ROOT"/utf8-internal.h

echo "Copying include files..."
cp -r "$TMP_DIR/include" "$VENDOR_DIR/"
cp "$TMP_DIR/COPYING" "$VENDOR_DIR/"

echo "Copying source files to package root..."
cp "$TMP_DIR"/lib/*.cc "$REPO_ROOT/"
cp "$TMP_DIR"/lib/*.c "$REPO_ROOT/"
cp "$TMP_DIR"/lib/*.h "$REPO_ROOT/"

echo "Done! Vendored files updated from upstream."
echo "Don't forget to commit the changes."
