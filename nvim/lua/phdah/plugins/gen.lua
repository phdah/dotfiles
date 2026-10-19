local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "gen.nvim" })

    require("gen").setup({
        model = "gpt-oss:20b",
        display_mode = "horizontal-split", -- "float" or "split" or "horizontal-split"
        persistent_window = true,
        show_model = true,
        -- no_auto_close = true,
    })
    require("gen").prompts["Add_docstring"] = {
        prompt = "Add $filetype docstring(s) to the following code, use numpy style if possible, otherwise google style and only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
    }
    vim.api.nvim_create_user_command("ModelSelect", function()
        require("gen").select_model()
    end, {})
end)

lib.on_command("Gen", load)
vim.keymap.set("n", "<C-g>g", function()
    load()
    vim.cmd("Gen Chat")
end)
vim.keymap.set("v", "<C-g>g", function()
    lib.exit_visual()
    load()
    vim.cmd("'<,'>Gen Ask")
end)
vim.keymap.set("v", "<C-g>d", function()
    lib.exit_visual()
    load()
    vim.cmd("'<,'>Gen Add_docstring")
end)
