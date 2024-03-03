-- Keymap function to do jump to definition and search assigning variables
_G.nvim_quickfix_navigation = function()
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    local idx = vim.fn.getqflist({idx = 0}).idx
    local size = vim.fn.getqflist({size = 0}).size

    -- Store the current window ID before making changes
    local current_win = vim.api.nvim_get_current_win()

    if buftype == 'quickfix' then
        -- Grab the word under the cursor in the quickfix window

        if idx == size then
            vim.api.nvim_command('cfirst')
        else
            vim.api.nvim_command('cnext')
        end

	local keyword = vim.fn.expand('<cword>')
        -- Set the keyword as the search term (this will highlight it in the code buffer)
        vim.api.nvim_set_option('hlsearch', true)  -- Ensure hlsearch is enabled
        vim.api.nvim_command('let @/ = "' .. keyword .. '"')  -- Set the search register

        -- Set the cursor to the respective location in the code buffer and center it
        vim.cmd('normal! zz')

        -- Return focus to the quickfix window
        vim.api.nvim_set_current_win(current_win)
    else
        vim.lsp.buf.definition()
        vim.cmd('normal! zz')
    end
end

