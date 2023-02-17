vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use {
        'wbthomason/packer.nvim'
    }

    -- You add plugins here
    use {
        'junegunn/fzf', run = ":call fzf#install()"
    }
    use { 'junegunn/fzf.vim' }

    use {
      'unblevable/quick-scope'
    }
end)
