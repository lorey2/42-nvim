return {
  "nvim-treesitter/nvim-treesitter",
  version = false, 
  build = ":TSUpdate",
  branch = "master", -- IMPORTANT: Forces the stable branch to fix your crash
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Add languages you need here
      ensure_installed = { "c", "cpp", "go", "lua", "vim", "vimdoc", "python", "bash" },
      
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
      },
      
      indent = { enable = true },
      
      -- Config for nvim-treesitter-textobjects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    })
  end,
}
