require("dbee").setup({
  editor = {
    -- see drawer comment.
    window_options = {},
    buffer_options = {},

    -- directory where to store the scratchpads.
    --directory = "path/to/scratchpad/dir",

    -- mappings for the buffer
    mappings = {
      -- run what's currently selected on the active connection
      { key = "<C-s>", mode = "v", action = "run_selection" },
      -- run the whole file on the active connection
      { key = "<C-s>", mode = "n", action = "run_file" },
    },
  },
})
local auGroup = vim.api.nvim_create_augroup("nvim-dbee-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "sql",
    callback = function()
        vim.opt_local.commentstring = "-- %s"
        -- Seems to not work for some reason...
        vim.cmd("TSEnable highlight")
    end
})
