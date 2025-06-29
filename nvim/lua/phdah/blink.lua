require("blink-cmp").setup({
    enabled = function()
        return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
    appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
            window = { border = "rounded" },
        },
    },
    snippets = { preset = "luasnip" },
    sources = {
        -- remember to enable your providers here
        default = { "lsp", "path", "snippets", "buffer", "emoji" },
        per_filetype = {
            -- Dap
            ["dap-repl"] = { "dap" },
            ["dapui_watches"] = { "dap" },
            ["dapui_hover"] = { "dap" },
            -- Dbee
            sql = { "dbee", "buffer" },
            octo = { "lsp", "path", "snippets", "buffer", "emoji", "git" },
        },
        cmdline = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == "/" or type == "?" then
                return { "buffer" }
            end
            -- Commands
            if type == ":" then
                return { "cmdline" }
            end
            return {}
        end,
        providers = {
            dbee = { name = "cmp-dbee", module = "blink.compat.source" },
            dap = { name = "dap", module = "blink.compat.source" },
            lsp = { min_keyword_length = 0, score_offset = 0 },
            path = { min_keyword_length = 0 },
            snippets = { min_keyword_length = 2 },
            buffer = { min_keyword_length = 1, max_items = 5 },
            emoji = {
                module = "blink-emoji",
                name = "Emoji",
                score_offset = -3,
                min_keyword_length = 1,
            },
            git = {
                module = "blink-cmp-git",
                name = "Git",
            },
        },
    },
    keymap = {
        ["<up>"] = { "scroll_documentation_up", "fallback" },
        ["<down>"] = { "scroll_documentation_down", "fallback" },
        ["<C-i>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel" },
        ["<C-o>"] = { "show", "show_documentation", "hide_documentation" },
    },
    -- experimental signature help support
    signature = { enabled = true, window = { border = "rounded" } },
})
