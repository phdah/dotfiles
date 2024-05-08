require("dbee").setup()
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
