----------------------------------------------------------------------------
-- Leader keys. Must be set before any keymap any module below binds a
-- <leader>-prefixed mapping.
----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- `nvim-utils` is plain Lua with no `plugin/` files, and is needed
-- everywhere (even by settings.lua), so it's added to the runtimepath
-- immediately - unlike `nvim-dbee`/`cmp-dbee` (see plugins/nvim-dbee.lua),
-- which ship `plugin/` files that eagerly `require("dbee")` as soon as
-- they're sourced, so (to keep them genuinely lazy) their path is only
-- prepended once actually triggered.
vim.opt.rtp:prepend(vim.fn.expand("~/repos/privat/nvim-utils"))

----------------------------------------------------------------------------
-- This file is only a table of contents: each `require()` below either
-- loads an "always on" plugin right now (see plugins/lib.lua's `eager()`),
-- or - for everything else - just registers the keymap/command/filetype
-- trigger that will load it later. Each module owns its own complete
-- behaviour: install spec lookup, trigger, setup, and keymaps.
--
-- Eager modules are required first and in this specific order
-- (colorscheme/treesitter first) so that settings.lua (required
-- immediately after this file, see phdah/init.lua) always sees them fully
-- active - this is what fixes the old "colorscheme/plugin loaded after my
-- settings already ran" ordering bug. Lazy modules are a flat, unordered
-- list; see each one for its trigger.
----------------------------------------------------------------------------

-- Eager
require("phdah.plugins.nord")
require("phdah.plugins.treesitter")
require("phdah.plugins.marks")
require("phdah.plugins.gitsigns")
require("phdah.plugins.surround")
require("phdah.plugins.snacks")
require("phdah.plugins.vimtex")
require("phdah.plugins.flash")

-- Lazy
require("phdah.plugins.diffview")
require("phdah.plugins.colorizer")
require("phdah.plugins.oil")
require("phdah.plugins.octo")
require("phdah.plugins.mason")
require("phdah.plugins.nvim-java")
require("phdah.plugins.blink")
require("phdah.plugins.nvim-comment")
require("phdah.plugins.nvim-dbee")
require("phdah.plugins.snake")
require("phdah.plugins.dap")
require("phdah.plugins.nvim-metals")
require("phdah.plugins.quickbuf")
require("phdah.plugins.nvim-statusline")
require("phdah.plugins.mini-ai")
require("phdah.plugins.neogen")
require("phdah.plugins.plenary")
require("phdah.plugins.quicker")
require("phdah.plugins.gen")
require("phdah.plugins.golf")
require("phdah.plugins.snipe-marks")
require("phdah.plugins.csvview")
require("phdah.plugins.yank-path")
require("phdah.plugins.opencode")
require("phdah.plugins.obsidian")
require("phdah.plugins.render-markdown")
require("phdah.plugins.live-preview")
