-- Git Gutter configuration
vim.o.updatetime = 50
vim.g.gitgutter_max_signs = 500
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_override_sign_column_highlight = 0

-- Highlight commands
vim.cmd([[
  highlight clear SignColumn
  highlight GitGutterAdd guifg=#00ff00 ctermfg=2
  highlight GitGutterChange guifg=#ffff00 ctermfg=3
  highlight GitGutterDelete guifg=#ff0000 ctermfg=1
  highlight GitGutterChangeDelete guifg=#ff0000 ctermfg=4
]])
