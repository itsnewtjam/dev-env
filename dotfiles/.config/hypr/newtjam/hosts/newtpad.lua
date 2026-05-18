hl.monitor({
  output = "eDP-1",
  mode = "1920x1080",
  position = "auto",
  scale = 1.25,
})

hl.device({
  name = "tpps/2-elan-trackpoint",
  enabled = true,
})

hl.device({
  name = "synps/2-synaptics-touchpad",
  enabled = true,
})
