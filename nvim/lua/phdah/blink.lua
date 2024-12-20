require("blink-cmp").setup({
    keymap = {preset = 'default'},
    appearance = {use_nvim_cmp_as_default = true, nerd_font_variant = 'mono'},
    sources = {
        -- remember to enable your providers here
        default = {'lsp', 'path', 'snippets', 'buffer', 'emoji', 'ripgrep'},
        providers = {
            emoji = {
                name = 'emoji',
                module = 'blink.compat.source',
                score_offset = -3
            },
            ripgrep = {
                module = "blink-ripgrep",
                name = "Ripgrep",
                opts = {
                    prefix_min_len = 3,
                    context_size = 5,
                    max_filesize = "1M",
                    additional_rg_options = {}
                }
            }
        }
    }
    -- experimental signature help support
    -- signature = {enabled = true},
})
