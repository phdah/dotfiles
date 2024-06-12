require("octo").setup({
    suppress_missing_scope = {projects_v2 = true},
    enable_builtin = true
})

local auGroup = vim.api.nvim_create_augroup("nvim-octo-custom", {clear = true})
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "octo",
    callback = function() vim.cmd("setlocal spell! spelllang=en_us") end
})

