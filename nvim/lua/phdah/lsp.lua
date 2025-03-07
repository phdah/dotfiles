---------------
-- Mason lsp --
---------------
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "ruff",
        "clangd",
        "jsonls",
        "yamlls",
        "bashls",
        "gopls",
        "jdtls",
    },
})

-- Setup all lsp with defaults
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
    function(server_name)
        -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
        if server_name ~= "jdtls" then
            lspconfig[server_name].setup({})
        end
    end,
})
vim.diagnostic.config({ virtual_text = true, signs = false })

-- Hover boarder
local border = "rounded"
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

-- TODO: Figure out how to use ruff as the LSP instead
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup(
        "lsp_attach_disable_ruff_hover",
        { clear = true }
    ),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = "LSP: Disable hover capability from Ruff (https://docs.astral.sh/ruff/editors/setup/#neovim)",
})

local notifyNoInfo = function()
    require("snacks").notify.info("No information available")
end
lspconfig.pyright.setup({
    -- Specific handler to remove the `&nbsp;`. Not sure how to resolve it
    -- otherwise...
    handlers = {
        ["textDocument/hover"] = vim.lsp.with(function(_, result, _, config)
            if not (result and result.contents) then
                notifyNoInfo()
                return
            end
            local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
            contents = vim.split(table.concat(contents, "\n"), "\n", { trimempty = true })
            if vim.tbl_isempty(contents) then
                notifyNoInfo()
                return
            end
            for i, line in ipairs(contents) do
                contents[i] = line:gsub("&nbsp;", " ")
            end
            vim.lsp.util.open_floating_preview(contents, "markdown", config)
        end, { border = border }),
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
            },
            pythonPath = "python3",
        },
    },
})

-- Set up the lua-language-server
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
            telemetry = { enable = false },
        },
    },
})

----------------
-- Metals lsp --
----------------

local metals_config = require("metals").bare_config()

-- Build in automatic setup dap adapter
metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})

----------------
-- Formatters --
----------------
-- Function to set the lint command for filetype
local function lintFile(args)
    local snacks = require("snacks")
    -- Clean out all trailing ExtraWhitespace, and tabs
    local ok, _ = pcall(function()
        vim.cmd("%s/\\t\\+$\\| \\+$//")
    end)
    if ok then
        snacks.notify.info("Found and removed all trailing whitespace")
    end

    -- Save the file first
    vim.cmd("silent! w")

    local filetype = vim.bo.filetype

    -- Run the corresponding formatter based on the filetype
    if filetype == "python" then
        vim.cmd("silent! !ruff format % " .. args)
    elseif filetype == "go" then
        vim.cmd("silent! !gofmt -w % " .. args)
        -- Replace tabs with spaces (treesitter issue)
        -- vim.cmd('silent! %s/\\t/    /g')
    elseif filetype == "sh" then
        vim.cmd("silent! !shfmt -w -i 4 -ci % " .. args)
    elseif
        filetype == "c"
        or filetype == "cpp"
        or filetype == "json"
        or filetype == "java"
    then
        vim.cmd("silent! !clang-format -i % " .. args)
    elseif filetype == "lua" then
        vim.cmd(
            "silent! !stylua --indent-type Spaces --indent-width 4 --column-width 90 % "
                .. args
        )
    elseif filetype == "sql" then
        vim.cmd(
            'silent! !sql-formatter --fix --config \'{"tabWidth": 4, "linesBetweenQueries": 2}\' --language postgresql % '
                .. args
        )
    elseif
        filetype == "markdown"
        or filetype == "typescriptreact"
        or filetype == "typescript"
        or filetype == "javascript"
        or filetype == "yaml"
        or filetype == "css"
    then
        vim.cmd(
            "silent! !prettier --print-width 90 --prose-wrap always --write --tab-width 4 % "
                .. args
        )
    elseif filetype == "terraform" then
        vim.cmd("silent! !terraform fmt % " .. args)
    end
    snacks.notify.info(
        "Formatted file: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    )
end

-- Create the :Lint command
vim.api.nvim_create_user_command("Lint", function(opts)
    lintFile(opts.args)
end, { nargs = "*" })
