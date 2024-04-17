-- Set save location for db_ui
vim.g.db_ui_save_location = '~/.config/db_ui'
vim.g.db_ui_tables = {'public.tables', 'public.views'}

-- This is to make sure commenting works with Dadbod-ui
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        vim.opt_local.commentstring = "-- %s"
    end
})
