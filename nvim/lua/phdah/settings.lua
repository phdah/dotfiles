-- TODO: Move all coloring to it's own file.
-- It's importatnt that the nord theme coloring is
-- caled last.
-- Enable True color support
vim.opt.termguicolors = true

-- Setup copy/paste for Windows
vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
vim.g.clipboard = {
    name = "pbcopy/paste",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
}

-- Width limit
vim.wo.colorcolumn = "80"
vim.cmd("highlight ColorColumn guifg=#4C566A")

-- Set up default tabs
local setDefaults = function()
    local fileType = vim.bo.filetype
    if fileType == "make" or fileType == "go" then
        vim.o.expandtab = false -- use tab instead of space
    else
        -- Tab settings
        vim.o.tabstop = 4
        vim.o.softtabstop = 4 -- set number of spaces, but treat as one object
        vim.o.shiftwidth = 4 -- set width for 'enter' after tabbed line
        vim.o.expandtab = true -- use spaces instead of tab
    end

    -- Auto resize windows when window changes size
    vim.api.nvim_create_autocmd("VimResized", {
        command = "wincmd =",
    })

    -- Auto-indent configurations
    vim.o.autoindent = false -- Disable auto-indentation
    vim.bo.autoindent = false -- Ensure local buffer autoindent is off
    vim.cmd("filetype indent off") -- Disable filetype-specific indentation
    -- Adjust formatoptions
    vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Remove auto-commenting and auto-wrapping
end
setDefaults()

local defaultGroup = vim.api.nvim_create_augroup("DefaultTabSettings", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = defaultGroup,
    pattern = "*",
    callback = setDefaults,
})

-- Set automatic pwd to the current buffer's pwd
vim.o.autochdir = true

-- Turn of swap files
vim.opt.swapfile = false

-- Folding
vim.wo.foldmethod = "indent"
vim.wo.foldenable = false

-- Set to only one status line
vim.o.laststatus = 3

-- Highlighting for white space
local whiteGroup = vim.api.nvim_create_augroup("MyCustomWhiteSpaceHighlights", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "ColorScheme" }, {
    group = whiteGroup,
    pattern = "*",
    callback = function()
        local fileType = vim.bo.filetype
        if fileType ~= "" and fileType ~= "dbee" then
            -- Only apply the highlight if the buffer has a filetype
            vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "#BF616A" })
            vim.fn.matchadd("ExtraWhitespace", "\\s\\+$")
        end
    end,
})

-- Clean out all trailing ExtraWhitespace, and tabs
vim.api.nvim_create_user_command("Clean", function()
    local snacks = require("snacks")
    -- Clean out all trailing ExtraWhitespace, and tabs
    local ok, _ = pcall(function()
        vim.cmd("%s/\\t\\+$\\| \\+$//")
    end)
    if ok then
        snacks.notify.info("Found and removed all trailing whitespace")
    end
end, {})

-- Set show number as default
vim.wo.number = true
vim.wo.relativenumber = true

-- Disable mouse
require("nvim-utils").Mouse:new(false)
vim.api.nvim_create_user_command("MouseToggle", function()
    require("nvim-utils").Mouse:toggle()
end, {})

-- Open help in its own buffer, use ':H <args>'
vim.cmd([[command! -nargs=1 -complete=command -bar H help <args> | only]])

-- Center search
vim.o.scrolloff = 0

-- Set colorscheme to nord
vim.cmd([[colorscheme nord]])

-- Set filechar and colors for diff
vim.opt.fillchars:append("diff: ")
-- Tokyonight colors: https://github.com/folke/tokyonight.nvim/blob/775f82f08a3d1fb55a37fc6d3a4ab10cd7ed8a10/extras/lua/tokyonight_night.lua#L899
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

-- Set spelling on for specific files
local auGroupSpelling = vim.api.nvim_create_augroup("nvim-spelling-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroupSpelling,
    pattern = "markdown",
    callback = function()
        vim.cmd("setlocal spell! spelllang=en_us")
    end,
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
local function defineMake(args)
    local filetype = vim.bo.filetype
    if filetype == "python" then
        vim.cmd("DBRun " .. args) -- nvim-databricks run command
    elseif filetype == "sh" then
        vim.cmd("!bash % " .. args)
    elseif filetype == "c" or filetype == "cpp" then
        vim.cmd("!make -C build && ./build/%< " .. args)
    elseif filetype == "scala" then
        vim.cmd("!scala % " .. args)
    elseif filetype == "haskell" then
        vim.cmd("!ghc -no-keep-hi-files -no-keep-o-files -o %:r % && ./%:r " .. args)
    elseif filetype == "lua" then
        vim.cmd("!luajit % " .. args)
    elseif filetype == "make" then
        vim.cmd("!make " .. args)
    elseif filetype == "go" then
        vim.cmd("!go run % " .. args)
    end
end

-- Create the :Make command
vim.api.nvim_create_user_command("Make", function(opts)
    defineMake(opts.args)
end, { nargs = "*" })

local function resizeSplitsEqually()
    local total_width = 0
    local num_splits = vim.fn.winnr("$")
    -- Iterate over all windows to get the total width
    for i = 1, num_splits do
        total_width = total_width + vim.api.nvim_win_get_width(vim.fn.win_getid(i))
    end
    local new_width = math.floor(total_width / num_splits)
    for i = 1, num_splits do
        vim.cmd(i .. "wincmd w")
        vim.cmd("vertical resize " .. new_width)
    end
end

vim.api.nvim_create_user_command("EqualizeSplits", function()
    resizeSplitsEqually()
end, {})
