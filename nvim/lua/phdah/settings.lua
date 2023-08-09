-- Setup copy/paste for Windows
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
vim.g.clipboard = {
    name = 'pbcopy/paste',
    copy = {
        ['+'] = 'pbcopy',
        ['*'] = 'pbcopy',
    },
    paste = {
        ['+'] = 'pbpaste',
        ['*'] = 'pbpaste',
    },
    cache_enabled = 0
}

-- Width limit
vim.wo.colorcolumn = "80"
vim.cmd('highlight ColorColumn ctermbg=238')

-- Set up default tabs
vim.bo.softtabstop = 4 -- set number of spaces, but treat as one object
vim.bo.shiftwidth = 4 -- set width for 'enter' after tabbed line
vim.bo.expandtab = true -- use spaces instead of tab


-- Special setting for 'make' files
vim.cmd('autocmd FileType make setlocal noexpandtab')

-- Folding
vim.wo.foldmethod = 'indent'
vim.wo.foldenable = false

-- Highlighting for white space
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=red')
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Set show number as default
vim.wo.number = true
vim.wo.relativenumber = true

-- Disable mouse
vim.o.mouse = ""

-- Open help in its own buffer, use ':H <args>'
vim.cmd[[command! -nargs=1 -complete=command -bar H help <args> | only]]

-- Center search
vim.o.scrolloff = 0

-- Auto indent configurations
vim.o.autoindent = false
vim.cmd[[filetype indent off]]
vim.cmd[[autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]
