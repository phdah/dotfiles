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
    ----------------------------
    -- Can not be Lazy Loaded --
    ----------------------------

    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    {'p00f/nvim-ts-rainbow'}, {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
        }
    }, {'voldikss/vim-floaterm'},
    {'folke/todo-comments.nvim', dependencies = {'nvim-lua/plenary.nvim'}},
    {'akinsho/git-conflict.nvim'},
    {'shaunsingh/nord.nvim'},
    {'lewis6991/gitsigns.nvim'},

    ------------------------
    -- Can be Lazy Loaded --
    ------------------------

    {
        'pwntester/octo.nvim',
        event = "VeryLazy",
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons'
        }
    }, {
        'VonHeikemen/lsp-zero.nvim',
        event = "VeryLazy",
        branch = 'v3.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig', 'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim', -- DAP support
            'jay-babu/mason-nvim-dap.nvim'
        }
    }, {
        'hrsh7th/nvim-cmp',
        event = "VeryLazy",
        dependencies = {
            -- Sources
            'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path',
            'quangnguyen30192/cmp-nvim-tags', 'lukas-reineke/cmp-rg',
            'rcarriga/cmp-dap', 'ray-x/cmp-treesitter', 'MattiasMTS/cmp-dbee',
            -- Snippets
            'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip'
        }
    }, {'terrortylor/nvim-comment', event = "VeryLazy"}, {
        "MattiasMTS/nvim-dbee",
        -- "kndndrj/nvim-dbee",
        event = "VeryLazy",
        branch = "mattias/databricks-adapter",
        dependencies = {"MunifTanjim/nui.nvim"},
        build = function() require("dbee").install() end
    }, {
        "Febri-i/snake.nvim",
        cmd = "SnakeStart",
        dependencies = {"Febri-i/fscreen.nvim"},
        opts = {}
    }, {
        'iamcco/markdown-preview.nvim',
        event = "VeryLazy",
        build = function() vim.fn['mkdp#util#install']() end
    }, {
        'rcarriga/nvim-dap-ui',
        event = "VeryLazy",
        dependencies = {
            'mfussenegger/nvim-dap', 'jbyuki/one-small-step-for-vimkind',
            'theHamsta/nvim-dap-virtual-text',
            'tomblind/local-lua-debugger-vscode', 'nvim-neotest/nvim-nio'
        }
    }, {
        "scalameta/nvim-metals",
        event = "VeryLazy",
        dependencies = {"nvim-lua/plenary.nvim"}
    }, {"folke/flash.nvim", event = "VeryLazy"}, {
        -- 'phdah/nvim-statusline',
        dir = '~/repos/privat/nvim-statusline/',
        event = "VeryLazy"
    }, {
        -- 'phdah/nvim-databricks',
        dir = '~/repos/privat/nvim-databricks/',
        event = "VeryLazy"
    }, {
        -- 'phdah/nvim-utils',
        dir = '~/repos/privat/nvim-utils/',
        event = "VeryLazy"
    }, {'nvim-lua/plenary.nvim', event = "VeryLazy"},
    {'David-Kunz/gen.nvim', event = "VeryLazy"}
})
