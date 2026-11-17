local lib = require("phdah.plugins.lib")

local file_types = { "markdown", "opencode_output", "octo" }
lib.on_event("FileType", function()
    lib.load({ "render-markdown.nvim" })
    require("render-markdown").setup({
        file_types = file_types,
        render_modes = true, -- render in all modes, incl. insert
        sign = { enabled = false },
        overrides = {
            filetype = {
                -- Keep the read-only opencode output fully rendered
                opencode_output = { anti_conceal = { enabled = false } },
            },
        },
    })
end, file_types)
