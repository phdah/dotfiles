" # Set up vim # "

" Key mapping
    let mapleader = " "

    nnoremap <CR> :noh<CR><CR>

    nnoremap <leader>1 :b1<CR>
    nnoremap <leader>2 :b2<CR>
    nnoremap <leader>3 :b3<CR>
    nnoremap <leader>4 :b4<CR>
    nnoremap <leader>5 :b5<CR>
    nnoremap <leader>6 :b6<CR>
    nnoremap <leader>7 :b7<CR>
    nnoremap <leader>8 :b8<CR>
    nnoremap <leader>9 :b9<CR>

    nnoremap <leader>q :bd<CR>

" Set show number as default "
    set number

" Set clipboard on
    set clipboard=unnamedplus

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
        let bufferinfo = getbufinfo({'bufloaded': 1, 'buflisted': 1})
        let buffer_total = bufferinfo[len(bufferinfo)-1].bufnr
        let current_buffer = bufnr('%')

        let lower_bound = []

        for item in bufferinfo
            if item.bufnr >= current_buffer
                continue
            endif
            call add(lower_bound, item.bufnr)
        endfor

        if len(bufferinfo) == 1 || current_buffer == 1
            return printf('')
        else
            return printf('%s', lower_bound)
    endfunction

    function! Buffer_upper()
        let bufferinfo = getbufinfo({'bufloaded': 1, 'buflisted': 1})
        let buffer_total = bufferinfo[len(bufferinfo)-1].bufnr
        let current_buffer = bufnr('%')

        let upper_bound = []

        for item in bufferinfo
            if item.bufnr <= current_buffer
                continue
            endif
            call add(upper_bound, item.bufnr)
        endfor

        if current_buffer == buffer_total
            return printf('')
        else
            return printf('%s', upper_bound)
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
    set colorcolumn=80
    highlight ColorColumn ctermbg=238

" Set up default tabs "
    set softtabstop=4 "set number of spaces, but treat as one object
    set shiftwidth=4 "set width for 'enter' after tabbed line
    set expandtab "use spaces instead of tab (use CTR-V<tab> for normal tab)

    "tabs make
    autocmd FileType make setlocal noexpandtab

" Folding "
    set foldmethod=indent

" Syntax "
   syntax on

" Hilighting "
    "search
    set hls
    set incsearch
    set inccommand=nosplit

    "whitespace
    " The following alternative may be less obtrusive.
    highlight ExtraWhitespace ctermbg=red guibg=red

    " Show trailing whitespace:
    match ExtraWhitespace /\s\+$/
