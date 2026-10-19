local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "csvview.nvim" })
    require("csvview").setup({
        parser = { comments = { "#", "//" } },
        keymaps = {
            jump_next_field_end = { "w", mode = { "n", "v" } },
            jump_prev_field_end = { "b", mode = { "n", "v" } },
            jump_next_row = { "j", mode = { "n", "v" } },
            jump_prev_row = { "k", mode = { "n", "v" } },
        },
    })
end)

lib.on_command({ "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" }, load)
vim.keymap.set("n", "so", function()
    load()
    vim.cmd("CsvViewToggle display_mode=border header_lnum=1")
end, { desc = "Toggle c(s)v (o)pen" })
