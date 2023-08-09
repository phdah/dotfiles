-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use ({'wbthomason/packer.nvim'})

  use ({
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate"
	})
  use ({
        'junegunn/fzf',
        run = ":call fzf#install()"
    })
    use ({
        'junegunn/fzf.vim'
    })

    use ({
        'unblevable/quick-scope'
    })

    use ({
        'hashivim/vim-terraform'
    })
    use ({
        "terrortylor/nvim-comment"
    })

    use ({
        'tpope/vim-dadbod'
    })
    use ({
        'kristijanhusak/vim-dadbod-ui'
    })
    -- install without yarn or npm
    use ({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", 'mfussenegger/nvim-dap-python'} }
  end)
