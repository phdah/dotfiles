vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function() require("todo-comments").setup({signs = false}) end
})
