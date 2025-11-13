-- Configuration Module
-- Loads and parses config.json

local M = {}

function M.load()
  local configPath = hs.configdir .. "/config.json"

  -- Check if config file exists
  local file = io.open(configPath, "r")
  if not file then
    hs.alert.show("Config file not found: " .. configPath)
    return {}
  end

  -- Read and parse JSON
  local content = file:read("*a")
  file:close()

  local success, config = pcall(hs.json.decode, content)
  if not success then
    hs.alert.show("Error parsing config.json: " .. tostring(config))
    return {}
  end

  return config
end

return M
