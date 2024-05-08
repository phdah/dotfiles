-- llama gen
vim.api.nvim_set_keymap('n', '<C-g>', ':Gen Chat<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-g>', ':Gen Ask<CR>', { noremap = true, silent = true })

-- LSP keymaps
vim.api.nvim_set_keymap('n', '<leader>g', ':lua nvim_quickfix_navigation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

-- Quickfix list
vim.api.nvim_set_keymap('n', 'cn', ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cp', ':cprev<CR>', { noremap = true, silent = true })

-- Flash jump
vim.api.nvim_set_keymap('n', 's', '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 's', '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 's', '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })

-- Flash Treesitter
vim.api.nvim_set_keymap('n', 'S', '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'S', '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'S', '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })

-- Git conflict
vim.api.nvim_set_keymap('n', 'cl', ':GitConflictListQf<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'co', ':GitConflictChooseOurs<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'ct', ':GitConflictChooseTheirs<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'c0', ':GitConflictChooseBoth<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'cb', ':GitConflictChooseNone<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'cj', ':GitConflictNextConflict<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'ck', ':GitConflictPrevConflict<CR>', { silent = true })

-- lazygit
vim.api.nvim_set_keymap('n', '<C-l>', ':FloatermNew --width=0.9 --height=0.9 lazygit<CR>', { noremap = true, silent = true })

-- Octo GitHub pull requests
vim.api.nvim_set_keymap('n', '<C-o>', ':Octo<CR>', { noremap = true, silent = true })

-- Other git commands
vim.api.nvim_set_keymap('n', 'gp', ':w | FloatermNew --width=0.9 --height=0.9 git add -p %<CR>', { noremap = true, silent = true })

-- Dap keymaps
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require("dap").toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("dap").continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':lua _G.Dapui_terminate()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require("dap").step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':lua require("dap").step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':lua require("dap").step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>CB', ':lua require("dap").clear_breakpoints()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>r', ':lua require("dapui").open({reset = true})<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>B', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition (key==\'value\'): "))<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dh', ':lua require("dap.ui.widgets").hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>db', ':DapNvimDebugee<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ds', ':DapNvimSource<CR>', { noremap = true, silent = true })

-- Execute vim line in shell
vim.api.nvim_set_keymap('n', '<leader><Enter>', ':.!zsh<CR>', { noremap = true, silent = true })

-- Buffer control
vim.api.nvim_set_keymap('n', '<C-m>', ':noh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':bn<CR>', { noremap = true, silent = true })

-- Close buffers
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Q', ':bd!<CR>', { noremap = true, silent = true })

-- Window control
vim.api.nvim_set_keymap('n', '<S-Right>', ':vertical resize +3<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', '<S-Left>', ':vertical resize -3<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', '<S-Up>', ':resize +1<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', '<S-Down>', ':resize -1<CR>', { noremap = true, silent = true  })

-- Open vertical split
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })

-- Delete line and insert empty line
vim.api.nvim_set_keymap('n', '<leader>d', 'Vc<Esc>', { noremap = true, silent = true })

-- DBee database
vim.api.nvim_set_keymap('n', '<leader>ö', ':lua require("dbee").toggle()<CR>', { noremap = true, silent = true })

-- Browse files
vim.api.nvim_set_keymap('n', '<leader>ff', ':lua require("phdah/telescope").find_files_git()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fF', ":lua require('telescope.builtin').find_files({cwd='~'})<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', ':lua require("phdah/telescope").live_grep_git()<CR>', { noremap = true, silent = true })

-- Spell checking
vim.api.nvim_set_keymap('n', '<leader>z', ':setlocal spell! spelllang=en_us<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'z=', ":lua require('telescope.builtin').spell_suggest()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Z', '1z=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zl', ']szz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zh', '[szz', { noremap = true, silent = true })

-- Line toggle comment
vim.api.nvim_set_keymap('n', '<leader>\'', ':CommentToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>\'', ':CommentToggle<CR>', { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('n', 'gj', ':lua require("gitsigns").nav_hunk("next")<CR>zz', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gk', ':lua require("gitsigns").nav_hunk("prev")<CR>zz', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gu', ':lua require("gitsigns").reset_hunk()<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gU', ':lua require("gitsigns").undo_stage_hunk()<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gd', ':lua require("gitsigns").diffthis()<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gs', ':lua require("gitsigns").stage_hunk()<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('n', 'gb', ':lua require("gitsigns").blame_line()<CR>', { noremap = true, silent = true  })
vim.api.nvim_set_keymap('v', 'gs', [[:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>]], { noremap = true, silent = true  })

-- Jump between code blocks
vim.api.nvim_set_keymap('n', '<leader>j', '}zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '{zz', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>j', '}zzk', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>k', '{zzj', { noremap = true })

-- Toggle number and sign column
vim.api.nvim_set_keymap('n', '<leader>n', ':set invrelativenumber invnumber<CR>:GitGutterToggle<CR>', { noremap = true, silent = true })

-- Toggle markdown preview
vim.api.nvim_set_keymap('n', '<leader>MD', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true })

-- Command line remaps
vim.api.nvim_set_keymap('c', '<D-Left>', '<Home>', { noremap = true })
vim.api.nvim_set_keymap('c', '<D-Right>', '<End>', { noremap = true })
vim.api.nvim_set_keymap('c', '<M-Left>', '<S-Left>', { noremap = true })
vim.api.nvim_set_keymap('c', '<M-Right>', '<S-Right>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-k>', '<C-c>', { noremap = true })

