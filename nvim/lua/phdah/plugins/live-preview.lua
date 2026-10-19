local lib = require("phdah.plugins.lib")

lib.on_event("FileType", function()
    lib.load({ "live-preview.nvim" })
end, "markdown")
