require("gen").setup({
    model = "qwen2.5-coder:32b",
    display_mode = "horizontal-split", -- "float" or "split" or "horizontal-split"
    persistent_window = true,
    show_model = true,
    no_auto_close = true,
})
vim.api.nvim_create_user_command("ModelSelect", function()
    require("gen").select_model()
end, {})
