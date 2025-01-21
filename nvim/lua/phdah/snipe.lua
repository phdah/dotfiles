local snipe = require("snipe")
snipe.setup({
    hints = {
        -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
        dictionary = "asdflewcmpghio",
    },
    ui = { position = "center", preselect_current = true, text_align = "file-first" },
    navigate = { cancel_snipe = "q", under_cursor = "<C-j>" },
})
