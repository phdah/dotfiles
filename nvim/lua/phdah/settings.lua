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
vim.o.tabstop = 4
vim.o.softtabstop = 4 -- set number of spaces, but treat as one object
vim.o.shiftwidth = 4 -- set width for 'enter' after tabbed line
vim.o.expandtab = true -- use spaces instead of tab


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
vim.opt.autoindent = false
vim.cmd[[filetype indent off]]
vim.cmd[[autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]

-- Function to set the executor based on file type
_G.Define_Make = function(args)
    local filetype = vim.bo.filetype
    if filetype == 'python' then
        vim.cmd('!python3 % ' .. args)
    elseif filetype == 'sh' then
        vim.cmd('!bash % ' .. args)
    elseif filetype == 'lua' then
        vim.cmd('!lua % ' .. args)
    elseif filetype == 'c' or filetype == 'cpp' then
        vim.cmd('!make -C build && ./build/%< ' .. args)
    elseif filetype == 'scala' then
        vim.cmd("!scalac % && scala %< " .. args)
    end
end

-- Create the :Make command
vim.cmd("command! -nargs=* Make lua _G.Define_Make(<q-args>)")
