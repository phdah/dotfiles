require('nvim-treesitter.configs').setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = "all",
    sync_install = false,
    auto_install = true,
    highlight = {enable = true, additional_vim_regex_highlighting = false},
})
vim.treesitter.language.register('markdown', 'octo')
