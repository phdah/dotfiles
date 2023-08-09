vim.g.mapleader = " "

-- Packer Sync
vim.api.nvim_set_keymap('n', '<leader>s', ':PackerSync<CR>', { noremap = true })

-- Key mapping
vim.api.nvim_set_keymap('n', '<leader>r', ':so<CR>', { noremap = true, silent = true })

-- Dap keymaps
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require("dap").toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("dap").continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("dap").terminate()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require("dap").step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':lua require("dap").step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cb', ':lua require("dap").clear_breakpoints()<CR>', { noremap = true, silent = true })

-- Execute vim line in shell
vim.api.nvim_set_keymap('n', '<leader><Enter>', ':.!zsh<CR>', { noremap = true })

-- Paste without yanking
vim.api.nvim_set_keymap('x', '<leader>p', '"_dP', { noremap = true, silent = true })

-- Buffer control
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-m>', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':bn<CR>', { noremap = true, silent = true })

-- Buffer control related to nvim_Cbuffer_number
vim.api.nvim_set_keymap('n', '<leader>1', ':lua vim.cmd("b" .. nvim_Cbuffer_number(1))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', ':lua vim.cmd("b" .. nvim_Cbuffer_number(2))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', ':lua vim.cmd("b" .. nvim_Cbuffer_number(3))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', ':lua vim.cmd("b" .. nvim_Cbuffer_number(4))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>5', ':lua vim.cmd("b" .. nvim_Cbuffer_number(5))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>6', ':lua vim.cmd("b" .. nvim_Cbuffer_number(6))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>7', ':lua vim.cmd("b" .. nvim_Cbuffer_number(7))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>8', ':lua vim.cmd("b" .. nvim_Cbuffer_number(8))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>9', ':lua vim.cmd("b" .. nvim_Cbuffer_number(9))<CR>', { noremap = true, silent = true })

-- Open vertical split
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })

-- Delete line and insert empty line
vim.api.nvim_set_keymap('n', '<leader>d', 'Vc<Esc>', { noremap = true, silent = true })

-- Dadbod commands
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Q', ':bufdo bd!<CR>:q!<CR>', { noremap = true })

-- Browse files
vim.api.nvim_set_keymap('n', '<leader>f', ':lua nvim_FilesGitRoot()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>F', ':execute \'Files ~\'<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>B', ':Buffers<CR>', { noremap = true })

-- Spell checking
vim.api.nvim_set_keymap('n', '<leader>z', ':setlocal spell! spelllang=en_us<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Z', '1z=', { noremap = true })
vim.api.nvim_set_keymap('n', 'zl', ']szz', { noremap = true })
vim.api.nvim_set_keymap('n', 'zh', '[szz', { noremap = true })

-- Line toggle comment
vim.api.nvim_set_keymap('n', '<leader>\'', ':CommentToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>\'', ':CommentToggle<CR>', { noremap = true })

-- Center search
vim.api.nvim_set_keymap('n', 'gg', 'ggzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'G', 'Gzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'n', 'nzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'j', 'jzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'kzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'g*', 'g*zz', { noremap = true })
vim.api.nvim_set_keymap('n', 'g#', 'g#zz', { noremap = true })
vim.api.nvim_set_keymap('n', '#', '#zz', { noremap = true })
vim.api.nvim_set_keymap('n', '*', '*zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true })

-- Open line above and below
vim.api.nvim_set_keymap('n', '<leader>o', 'o<Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>O', 'O<Esc>', { noremap = true })

-- Git gutter commands
vim.api.nvim_set_keymap('n', 'gj', ':GitGutterNextHunk<CR>zz', { noremap = true })
vim.api.nvim_set_keymap('n', 'gk', ':GitGutterPrevHunk<CR>zz', { noremap = true })
vim.api.nvim_set_keymap('n', 'gu', ':GitGutterUndoHunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gd', ':GitGutterDiffOrig<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gM', ':GitGutterFold<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gs', ':GitGutterStageHunk<CR>', { noremap = true })

-- Repeat previous f, t, F or T movement
vim.api.nvim_set_keymap('n', '<leader>h', ',', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', ';', { noremap = true })

-- Jump between code blocks
vim.api.nvim_set_keymap('n', '<leader>j', '}zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '{zz', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>j', '}zzk', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>k', '{zzj', { noremap = true })

-- Toggle number and sign column
vim.api.nvim_set_keymap('n', '<leader>n', ':set invrelativenumber invnumber<CR>:GitGutterToggle<CR>', { noremap = true })

-- Toggle markdown preview
vim.api.nvim_set_keymap('n', '<leader>md', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true })
