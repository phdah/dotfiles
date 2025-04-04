require('nvim-treesitter.configs').setup({
    ensure_installed = {"lua"},
    sync_install = false,
    auto_install = true,
    highlight = {enable = true, additional_vim_regex_highlighting = false},
})
vim.treesitter.language.register('markdown', 'octo')
