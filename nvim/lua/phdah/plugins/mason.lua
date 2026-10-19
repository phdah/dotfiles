local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "mason.nvim", "mason-tool-installer.nvim" })

    require("mason").setup({})
    require("mason-tool-installer").setup({
        ensure_installed = {
            -- formatters
            "clang-format",
            "prettier",
            "rumdl",
            "shfmt",
            "sqruff",
            "stylua",

            -- linters
            "ruff",
            "actionlint",

            -- debuggers
            "codelldb",
            "delve",

            -- tools / servers
            "tree-sitter-cli",
            "gopls",
            "lua-language-server",
            "pyright",
            "terraform-ls",
            "texlab",
            "tex-fmt",
        },
        run_on_start = true,
    })
    require("mason-tool-installer").check_install(true)
end)

lib.on_command({ "Mason", "MasonToolsUpdate", "MasonToolsInstall" }, load)

-- Returned so plugins.dap can do the full mason setup before using it.
return load
