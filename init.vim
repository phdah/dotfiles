" # Set up vim # "

" Neovim package manager
    lua require('plugins')

" Keymap leader key
    let mapleader = " "

" Key mapping
    " Reload vim config (rememeber to save the file first)
    nnoremap <leader>r :source ~/.config/nvim/init.vim<CR>:noh<CR>

    " Keybind insert
    inoremap <C-j> <Enter>
    inoremap <C-h> <BS>
    inoremap <C-e> <Esc>A
    inoremap <C-b> <Esc>I
    inoremap <C-x> <Del>

    " Keybind normal
    nnoremap <C-e> <End>
    nnoremap <C-b> I<Esc>
    nnoremap <C-h> xh
    nnoremap <C-x> x

    " Keybind visual
    vnoremap <C-e> <End>
    vnoremap <C-b> <Home>
    vnoremap <leader> <Nop>

    " Keybind Esc
    inoremap <C-k> <Esc>
    cnoremap <C-k> <Esc>
    nnoremap <C-k> <Esc>
    vnoremap <C-k> <Esc>

    " Keybind command
    cnoremap <C-j> <Enter>
    cnoremap <C-h> <BS>

    " Enter command mode
    nnoremap <C-f> :

    " Execute vim line in shell
    nnoremap <leader><Enter> :.!zsh<CR>

    " Remove newbie crutches in Normal and Mode
    nnoremap <Up> <Nop>
    nnoremap <Down> <Nop>
    nnoremap <Left> <Nop>
    nnoremap <Right> <Nop>

    " Remove newbie crutches in Visual Visual Mode
    vnoremap <Right> <Nop>
    vnoremap <Left> <Nop>
    vnoremap <Up> <Nop>
    vnoremap <Down> <Nop>

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

    " Buffer control
    nnoremap <CR> :noh<CR><CR>
    nnoremap <C-m> :noh<CR>
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
    nnoremap <leader>Q :bufdo bd!<CR>:q!<CR>

    " Open vim browser
    function! FilesGitRoot()
        " If git repo, show all files in repo.
        let root = trim(system('git rev-parse --show-toplevel'))
        if root == 'fatal: not a git repository (or any of the parent directories): .git'
            execute 'Files'
        else
            execute 'Files' root
        endif
    endfunction
    nnoremap <leader>f :call FilesGitRoot()<CR>
    nnoremap <leader>F :execute 'Files ~'<CR>
    nnoremap <leader>b :Buffers<CR>

    " Spell checking
    nnoremap <leader>z :setlocal spell! spelllang=en_us<CR>
    nnoremap <leader>Z 1z=
    nnoremap zl ]szz
    nnoremap zh [szz

    " Line toggle comment
    nnoremap <C-'> :CommentToggle<CR>
    vnoremap <C-'> :CommentToggle<CR>

    " Open help in its own buffer, use ':H <args>'
    command! -nargs=1 -complete=command -bar H help <args> | only

    " Center search
    set scrolloff=0
    nnoremap gg ggzz
    nnoremap G Gzz
    nnoremap n nzz
    nnoremap N Nzz
    nnoremap j jzz
    nnoremap k kzz
    nnoremap g* g*zz
    nnoremap g# g#zz
    nnoremap # #zz
    nnoremap * *zz
    nnoremap <C-d> <C-d>zz
    nnoremap <C-u> <C-u>zz

    " Open line above and below
    nnoremap <leader>o o<Esc>
    nnoremap <leader>O O<Esc>

    " Delete line and insert empty line
    nnoremap <leader>d Vc<Esc>

    " Git gutter commands
    nnoremap gj :GitGutterNextHunk<CR>zz
    nnoremap gk :GitGutterPrevHunk<CR>zz
    nnoremap gu :GitGutterUndoHunk<CR>
    nnoremap gd :GitGutterDiffOrig<CR>
    nnoremap gM :GitGutterFold<CR>
    nnoremap gs :GitGutterStageHunk<CR>

    " Repeat previous f, t, F or T movement
    nnoremap <leader>h ,
    nnoremap <leader>l ;

    " Jump between code blocks
    nnoremap <leader>j }zz
    nnoremap <leader>k {zz
    vnoremap <leader>j }zzk
    vnoremap <leader>k {zzj

    " Paste without yanking
    xnoremap <leader>p "_dP

    " Toggle number adn sign column
    nnoremap <leader>n :set invrelativenumber invnumber<CR>:GitGutterToggle<CR>

    " Setup Vim db
    nnoremap <silent> <leader>du :DBUIToggle<CR>
    " nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
    " nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
    " nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>
    let g:db_ui_save_location = '~/.config/db_ui'

    " Toggle markdown preview
    nnoremap <leader>md :MarkdownPreviewToggle<CR>

    " Packer Sync
    nnoremap <leader>s :PackerSync<CR>

" Set show number as default "
    set number
    set relativenumber

" Disable mouse
    set mouse=

" Set clipboard on
    set clipboard=unnamedplus

" Auto indent "
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
        let buffer = getbufinfo({'bufloaded': 1})[a:number-1].bufnr
        return buffer
    endfunction

    function! Buffer_lower()
        let bufferinfo = getbufinfo({'bufloaded': 1})
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
        let bufferinfo = getbufinfo({'bufloaded': 1})
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
        let bufferinfo = getbufinfo({'bufloaded': 1})
        let current_buffer = bufnr('%')

	let i = 1
        while bufferinfo[i-1].bufnr != current_buffer
		let i += 1
        endwhile

        return printf('%s', i)
    endfunction

    " Git and path/file name
    set statusline=
    set statusline+=%#CursorColumn#%{StatuslineGit()}%{GitStatus()}%#LineNr#
    set statusline+=\ %f%m
    " Buffers
    set statusline+=%=
    set statusline+=%{Buffer_lower()}%#CursorColumn#\[\ %{Buffer_current()}\ \]%#LineNr#%{Buffer_upper()}
    " File format and lines
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
    set nofoldenable

" Syntax "
   syntax on

" Highlighting "
    "search
    set hls
    set incsearch
    set inccommand=nosplit

    "white space
    " The following alternative may be less obtrusive.
    highlight ExtraWhitespace ctermbg=red guibg=red

    " Show trailing white space:
    match ExtraWhitespace /\s\+$/

    " Highlight signs to jump to
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    let g:qs_accepted_chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_', 'å', 'ä', 'ö', 'Å', 'Ä', 'Ö']
    highlight QuickScopePrimary guifg=#ff000 gui=underline ctermfg=DarkRed cterm=underline
    highlight QuickScopeSecondary guifg=#ff000 gui=underline ctermfg=DarkMagenta cterm=underline
