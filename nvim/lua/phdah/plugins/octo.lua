local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "plenary.nvim", "telescope.nvim", "nvim-web-devicons", "octo.nvim" })

    require("telescope").setup({
        defaults = {
            mappings = {
                i = { ["<C-i>"] = require("telescope.actions").select_default },
                n = { ["<C-i>"] = require("telescope.actions").select_default },
            },
        },
    })

    require("octo").setup({
        gh_env = function()
            -- octo runs gh with a stripped env; without the display vars,
            -- `gh --web` -> xdg-open can't find the desktop browser
            return {
                GH_HOST = require("octo.utils").get_remote_host(),
                DISPLAY = vim.env.DISPLAY,
                WAYLAND_DISPLAY = vim.env.WAYLAND_DISPLAY,
                XDG_CURRENT_DESKTOP = vim.env.XDG_CURRENT_DESKTOP,
                XDG_RUNTIME_DIR = vim.env.XDG_RUNTIME_DIR,
                BROWSER = vim.env.BROWSER,
            }
        end,
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

    local function set_gh_host()
        vim.env.GH_HOST = require("octo.utils").get_remote_host()
    end
    set_gh_host()
    vim.api.nvim_create_autocmd("DirChanged", { callback = set_gh_host })
end)

lib.on_command("Octo", load)
-- GH_HOST (used by gh in terminals, lazygit, snacks.gh, blink-cmp-git)
-- comes from octo's remote parsing, so octo is loaded right after startup
-- instead of on demand. Deferred so it doesn't delay the first screen.
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(load)
    end,
})
vim.keymap.set("n", "<C-o>", function()
    load()
    vim.cmd("Octo")
end, { desc = "Open (o)cto action list", silent = true })
vim.keymap.set("n", "<leader>fo", function()
    load()
    vim.cmd("Octo pr list")
end, { desc = "Open (o)cto pr list", silent = true })
