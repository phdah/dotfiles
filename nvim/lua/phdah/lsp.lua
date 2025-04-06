---------------
-- LSP --
---------------

-- Setup all lsp with defaults
vim.diagnostic.config({
    virtual_text = { current_line = true },
    signs = false,
})

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

vim.lsp.config.ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
}

vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
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
}

-- Set up the lua-language-server
vim.lsp.config.luals = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
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
}

vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
}

vim.lsp.config.clangd = {
    cmd = { "clangd", "--background-index" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
}

vim.lsp.config.bash = {
    cmd = { "bash-language-server", "start" },
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
        },
    },
    filetypes = { "bash", "sh", "zsh" },
    root_markers = { ".git" },
}

vim.lsp.config.json = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { ".git" },
}

vim.lsp.config.terraform = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars" },
    root_markers = { ".terraform", ".git" },
}

-- All lsp config's are taken from: https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
vim.lsp.enable({
    "luals",
    "pyright",
    "gopls",
    "clangd",
    "ruff",
    "bash",
    "json",
    "terraform",
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
    else
        snacks.notify.info("No available formatter for " .. filetype)
        return
    end
    snacks.notify.info(
        "Formatted file: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    )
    vim.cmd(":noh")
end

-- Create the :Lint command
vim.api.nvim_create_user_command("Lint", function(opts)
    lintFile(opts.args)
end, { nargs = "*" })
