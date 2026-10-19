local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "quickbuf.nvim" })
    -- quickbuf's own `plugin/` script already calls `setup(nil, false)` as
    -- soon as it's sourced above; `force_load = true` (2nd arg) is
    -- required for our custom options to take effect instead of being
    -- silently skipped by its "already set up" guard.
    require("quickbuf").setup({
        picker = {
            include_special = true,
            move_up_key = "k",
            move_down_key = "j",
            select_key = "<C-j>",
            toggle_pin_key = "T",
        },
    }, true)
end)

vim.keymap.set("n", "<leader>fb", function()
    load()
    vim.cmd("QuickBuf")
end)
vim.keymap.set("n", "<C-q>t", function()
    load()
    vim.cmd("QuickBufPinToggle")
end, { desc = "Pin toggle" })
