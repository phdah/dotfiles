require("blink-cmp").setup({
    appearance = {use_nvim_cmp_as_default = true, nerd_font_variant = 'mono'},
    completion = {
        accept = {auto_brackets = {enabled = true}},
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
            window = {border = "rounded"}
        }
    },
    sources = {
        -- remember to enable your providers here
        default = {'lsp', 'path', 'snippets', 'buffer', 'emoji'},
        cmdline = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == "/" or type == "?" then return {"buffer"} end
            -- Commands
            if type == ":" then return {"cmdline"} end
            return {}
        end,
        providers = {
            lsp = {min_keyword_length = 2, score_offset = 0},
            path = {min_keyword_length = 0},
            snippets = {min_keyword_length = 2},
            buffer = {min_keyword_length = 3, max_items = 5},
            emoji = {
                name = 'emoji',
                module = 'blink.compat.source',
                score_offset = -3,
                min_keyword_length = 1
            }
        }
    },
    keymap = {
        ["<up>"] = {"scroll_documentation_up", "fallback"},
        ["<down>"] = {"scroll_documentation_down", "fallback"},
        ["<C-i>"] = {"accept", "fallback"}

    },
    -- experimental signature help support
    signature = {enabled = true, window = {border = "rounded"}}
})
