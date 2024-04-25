-- Set save location for db_ui
vim.g.db_ui_save_location = '~/.config/db_ui'
vim.g.db_ui_tables = {'public.tables', 'public.views'}


-- Setup UI graphical
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_winwidth = 60
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_win_position = 'right'

-- Setup logic
vim.g.db_ui_execute_on_save = 0

local auGroup = vim.api.nvim_create_augroup("DadbodUI", { clear = true })

-- Remaps for Dadbod-ui
vim.g.db_ui_disable_mappings = 1
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "dbui",
    callback = function()
        -- DBUI
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-j>', '<Plug>(DBUI_SelectLine)', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'A', '<Plug>(DBUI_AddConnection)', { noremap=true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'd', '<Plug>(DBUI_DeleteLine)', { noremap=true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<Plug>(DBUI_ToggleDetails)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'R', '<Plug>(DBUI_Redraw)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'r', '<Plug>(DBUI_RenameLine)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<Plug>(DBUI_GotoPrevSibling)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<Plug>(DBUI_GotoNextSibling)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-p>', '<Plug>(DBUI_GotoParentNode)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-n>', '<Plug>(DBUI_GotoChildNode)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>j', '<Plug>(DBUI_GotoLastSibling)', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>k', '<Plug>(DBUI_GotoFirstSibling)', { noremap = true, silent = true })


        vim.wo.number = true
        vim.wo.relativenumber = true

    end
})

-- Remaps for Dadbod-ui output window
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = auGroup,
    pattern = "*.dbout",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', '<Plug>(DBUI_JumpToForeignKey)', { noremap=true, silent = true })
    end
})

-- This is to make sure commenting works with Dadbod-ui
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "sql",
    callback = function()
        vim.opt_local.commentstring = "-- %s"
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>w', '<Plug>(DBUI_SaveQuery)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>s', '<Plug>(DBUI_ExecuteQuery)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'v', '<Leader>s', '<Plug>(DBUI_ExecuteQuery)', { noremap= true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>r', '<Plug>(DBUI_ToggleResultLayout)', { noremap= true, silent = true })
    end
})
