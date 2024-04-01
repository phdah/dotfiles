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
        'unblevable/quick-scope'
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
            'mfussenegger/nvim-dap-python',
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

    {'shaunsingh/nord.nvim'},
    {'airblade/vim-gitgutter'},
    {'phdah/nvim-statusline'},
    {'phdah/nvim-databricks'},
    {'nvim-lua/plenary.nvim'},
    {'akinsho/git-conflict.nvim'},
    {'David-Kunz/gen.nvim'},
    {'voldikss/vim-floaterm'},

})
