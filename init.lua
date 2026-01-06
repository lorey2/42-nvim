-- [[ Init.lua - Main Entry Point ]]

-- 1. Load basic settings (Leader key, options)
require("config.vim_settings")

-- 2. Bootstrap lazy.nvim (The Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("plugins")

-- 4. Load Configuration (LSP, Treesitter, etc.)
require("config")
