#!/bin/sh
# Link this module into the Hyprland user config and load it once.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
hypr_dir="$config_home/hypr"
dest="$hypr_dir/mac_gestures.lua"
hyprland="$hypr_dir/hyprland.lua"

if [ ! -f "$hyprland" ]; then
  echo "hypr-mac-gestures: $hyprland not found" >&2
  exit 1
fi

mkdir -p "$hypr_dir"
ln -sfn "$root/mac_gestures.lua" "$dest"

if grep -q 'require("hypr.mac_gestures")' "$hyprland"; then
  echo "hypr-mac-gestures: already required in $hyprland"
else
  tmp=$(mktemp)
  awk '
    !inserted && $0 ~ /require\("hypr\.input"\)/ {
      print
      print "require(\"hypr.mac_gestures\")"
      inserted = 1
      next
    }
    { print }
    END {
      if (!inserted) {
        print "require(\"hypr.mac_gestures\")"
      }
    }
  ' "$hyprland" > "$tmp"
  mv "$tmp" "$hyprland"
  echo "hypr-mac-gestures: added require to $hyprland"
fi

echo "hypr-mac-gestures: linked $dest"
echo "reload with: hyprctl reload"
