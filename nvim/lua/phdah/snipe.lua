local snipe = require("snipe")
snipe.setup({
    hints = {
        -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
        dictionary = "asdflewcmpghio"
    },
    ui = {position = "center", preselect_current = true},
    navigate = {cancel_snipe = "<C-k>", under_cursor = "<C-j>"}
})

snipe.ui_select_menu = require("snipe.menu"):new{position = "center"}
snipe.ui_select_menu:add_new_buffer_callback(function(m)
    vim.keymap.set("n", "<esc>", function() m:close() end,
                   {nowait = true, buffer = m.buf})
end)
vim.ui.select = snipe.ui_select;
