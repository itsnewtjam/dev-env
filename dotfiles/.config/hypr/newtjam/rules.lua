local float_rules = {
  {
    width = 30,
    height = 54,
    patterns = {
      "%(Bitwarden.*Password Manager%) %- Bitwarden",
      "^Bitwarden$",
    },
  },
  {
    width = 25,
    height = 54,
    patterns = {
      "^Sign In %- Google Accounts",
    },
  },
}

local function matches(title, rule)
  for _, pattern in ipairs(rule.patterns) do
    if title:match(pattern) then return true end
  end
  return false
end

hl.on("window.title", function(window)
  local title = window.title or ""
  for _, rule in ipairs(float_rules) do
    if matches(title, rule) then
      local monitor = hl.get_active_monitor()
      if not monitor then return end

      hl.dispatch(hl.dsp.window.float({ window = window, action = "on" }))
      hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
      hl.dispatch(hl.dsp.window.resize({
        window = window,
        x = math.floor(monitor.width * rule.width / 100),
        y = math.floor(monitor.height * rule.height / 100),
      }))
      return
    end
  end
end)

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
