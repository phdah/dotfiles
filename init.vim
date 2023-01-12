" # Set up vim # "
"set show number as default "
    set number

" Autoindent "
    set noautoindent
    filetype indent off
    autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    "set fo-=ro

" Git Gutter "
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

" Status line "
    function! GitBranch()
      return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    endfunction

    function! StatuslineGit()
      let l:branchname = GitBranch()
      return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
    endfunction

    function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
      return printf(' | +%d ~%d -%d ', a, m, r)
    endfunction

    function! Buffer_lower()
        let buffer_total = len(getbufinfo({'buflisted':1}))
        let current_buffer = bufnr('%')
        let lower_bound = range(1,current_buffer-1)
        if buffer_total == 1
            return printf('')
        elseif current_buffer == 1
            return printf('')
        else
            return printf('%s', string(lower_bound))
        endif
    endfunction

    function! Buffer_upper()
        let buffer_total = len(getbufinfo({'buflisted':1}))
        let current_buffer = bufnr('%')
        let upper_bound = range(current_buffer+1,buffer_total)
        if buffer_total == 1
            return printf('')
        elseif current_buffer == buffer_total
            return printf('')
        else
            return printf('%s', string(upper_bound))
        endif
    endfunction
    " Git and path/filename
    set statusline=
    set statusline+=%#PmenuSel#%{StatuslineGit()}%{GitStatus()}%#LineNr#
    set statusline+=\ %f%m
    " Buffers
    set statusline+=%=
    set statusline+=%{Buffer_lower()}%#CursorColumn#\[\ %n\ \]%#LineNr#%{Buffer_upper()}
    " Fileformat and lines
    set statusline+=%=
    set statusline+=%#CursorColumn#\ %y\ %{&fileencoding?&fileencoding:&encoding}\[%{&fileformat}\]
    set statusline+=\ %p%%\ %l:%c\ 

" Width limit "
" TODO: set colorcolumn=80

"" tabs https://vim.fandom.com/wiki/Converting_tabs_to_spaces
"set up default tabs "
    set softtabstop=4 "set number of spaces, but treat as one object
    set shiftwidth=4 "set width for 'enter' after tabbed line
    set expandtab "use spaces instead of tab (use CTR-V<tab> for normal tab)

    "tabs make
    autocmd FileType make setlocal noexpandtab

" folding "
    set foldmethod=indent

" syntax "
   syntax on

" hilighting "
    "search
    set hls
    set incsearch
    set inccommand=nosplit

    "https://vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)#Creating_keymaps
    nnoremap <CR> :noh<CR><CR>
    "whitespace
    " The following alternative may be less obtrusive.
    highlight ExtraWhitespace ctermbg=red guibg=red

    " Show trailing whitespace:
    match ExtraWhitespace /\s\+$/
