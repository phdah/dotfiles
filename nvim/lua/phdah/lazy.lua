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
      'pwntester/octo.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        -- OR 'ibhagwan/fzf-lua',
        'nvim-tree/nvim-web-devicons',
      },
    },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- DAP support
            {'jay-babu/mason-nvim-dap.nvim'}
        }
    },

    {
        'junegunn/fzf',
        build = ':call fzf#install()'
    },
    {
        'junegunn/fzf.vim'
    },

    {
        'terrortylor/nvim-comment'
    },

    {
        'tpope/vim-dadbod'
    },
    {
        'kristijanhusak/vim-dadbod-ui'
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
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    {'shaunsingh/nord.nvim'},
    {'lewis6991/gitsigns.nvim'},
    {'phdah/nvim-statusline'},
    {'phdah/nvim-databricks'},
    {'nvim-lua/plenary.nvim'},
    {'akinsho/git-conflict.nvim'},
    {'David-Kunz/gen.nvim'},
    {'voldikss/vim-floaterm'},

})
