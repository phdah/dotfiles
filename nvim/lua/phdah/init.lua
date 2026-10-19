-- Load plugins first (installs/loads everything via vim.pack - see
-- plugins/init.lua for why this must run before anything else)
require("phdah.plugins")
-- Load basic configs
require("phdah.defaultremap")
require("phdah.remap")
require("phdah.lsp")
-- Finally load default settings to ensure they are not overwritten
require("phdah.settings")
require("phdah.keymap_conflicts")
