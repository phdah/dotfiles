local lib = require("phdah.plugins.lib")

lib.on_event("FileType", function()
    lib.load({ "quicker.nvim" })
    require("quicker").setup({})
end, "qf")
