require("blink-cmp").setup({
    keymap = {preset = 'default'},
    appearance = {use_nvim_cmp_as_default = true, nerd_font_variant = 'mono'},
    sources = {
        -- remember to enable your providers here
        default = {'lsp', 'path', 'snippets', 'buffer', 'emoji'},
        providers = {
            emoji = {
                name = 'emoji',
                module = 'blink.compat.source',
                score_offset = -3
            },
        }
    }
    -- experimental signature help support
    -- signature = {enabled = true},
})
