vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use {
        'wbthomason/packer.nvim'
    }

    -- You add plugins here
    use {
        'junegunn/fzf',
        run = ":call fzf#install()"
    }
    use {
        'junegunn/fzf.vim'
    }

    use {
        'unblevable/quick-scope'
    }

    use {
        'hashivim/vim-terraform'
    }
    use {
        "terrortylor/nvim-comment",
        require('nvim_comment').setup(
            {
                -- should comment out empty or whitespace only lines
                comment_empty = false,
                -- Normal mode mapping left hand side
                line_mapping = "gcc",
                -- Visual/Operator mapping left hand side
                operator_mapping = "gc"
            }
        )
    }
    use {
        'tpope/vim-dadbod'
    }
    use {
        'kristijanhusak/vim-dadbod-ui'
    }
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use({
        "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" },
    })
    use {
        "rcarriga/nvim-dap-ui",
    requires = {
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python"
        }
    }
end)
