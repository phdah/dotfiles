-- Remove newbie crutches in Normal mode
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<Nop>', { noremap = true, silent = true })

-- Remove newbie crutches in Visual mode
vim.api.nvim_set_keymap('v', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Down>', '<Nop>', { noremap = true, silent = true })

-- Remove newbie crutches in Insert mode
vim.api.nvim_set_keymap('i', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Right>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Down>', '<Nop>', { noremap = true, silent = true })

-- Keybind insert
vim.api.nvim_set_keymap('i', '<C-j>', '<Enter>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<Esc>A', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-b>', '^', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-x>', '<Del>', { noremap = true })

-- Keybind normal
vim.api.nvim_set_keymap('n', '<C-e>', '<End>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-b>', '^', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', 'xh', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-x>', 'x', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>', '<Nop>', { noremap = true })

-- Keybind visual
vim.api.nvim_set_keymap('v', '<C-e>', '<End>h', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-b>', '^', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>', '<Nop>', { noremap = true })

-- Keybind Esc
vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-k>', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-k>', '<Esc>', { noremap = true })

-- Keybind command
vim.api.nvim_set_keymap('c', '<C-j>', '<Enter>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-h>', '<BS>', { noremap = true })

-- Enter command mode
vim.api.nvim_set_keymap('n', '<C-f>', ':', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-f>', ':', { noremap = true })

