hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  general = {
    border_size = 0,
    gaps_in = 0,
    gaps_out = 0,
    layout = "dwindle",
  },
  decoration = {
    dim_modal = true,
    dim_inactive = true,
    dim_strength = 0.2,
    blur = {
      enabled = true,
      size = 5,
      passes = 3,
      vibrancy = 0.1696,
    },
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },
  },
  animations = {
    enabled = true,
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    focus_on_activate = true,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  dwindle = {
    preserve_split = true
  },
})

hl.monitor({
  output = "",
  mode = "1920x1080",
  position = "auto",
  scale = 1,
})

require("newtjam.animations")
require("newtjam.input")
require("newtjam.binds")
require("newtjam.rules")
require("newtjam.autostart")

local h = io.popen("uname -n")
if h ~= nil then
  local hostname = h:read("*a") or ""
  h:close()
  hostname = string.gsub(hostname, "\n$", "")

  require("newtjam.hosts." .. hostname)
end

