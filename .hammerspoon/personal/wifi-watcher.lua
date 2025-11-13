-- WiFi Watcher Module
-- React to WiFi events: http://www.hammerspoon.org/go/#wifievents
-- Automatically adjusts volume when joining/leaving home network

local M = {}

local wifiWatcher = nil
local homeSSID = nil
local homeVolume = 25
local awayVolume = 0
local lastSSID = hs.wifi.currentNetwork()

local function ssidChangedCallback()
  local newSSID = hs.wifi.currentNetwork()

  if newSSID == homeSSID and lastSSID ~= homeSSID then
    -- We just joined our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(homeVolume)
    print("wifi: home")
  elseif newSSID ~= homeSSID and lastSSID == homeSSID then
    -- We just departed our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(awayVolume)
    print("wifi: other")
  end

  lastSSID = newSSID
end

function M.init(config)
  if not config or not config.homeSSID then
    print("WiFi watcher: homeSSID not configured, skipping wifi watcher initialization")
    return
  end

  homeSSID = config.homeSSID
  homeVolume = config.homeVolume or 25
  awayVolume = config.awayVolume or 0
  wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
  wifiWatcher:start()
end

return M
