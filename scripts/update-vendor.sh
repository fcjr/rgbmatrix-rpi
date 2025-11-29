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

echo "Copying new files..."
cp -r "$TMP_DIR/include" "$VENDOR_DIR/"
cp -r "$TMP_DIR/lib" "$VENDOR_DIR/"
cp "$TMP_DIR/COPYING" "$VENDOR_DIR/"

echo "Done! Vendored files updated from upstream."
echo "Don't forget to commit the changes."
