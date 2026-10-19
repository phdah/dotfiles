local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "snipe.nvim", "snipe-marks" })
    require("snipe").setup({
        hints = {
            dictionary = "asdflewcmpghio",
        },
        ui = {
            position = "center",
            preselect_current = true,
            text_align = "file-first",
        },
        navigate = { cancel_snipe = "q", under_cursor = "<C-j>" },
    })
end)

vim.keymap.set("n", "<leader>fm", function()
    load()
    require("snipe_marks").open()
end, { desc = "(f)ind all (m)arks", silent = true })
vim.keymap.set("n", "<leader>dm", function()
    load()
    require("snipe_marks").delAll()
end, { desc = "(d)elete all (m)arks", silent = true })
