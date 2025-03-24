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
                        silent = true,
                    },
                    {
                        "gU",
                        ':lua require("gitsigns").undo_stage_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (U)undo staged hunk",
                        silent = true,
                    },
                    {
                        "gd",
                        ':lua require("gitsigns").preview_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (d)iff",
                        silent = true,
                    },
                    {
                        "gD",
                        ':lua require("gitsigns").diffthis()<CR>',
                        mode = "n",
                        desc = "(g)it (d)iff this file",
                        silent = true,
                    },
                    {
                        "gs",
                        ':lua require("gitsigns").stage_hunk()<CR>',
                        mode = "n",
                        desc = "(g)it (s)tage",
                        silent = true,
                    },
                    {
                        "gs",
                        [[:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>]],
                        mode = "v",
                        desc = "(g)it (s)tage",
                        silent = true,
                    },
                    {
                        "gb",
                        ':lua require("gitsigns").blame_line()<CR>',
                        mode = "n",
                        desc = "(g)it (b)lame",
                        silent = true,
                    },
                },
            },
        },
    },
    {
        "echasnovski/mini.surround",
        keys = {
            { "sa", mode = { "v" }, desc = "(S)urround (a)round visual", silent = true },
            { "sd", mode = { "n" }, desc = "(S)urround (d)elete", silent = true },
            { "sh", mode = { "n" }, desc = "(S)urround (h)ighlight", silent = true },
            { "sr", mode = { "n" }, desc = "(S)urround (r)eplace", silent = true },
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
                silent = true,
            },
            {
                "<leader>Q",
                ":lua Snacks.bufdelete({force=true})<CR>",
                mode = "n",
                desc = "(Q)uite buffer",
                silent = true,
            },
            {
                "<leader>ns",
                ':lua require("snacks").notifier.show_history()<CR>',
                mode = "n",
                desc = "(n)otifier (s)how history",
                silent = true,
            },
            {
                "go",
                ":lua require('snacks').gitbrowse.open()<CR>",
                mode = { "n" },
                desc = "(G)it (o)pen browser link",
                silent = true,
            },
            {
                "go",
                [[:lua require('snacks').gitbrowse.open({ line_start = vim.fn.line("'<"), line_end = vim.fn.line("'>")})<CR>]],
                mode = { "v" },
                desc = "(G)it (o)pen browser link",
                silent = true,
            },
            {
                "gy",
                ":lua require('snacks').gitbrowse({ open = function(url) vim.fn.setreg('+', url) end })<CR>",
                mode = { "n" },
                desc = "(G)it (y)ank browser link",
                silent = true,
            },
            {
                "gy",
                [[:lua require('snacks').gitbrowse({ line_start = vim.fn.line("'<"), line_end = vim.fn.line("'>"), open = function(url) vim.fn.setreg('+', url) end })<CR>]],
                mode = { "v" },
                desc = "(G)it (y)ank browser link",
                silent = true,
            },
            {
                "zf",
                ':lua require("snacks").dim.enable()<CR>',
                mode = "n",
                desc = "(Z)en (f)ile enable",
                silent = true,
            },
            {
                "zF",
                ':lua require("snacks").dim.disable()<CR>',
                mode = "n",
                desc = "(Z)en (F)ile disable",
                silent = true,
            },
            {
                "<leader>gg",
                ":lua require('snacks').picker.lsp_definitions()<CR>",
                desc = "Goto Definition",
                silent = true,
            },
            {
                "gr",
                ":lua require('snacks').picker.lsp_references()<CR>",
                nowait = true,
                desc = "References",
                silent = true,
            },
            {
                "gI",
                ":lua require('snacks').picker.lsp_implementations()<CR>",
                desc = "Goto Implementation",
                silent = true,
            },
            {
                "<leader>gy",
                ":lua require('snacks').picker.lsp_type_definitions()<CR>",
                desc = "Goto T[y]pe Definition",
                silent = true,
            },
            {
                "<leader>sb",
                ":lua require('snacks').picker.lsp_symbols()<CR>",
                desc = "LSP Symbols",
                silent = true,
            },
            {
                "<leader>ff",
                ":lua require('snacks').picker.smart({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind (f)iles locally",
                silent = true,
            },
            {
                "<leader>fF",
                ":lua require('snacks').picker.smart({ cwd = '~' })<CR>",
                mode = "n",
                desc = "(f)ind (F)iles globally",
                silent = true,
            },
            {
                "<leader>fr",
                ":lua require('snacks').picker.grep({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind g(r)ep",
                silent = true,
            },
            {
                "<leader>fR",
                ":lua require('snacks').picker.recent()<CR>",
                mode = "n",
                desc = "(f)ind (R)ecent",
                silent = true,
            },
            {
                "<leader>fp",
                ":lua require('snacks').picker.projects()<CR>",
                mode = "n",
                desc = "(f)ind g(r)ep",
                silent = true,
            },
            {
                "<leader>f*",
                ":lua require('snacks').picker.grep_word({ cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind (*) search",
                silent = true,
            },
            {
                "<leader>fh",
                ":lua require('snacks').picker.help()<CR>",
                mode = "n",
                desc = "(f)ind (h)elp tags",
                silent = true,
            },
            {
                "<leader>fe",
                ":lua require('snacks').picker.diagnostics()<CR>",
                mode = "n",
                desc = "(f)ind (e)rror",
                silent = true,
            },
            {
                "<leader>fk",
                ":lua require('snacks').picker.keymaps()<CR>",
                mode = "n",
                desc = "(f)ind (k)eymaps",
                silent = true,
            },
            {
                "<leader>fx",
                ":lua Snacks.picker.explorer({ cwd = require('nvim-utils').Git.find_git_root(), auto_close = true, })<CR>",
                mode = "n",
                desc = "(f)ind (k)eymaps",
                silent = true,
            },
            {
                "z=",
                ":lua Snacks.picker.spelling()<CR>",
                mode = "n",
                desc = "Spelling suggestions list",
                silent = true,
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
                silent = true,
            },
            {
                "<leader>gd",
                ":lua require('phdah.diffview').toggleDiffView()<CR>",
                desc = "(G)it (d)iff toggle Diffview window",
                silent = true,
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
                silent = true,
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
            silent = true,
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
            -- Currently broken
            -- { "smjonas/inc-rename.nvim", opts = {} },
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
        version = "0.10.0",
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
            { "L3MON4D3/LuaSnip", version = "v2.*" },
            "hrsh7th/cmp-emoji",
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
                silent = true,
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
                silent = true,
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
                silent = true,
            },
            {
                "<leader>B",
                ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition (key==\'value\'): "))<CR>',
                mode = "n",
                desc = "Set conditional (B)reakpoint",
                silent = true,
            },
            {
                "<leader>db",
                ":DapNvimDebugee<CR>",
                mode = "n",
                desc = "Start (d)ebugg (b)ase",
                silent = true,
            },
            {
                "<leader>ds",
                ":DapNvimSource<CR>",
                mode = "n",
                desc = "Start (d)ebug (s)ource",
                silent = true,
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
                silent = true,
            },
            {
                "<leader>dl",
                ":lua require('dap').run_last()<CR>",
                mode = "n",
                desc = "(D)AP run (l)ast",
                silent = true,
            },
            {
                "<leader>dy",
                ':lua require("phdah.nvim-dap").start_repl()<CR>',
                mode = "n",
                desc = "Start (D)AP repl",
                silent = true,
            },
            {
                "<leader>t",
                ':lua require("phdah.nvim-dap").dapui_terminate()<CR>',
                mode = "n",
                desc = "(t)erminate dap",
                silent = true,
            },
            {
                "<leader>i",
                ':lua require("dap").step_into()<CR>',
                mode = "n",
                desc = "dap step (i)into function",
                silent = true,
            },
            {
                "<leader>m",
                ':lua require("dap").step_over()<CR>',
                mode = "n",
                desc = "dap (m)ove to next line",
                silent = true,
            },
            {
                "<leader>e",
                ':lua require("dap").step_out()<CR>',
                mode = "n",
                desc = "dap (e)xit current function",
                silent = true,
            },
            {
                "<leader>CB",
                ':lua require("dap").clear_breakpoints()<CR>',
                mode = "n",
                desc = "(C)lear all (B)reakpoints",
                silent = true,
            },
            {
                "<Leader>r",
                ':lua require("dapui").open({reset = true})<CR>',
                mode = "n",
                desc = "(r)edraw dap UI",
                silent = true,
            },
            {
                "<leader>dr",
                ':lua require("phdah.nvim-dap").send_code_to_repl()<CR>',
                mode = "v",
                desc = "(d)ap send line to (r)epl",
                silent = true,
            },
            {
                "<leader>dR",
                ':lua require("phdah.nvim-dap").send_file_to_repl()<CR>',
                mode = "n",
                desc = "(d)ap send all file to (R)epl",
                silent = true,
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
