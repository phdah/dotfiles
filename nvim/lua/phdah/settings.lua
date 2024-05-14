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

-- Set automatic pwd to the current buffer's pwd
vim.o.autochdir = true

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

-- Clean out all trailing ExtraWhitespace, and tabs
vim.api.nvim_create_user_command('Clean', function()
  local ok,_ = pcall(function() vim.cmd("%s/\\t\\+$\\| \\+$//") end)
  if not ok then
    print("No trailing whitespace found")
  end
end, {})

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

-- Set spelling on for specific files
local auGroupSpelling = vim.api.nvim_create_augroup("nvim-spelling-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroupSpelling,
    pattern = "markdown",
    callback = function()
        vim.cmd("setlocal spell! spelllang=en_us")
    end
})

-- Set configs for floaterm
local auGroupFloaterm = vim.api.nvim_create_augroup("nvim-floaterm-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroupFloaterm,
    pattern = "floaterm",
    callback = function()
        -- What will happen on entry
        vim.opt.mouse = "a"
        -- What will happen on exit
        vim.api.nvim_create_autocmd("BufLeave", {
            buffer = 0,
            once = true,
            callback = function()
                vim.o.mouse = ""
            end,
        })
    end,
})

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
        vim.cmd("!scala % " .. args)
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

