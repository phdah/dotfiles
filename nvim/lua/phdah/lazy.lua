local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
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
                "chentoast/marks.nvim",
                event = "VeryLazy",
                opts = {},
            },
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
    {
        "echasnovski/mini.ai",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        opts = { n_lines = 500 },
    },
    { dir = "~/repos/privat/nvim-utils/" },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {},
            bufdelete = {},
            terminal = {},
            dashboard = {
                sections = {
                    { section = "header" },
                    {
                        icon = " ",
                        title = "Keymaps",
                        section = "keys",
                        indent = 2,
                        padding = 1,
                    },
                    {
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },
                    { section = "startup" },
                },
                preset = {
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = "<leader>ff",
                        },
                        {
                            icon = " ",
                            key = "n",
                            desc = "New File",
                            action = ":ene | startinsert",
                        },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = "<leader>fr",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = "<leader>fR",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = function()
                                require("snacks").picker.smart({
                                    cwd = vim.fn.stdpath("config"),
                                })
                            end,
                        },
                        {
                            icon = " ",
                            key = "s",
                            desc = "Restore Session",
                            section = "session",
                        },
                        {
                            icon = "󰒲 ",
                            key = "L",
                            desc = "Lazy",
                            action = ":Lazy",
                            enabled = package.loaded.lazy ~= nil,
                        },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
            notifier = {},
            gitbrowse = {
                url_patterns = {
                    ["github%.schibsted%.io"] = {
                        branch = "/tree/{branch}",
                        file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/commit/{commit}",
                    },
                },
            },
            picker = {
                layout = {
                    preview = false,
                },
                win = {
                    input = {
                        keys = {
                            ["<C-i>"] = { "confirm", mode = { "n", "i" } },
                            ["<C-k>"] = { "<Esc>", mode = { "n", "i" }, expr = true },
                            ["<C-c>"] = { "close", mode = { "n", "i" } },
                            ["<c-h>"] = {
                                { "toggle_hidden", "toggle_ignored" },
                                mode = { "i", "n" },
                            },
                            ["<c-j>"] = false,
                            ["<C-t>"] = { "toggle_preview", mode = { "i", "n" } },
                            ["<C-f>"] = { "toggle_follow", mode = { "i", "n" } },
                        },
                    },
                },
                formatters = {
                    file = { filename_first = true, truncate = 100 },
                },
                previewers = {
                    git = {
                        native = true,
                    },
                },
            },
            dim = {},
            lazygit = {
                theme = {
                    inactiveBorderColor = { fg = "Boolean" },
                    activeBorderColor = { fg = "Boolean", bold = true },
                    selectedLineBgColor = { bg = "Search" },
                },
            },
        },
        keys = {
            {
                "<leader>lo",
                ":lua Snacks.lazygit.open()<CR>",
                mode = "n",
                desc = "(l)azygit open in floating terminal",
                silent = true,
            },
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
                ":lua require('snacks').picker.lsp_references({ layout = { preview = true } })<CR>",
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
                "<leader>fu",
                ":lua require('snacks').picker.undo()<CR>",
                mode = "n",
                desc = "(f)ind (f)iles locally",
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
                "<leader>fc",
                ":lua require('snacks').picker.smart({ cwd = vim.fn.stdpath('config') })<CR>",
                mode = "n",
                desc = "(f)ind neovim (c)onfig",
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
                ":lua require('snacks').picker.grep( { layout = { preview = true }, cwd = require('nvim-utils').Git.find_git_root() })<CR>",
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
                ":lua require('snacks').picker.grep_word({ layout = { preview = true }, cwd = require('nvim-utils').Git.find_git_root() })<CR>",
                mode = "n",
                desc = "(f)ind (*) search",
                silent = true,
            },
            {
                "<leader>f*",
                ":lua require('snacks').picker.grep({ layout = { preview = true }, search = require('nvim-utils').String.escape_line(require('nvim-utils').String.get_visual_selection()) })<CR>",
                mode = "v",
                desc = "(f)ind (*) search",
                silent = true,
            },
            {
                "<leader>fh",
                ":lua require('snacks').picker.help( { layout = { preview = true } } )<CR>",
                mode = "n",
                desc = "(f)ind (h)elp tags",
                silent = true,
            },
            {
                "<leader>fe",
                ":lua require('snacks').picker.diagnostics({ layout = { preview = true } })<CR>",
                mode = "n",
                desc = "(f)ind (e)rror",
                silent = true,
            },
            {
                "<leader>fk",
                ":lua require('snacks').picker.keymaps({ layout = { preview = true } })<CR>",
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
                mode = "n",
                silent = true,
            },
            {
                "<leader>gf",
                ":'<,'>DiffviewFileHistory<CR>",
                desc = "(G)it (f)ile toggle DiffviewFileHistory window for lines",
                mode = "v",
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
        config = function()
            require("phdah.oil")
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>-", ":Oil --float<CR>", mode = "n" } },
    },
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        config = function()
            require("phdah.octo")
        end,
        keys = {
            {
                "<C-o>",
                ":Octo<CR>",
                mode = "n",
                desc = "Open (o)cto action list",
                silent = true,
            },
            {
                "<leader>fo",
                ":Octo pr list<CR>",
                mode = "n",
                desc = "Open (o)cto pr list",
                silent = true,
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope.nvim",
                config = function()
                    require("telescope").setup({
                        defaults = {
                            mappings = {
                                i = {
                                    ["<C-i>"] = require("telescope.actions").select_default,
                                },
                                n = {
                                    ["<C-i>"] = require("telescope.actions").select_default,
                                },
                            },
                        },
                    })
                end,
            },
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
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
        event = { "InsertEnter", "CmdlineEnter" },
        version = "1.7.0",
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
            "moyiz/blink-emoji.nvim",
            "Kaiser-Yang/blink-cmp-git",
        },
    },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup({
                comment_empty = false,
                create_mappings = false,
            })
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
            {
                "<leader>ä",
                ':lua require("dbee").open()<CR>',
                mode = "n",
                desc = "Toggle dbee",
                silent = true,
            },
            {
                "<C-s",
                ':lua require("dbee").run_selection()<CR>',
                mode = "v",
                desc = "Run dbee selection outside of dbee UI",
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
                function()
                    require("phdah.nvim-dap")
                    require("osv").launch({ port = 8086 })
                end,
                mode = "n",
                desc = "Start (d)ebugg (b)ase",
                silent = true,
            },
            {
                "<leader>c",
                function()
                    -- Ensure the module is loaded, this is only
                    -- a problem if loaded by this mapping
                    require("phdah.nvim-dap")
                    if require("dap").session() == nil then
                        require("phdah.nvim-dap").setup_configs()
                    end
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
                "<leader>dc",
                ":lua require('dap').run_to_cursor()<CR>",
                mode = "n",
                desc = "(D)AP run to (c)ursor",
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
                "<leader>dw",
                ":lua require('dapui').elements.watches.add(vim.fn.expand('<cexpr>'))<CR>",
                mode = "n",
                desc = "(D)AP add variable to (w)atch",
                silent = true,
            },
            {
                "<leader>dw",
                ":lua require('dapui').elements.watches.add(require('nvim-utils').String.get_visual_selection())<CR>",
                mode = "v",
                desc = "(D)AP add variable to (w)atch",
                silent = true,
            },

            {
                "<leader>dh",
                ":lua require('dap.ui.widgets').hover(nil, { border = 'rounded' })<CR>",
                mode = "n",
                desc = "(D)AP (h)over varaible",
                silent = true,
            },
            {
                "<leader>dH",
                ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes, { border = 'rounded' })<CR>",
                mode = "n",
                desc = "(D)AP (H)over scopes",
                silent = true,
            },
            {
                "<leader>dT",
                ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').threads, { border = 'rounded' })<CR>",
                mode = "n",
                desc = "(D)AP (H)over scopes",
                silent = true,
            },
            {
                "<leader>dB",
                ':lua require("dapui").float_element("breakpoints", { enter = true, position = "center", border = "rounded" })<CR>',
                mode = "n",
                desc = "(D)AP (H)over scopes",
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
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = { "scala", "sbt" },
        opts = function()
            local metals_config = require("metals").bare_config()
            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()
            end

            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group =
                vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = self.ft,
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end,
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
        "phdah/nvim-statusline",
        config = function()
            require("phdah.nvim-statusline")
        end,
        event = { "BufReadPre", "BufNewFile" },
    },
    -- {
    --     'phdah/nvim-databricks',
    --     -- dir = "~/repos/privat/nvim-databricks/",
    --     cmd = { "DBOpen", "DBRun", "DBRunOpen", "DBPrintState" },
    --     ft = "python",
    --     config = function()
    --         require("phdah.nvim-databricks")
    --     end,
    -- },
    {
        "danymat/neogen",
        cmd = "Neogen",
        dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
        keys = {
            {
                "<leader>ne",
                function()
                    require("neogen").generate()
                end,
                desc = "(N)(e)ogen Comment",
            },
        },
        opts = {
            snippet_engine = "luasnip",
            input_after_comment = false,
            languages = {
                python = {
                    template = {
                        annotation_convention = "google_docstrings",
                    },
                },
                go = {
                    template = {
                        annotation_convention = "godoc",
                    },
                },
                lua = {
                    template = {
                        annotation_convention = "emmylua",
                    },
                },
            },
        },
    },
    -- {
    --     "phdah/lazydbrix",
    --     -- dir = "~/repos/privat/lazydbrix",
    --     build = ':lua require("lazydbrix").install()',
    --     ft = { "python" },
    --     opts = { sourceOnStart = true },
    --     keys = {
    --         { "<leader>do", ':lua require("lazydbrix").open()<CR>', "n" },
    --         { "<leader>dp", ':lua require("lazydbrix").show()<CR>', "n" },
    --     },
    --     dependencies = { "voldikss/vim-floaterm" },
    -- },
    { "nvim-lua/plenary.nvim", cmd = "PlenaryBustedDirectory" },
    { "stevearc/quicker.nvim", event = "FileType qf", opts = {} },
    {
        "David-Kunz/gen.nvim",
        config = function()
            require("phdah.gen")
        end,
        cmd = { "Gen" },
        keys = {
            { "<C-g>g", mode = "n", ":Gen Chat<CR>" },
            { "<C-g>g", mode = "v", ":Gen Ask<CR>" },
            { "<C-g>d", mode = "v", ":Gen Add_docstring<CR>" },
        },
    },
    -- {
    --     "3rd/image.nvim",
    --     ft = { "markdown", "octo" },
    --     config = function()
    --         require("phdah.image")
    --     end,
    -- },
    { "vuciv/golf", cmd = "Golf" },
    {
        "phdah/snipe-marks",
        dependencies = { "leath-dub/snipe.nvim" },
        keys = {
            {
                "<leader>fm",
                mode = "n",
                function()
                    require("snipe_marks").open()
                end,
                desc = "(f)ind all (m)arks",
                silent = true,
            },
            {
                "<leader>dm",
                mode = "n",
                function()
                    require("snipe_marks").delAll()
                end,
                desc = "(d)elete all (m)arks",
                silent = true,
            },
        },
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
            { "folke/snacks.nvim", opts = { input = { enabled = true } } },
        },
        config = function()
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`
            }
            vim.opt.autoread = true
        end,
        keys = {
            -- Recommended keymaps
            {
                "<leader>at",
                mode = "n",
                function()
                    require("opencode").toggle()
                end,
                desc = "Toggle",
            },
            {
                "<leader>aA",
                mode = "n",
                function()
                    require("opencode").ask()
                end,
                desc = "Ask",
            },
            {
                "<leader>aa",
                mode = "n",
                function()
                    require("opencode").ask("@cursor: ")
                end,
                desc = "Ask about this",
            },
            {
                "<leader>aa",
                mode = "v",
                function()
                    require("opencode").ask("@selection: ")
                end,
                desc = "Ask about selection",
            },
            {
                "<leader>ab",
                mode = "n",
                function()
                    require("opencode").append_prompt("@buffer")
                end,
                desc = "Add buffer to prompt",
            },
            {
                "<leader>ab",
                mode = "v",
                function()
                    require("opencode").append_prompt("@selection")
                end,
                desc = "Add selection to prompt",
            },
            {
                "<leader>an",
                mode = "n",
                function()
                    require("opencode").command("session_new")
                end,
                desc = "New session",
            },
            {
                "<leader>ay",
                mode = "n",
                function()
                    require("opencode").command("messages_copy")
                end,
                desc = "Copy last response",
            },
            {
                "<leader>au",
                mode = "n",
                function()
                    require("opencode").command("messages_half_page_up")
                end,
                desc = "Messages half page up",
            },
            {
                "<leader>ad",
                mode = "n",
                function()
                    require("opencode").command("messages_half_page_down")
                end,
                desc = "Messages half page down",
            },
            {
                "<leader>ae",
                mode = "v",
                function()
                    require("opencode").prompt("Explain @selection and its context")
                end,
                desc = "Explain this code",
            },
            {
                "<leader>aD",
                mode = "v",
                function()
                    require("opencode").prompt(
                        "Add a docstring to @selection and its context. Make sure to use proper indentation for the entire docstring."
                            .. " If it's python, use numpy-style, without any backticks"
                    )
                end,
                desc = "Explain this code",
            },
        },
    },
    {
        "hat0uma/csvview.nvim",
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                jump_next_field_end = { "w", mode = { "n", "v" } },
                jump_prev_field_end = { "b", mode = { "n", "v" } },
                jump_next_row = { "j", mode = { "n", "v" } },
                jump_prev_row = { "k", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
        keys = {
            {
                "so",
                ":CsvViewEnable display_mode=border header_lnum=1<CR>",
                mode = "n",
                desc = "Scroll messages down",
            },
        },
    },
})
