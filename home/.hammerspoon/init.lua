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
