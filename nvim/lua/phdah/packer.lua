-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use ({
        'wbthomason/packer.nvim'
    })

    use ({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    })
    use ({'p00f/nvim-ts-rainbow'})

    use ({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- DAP support
            {'jay-babu/mason-nvim-dap.nvim'}
        }
    })

    use ({
        'junegunn/fzf',
        run = ':call fzf#install()'
    })
    use ({
        'junegunn/fzf.vim'
    })

    use ({
        'unblevable/quick-scope'
    })

    use ({
        'terrortylor/nvim-comment'
    })

    use ({
        'tpope/vim-dadbod'
    })
    use ({
        'kristijanhusak/vim-dadbod-ui'
    })
    -- install without yarn or npm
    use ({
        'iamcco/markdown-preview.nvim',
        run = function() vim.fn['mkdp#util#install']() end,
    })
    use ({
        'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
            'mfussenegger/nvim-dap-python',
            'jbyuki/one-small-step-for-vimkind',
            'theHamsta/nvim-dap-virtual-text',
            'tomblind/local-lua-debugger-vscode',
        }
    })
    use ({'shaunsingh/nord.nvim'})
    use ({'phdah/nvim-statusline'})
    use ({'phdah/nvim-databricks'})
    use ({'nvim-lua/plenary.nvim'})

end)
