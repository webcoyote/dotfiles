-- https://github.com/dbalatero/nixpkgs/blob/main/home/modules/gui/macos/hammerspoon/config/text-expander.lua

local M = {}

local snippetWatcher = nil

local function buildTrie(snippets)
  local trie = {
    expandFn = nil,
    children = {},
  }

  for shortcode, snippet in pairs(snippets) do
    local currentElement = trie

    -- Loop through each character in the snippet keyword and insert a tree
    -- of nodes into the trie.
    for i = 1, #shortcode do
      local char = shortcode:sub(i, i)

      currentElement.children[char] = currentElement.children[char]
        or {
          expandFn = nil,
          children = {},
        }

      currentElement = currentElement.children[char]

      -- If we're on the last character, save off the snippet function
      -- to the node as well.
      local isLastChar = i == #shortcode

      if isLastChar then
        if type(snippet) == "function" then
          -- If the snippet is a function, just save it off to be called
          -- later.
          currentElement.expandFn = snippet
        else
          -- If the snippet is a static string, convert it to a function so that
          -- everything is uniformly a function.
          currentElement.expandFn = function()
            return snippet
          end
        end
      end
    end
  end

  return trie
end

local shiftedKeymap = {
  ["1"] = "!",
  ["2"] = "@",
  ["3"] = "#",
  ["4"] = "$",
  ["5"] = "%",
  ["6"] = "^",
  ["7"] = "&",
  ["8"] = "*",
  ["9"] = "(",
  ["0"] = ")",
  ["`"] = "~",
  ["-"] = "_",
  ["="] = "+",
  ["["] = "{",
  ["]"] = "}",
  ["\\"] = "|",
  ["/"] = "?",
  [","] = "<",
  ["."] = ">",
  ["'"] = '"',
  [";"] = ":",
}

local unshiftedKeymap = {
  ["!"] = "1",
  ["@"] = "2",
  ["#"] = "3",
  ["$"] = "4",
  ["%"] = "5",
  ["^"] = "6",
  ["&"] = "7",
  ["*"] = "8",
  ["("] = "9",
  [")"] = "0",
  ["~"] = "`",
  ["_"] = "-",
  ["+"] = "=",
  ["{"] = "[",
  ["}"] = "]",
  ["|"] = "\\",
  ["?"] = "/",
  ["<"] = ",",
  [">"] = ".",
  ['"'] = "'",
  [":"] = ";",
}

-- Returns a table with a key down and key up event for a given (mods, key)
-- key press.
local function keySequence(mods, key)
  return {
    hs.eventtap.event.newKeyEvent(mods, key, true),
    hs.eventtap.event.newKeyEvent(mods, key, false),
  }
end

function M.init(config)
  local snippets = config and config.snippets or {}
  local snippetTrie = buildTrie(snippets)
  local numPresses = 0
  local currentTrieNode = snippetTrie

  if snippetWatcher then
    snippetWatcher:stop()
    snippetWatcher = nil
  end

  snippetWatcher = hs.eventtap.new(
    { hs.eventtap.event.types.keyDown },
    function(event)
      local keyPressed = hs.keycodes.map[event:getKeyCode()]

      if event:getFlags():containExactly({ "shift" }) then
        -- Convert the keycode to the shifted version of the key,
        -- e.g. "=" turns into "+", etc.
        keyPressed = shiftedKeymap[keyPressed] or keyPressed
      end

      local shouldFireSnippet = keyPressed == "return" or keyPressed == "space"

      local reset = function()
        currentTrieNode = snippetTrie
        numPresses = 0
      end

      if currentTrieNode.expandFn then
        if shouldFireSnippet then
          local keyEventsToPost = {}

          -- Delete backwards however many times a key has been typed, to remove
          -- the snippet "+keyword"
          for i = 1, numPresses do
            keyEventsToPost =
              hs.fnutils.concat(keyEventsToPost, keySequence({}, "delete"))
          end

          -- Call the snippet's function to get the snippet expansion.
          local textToWrite = currentTrieNode.expandFn()

          for i = 1, textToWrite:len() do
            local char = textToWrite:sub(i, i)
            local flags = {}

            -- If you encounter a shifted character, like "*", you have to convert
            -- it back to its modifiers + keycode form.
            --
            -- Example:
            --   If char == "*"
            --   Send `shift + 8` instead.
            if unshiftedKeymap[char] then
              flags = { "shift" }
              char = unshiftedKeymap[char]
            end

            keyEventsToPost =
              hs.fnutils.concat(keyEventsToPost, keySequence(flags, char))
          end

          -- Send along the keypress that activated the snippet (either space or
          -- return).
          -- hs.eventtap.keyStroke(event:getFlags(), keyPressed, 0)
          keyEventsToPost = hs.fnutils.concat(
            keyEventsToPost,
            keySequence(event:getFlags(), event:getKeyCode())
          )

          -- Reset our pointers back to the beginning to get ready for the next
          -- snippet.
          reset()

          -- Don't pass thru the original keypress, and return our replacement key
          -- events instead.
          return true, keyEventsToPost
        else
          reset()
          return false
        end
      end

      if currentTrieNode.children[keyPressed] then
        currentTrieNode = currentTrieNode.children[keyPressed]
        numPresses = numPresses + 1
      else
        reset()
      end

      return false
    end
  )

  snippetWatcher:start()
end

return M
