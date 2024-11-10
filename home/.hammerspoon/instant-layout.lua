function plainTextMatch (a, b)
  return string.find(a, b, 1, true)
end

function axHotfix(win)
  if not win then win = hs.window.frontmostWindow() end

  local axApp = hs.axuielement.applicationElement(win:application())
  local wasEnhanced = axApp.AXEnhancedUserInterface
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = false
  end

  return function()
    if wasEnhanced then
      axApp.AXEnhancedUserInterface = true
    end
  end
end

function withAxHotfix(fn, position)
  if not position then position = 1 end
  return function(...)
    local args = {...}
    local revert = axHotfix(args[position])
    fn(...)
    revert()
  end
end

-- Monkey Patch metatable for wrapping functions that need the animation fix
local windowMT = hs.getObjectMetatable("hs.window")
windowMT.setFrame = withAxHotfix(windowMT.setFrame)

function instantlayoutApply (windowLayout, windowTitleComparator)
  local previous = hs.window.animationDuration
  hs.window.animationDuration = 0
  hs.layout.apply(windowLayout, windowTitleComparator)
  hs.window.animationDuration = previous
end
