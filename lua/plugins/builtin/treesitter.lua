return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master", -- FIXED: Forces the stable branch to prevent the crash
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            -- Add languages you need here
            ensure_installed = { "c", "cpp", "go", "lua", "python", "bash", "vim", "vimdoc" },

            auto_install = true,
            sync_install = false,
            
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
