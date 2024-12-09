local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

return require('lazy').setup({
    ------------------
    -- Code visuals --
    ------------------

    {
        'nvim-treesitter/nvim-treesitter',
        event = {"BufReadPre", "BufNewFile"},
        build = ':TSUpdate',
        config = function() require("phdah.treesitter") end,
        dependencies = {
            'p00f/nvim-ts-rainbow', 'shaunsingh/nord.nvim', {
                'akinsho/git-conflict.nvim',
                config = function() require("phdah.git-conflict") end
            }, {
                'lewis6991/gitsigns.nvim',
                config = function() require("phdah.gitsigns") end
            }
        }
    }, {
        'echasnovski/mini.surround',
        keys = {
            {'sa', mode = {'v'}}, {'sd', mode = {'n'}}, {'sh', mode = {'n'}},
            {'sr', mode = {'n'}}
        },
        version = false,
        config = function() require("phdah.surround") end
    }, {
        dir = '~/repos/privat/nvim-utils/' -- 'phdah/nvim-utils',
    }, {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {enabled = true},
            bufdelete = {enabled = true},
            dashboard = {enabled = true},
            notifier = {enabled = true},
            gitbrowse = {enabled = true}
        }
    }, ------------------------
    -- Can be Lazy Loaded --
    ------------------------
    {'voldikss/vim-floaterm', cmd = "FloatermNew"}, {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        config = function() require("phdah.markview") end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"
        }
    }, {
        'stevearc/oil.nvim',
        config = function() require('phdah.oil') end,
        dependencies = {"nvim-tree/nvim-web-devicons"},
        keys = {{'<leader>-', ':Oil --float<CR>', mode = 'n'}}
    }, {
        'nvim-telescope/telescope.nvim',
        keys = {
            {
                '<leader>ff',
                ':lua require("phdah.telescope").find_files_git()<CR>',
                mode = 'n'
            }, {
                '<leader>fF',
                ":lua require('telescope').extensions.smart_open.smart_open({cwd='~'})<CR>",
                mode = 'n'
            }, {
                '<leader>fr',
                ':lua require("phdah.telescope").live_grep_git()<CR>',
                mode = 'n'
            }, {
                '<leader>f*',
                ':lua require("phdah/telescope").grep_string_git()<CR>',
                mode = 'n'
            },
            {
                '<leader>fh',
                ':lua require("telescope.builtin").help_tags()<CR>',
                mode = 'n'
            }, {
                '<leader>fc',
                ':lua require("phdah.telescope").telescope_diff_from_history()<CR>',
                mode = 'n'
            }, {'<leader>fe', ':Telescope diagnostics<CR>', mode = 'n'}
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}, {
                "danielfalk/smart-open.nvim",
                branch = "0.2.x",
                config = function()
                    require("telescope").load_extension("smart_open")
                end,
                dependencies = {"kkharji/sqlite.lua"}
            }
        }
    }, {
        'pwntester/octo.nvim',
        cmd = "Octo",
        config = function() require("phdah.octo") end,
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons'
        }
    }, {
        'VonHeikemen/lsp-zero.nvim',
        event = {"BufReadPre", "BufNewFile"},
        branch = 'v4.x',
        config = function() require("phdah.lsp") end,
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig', 'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            {"smjonas/inc-rename.nvim", opts = {}}
        }
    }, {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function() require("phdah.nvim-java") end
    }, {
        'hrsh7th/nvim-cmp',
        event = {"InsertEnter"},
        config = function() require("phdah.nvim-cmp") end,
        dependencies = {
            -- Sources
            'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-emoji', 'quangnguyen30192/cmp-nvim-tags',
            'lukas-reineke/cmp-rg', 'ray-x/cmp-treesitter', 'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets', 'saadparwaiz1/cmp_luasnip'
        }
    }, {
        'terrortylor/nvim-comment',
        cmd = "CommentToggle",
        config = function() require("phdah.codecomment") end
    }, {
        "MattiasMTS/nvim-dbee",
        -- "kndndrj/nvim-dbee",
        keys = {
            {
                '<leader>ö',
                ':lua require("dbee").toggle(); require("nvim-utils").Mouse:toggle()<CR>',
                mode = 'n'
            }
        },
        branch = "mattias/databricks-adapter",
        config = function() require("phdah.nvim-dbee") end,
        dependencies = {
            "MunifTanjim/nui.nvim", {"MattiasMTS/cmp-dbee", opts = {}}
        },
        build = function() require("dbee").install() end
    }, {
        "Febri-i/snake.nvim",
        cmd = "SnakeStart",
        dependencies = {"Febri-i/fscreen.nvim"},
        opts = {}
    }, {
        'rcarriga/nvim-dap-ui',
        keys = {
            {
                '<leader>b',
                ':lua require("dap").toggle_breakpoint()<CR>',
                mode = 'n'
            }, {
                '<leader>B',
                ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition (key==\'value\'): "))<CR>',
                mode = 'n'
            }, {'<leader>db', ':DapNvimDebugee<CR>', mode = 'n'},
            {'<leader>ds', ':DapNvimSource<CR>', mode = 'n'}, {
                '<leader>c',
                function()
                    -- Ensure the module is loaded, this is only
                    -- a problem if loaded by this mapping
                    require("phdah.nvim-dap")
                    require("dap").continue()
                end,
                mode = 'n'
            },
            {
                '<leader>dy',
                ':lua require("phdah.nvim-dap").start_repl()<CR>',
                mode = 'n'
            }
        },
        config = function() require("phdah.nvim-dap") end,
        dependencies = {
            'mfussenegger/nvim-dap', 'jbyuki/one-small-step-for-vimkind',
            'theHamsta/nvim-dap-virtual-text',
            'tomblind/local-lua-debugger-vscode', 'nvim-neotest/nvim-nio',
            'jay-babu/mason-nvim-dap.nvim', 'rcarriga/cmp-dap'
        }
    }, {
        "scalameta/nvim-metals",
        ft = "scala",
        dependencies = {"nvim-lua/plenary.nvim"}
    }, {
        "folke/flash.nvim",
        config = function() require("phdah.flash") end,
        keys = {
            {'f', mode = 'n'}, {'F', mode = 'n'}, {'t', mode = 'n'},
            {'T', mode = 'n'},
            {'ss', '<cmd>lua require("flash").jump()<CR>', mode = 'n'},
            {'ss', '<cmd>lua require("flash").jump()<CR>', mode = 'x'},
            {'ss', '<cmd>lua require("flash").jump()<CR>', mode = 'o'},
            {'sS', '<cmd>lua require("flash").treesitter()<CR>', mode = 'n'},
            {'sS', '<cmd>lua require("flash").treesitter()<CR>', mode = 'x'},
            {'sS', '<cmd>lua require("flash").treesitter()<CR>', mode = 'o'}
        }
    }, {
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<leader>fb",
                ':lua require("snipe").open_buffer_menu()<CR>',
                mode = 'n'
            }
        },
        config = function() require("phdah.snipe") end
    }, {
        -- 'phdah/nvim-statusline',
        dir = '~/repos/privat/nvim-statusline/',
        config = function() require("phdah.nvim-statusline") end,
        event = {"BufReadPre", "BufNewFile"}
    }, {
        -- 'phdah/nvim-databricks',
        dir = '~/repos/privat/nvim-databricks/',
        cmd = {"DBOpen", "DBRun", "DBRunOpen", "DBPrintState"},
        ft = "python",
        config = function() require("phdah.nvim-databricks") end
    }, {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"
        },
        keys = {
            {"<leader>gp", "<cmd>CodeCompanionActions<CR>", 'n'},
            {"<leader>gp", "<cmd>CodeCompanionActions<CR>", 'v'}
        },
        config = function() require("phdah.code_companion") end
    }, {
        "danymat/neogen",
        cmd = "Neogen",
        config = true
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    }, {
        "kelvinauta/focushere.nvim",
        opts = {},
        keys = {
            {"zf", ":FocusHere<CR>", mode = "v"},
            {"zf", ":FocusClear<CR>", mode = "n"}
        }
    }, {
        "oskarrrrrrr/symbols.nvim",
        config = function() require('phdah.symbols') end,
        keys = {{"sb", "<cmd> SymbolsToggle<CR>", mode = 'n'}}
    }
})
