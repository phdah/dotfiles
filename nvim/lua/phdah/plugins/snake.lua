local lib = require("phdah.plugins.lib")

lib.on_command(
    "SnakeStart",
    lib.once(function()
        lib.load({ "fscreen.nvim", "snake.nvim" })
        require("snake").setup({})
    end)
)
