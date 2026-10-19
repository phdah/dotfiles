local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "nvim-comment" })
    require("nvim_comment").setup({
        comment_empty = false,
        create_mappings = false,
    })
end)

vim.keymap.set("n", "<leader>'", function()
    load()
    vim.cmd("CommentToggle")
end, { desc = "Toggle comment on line/s", silent = true })
vim.keymap.set("v", "<leader>'", function()
    lib.exit_visual()
    load()
    vim.cmd("'<,'>CommentToggle")
end, { desc = "Toggle comment on line/s", silent = true })
