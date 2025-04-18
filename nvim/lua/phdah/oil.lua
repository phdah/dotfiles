require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
        end
    },
    float = {padding = 2, max_width = 0, max_height = 0},
    win_options = {wrap = true, winblend = 0},
    keymaps = {["<leader>-"] = "actions.close"}
})
