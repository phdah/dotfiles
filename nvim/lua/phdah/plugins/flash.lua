require("phdah.plugins.lib").eager({ "flash.nvim" })

-- f/F/t/T aren't mapped here - flash's own setup() below installs those
-- enhanced motions itself.
require("flash").setup({ modes = { search = { enabled = false } } })

vim.keymap.set({ "n", "x", "o" }, "ss", function()
    require("flash").jump()
end)
vim.keymap.set({ "n", "x", "o" }, "sS", function()
    require("flash").treesitter()
end)
