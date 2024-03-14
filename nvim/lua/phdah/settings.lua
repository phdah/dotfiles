-- TODO: Move all coloring to it's own file.
-- It's importatnt that the nord theme coloring is
-- caled last.

-- Enable True color support
vim.opt.termguicolors = true

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
vim.cmd('highlight ColorColumn guifg=#4C566A')

-- Set up default tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4 -- set number of spaces, but treat as one object
vim.o.shiftwidth = 4 -- set width for 'enter' after tabbed line
vim.o.expandtab = true -- use spaces instead of tab

-- Turn of swap files
vim.opt.swapfile = false

-- Special setting for 'make' files
vim.cmd('autocmd FileType make setlocal noexpandtab')

-- Folding
vim.wo.foldmethod = 'indent'
vim.wo.foldenable = false

-- Set to only one status line
vim.o.laststatus = 3

-- Match command
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Highlighting for white space
vim.cmd([[
augroup MyCustomWhiteSpaceHighlights
  autocmd!
  autocmd ColorScheme * highlight ExtraWhitespace guibg=#BF616A
augroup END
]])

-- Clean out all trailing ExtraWhitespace
vim.api.nvim_create_user_command('Clean', function()
    vim.cmd("%s/ \\+$//")
end, {})

-- Set highlight groups for QuickScope
vim.cmd([[
augroup MyCustomHighlights
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg=#BF616A gui=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg=#D08770 gui=underline
augroup END
]])

-- Define custom highlight groups
vim.cmd [[
  highlight TodoHighlight ctermfg=Yellow ctermbg=NONE cterm=bold,underline gui=bold,underline guifg=#ffeb95 guibg=NONE
  highlight NoteHighlight ctermfg=Cyan ctermbg=NONE cterm=bold,underline gui=bold,underline guifg=#8be9fd guibg=NONE
]]

-- Match and link the keywords to the custom highlight groups
vim.api.nvim_exec([[
  autocmd Syntax * syn match TodoHighlight "\<TODO\>"
  autocmd Syntax * syn match NoteHighlight "\<NOTE\>"
]], false)


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

-- Set colorscheme to nord
vim.cmd[[colorscheme nord]]

-- Function to set the executor based on file type
_G.Define_Make = function(args)
    local filetype = vim.bo.filetype
    if filetype == 'python' then
        vim.cmd('DBRun ' .. args) -- nvim-databricks run command
    elseif filetype == 'sh' then
        vim.cmd('!bash % ' .. args)
    elseif filetype == 'c' or filetype == 'cpp' then
        vim.cmd('!make -C build && ./build/%< ' .. args)
    elseif filetype == 'scala' then
        vim.cmd("!scalac % && scala %< " .. args)
    elseif filetype == 'haskell' then
        vim.cmd("!ghc -no-keep-hi-files -no-keep-o-files -o %:r % && ./%:r " .. args)
    elseif filetype == 'lua' then
        vim.cmd("!luajit % " .. args)
    end
end

-- Create the :Make command
vim.api.nvim_create_user_command('Make', function(opts)
    _G.Define_Make(opts.args)
end, {nargs = "*"})

-- Global variable to hold the buffer ID
local buffer_id = nil
local buffer_opts = nil

-- Open floating buffer
vim.api.nvim_create_user_command('RunDB', function()
    -- Calculate window size as 90% of the current Neovim window
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)

    -- Calculate window position to be centered
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a new buffer and floating window
    local buf = vim.api.nvim_create_buf(false, true)
    buffer_id = buf
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single'  -- Add a border here
    }
    buffer_opts = opts
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Start the terminal with the command
    local file_path = vim.fn.expand('#:p')  -- Get the alternate buffer path
    vim.fn.termopen('runDB ' .. file_path, {detach = true})

    -- Set key mapping for 'q' to close the floating window
    local close_command = string.format(":lua vim.api.nvim_win_close(%s, false)<CR>", win)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', close_command, {noremap = true, silent = true})

    -- Set the buffer to the terminal buffer
    vim.api.nvim_set_current_buf(buf)
end, {})

-- Open the result buffer
vim.api.nvim_create_user_command('OpenRunDB', function()
    -- Open the already existing buffer
    if buffer_id then
        local win = vim.api.nvim_open_win(buffer_id, true, buffer_opts)
        local close_command = string.format(":lua vim.api.nvim_win_close(%s, false)<CR>", win)
        vim.api.nvim_buf_set_keymap(buffer_id, 'n', 'q', close_command, {noremap = true, silent = true})
    else
        print("No results to show, run :RunDB to generate it")
    end
end, {})
