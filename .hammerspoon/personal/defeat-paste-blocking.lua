-- Defeat Paste Blocking Module
-- Defeat paste-blocking: https://www.hammerspoon.org/go/#pasteblock

local M = {}

function M.init()
  hs.hotkey.bind({"cmd", "alt"}, "V", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end)
end

return M
