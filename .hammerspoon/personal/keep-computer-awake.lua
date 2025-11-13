-- Keep Computer Awake Module
-- Keep computer awake: https://www.hammerspoon.org/go/#simplemenubar

local M = {}

local caffeine = hs.menubar.new()

local function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("☕️")
  else
    caffeine:setTitle("🥱")
  end
end

local function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function M.init()
  if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
  end
end

return M
