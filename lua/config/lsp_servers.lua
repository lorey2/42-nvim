-- [[ LSP Server Configurations ]]

-- Helper to find the root directory safely
local function get_root(buf_or_name, markers)
    -- 1. Convert buffer number to a filename string if needed
    local fname = buf_or_name
    if type(buf_or_name) == "number" then
        fname = vim.api.nvim_buf_get_name(buf_or_name)
    end

    -- 2. Safety check: If no filename (e.g. empty buffer), use current directory
    if not fname or fname == "" then
        return vim.fn.getcwd()
    end

    -- 3. Search for markers (go.mod, .git, etc.) upward from the file
    local found = vim.fs.find(markers, { path = fname, upward = true })[1]
    if found then
        return vim.fs.dirname(found)
    end

    -- 4. Fallback
    return vim.fn.getcwd()
end

return {
    -- 1. C/C++ (Clangd)
    clangd = {
        cmd = { 'clangd', '--background-index', '--header-insertion=never' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_dir = function(arg)
            return get_root(arg, { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', '.git' })
        end,
    },

    -- 2. Lua (Lua LS)
    lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_dir = function(arg)
            return get_root(arg, { '.luarc.json', '.stylua.toml', '.git' })
        end,
        settings = {
            Lua = {
                workspace = { checkThirdParty = true },
                telemetry = { enable = false },
            },
        },
    },

    -- 3. Go (Gopls)
    gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_dir = function(arg)
            return get_root(arg, { 'go.mod', '.git' })
        end,
        settings = {
            gopls = {
                usePlaceholders = true,
                completeUnimported = true,
                analyses = { unusedparams = true },
            },
        },
    },

-- 4. HTML Support
    html = { 
        cmd = { "vscode-html-language-server", "--stdio" }, -- Add this line
        filetypes = { 'html', 'twig', 'hbs', 'javascriptreact', 'typescriptreact' } 
    },

    -- 5. TypeScript / React Support (ts_ls)
    ts_ls = {
        cmd = { "typescript-language-server", "--stdio" }, -- Add this line
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = function(arg)
            return get_root(arg, { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' })
        end,
    },

	-- Python LSP with settings:

	-- pylsp = {
	-- 	settings = {
	-- 		pylsp = {
	-- 			plugins = {
	-- 				pycodestyle = {
	-- 					enabled = false
	-- 				}
	-- 			}
	-- 		}
	-- 	}
	-- },

	--	-- WARN: rust-analyzer will *only* work in a directory created by 'cargo init'.
	--	--
	-- rust_analyzer = {},
	-- codelldb = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },
	-- ts_ls = {},
}
