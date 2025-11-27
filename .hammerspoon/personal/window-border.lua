-- Window Border Module
-- Based on: https://gist.github.com/cfe84/901411ee43450e7ee0e50e88cf029f7c

local M = {}

-- === Config ===
local BORDER_WIDTH = 8
local CORNER_RADIUS = 12
local BORDER_COLOR = {red=1, green=0.5, blue=0, alpha=0.8}
local BORDER_DURATION = 3 -- seconds

-- === State ===
local focusBorder = nil
local borderTimer = nil
local wf = nil

-- === Core Border Drawing ===
local function clearBorder()
    if focusBorder and type(focusBorder.delete) == "function" then
        pcall(function()
            focusBorder:delete()
        end)
    end
    focusBorder = nil
end


local function drawBorder(win)
    if not win then return end

    -- Remove old border
    clearBorder()

    -- Draw new border
    local frame = win:frame()
    focusBorder = hs.drawing.rectangle(frame)
    focusBorder:setStrokeColor(BORDER_COLOR)
    focusBorder:setFill(false)
    focusBorder:setStrokeWidth(BORDER_WIDTH)
    focusBorder:setRoundedRectRadii(CORNER_RADIUS, CORNER_RADIUS)
    focusBorder:setLevel("overlay")
    focusBorder:show()

    -- Cancel and reschedule auto-clear
    if borderTimer then borderTimer:stop() end
    borderTimer = hs.timer.doAfter(BORDER_DURATION, clearBorder)
end

-- === Event Handlers ===
local function handleWindowEvent(win)
    drawBorder(win)
end

-- === Public API ===
function M.init()
    -- Set up Event Subscriptions
    wf = hs.window.filter.new():setDefaultFilter()
    wf:subscribe({
        hs.window.filter.windowFocused,
        hs.window.filter.windowMoved,
        hs.window.filter.windowResized,
    }, handleWindowEvent)
end

return M
