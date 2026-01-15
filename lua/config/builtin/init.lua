--[[ Built-ins config loader. ]]--

local config = ... .. "."

-- Load Telescope Settings.
require(config .. "_telescope")

local status, err = pcall(require, "config.builtin._treesitter")
if not status then
    print("Treesitter not found yet, skipping loading...")
end

-- Load LSP Settings.
require(config .. "_lsp")

-- Load Autocompletion Settings.
require(config .. "_cmp")

-- Load File Tree Settings.
require(config .. "_neo-tree")

-- Load Lua Line Extensions
require(config .. "_lualine")
