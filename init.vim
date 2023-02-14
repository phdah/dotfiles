" # Set up vim # "

" Neovim package manager
    lua require('plugins')

" Neovim color scheme
    highlight Normal guibg=blue

" Key mapping
    " Remove newbie crutches in Normal and Visual Mode
    noremap <Up> <Nop>
    noremap <Down> <Nop>
    noremap <Left> <Nop>
    noremap <Right> <Nop>

    " Remove newbie crutches in Normal Ctrl Mode
    nnoremap <C-Right> <Nop>
    nnoremap <C-Left> <Nop>
    nnoremap <C-Up> <Nop>
    nnoremap <C-Down> <Nop>

    " Remove newbie crutches in Visual Ctrl Mode
    vnoremap <C-Right> <Nop>
    vnoremap <C-Left> <Nop>
    vnoremap <C-Up> <Nop>
    vnoremap <C-Down> <Nop>

    " Remove newbie crutches in Insert Mode
    inoremap <Down> <Nop>
    inoremap <Left> <Nop>
    inoremap <Right> <Nop>
    inoremap <Up> <Nop>

    " Remove newbie crutches in Insert Ctrl Mode
    inoremap <C-Right> <Nop>
    inoremap <C-Left> <Nop>
    inoremap <C-Up> <Nop>
    inoremap <C-Down> <Nop>

    let mapleader = " "

    " Buffer control
    nnoremap <CR> :noh<CR><CR>

    nnoremap <leader>1 :execute 'b'.Cbuffer_number(1)<CR>
    nnoremap <leader>2 :execute 'b'.Cbuffer_number(2)<CR>
    nnoremap <leader>3 :execute 'b'.Cbuffer_number(3)<CR>
    nnoremap <leader>4 :execute 'b'.Cbuffer_number(4)<CR>
    nnoremap <leader>5 :execute 'b'.Cbuffer_number(5)<CR>
    nnoremap <leader>6 :execute 'b'.Cbuffer_number(6)<CR>
    nnoremap <leader>7 :execute 'b'.Cbuffer_number(7)<CR>
    nnoremap <leader>8 :execute 'b'.Cbuffer_number(8)<CR>
    nnoremap <leader>9 :execute 'b'.Cbuffer_number(9)<CR>

    nnoremap <leader>q :bd<CR>

    " Open vim browser
    nnoremap <leader>f :Files<CR>
    nnoremap <leader>b :Buffers<CR>

    " Center search
    set scrolloff=0
    nnoremap gg ggzz
    nnoremap n nzz
    nnoremap N Nzz
    nnoremap j jzz
    nnoremap k kzz
    nnoremap g* g*zz
    nnoremap g# g#zz
    nnoremap # #zz
    nnoremap * *zz

    " Toggle relative linenumbers
    nnoremap <leader>l :set invrelativenumber<CR>

    " Packer Sync
    nnoremap <leader>s :PackerSync<CR>

" Set show number as default "
    set number
    set relativenumber

" Disable mouse
    set mouse=

" Set clipboard on
    set clipboard=unnamedplus

" Autoindent "
    set noautoindent
    filetype indent off
    autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Git Gutter "
    set updatetime=50
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
      return strlen(l:branchname) > 0?' Branch: '.l:branchname.' ':''
    endfunction

    function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
      return printf(' | +%d ~%d -%d ', a, m, r)
    endfunction

    function! Cbuffer_number(number)
        let buffer = getbufinfo({'bufloaded': 1, 'buflisted': 1})[a:number-1].bufnr
        return buffer
    endfunction

    function! Buffer_lower()
        let bufferinfo = getbufinfo({'bufloaded': 1, 'buflisted': 1})
        let current_buffer = bufnr('%')

        let lower_bound = []

        let i = 1
        while bufferinfo[i-1].bufnr < current_buffer
                call add(lower_bound, i)
                let i += 1
        endwhile

        if lower_bound == []
            return printf('')
        else
            return printf('%s', lower_bound)
        endif
    endfunction

    function! Buffer_upper()
        let bufferinfo = getbufinfo({'bufloaded': 1, 'buflisted': 1})
        let current_buffer = bufnr('%')

	let i = 1
        while bufferinfo[i-1].bufnr != current_buffer
		let i += 1
        endwhile

        let upper_bound = range(i+1, len(bufferinfo))

        if upper_bound == []
            return printf('')
        else
            return printf('%s', upper_bound)
        endif
    endfunction

    function! Buffer_current()
        let bufferinfo = getbufinfo({'bufloaded': 1, 'buflisted': 1})
        let current_buffer = bufnr('%')

	let i = 1
        while bufferinfo[i-1].bufnr != current_buffer
		let i += 1
        endwhile

        return printf('%s', i)
    endfunction

    " Git and path/filename
    set statusline=
    set statusline+=%#PmenuSel#%{StatuslineGit()}%{GitStatus()}%#LineNr#
    set statusline+=\ %f%m
    " Buffers
    set statusline+=%=
    set statusline+=%{Buffer_lower()}%#CursorColumn#\[\ %{Buffer_current()}\ \]%#LineNr#%{Buffer_upper()}
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
