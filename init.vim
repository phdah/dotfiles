""" Set up vim
"set show number as default
" Git Gutter"
set updatetime=100
let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd guifg=#00ff00 ctermfg=2
highlight GitGutterChange guifg=#ffff00 ctermfg=3
highlight GitGutterDelete guifg=#ff0000 ctermfg=1
highlight GitGutterChangeDelete guifg=#ff0000 ctermfg=4

" Status line
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

set statusline+=%{GitStatus()}
set laststatus=2

set number

"" tabs https://vim.fandom.com/wiki/Converting_tabs_to_spaces
"set up default tabs
set softtabstop=4 "set number of spaces, but treat as one object
set shiftwidth=4 "set width for 'enter' after tabbed line
set expandtab "use spaces instead of tab (use CTR-V<tab> for normal tab)

"tabs make
autocmd FileType make setlocal noexpandtab

"" syntax
syntax on

"" hilighting
"search
set hls
set incsearch
"https://vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)#Creating_keymaps
nnoremap <CR> :noh<CR><CR>
"whitespace
" The following alternative may be less obtrusive.
highlight ExtraWhitespace ctermbg=red guibg=red

" Show trailing whitespace:
match ExtraWhitespace /\s\+$/
