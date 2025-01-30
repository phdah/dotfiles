require("octo").setup({
    suppress_missing_scope = { projects_v2 = true },
    enable_builtin = true,
    mappings = {
        issue = {
            reload = { lhs = "<localleader>r", desc = "reload PR" },
            open_in_browser = { lhs = "<leader>bo", desc = "open PR in browser" },
        },
        pull_request = {
            reload = { lhs = "<localleader>r", desc = "reload PR" },
            open_in_browser = { lhs = "<leader>bo", desc = "open PR in browser" },
        },
        review_thread = {
            select_next_entry = { lhs = "<TAB>", desc = "move to next changed file" },
            select_prev_entry = {
                lhs = "<S-TAB>",
                desc = "move to previous changed file",
            },
        },
        review_diff = {
            select_next_entry = { lhs = "<TAB>", desc = "move to next changed file" },
            select_prev_entry = {
                lhs = "<S-TAB>",
                desc = "move to previous changed file",
            },
        },
        file_panel = {
            select_next_entry = { lhs = "<TAB>", desc = "move to next changed file" },
            select_prev_entry = {
                lhs = "<S-TAB>",
                desc = "move to previous changed file",
            },
        },
    },
})

vim.treesitter.language.register("markdown", "octo")

local auGroup = vim.api.nvim_create_augroup("nvim-octo-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "octo",
    callback = function()
        vim.cmd("setlocal spell! spelllang=en_us")
        vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
        vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
    end,
})
