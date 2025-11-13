-- Dim Background Windows Module
-- Makes inactive windows dimmer

local M = {}

function M.init()
  hs.window.highlight.ui.overlay = true
  hs.window.highlight.start()
end

return M
