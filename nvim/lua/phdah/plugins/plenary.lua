local lib = require("phdah.plugins.lib")

-- Also loaded as a dependency by plugins/octo.lua and plugins/nvim-metals.lua.
lib.on_command(
    "PlenaryBustedDirectory",
    lib.once(function()
        lib.load({ "plenary.nvim" })
    end)
)
