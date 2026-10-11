-- Mac-like trackpad gestures for Hyprland 0.55+.
-- Three fingers left or right move between workspaces that already exist.
-- Three fingers up stays unbound: Hyprland has no desktop overview.

local config = {
  fingers = 3,
  -- The workspace follows the fingers, same as a macOS natural swipe.
  invert = true,
  -- Do not mint an empty workspace when the swipe passes the last one.
  create_new = false,
  -- One neighboring workspace per swipe.
  forever = false,
  -- Finger travel, in px, that drags the workspace across the whole screen.
  -- Lower so a normal swipe can reach the halfway point.
  distance = 200,
  -- Past this fraction, lifting the fingers finishes the switch.
  -- 0.5 is the middle of the screen. Below it, the swipe springs back.
  cancel_ratio = 0.5,
  -- Leftover travel after you lift, in deciseconds. 3.5 is 350ms.
  swipe_speed = 3.5,
  -- Bind three fingers up only after an overview plugin is installed.
  overview = false,
}

if type(hl) ~= "table" or type(hl.gesture) ~= "function" or type(hl.config) ~= "function" then
  error("hypr-mac-gestures needs Hyprland 0.55 or newer")
end

hl.config({
  gestures = {
    workspace_swipe_invert = config.invert,
    workspace_swipe_create_new = config.create_new,
    workspace_swipe_forever = config.forever,
    workspace_swipe_distance = config.distance,
    workspace_swipe_cancel_ratio = config.cancel_ratio,
  },
})

-- Without this, Hyprland jumps the rest of the way the moment the fingers lift.
-- The same slide is what Super+number uses to change workspace.
hl.curve("macSwipe", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = config.swipe_speed,
  bezier = "macSwipe",
  style = "slide",
})

hl.gesture({
  fingers = config.fingers,
  direction = "horizontal",
  action = "workspace",
})

if config.overview then
  hl.gesture({
    fingers = config.fingers,
    direction = "up",
    action = function()
      local plugins = hl.plugin
      local hyprview = plugins and plugins.hyprview
      if hyprview and type(hyprview.toggle) == "function" then
        hyprview.toggle("toggle")
        return
      end
      if type(hl.notification) == "table" and hl.notification.create then
        hl.notification.create({
          text = "No desktop overview is installed.",
          timeout = 2500,
          icon = "warning",
        })
      end
    end,
  })
end
