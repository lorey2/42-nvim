-- [[ 1. Configure Keybinds (LspAttach) ]]
-- In Nvim 0.11, we use an autocommand instead of passing 'on_attach' to every server.
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        -- Helper function to make mapping easier
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        
        -- Lesser used LSP functionality
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
            vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        -- Optional: nvim-navic support (Winbar)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local status, navic = pcall(require, "nvim-navic")
        if status and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, event.buf)
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
    end,
})

-- [[ 2. Diagnostic Configuration ]]
vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = {
        severity = { 
            -- ERROR: min = "WARN" (Fixed below)
            min = vim.diagnostic.severity.WARN, 
            max = vim.diagnostic.severity.ERROR 
        }
    },
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        prefix = function(diagnostic)
            if vim.g.have_nerd_font == false then
                return '●'
            end
            local icons = {
                [vim.diagnostic.severity.ERROR] = ' ',
                [vim.diagnostic.severity.WARN] = ' ',
                [vim.diagnostic.severity.INFO] = ' ',
                [vim.diagnostic.severity.HINT] = ' ',
            }
            return icons[diagnostic.severity]
        end
    },
}

-- [[ 3. Configure Servers (Robust Manual Method) ]]
local servers = require("config.lsp_servers")

-- 1. Setup Capabilities (for nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- 2. Ensure Binaries are Installed (Mason)
local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_ok then
    mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers)
    }
end

-- 3. Force-Start Servers using Autocommands
for server_name, server_opts in pairs(servers) do
    -- Add the capabilities to the server options
    server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
    -- Ensure the server has a name (required for vim.lsp.start logs)
    server_opts.name = server_name

    -- Create an Autocommand for the specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
        pattern = server_opts.filetypes, -- e.g. {'go', 'gomod'}
        callback = function(ev)
            -- "vim.lsp.start" safely reuses the client if it's already running.
            -- It returns the client_id or nil if it failed.
            local client_id = vim.lsp.start(server_opts, { bufnr = ev.buf })
            
            -- Debugging: Uncomment the line below if it still fails
            -- if not client_id then vim.notify("Failed to start " .. server_name) end
        end,
    })
end
