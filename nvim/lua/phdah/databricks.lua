-- Save and import file to Databricks
vim.api.nvim_create_user_command('ImportDB', function()
    vim.cmd('w')
    local file_path = vim.fn.expand('%:p')
    vim.cmd('!ImportDB ' .. file_path)
end, {})

-- Open floating buffer and run file in Databricks
vim.api.nvim_create_user_command('RunDB', function()
    -- Calculate window size as 90% of the current Neovim window
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)

    -- Calculate window position to be centered
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a new buffer and floating window
    local buf = vim.api.nvim_create_buf(false, true)
    buffer_id = buf
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single'  -- Add a border here
    }
    buffer_opts = opts
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Start the terminal with the command
    local file_path = vim.fn.expand('#:p')  -- Get the alternate buffer path
    vim.fn.termopen('runDB ' .. file_path, {detach = true})

    -- Set key mapping for 'q' to close the floating window
    local close_command = string.format(":lua vim.api.nvim_win_close(%s, false)<CR>", win)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', close_command, {noremap = true, silent = true})

    -- Set the buffer to the terminal buffer
    vim.api.nvim_set_current_buf(buf)
end, {})

-- Open the result buffer
vim.api.nvim_create_user_command('OpenRunDB', function()
    -- Open the already existing buffer
    if buffer_id then
        local win = vim.api.nvim_open_win(buffer_id, true, buffer_opts)
        local close_command = string.format(":lua vim.api.nvim_win_close(%s, false)<CR>", win)
        vim.api.nvim_buf_set_keymap(buffer_id, 'n', 'q', close_command, {noremap = true, silent = true})
    else
        print("No results to show, run :RunDB to generate it")
    end
end, {})
