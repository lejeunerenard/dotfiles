require('hs.ipc')
hs.loadSpoon('SpoonInstall')
require('instant-layout')

spoon.SpoonInstall.repos.ShiftIt = {
   url = "https://github.com/peterklijn/hammerspoon-shiftit",
   desc = "ShiftIt spoon repository",
   branch = "master",
}

spoon.SpoonInstall:andUse("ShiftIt", { repo = "ShiftIt" })
spoon.ShiftIt:bindHotkeys({})

-- Layouts
mainScreen = 'Cinema HD'

function layoutRocketLeague (sessionName)
  local screen = mainScreen
  local windowLayout = {
    {"Brave", "Live Tracker - Rocket League Tracker - Brave", screen, { x = 0.5, y = 0, w = 0.5, h = 0.5 }, nil, nil},
    {"Brave", sessionName, screen, { x = 0, y = 0, w = 0.5, h = 1 }, nil, nil},
    {"iTerm", nil, screen, { x = 0.5, y = 0.5, w = 0.5, h = 0.5 }, nil, nil}
  }
  instantlayoutApply(windowLayout, plainTextMatch)
end

-- Shortcuts
function focusWindow ()
  local currentWin = hs.window.focusedWindow()

  local wins = hs.window.visibleWindows()
  for _, win in ipairs(wins) do
    if win ~= currentWin then
      win:application():hide()
    end
  end
end

hs.hotkey.bind({"cmd", "shift"}, "H", function()
  focusWindow()
end)
