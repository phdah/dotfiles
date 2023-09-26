-- Git Gutter configuration
vim.o.updatetime = 50
vim.g.gitgutter_max_signs = 500
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_override_sign_column_highlight = 0

-- Highlight commands
vim.cmd([[
  highlight clear SignColumn
  highlight GitGutterAdd guifg=#A3BE8C
  highlight GitGutterChange guifg=#EBCB8B
  highlight GitGutterDelete guifg=#BF616A
  highlight GitGutterChangeDelete guifg=#BF616A
]])
