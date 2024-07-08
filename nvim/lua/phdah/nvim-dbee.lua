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
            {key = "<C-s>", mode = "v", action = "run_selection"},
            -- run the whole file on the active connection
            {key = "<C-s>", mode = "n", action = "run_file"}
        }
    }
})

