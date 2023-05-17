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
        'tpope/vim-dadbod'
    }
    use {
        'kristijanhusak/vim-dadbod-ui'
    }
    -- TODO: Figure out how to port to Chrome from wsl
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
end)
