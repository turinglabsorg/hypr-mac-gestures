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
  },
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
