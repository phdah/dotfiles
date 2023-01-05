""" Set up vim
"set show number as default
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
