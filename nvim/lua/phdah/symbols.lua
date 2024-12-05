require('symbols').setup({
    sidebar = {
        hide_cursor = false,
        open_direction = "right",
        close_on_goto = true,
        keymaps = {
            -- Jumps to symbol in the source window.
            ["<C-j>"] = "goto-symbol"
        }
    }
})
