-- VimMode Module
-- Configures VimMode spoon for system-wide vim bindings

local M = {}

function M.init()
  local VimMode = hs.loadSpoon('VimMode')
  vim = VimMode:new()

  vim
    :disableForApp('Code')
    :disableForApp('MacVim')
    :disableForApp('zoom.us')
    :disableForApp('Sublime Text')
    :enterWithSequence('jk')
end

return M
