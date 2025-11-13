-- Hammerspoon Configuration
print("--------------------")

-- Load configuration
-- local config = require('personal.config').load()

-- Initialize modules
require('personal.dim-background-windows').init()
require('personal.vim-mode').init()
require('personal.app-launcher').init()
-- require('personal.defeat-paste-blocking').init()
-- require('personal.keep-computer-awake').init()
-- require('personal.wifi-watcher').init(config.wifi)
