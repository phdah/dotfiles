local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    require("phdah.plugins.blink")()
    lib.load({ "plenary.nvim", "opencode.nvim" })
    require("opencode").setup({
        keymap_prefix = "<leader>a",
        keymap = {
            input_window = {
                ["<S-cr>"] = false,
                ["<cr>"] = { "submit_input_prompt", mode = { "n", "i" } },
                ["~"] = false,
                ["<M-v>"] = { "paste_image", mode = { "i", "n" } }, -- Paste image from clipboard as attachment
            },
            output_window = {
                ["gj"] = { "next_message" },
                ["gk"] = { "prev_message" },
            },
        },
    })
end)

lib.on_command("Opencode", load)
vim.keymap.set("n", "<leader>ag", function()
    load()
    require("opencode.api").toggle()
end, { desc = "Opencode To(g)gle", silent = true })
vim.keymap.set("v", "<leader>aD", function()
    lib.exit_visual()
    load()
    vim.cmd(
        [['<,'>Opencode quick_chat "Add docstring(s) to the following code, use numpy style if python and possible, otherwise google style." agent=build context.selection.enabled=true]]
    )
end, { desc = "Opencode (a) (d)ocstring", silent = true })
