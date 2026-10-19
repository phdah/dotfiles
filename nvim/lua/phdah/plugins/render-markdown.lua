local lib = require("phdah.plugins.lib")

lib.on_event("FileType", function()
    lib.load({ "render-markdown.nvim" })
    require("render-markdown").setup({
        file_types = { "markdown", "opencode_output" },
        render_modes = true, -- render in all modes, incl. insert
        sign = { enabled = false },
        overrides = {
            filetype = {
                -- Keep the read-only opencode output fully rendered
                opencode_output = { anti_conceal = { enabled = false } },
            },
        },
    })
end, { "markdown", "opencode_output" })
