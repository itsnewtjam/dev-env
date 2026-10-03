local function popup(win, x, y)
  x = x or 450
  y = y or 600
  hl.dispatch(hl.dsp.window.resize({ x = x, y = y, window = win }))
  hl.dispatch(hl.dsp.window.center({ window = win }))
  hl.dispatch(hl.dsp.focus({ window = win }))
end

hl.on("window.open", function(w)
  if w.class ~= "firefox" then return end
  if w.initial_title ~= "Mozilla Firefox" then return end

  local ff_windows = hl.get_windows({ class = "firefox" })
  if #ff_windows <= 1 then return end

  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
    if tw.address ~= w.address then return end
    if tw.title == ""
      or tw.title == "Mozilla Firefox"
      or tw.title == "about:blank"
      or tw.title:match("^about:.*Mozilla Firefox$") then return end

    sub:remove()

    if tw.title:match("^Extension:")
      or tw.title:match("^Sign in %- Google Accounts") then
      popup(tw)
    else
      hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
    end
  end)
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
