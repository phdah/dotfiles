local lib = require("phdah.plugins.lib")

lib.on_command(
    "Golf",
    lib.once(function()
        lib.load({ "golf" })
    end)
)
