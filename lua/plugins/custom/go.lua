return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        -- Tell go.nvim NOT to try setting up gopls, we did it already.
        lsp_cfg = false, 
        -- Enable formatting
        lsp_gofumpt = true, 
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':GoInstallBinaries'
  },

  -- 2. Ensure Treesitter highlights Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },
}
