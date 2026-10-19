local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "LuaSnip", "neogen" })
    require("neogen").setup({
        snippet_engine = "luasnip",
        input_after_comment = false,
        languages = {
            python = { template = { annotation_convention = "google_docstrings" } },
            go = { template = { annotation_convention = "godoc" } },
            lua = { template = { annotation_convention = "emmylua" } },
        },
    })
end)

lib.on_command("Neogen", load)
vim.keymap.set("n", "<leader>ne", function()
    load()
    require("neogen").generate()
end, { desc = "(N)(e)ogen Comment" })
