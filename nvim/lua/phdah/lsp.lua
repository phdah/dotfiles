---------------
-- LSP --
---------------
local M = {}

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

function M.switchSourceHeader(bufnr)
    local method_name = "textDocument/switchSourceHeader"
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
    if not client then
        return vim.notify(
            ("method %s is not supported by any servers active on the current buffer"):format(
                method_name
            )
        )
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client.request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify("corresponding file cannot be determined")
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

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

local notifyNoInfo = function()
    require("snacks").notify.info("No information available")
end
vim.lsp.config.pyright = {
    -- Specific handler to remove the `&nbsp;`. Not sure how to resolve it
    -- otherwise...
    handlers = {
        ["textDocument/hover"] = function(_, result, _, config)
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
        end,
    },
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
        or filetype == "css"
    then
        vim.cmd(
            "silent! !prettier --print-width 90 --prose-wrap always --write --tab-width 4 % "
                .. args
        )
    elseif filetype == "yaml" then
        vim.cmd(
            "silent! !prettier --print-width 90 --prose-wrap always --write --tab-width 2 % "
                .. args
        )
    elseif filetype == "terraform" then
        vim.cmd("silent! !terraform fmt % " .. args)
    elseif filetype == "scala" or filetype == "sbt" then
        vim.cmd(
            "silent! !scalafmt --config "
                .. vim.lsp.get_clients({ bufnr = 0 })[1].config.root_dir
                .. "/.scalafmt.conf % "
                .. args
        )
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

return M
