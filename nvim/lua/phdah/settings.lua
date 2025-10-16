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
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "#BF616A" })
        vim.api.nvim_set_hl(0, "NonText", { fg = "#838996" })
    end,
})

-- Set up default tabs
local setDefaults = function()
    local fileType = vim.bo.filetype
    if fileType == "make" or fileType == "go" then
        vim.o.expandtab = false -- use tab instead of space
    elseif fileType == "yaml" or fileType == "scala" then
        -- Tab settings
        vim.o.tabstop = 2
        vim.o.softtabstop = 2 -- set number of spaces, but treat as one object
        vim.o.shiftwidth = 2 -- set width for 'enter' after tabbed line
        vim.o.expandtab = true -- use spaces instead of tab
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

-- Set short message (a)ll and (t)runcate filename
vim.o.shortmess = "at"

-- Set window boarder to rounded
vim.o.winborder = "rounded"

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
local whiteGroup =
    vim.api.nvim_create_augroup("MyCustomWhiteSpaceHighlights", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "ColorScheme" }, {
    group = whiteGroup,
    pattern = "*",
    callback = function()
        local fileType = vim.bo.filetype
        if
            fileType ~= ""
            and fileType ~= "dbee"
            and fileType ~= "snacks_picker_list"
            and fileType ~= "snacks_dashboard"
            and fileType ~= "opencode_terminal"
        then
            -- Only apply the highlight if the buffer has a filetype
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

vim.o.diffopt = "internal,filler,closeoff,linematch:60"

-- Set filechar and colors for diff
vim.opt.fillchars:append("diff: ")
-- Tokyonight colors: https://github.com/folke/tokyonight.nvim/blob/775f82f08a3d1fb55a37fc6d3a4ab10cd7ed8a10/extras/lua/tokyonight_night.lua#L899
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

-- Set spelling on for specific files
local auGroupSpelling =
    vim.api.nvim_create_augroup("nvim-spelling-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroupSpelling,
    pattern = { "markdown", "octo" },
    callback = function()
        vim.cmd("setlocal spell! spelllang=en_us")
    end,
})

-- Set configs for floaterm
local auGroupFloaterm =
    vim.api.nvim_create_augroup("nvim-floaterm-custom", { clear = true })
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
        vim.cmd("silent! DBRun " .. args) -- nvim-databricks run command
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

-- Set PYTHONPATH same as LSP
local function setPythonPathToRoot()
    local filetype = vim.bo.filetype
    local PYTHONPATH = nil

    if filetype == "python" then
        local client = vim.lsp.get_clients({ bufnr = 0, name = "pyright" })[1]
        local cfg = client.config
        local root = cfg.root_dir
        local extra = cfg.settings.python.analysis.extraPaths or {}

        local paths = {}
        table.insert(paths, root)
        for _, p in ipairs(extra) do
            table.insert(paths, root .. "/" .. p)
        end
        local PYTHONPATH = table.concat(paths, ":")
        vim.fn.setenv("PYTHONPATH", PYTHONPATH)
    end
    return PYTHONPATH
end

vim.api.nvim_create_user_command("PythonPath", function(opts)
    local snacks = require("snacks")
    local root = setPythonPathToRoot()
    if root ~= nil then
        snacks.notify.info("PYTHONPATH set to: " .. root)
    end
end, { nargs = "*" })

local filetypeAC = vim.api.nvim_create_augroup("pyright-autocommands", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = filetypeAC,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.name == "pyright" then
            setPythonPathToRoot()
        end
    end,
})

-- Quickfix list
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "", {
            noremap = true,
            silent = true,
            callback = function()
                local lineNumber = vim.fn.line(".")
                vim.cmd("cc " .. lineNumber)
            end,
        })
        vim.api.nvim_buf_set_keymap(0, "n", "cl", ":cclose<CR>", { silent = true })
    end,
})
