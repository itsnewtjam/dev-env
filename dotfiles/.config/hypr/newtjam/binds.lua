local function mod_key(key)
  return "SUPER + " .. key
end

hl.bind(
  mod_key("SHIFT + Escape"),
  hl.dsp.exec_cmd("hyprctl reload && hyprctl notify -1 3000 0 \"Config reloaded\"")
)
hl.bind(mod_key("SHIFT + B"), hl.dsp.exec_cmd("pkill waybar && waybar &"))
hl.bind(mod_key("SHIFT + F"), hl.dsp.window.float())
hl.bind(mod_key("SHIFT + P"), function()
  if (hl.get_active_window().pinned) then
    hl.dispatch(hl.dsp.window.float())
  else
    hl.dispatch(hl.dsp.window.float())
    hl.dispatch(hl.dsp.window.pin())
    hl.dispatch(hl.dsp.window.resize({ x = 500, y = 281 }))
    hl.dispatch(hl.dsp.window.move({
      x = (hl.get_active_monitor().width / hl.get_active_monitor().scale) - 500,
      y = 30,
      relative = false,
    }))
  end
end)
hl.bind(mod_key("SHIFT + A"), hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mod_key("Q"), hl.dsp.window.kill())
hl.bind(mod_key("M"), hl.dsp.exit())
hl.bind(
  mod_key("Space"),
  hl.dsp.exec_cmd("rofi -show combi -combi-modes \"drun,power:~/.config/rofi/powermenu\" -modes combi")
)
hl.bind(
  mod_key("SHIFT + Space"),
  hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history")
)
hl.bind(mod_key("Escape"), hl.dsp.exec_cmd("hyprlock"))
hl.bind(
  "Print",
  hl.dsp.exec_cmd("if area=$(slurp); then grim -g \"$area\" - | tee >(wl-copy) && dunstify \"Screenshot copied to clipboard\"; fi")
)
hl.bind(
  "SHIFT + Print",
  hl.dsp.exec_cmd("if area=$(slurp); then grim -g \"$area\" \"$HOME/screenshots/$(date +%F_%T)_s.png\" && dunstify \"Screenshot saved\"; fi")
)

hl.bind(mod_key("left"), hl.dsp.focus({ direction = "left" }))
hl.bind(mod_key("right"), hl.dsp.focus({ direction = "right" }))
hl.bind(mod_key("up"), hl.dsp.focus({ direction = "up" }))
hl.bind(mod_key("down"), hl.dsp.focus({ direction = "down" }))
hl.bind(mod_key("H"), hl.dsp.focus({ direction = "left" }))
hl.bind(mod_key("L"), hl.dsp.focus({ direction = "right" }))
hl.bind(mod_key("K"), hl.dsp.focus({ direction = "up" }))
hl.bind(mod_key("J"), hl.dsp.focus({ direction = "down" }))

hl.bind(mod_key("1"), hl.dsp.focus({ workspace = 1 }))
hl.bind(mod_key("2"), hl.dsp.focus({ workspace = 2 }))
hl.bind(mod_key("3"), hl.dsp.focus({ workspace = 3 }))
hl.bind(mod_key("4"), hl.dsp.focus({ workspace = 4 }))
hl.bind(mod_key("5"), hl.dsp.focus({ workspace = 5 }))
hl.bind(mod_key("6"), hl.dsp.focus({ workspace = 6 }))
hl.bind(mod_key("7"), hl.dsp.focus({ workspace = 7 }))
hl.bind(mod_key("8"), hl.dsp.focus({ workspace = 8 }))
hl.bind(mod_key("9"), hl.dsp.focus({ workspace = 9 }))
hl.bind(mod_key("0"), hl.dsp.focus({ workspace = 10 }))

hl.bind(mod_key("SHIFT + 1"), hl.dsp.window.move({ workspace = 1 }))
hl.bind(mod_key("SHIFT + 2"), hl.dsp.window.move({ workspace = 2 }))
hl.bind(mod_key("SHIFT + 3"), hl.dsp.window.move({ workspace = 3 }))
hl.bind(mod_key("SHIFT + 4"), hl.dsp.window.move({ workspace = 4 }))
hl.bind(mod_key("SHIFT + 5"), hl.dsp.window.move({ workspace = 5 }))
hl.bind(mod_key("SHIFT + 6"), hl.dsp.window.move({ workspace = 6 }))
hl.bind(mod_key("SHIFT + 7"), hl.dsp.window.move({ workspace = 7 }))
hl.bind(mod_key("SHIFT + 8"), hl.dsp.window.move({ workspace = 8 }))
hl.bind(mod_key("SHIFT + 9"), hl.dsp.window.move({ workspace = 9 }))
hl.bind(mod_key("SHIFT + 0"), hl.dsp.window.move({ workspace = 10 }))

hl.bind(mod_key("SHIFT + H"), hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod_key("SHIFT + L"), hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod_key("SHIFT + K"), hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod_key("SHIFT + J"), hl.dsp.window.swap({ direction = "down" }))

hl.bind(mod_key("ALT + H"), hl.dsp.window.move({ direction = "left" }))
hl.bind(mod_key("ALT + L"), hl.dsp.window.move({ direction = "right" }))
hl.bind(mod_key("ALT + K"), hl.dsp.window.move({ direction = "up" }))
hl.bind(mod_key("ALT + J"), hl.dsp.window.move({ direction = "down" }))

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5% && if [[ $(pactl get-sink-volume @DEFAULT_SINK@ | grep -o -E '[0-9]{1,3}%' | head -1 | tr -d '%') -gt 100 ]]; then pactl set-sink-volume @DEFAULT_SINK@ 100%; fi"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle; notif=$(pactl -- get-source-mute @DEFAULT_SOURCE@) | hyprctl notify -1 3000 0 $notif"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
  { locked = true, repeating = true }
)

hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  { locked = true }
)
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  { locked = true }
)
