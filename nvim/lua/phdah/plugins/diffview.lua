local lib = require("phdah.plugins.lib")

local toggleFileHistory, toggleDiffView

local load = lib.once(function()
    lib.load({ "diffview.nvim" })

    local actions = require("diffview.actions")

    require("diffview").setup({
        keymaps = {
            file_panel = {
                ["<c-f>"] = false,
                { "n", "<c-n>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            },
            file_history_panel = {
                ["<c-f>"] = false,
                { "n", "<c-n>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            },
        },
        view = { merge_tool = { layout = "diff3_mixed" } },
    })

    function toggleFileHistory()
        if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewFileHistory %")
        else
            vim.cmd("DiffviewClose")
        end
    end

    function toggleDiffView()
        if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
        else
            vim.cmd("DiffviewClose")
        end
    end
end)

lib.on_command({ "DiffviewOpen", "DiffviewFileHistory" }, load)
vim.keymap.set("n", "<leader>gf", function()
    load()
    toggleFileHistory()
end, { desc = "(G)it (f)ile toggle DiffviewFileHistory window", silent = true })
vim.keymap.set("v", "<leader>gf", function()
    lib.exit_visual()
    load()
    vim.cmd("'<,'>DiffviewFileHistory")
end, { desc = "(G)it (f)ile toggle DiffviewFileHistory window for lines", silent = true })
vim.keymap.set("n", "<leader>gd", function()
    load()
    toggleDiffView()
end, { desc = "(G)it (d)iff toggle Diffview window", silent = true })
