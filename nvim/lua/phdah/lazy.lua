local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

return require("lazy").setup({
    ------------------
    -- Code visuals --
    ------------------
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("phdah.treesitter")
        end,
        dependencies = {
            "shaunsingh/nord.nvim",
            {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require("phdah.gitsigns")
                end,
                keys = {
                    {
                        "gu",
                        ':lua require("gitsigns").reset_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (u)undo",
                    },
                    {
                        "gU",
                        ':lua require("gitsigns").undo_stage_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (U)undo staged hunk",
                    },
                    {
                        "gd",
                        ':lua require("gitsigns").preview_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (d)iff",
                    },
                    {
                        "gD",
                        ':lua require("gitsigns").diffthis()<CR>',
                        mode = "n",
                        desc = "(g)it (d)iff this file",
                    },
                    {
                        "gs",
                        ':lua require("gitsigns").stage_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (s)tage",
                    },
                    {
                        "gs",
                        [[:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>]],
                        mode = "v",
                        desc = "(g)it (s)tage",
                    },
                    {
                        "gb",
                        ':lua require("gitsigns").blame_line()<CR>',
                        mode = "n",
                        desc = "(g)it (b)lame",
                    },
                },
            },
        },
    },
    {
        "echasnovski/mini.surround",
        keys = {
            { "sa", mode = { "v" }, desc = "(S)urround (a)round visual" },
            { "sd", mode = { "n" }, desc = "(S)urround (d)elete" },
            { "sh", mode = { "n" }, desc = "(S)urround (h)ighlight" },
            { "sr", mode = { "n" }, desc = "(S)urround (r)eplace" },
        },
        version = false,
        config = function()
            require("phdah.surround")
        end,
    },
    { dir = "~/repos/privat/nvim-utils/" },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {},
            bufdelete = {},
            dashboard = {},
            notifier = {},
            gitbrowse = {},
            picker = {
                win = {
                    input = {
                        keys = {
                            ["<C-i>"] = { "confirm", mode = { "n", "i" } },
                        },
                    },
                },
                formatters = {
                    file = { filename_first = true },
                },
                previewers = {
                    git = {
                        native = true,
                    },
                },
            },
            dim = {},
        },
        keys = {
            {
                "<leader>q",
                ":lua Snacks.bufdelete()<CR>",
                mode = "n",
                desc = "(q)uite buffer",
            },
            {
                "<leader>Q",
                ":lua Snacks.bufdelete({force=true})<CR>",
                mode = "n",
                desc = "(Q)uite buffer",
            },
            {
                "<leader>ns",
                ':lua require("snacks").notifier.show_history()<CR>',
                mode = "n",
                desc = "(n)otifier (s)how history",
            },
            {
                "go",
                ":lua require('snacks').gitbrowse.open()<CR>",
                mode = "n",
                desc = "(G)it (o)pen browser link",
            },
            {
                "zf",
                ':lua require("snacks").dim.enable()<CR>',
                mode = "n",
                desc = "(Z)en (f)ile enable",
            },
            {
                "zF",
                ':lua require("snacks").dim.disable()<CR>',
                mode = "n",
                desc = "(Z)en (F)ile disable",
            },
            {
                "<leader>gg",
                ":lua require('snacks').picker.lsp_definitions()<CR>",
                desc = "Goto Definition",
            },
            {
                "gr",
                ":lua require('snacks').picker.lsp_references()<CR>",
                nowait = true,
                desc = "References",
            },
            {
                "gI",
                ":lua require('snacks').picker.lsp_implementations()<CR>",
                desc = "Goto Implementation",
            },
            {
                "gy",
                ":lua require('snacks').picker.lsp_type_definitions()<CR>",
                desc = "Goto T[y]pe Definition",
            },
            {
                "<leader>sb",
                ":lua require('snacks').picker.lsp_symbols()<CR>",
                desc = "LSP Symbols",
            },
            {
                "<leader>ff",
                ":lua require('snacks').picker.smart({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind (f)iles locally",
            },
            {
                "<leader>fF",
                ":lua require('snacks').picker.smart({ cwd = '~' })<CR>",
                mode = "n",
                desc = "(f)ind (F)iles globally",
            },
            {
                "<leader>fr",
                ":lua require('snacks').picker.grep({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind g(r)ep",
            },
            {
                "<leader>fR",
                ":lua require('snacks').picker.recent()<CR>",
                mode = "n",
                desc = "(f)ind (R)ecent",
            },
            {
                "<leader>fp",
                ":lua require('snacks').picker.projects()<CR>",
                mode = "n",
                desc = "(f)ind g(r)ep",
            },
            {
                "<leader>f*",
                ":lua require('snacks').picker.grep_word({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind (*) search",
            },
            {
                "<leader>fh",
                ":lua require('snacks').picker.help()<CR>",
                mode = "n",
                desc = "(f)ind (h)elp tags",
            },
            {
                "<leader>fe",
                ":lua require('snacks').picker.diagnostics()<CR>",
                mode = "n",
                desc = "(f)ind (e)rror",
            },
            {
                "<leader>fk",
                ":lua require('snacks').picker.keymaps()<CR>",
                mode = "n",
                desc = "(f)ind (k)eymaps",
            },
            {
                "<leader>fx",
                ":lua Snacks.picker.explorer({ cwd = require('nvim-utils').Git.find_git_root(), auto_close = true, })<CR>",
                mode = "n",
                desc = "(f)ind (k)eymaps",
            },
            {
                "z=",
                ":lua Snacks.picker.spelling()<CR>",
                mode = "n",
                desc = "Spelling suggestions list",
            },
        },
    }, ------------------------
    -- Can be Lazy Loaded --
    ------------------------
    {
        "sindrets/diffview.nvim",
        config = function()
            require("phdah.diffview")
        end,
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            {
                "<leader>gf",
                ":lua require('phdah.diffview').toggleFileHistory()<CR>",
                desc = "(G)it (f)ile toggle DiffviewFileHistory window",
            },
            {
                "<leader>gd",
                ":lua require('phdah.diffview').toggleDiffView()<CR>",
                desc = "(G)it (d)iff toggle Diffview window",
            },
        },
    },
    { "catgoose/nvim-colorizer.lua", ft = { "typescriptreact", "lua" }, opts = {} },
    {
        "voldikss/vim-floaterm",
        cmd = "FloatermNew",
        keys = {
            {
                "<leader>lo",
                ":FloatermNew --width=0.9 --height=0.9 lazygit<CR>",
                mode = "n",
                desc = "(l)azygit open in floating terminal",
            },
        },
    },
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown", "octo" },
        config = function()
            require("phdah.markview")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("phdah.oil")
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>-", ":Oil --float<CR>", mode = "n" } },
    },
    {
        -- 'pwntester/octo.nvim',
        dir = "~/repos/privat/octo.nvim",
        cmd = "Octo",
        config = function()
            require("phdah.octo")
        end,
        keys = {
            { "<C-o>", ":Octo<CR>", mode = "n", desc = "Open (o)cto action list" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        event = { "BufReadPre", "BufNewFile" },
        branch = "v4.x",
        config = function()
            require("phdah.lsp")
        end,
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "smjonas/inc-rename.nvim", opts = {} },
        },
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            require("phdah.nvim-java")
        end,
    },
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        version = "0.8.0",
        config = function()
            require("phdah.blink")
        end,
        dependencies = {
            {
                "saghen/blink.compat",
                version = "*",
                lazy = true,
                opts = { impersonate_nvim_cmp = false, debug = false },
            },
            "hrsh7th/cmp-emoji",
            "mikavilpas/blink-ripgrep.nvim",
            "folke/lazydev.nvim",
        },
    },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("phdah.codecomment")
        end,
        keys = {
            {
                "<leader>'",
                ":CommentToggle<CR>",
                mode = { "n", "v" },
                desc = "Toggle comment on line/s",
            },
        },
    },
    {
        -- "kndndrj/nvim-dbee",
        dir = "~/repos/privat/nvim-dbee",
        keys = {
            {
                "<leader>ö",
                ':lua require("dbee").toggle(); require("nvim-utils").Mouse:toggle()<CR>',
                mode = "n",
                desc = "Toggle dbee",
            },
        },
        config = function()
            require("phdah.nvim-dbee")
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            { "MattiasMTS/cmp-dbee", opts = {} },
        },
        build = function()
            require("dbee").install("go")
        end,
    },
    {
        "Febri-i/snake.nvim",
        cmd = "SnakeStart",
        dependencies = { "Febri-i/fscreen.nvim" },
        opts = {},
    },
    {
        "rcarriga/nvim-dap-ui",
        keys = {
            {
                "<leader>b",
                ':lua require("dap").toggle_breakpoint()<CR>',
                mode = "n",
                desc = "Set (b)reakpoint",
            },
            {
                "<leader>B",
                ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition (key==\'value\'): "))<CR>',
                mode = "n",
                desc = "Set conditional (B)reakpoint",
            },
            {
                "<leader>db",
                ":DapNvimDebugee<CR>",
                mode = "n",
                desc = "Start (d)ebugg (b)ase",
            },
            {
                "<leader>ds",
                ":DapNvimSource<CR>",
                mode = "n",
                desc = "Start (d)ebug (s)ource",
            },
            {
                "<leader>c",
                function()
                    -- Ensure the module is loaded, this is only
                    -- a problem if loaded by this mapping
                    require("phdah.nvim-dap")
                    require("dap").continue()
                end,
                mode = "n",
                desc = "DAP (c)continue",
            },
            {
                "<leader>dy",
                ':lua require("phdah.nvim-dap").start_repl()<CR>',
                mode = "n",
                desc = "Start (D)AP repl",
            },
            {
                "<leader>t",
                ':lua require("phdah.nvim-dap").dapui_terminate()<CR>',
                mode = "n",
                desc = "(t)erminate dap",
            },
            {
                "<leader>i",
                ':lua require("dap").step_into()<CR>',
                mode = "n",
                desc = "dap step (i)into function",
            },
            {
                "<leader>m",
                ':lua require("dap").step_over()<CR>',
                mode = "n",
                desc = "dap (m)ove to next line",
            },
            {
                "<leader>e",
                ':lua require("dap").step_out()<CR>',
                mode = "n",
                desc = "dap (e)xit current function",
            },
            {
                "<leader>CB",
                ':lua require("dap").clear_breakpoints()<CR>',
                mode = "n",
                desc = "(C)lear all (B)reakpoints",
            },
            {
                "<Leader>r",
                ':lua require("dapui").open({reset = true})<CR>',
                mode = "n",
                desc = "(r)edraw dap UI",
            },
            {
                "<leader>dr",
                ':lua require("phdah.nvim-dap").send_code_to_repl()<CR>',
                mode = "v",
                desc = "(d)ap send line to (r)epl",
            },
            {
                "<leader>dR",
                ':lua require("phdah.nvim-dap").send_file_to_repl()<CR>',
                mode = "n",
                desc = "(d)ap send all file to (R)epl",
            },
        },
        config = function()
            require("phdah.nvim-dap")
        end,
        dependencies = {
            "mfussenegger/nvim-dap",
            "jbyuki/one-small-step-for-vimkind",
            "theHamsta/nvim-dap-virtual-text",
            "tomblind/local-lua-debugger-vscode",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
            "rcarriga/cmp-dap",
        },
    },
    {
        "scalameta/nvim-metals",
        ft = "scala",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "folke/flash.nvim",
        config = function()
            require("phdah.flash")
        end,
        keys = {
            { "f", mode = "n" },
            { "F", mode = "n" },
            { "t", mode = "n" },
            { "T", mode = "n" },
            { "ss", '<cmd>lua require("flash").jump()<CR>', mode = "n" },
            { "ss", '<cmd>lua require("flash").jump()<CR>', mode = "x" },
            { "ss", '<cmd>lua require("flash").jump()<CR>', mode = "o" },
            { "sS", '<cmd>lua require("flash").treesitter()<CR>', mode = "n" },
            { "sS", '<cmd>lua require("flash").treesitter()<CR>', mode = "x" },
            { "sS", '<cmd>lua require("flash").treesitter()<CR>', mode = "o" },
        },
    },
    {
        "leath-dub/snipe.nvim",
        lazy = false,
        keys = {
            {
                "<leader>fb",
                ':lua require("snipe").open_buffer_menu()<CR>',
                mode = "n",
            },
        },
        config = function()
            require("phdah.snipe")
        end,
    },
    {
        -- 'phdah/nvim-statusline',
        dir = "~/repos/privat/nvim-statusline/",
        config = function()
            require("phdah.nvim-statusline")
        end,
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        -- 'phdah/nvim-databricks',
        dir = "~/repos/privat/nvim-databricks/",
        cmd = { "DBOpen", "DBRun", "DBRunOpen", "DBPrintState" },
        ft = "python",
        config = function()
            require("phdah.nvim-databricks")
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>gp", "<cmd>CodeCompanionActions<CR>", "n" },
            { "<leader>gp", "<cmd>CodeCompanionActions<CR>", "v" },
        },
        config = function()
            require("phdah.code_companion")
        end,
    },
    {
        "danymat/neogen",
        cmd = "Neogen",
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    {
        "phdah/lazydbrix",
        -- dir = "~/repos/privat/lazydbrix",
        build = ':lua require("lazydbrix").install()',
        ft = { "python" },
        opts = { sourceOnStart = true },
        keys = {
            { "<leader>do", ':lua require("lazydbrix").open()<CR>', "n" },
            { "<leader>dp", ':lua require("lazydbrix").show()<CR>', "n" },
        },
        dependencies = { "voldikss/vim-floaterm" },
    },
    { "nvim-lua/plenary.nvim", cmd = "PlenaryBustedDirectory" },
    { "stevearc/quicker.nvim", event = "FileType qf", opts = {} },
    {
        "David-Kunz/gen.nvim",
        config = function()
            require("phdah.gen")
        end,
        keys = {
            { "<C-g>", mode = "n", ":Gen Chat<CR>" },
            { "<C-g>", mode = "v", ":Gen Ask<CR>" },
        },
    },
    {
        "3rd/image.nvim",
        ft = { "markdown", "octo" },
        config = function()
            require("phdah.image")
        end,
    },
})
