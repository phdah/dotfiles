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
        event = {"BufReadPre", "BufNewFile"},
        version = false,
        opts = {}
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
        dependencies = {"nvim-tree/nvim-web-devicons"}
    }, {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
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
        branch = 'v3.x',
        config = function() require("phdah.lsp") end,
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig', 'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim', -- DAP support
            'jay-babu/mason-nvim-dap.nvim',
            {"smjonas/inc-rename.nvim", opts = {}}
        }
    }, {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function() require("phdah.nvim-java") end
    }, {
        'hrsh7th/nvim-cmp',
        event = {"BufReadPre", "BufNewFile"},
        config = function() require("phdah.nvim-cmp") end,
        dependencies = {
            -- Sources
            'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-emoji', 'quangnguyen30192/cmp-nvim-tags',
            'lukas-reineke/cmp-rg', 'rcarriga/cmp-dap', 'ray-x/cmp-treesitter',
            {"MattiasMTS/cmp-dbee", opts = {}}, -- Snippets
            'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip'
        }
    }, {
        'terrortylor/nvim-comment',
        cmd = "CommentToggle",
        config = function() require("phdah.codecomment") end
    }, {
        "MattiasMTS/nvim-dbee",
        -- "kndndrj/nvim-dbee",
        event = "VeryLazy",
        branch = "mattias/databricks-adapter",
        config = function() require("phdah.nvim-dbee") end,
        dependencies = {"MunifTanjim/nui.nvim"},
        build = function() require("dbee").install() end
    }, {
        "Febri-i/snake.nvim",
        cmd = "SnakeStart",
        dependencies = {"Febri-i/fscreen.nvim"},
        opts = {}
    }, {
        'rcarriga/nvim-dap-ui',
        event = "VeryLazy",
        config = function() require("phdah.nvim-dap") end,
        dependencies = {
            'mfussenegger/nvim-dap', 'jbyuki/one-small-step-for-vimkind',
            'theHamsta/nvim-dap-virtual-text',
            'tomblind/local-lua-debugger-vscode', 'nvim-neotest/nvim-nio'
        }
    }, {
        "scalameta/nvim-metals",
        event = "VeryLazy",
        dependencies = {"nvim-lua/plenary.nvim"}
    }, {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function() require("phdah.flash") end
    }, {
        -- 'phdah/nvim-statusline',
        dir = '~/repos/privat/nvim-statusline/',
        config = function() require("phdah.nvim-statusline") end,
        event = "VeryLazy"
    }, {
        -- 'phdah/nvim-databricks',
        dir = '~/repos/privat/nvim-databricks/',
        cmd = {"DBOpen", "DBRun", "DBRunOpen", "DBPrintState"},
        ft = "python",
        config = function() require("phdah.nvim-databricks") end
    }, -- {'nvim-lua/plenary.nvim', event = "VeryLazy"},
    {
        'David-Kunz/gen.nvim',
        cmd = "Gen",
        config = function() require("phdah.gen") end
    }, {
        "danymat/neogen",
        cmd = "Neogen",
        config = true
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    }
})
