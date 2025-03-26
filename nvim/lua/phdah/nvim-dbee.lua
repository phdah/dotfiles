require("dbee").setup({
    editor = {
        -- see drawer comment.
        window_options = {},
        buffer_options = {},

        -- directory where to store the scratchpads.
        -- directory = "path/to/scratchpad/dir",

        -- mappings for the buffer
        mappings = {
            -- run what's currently selected on the active connection
            { key = "<C-s>", mode = "v", action = "run_selection" },
            -- run the whole file on the active connection
            { key = "<C-s>", mode = "n", action = "run_file" },
        },
    },
    result = {
        mappings = {
            { key = "L", mode = "", action = "page_next" },
            { key = "H", mode = "", action = "page_prev" },
            { key = "J", mode = "", action = "page_last" },
            { key = "K", mode = "", action = "page_first" },
            { key = "<C-c>", mode = "", action = "cancel_call" },
            -- yank rows as csv/json
            { key = "yaj", mode = "n", action = "yank_current_json" },
            { key = "yaj", mode = "v", action = "yank_selection_json" },
            { key = "yaJ", mode = "", action = "yank_all_json" },
            { key = "yac", mode = "n", action = "yank_current_csv" },
            { key = "yac", mode = "v", action = "yank_selection_csv" },
            { key = "yaC", mode = "", action = "yank_all_csv" },
        },
        focus_result = false,
    },
})

local auGroup = vim.api.nvim_create_augroup("nvim-dbee-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "sql",
    callback = function()
        vim.opt_local.commentstring = "-- %s"
    end,
})
