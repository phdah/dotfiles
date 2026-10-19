local lib = require("phdah.plugins.lib")

lib.on_event("FileType", function()
    lib.load({ "nvim-colorizer.lua" })
    require("colorizer").setup({})
end, { "typescriptreact", "lua", "markdown" })
