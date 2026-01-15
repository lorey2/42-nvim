return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        
        -- Useful status updates for LSP
        { 'j-hui/fidget.nvim', opts = {} },

        -- Lua development config
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {}
        },
        -- Capabilities for completion (assuming you use nvim-cmp)
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- 1. Setup Mason (Package Manager)
        require('mason').setup()

        -- 2. Setup Mason-LSPConfig
        -- We explicitly REMOVE 'clangd' from this list so Mason doesn't try to download the broken binary
        require('mason-lspconfig').setup({
            ensure_installed = { 
                "lua_ls", 
                "gopls", 
                "pyright" 
                -- Add other servers here (html, cssls, etc.)
                -- DO NOT add "clangd" here
            },
        })

        -- 3. Define Capabilities (for auto-completion)
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')

        -- 4. Automatic Setup for Mason-Installed Servers
        require('mason-lspconfig').setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
        })

        -- 5. MANUAL Setup for Clangd (NixOS Fix)
        -- This forces Neovim to use the binary from your system ($PATH)
        lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = { "clangd" }, 
        })
    end
}
