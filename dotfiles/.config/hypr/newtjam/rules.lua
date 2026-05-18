hl.window_rule({
  match = {
    class = "org.mozilla.Thunderbird",
  },
  workspace = "1",
})
hl.window_rule({
  match = {
    class = "firefox",
  },
  workspace = "3",
})
hl.window_rule({
  match = {
    class = "com.mitchellh.ghostty",
  },
  workspace = "4",
})
hl.window_rule({
  match = {
    class = "org.kde.dolphin",
  },
  workspace = "5",
})
hl.window_rule({
  match = {
    class = "gimp",
  },
  workspace = "6",
})

hl.window_rule({
  match = {
    modal = true,
  },
  float = true,
  center = true,
})
hl.window_rule({
  match = {
    class = "org.mozilla.Thunderbird",
    initial_title = "Write:.*",
  },
  float = true,
  center = true,
})

hl.window_rule({
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})
