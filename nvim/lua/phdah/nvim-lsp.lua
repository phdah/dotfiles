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

-- Assuming other LSP configurations are set up before this point in the same file.

_G.copy_compile_flags = function()
    print("DEBUG")
  local src_file = vim.fn.expand('~/.config/clangd/compile_flags.txt')

    local root_dir = vim.lsp.buf.list_workspace_folders()[1]
  if not root_dir then
    print(root_dir)
    return
  end

  local dest_file = root_dir .. '/compile_flags.txt'
  if not vim.loop.fs_stat(dest_file) then
    os.execute('cp ' .. src_file .. ' ' .. dest_file)
    vim.cmd('LspRestart')
  end
end

_G.remove_compile_flags = function()
  local dest_dir = vim.lsp.buf.list_workspace_folders()[1]
  if not dest_dir then
    return
  end

  local dest_file = dest_dir .. '/compile_flags.txt'
  if vim.loop.fs_stat(dest_file) then
    os.execute('rm ' .. dest_file)
  end
end

-- Helper function to set up the autocmds
local function setup_autocmds()
            -- autocmd BufEnter *.c,*.cpp lua _G.copy_compile_flags()
    vim.cmd([[
        augroup ClangdSetup
            autocmd!
            autocmd VimLeave * lua _G.remove_compile_flags()
        augroup END
    ]])
end

local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  on_attach = function()
    copy_compile_flags()
  end
}

setup_autocmds()
