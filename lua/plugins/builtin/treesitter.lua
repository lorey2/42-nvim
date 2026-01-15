return {
  {
    -- Main Treesitter Engine
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- This is where your main treesitter setup goes
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        -- Add any other treesitter settings you had here
      })
    end,
  },
  {
    -- Treesitter Extensions (Must load AFTER the main engine)
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
