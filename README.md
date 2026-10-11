# hypr-mac-gestures

Three-finger trackpad gestures for Hyprland, in the direction macOS uses.

Hyprland 0.55 and newer already follows the fingers one-to-one. This module turns that swipe on and keeps it inside the workspaces you already have. It is a Lua module loaded by your config, not a hyprpm C++ plugin.

## Gestures

| Fingers | Motion | Result |
| --- | --- | --- |
| 3 | left or right | Move to the neighboring workspace. The desktop follows your fingers. |
| 3 | up | Unbound. Hyprland has no Mission Control-style overview. |

One swipe moves one workspace. The desktop follows your fingers. Lift past the middle of the screen and the rest of the travel eases into place. Lift before that and it eases back. Swiping past the last workspace does not create an empty one.

That ease is the workspace slide animation. Keyboard switches such as Super+number use it too.

## Install

Requires Hyprland 0.55 or newer, with the Lua config (`~/.config/hypr/hyprland.lua`).

```sh
git clone https://github.com/turinglabsorg/hypr-mac-gestures.git
cd hypr-mac-gestures
./install.sh
hyprctl reload
hyprctl configerrors
```

`install.sh` symlinks `mac_gestures.lua` to `~/.config/hypr/mac_gestures.lua` and adds this line after `require("hypr.input")`:

```lua
require("hypr.mac_gestures")
```

## Tune

The `config` table at the top of `mac_gestures.lua`:

| Field | Default | Meaning |
| --- | --- | --- |
| `invert` | `true` | The workspace follows your fingers, like a macOS natural swipe. |
| `create_new` | `false` | Stay on workspaces that already exist. |
| `forever` | `false` | One neighboring workspace per swipe. `true` lets one long swipe cross several. |
| `distance` | `200` | Finger travel that drags a workspace across the whole screen. |
| `cancel_ratio` | `0.5` | Lift past this fraction and the switch completes. Below it, the swipe eases back. |
| `swipe_speed` | `3.5` | How long the leftover travel takes, in deciseconds. `3.5` is 350ms. |
| `overview` | `false` | Bind three fingers up. Leave this off until an overview plugin is installed. |

## Overview

Stock Hyprland does not draw a preview of your desktops, and Omarchy does not ship one. Three fingers up is left free so the gesture is not swallowed.

When [hyprview](https://github.com/yz778/hyprview) is loaded, set `overview = true` and reload. Three fingers up then calls `hl.plugin.hyprview.toggle`.

## License

MIT
