-- Colorscheme only - no setup() needed. Must be eager (and loaded first,
-- see init.lua) so settings.lua's `vim.cmd.colorscheme("nord")` always
-- finds it already active.
require("phdah.plugins.lib").eager({ "nord.nvim" })
