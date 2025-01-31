require("gen").setup({
    model = "llama3.1",
    display_mode = "horizontal-split", -- "float" or "split" or "horizontal-split"
    persistent_window = true,
    show_model = true,
    no_auto_close = true,
})
vim.api.nvim_create_user_command("ModelSelect", function()
    require("gen").select_model()
end, {})
