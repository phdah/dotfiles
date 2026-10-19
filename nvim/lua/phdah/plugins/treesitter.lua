-- No setup() call here - settings.lua's generic FileType autocmd calls
-- require("nvim-treesitter") itself to install/start parsers per buffer.
-- Must be eager so that autocmd (registered by settings.lua, sourced
-- right after plugins/init.lua) never races a buffer opened before
-- treesitter is on the runtimepath.
require("phdah.plugins.lib").eager({ "nvim-treesitter" })
