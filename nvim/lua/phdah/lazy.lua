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

return require('lazy').setup({
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    {'p00f/nvim-ts-rainbow'},
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
    {
      'pwntester/octo.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
      },
    },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            -- DAP support
            'jay-babu/mason-nvim-dap.nvim',
        }
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Sources
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'quangnguyen30192/cmp-nvim-tags',
            'lukas-reineke/cmp-rg',
            'rcarriga/cmp-dap',
            'ray-x/cmp-treesitter',
	        -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',
        },
    },

    {
        'terrortylor/nvim-comment'
    },

    {
        'kristijanhusak/vim-dadbod-ui',
        event = "VeryLazy",
        dependencies = {
            'kristijanhusak/vim-dadbod-completion',
            'tpope/vim-dadbod'
        }
    },
    -- install without yarn or npm
    {
        'iamcco/markdown-preview.nvim',
        build = function() vim.fn['mkdp#util#install']() end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'jbyuki/one-small-step-for-vimkind',
            'theHamsta/nvim-dap-virtual-text',
            'tomblind/local-lua-debugger-vscode',
            'nvim-neotest/nvim-nio',
        }
    },
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
      },
    {"folke/flash.nvim"},
    {'shaunsingh/nord.nvim'},
    {'lewis6991/gitsigns.nvim'},
    {'phdah/nvim-statusline'},
    {'phdah/nvim-databricks'},
    {'nvim-lua/plenary.nvim'},
    {'akinsho/git-conflict.nvim'},
    {'David-Kunz/gen.nvim'},
    {'voldikss/vim-floaterm'},

})
