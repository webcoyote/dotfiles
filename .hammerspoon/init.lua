
-- Make inactive windows dimmer
hs.window.highlight.ui.overlay = true
hs.window.highlight.start()

-- Defeat paste-blocking: https://www.hammerspoon.org/go/#pasteblock
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- keep computer awake: https://www.hammerspoon.org/go/#simplemenubar
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("AWAKE")
    else
        caffeine:setTitle("SLEEPY")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- React to WiFi events: http://www.hammerspoon.org/go/#wifievents
