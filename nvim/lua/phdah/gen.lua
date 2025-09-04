require("gen").setup({
    model = "gpt-oss:20b",
    display_mode = "horizontal-split", -- "float" or "split" or "horizontal-split"
    persistent_window = true,
    show_model = true,
    -- no_auto_close = true,
})
require("gen").prompts["Add_docstring"] = {
    prompt = "Add $filetype docstring(s) to the following code, use google style if possible and only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
}
vim.api.nvim_create_user_command("ModelSelect", function()
    require("gen").select_model()
end, {})
