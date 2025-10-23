require("octo").setup({
    suppress_missing_scope = { projects_v2 = true },
    enable_builtin = true,
    -- use_local_fs = true, causing issues with diff
    -- picker = "snacks",
    mappings = {
        issue = {
            reload = { lhs = "<localleader>r", desc = "reload PR" },
            open_in_browser = { lhs = "<leader>bo", desc = "open PR in browser" },
            copy_sha = { lhs = "<C-s>", desc = "copy commit SHA to system clipboard" },
        },
        pull_request = {
            reload = { lhs = "<localleader>r", desc = "reload PR" },
            open_in_browser = { lhs = "<leader>bo", desc = "open PR in browser" },
            copy_sha = { lhs = "<C-s>", desc = "copy commit SHA to system clipboard" },
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
            copy_sha = { lhs = "<C-s>", desc = "copy commit SHA to system clipboard" },
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
