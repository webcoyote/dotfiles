-- Hammerspoon Configuration
print("--------------------")

-- Load configuration
local config = require('personal.config').load()

-- Initialize modules
require('personal.vim-mode').init()
require('personal.window-border').init()
require('personal.dim-background-windows').init()
require('personal.text-expander').init(config.textExpander)
-- require('personal.app-launcher').init()
-- require('personal.defeat-paste-blocking').init()
-- require('personal.keep-computer-awake').init()
-- require('personal.wifi-watcher').init(config.wifi)


-- https://news.ycombinator.com/item?id=47368116
-- Set window size based on the next two keys pressed
hs.hotkey.bind({"option", "ctrl"}, "D", function()
    hs.grid.ui.textSize = 40
    hs.grid.setGrid('10x3')
    hs.grid.show()
end)

-- hs.hotkey.bind({'cmd'}, 'M', function()
    -- hs.alert.show("Hammerspoon ignoring minimize", 1)
-- end)
