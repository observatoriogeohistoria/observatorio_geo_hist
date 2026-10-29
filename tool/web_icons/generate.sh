#!/usr/bin/env bash
# Generates the icons and the share image in web/ from the pages
# in this folder, "photographed" by Google Chrome in headless mode.
#
# Usage: tool/web_icons/generate.sh [output_dir]
# With no argument, writes straight to web/. Only needs to run again if the brand
# (assets/images/logo.svg) changes; remember to keep these pages' SVGs in sync.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/../.." && pwd)"
OUT="${1:-$ROOT/web}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT/icons"

# shot <page?params> <width> <height> <file> [transparent]
shot() {
  local page="$1" width="$2" height="$3" file="$4" background="${5:-}"
  local extra=()
  if [[ "$background" == "transparent" ]]; then
    extra+=(--default-background-color=00000000)
  fi
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=1 --allow-file-access-from-files \
    --virtual-time-budget=3000 \
    --window-size="$width,$height" ${extra[@]+"${extra[@]}"} \
    --screenshot="$file" "file://$DIR/$page" >/dev/null 2>&1
  local w h
  w=$(sips -g pixelWidth "$file" | awk '/pixelWidth/ {print $2}')
  h=$(sips -g pixelHeight "$file" | awk '/pixelHeight/ {print $2}')
  if [[ "$w" != "$width" || "$h" != "$height" ]]; then
    echo "Unexpected size in $file: ${w}x${h} (expected ${width}x${height})" >&2
    exit 1
  fi
  echo "ok  $file (${w}x${h})"
}

# Small icons are rendered at 512 and scaled down with sips, because
# headless Chrome won't open windows smaller than a few hundred pixels.
shrink() {
  local source="$1" size="$2" file="$3"
  cp "$source" "$file"
  sips -z "$size" "$size" "$file" >/dev/null
  echo "ok  $file (${size}x${size})"
}

shot "icon.html" 512 512 "$OUT/icons/Icon-512.png" transparent
shrink "$OUT/icons/Icon-512.png" 192 "$OUT/icons/Icon-192.png"
shrink "$OUT/icons/Icon-512.png" 32 "$OUT/favicon.png"

shot "maskable.html" 512 512 "$OUT/icons/Icon-maskable-512.png"
shrink "$OUT/icons/Icon-maskable-512.png" 192 "$OUT/icons/Icon-maskable-192.png"

shot "icon.html?background=white" 512 512 "$TMP/apple-512.png"
shrink "$TMP/apple-512.png" 180 "$OUT/icons/apple-touch-icon.png"

shot "og.html" 1200 630 "$OUT/og-image.png"

# Vector tab icon: the brand without fixed width/height.
sed -e 's/ width="34" height="34"//' "$ROOT/assets/images/logo.svg" > "$OUT/favicon.svg"
echo "ok  $OUT/favicon.svg"
