local actions = require("diffview.actions")

require("diffview").setup({
    keymaps = {
        file_panel = {
            ["<c-f>"] = false,
            {
                "n", "<c-n>", actions.scroll_view(0.25),
                {desc = "Scroll the view down"}
            }
        },
        file_history_panel = {
            ["<c-f>"] = false,
            {
                "n", "<c-n>", actions.scroll_view(0.25),
                {desc = "Scroll the view down"}
            }
        }
    },
    view = {merge_tool = {layout = "diff3_mixed"}}
})

local M = {}
function M.toggleFileHistory()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewFileHistory %")
    else
        vim.cmd("DiffviewClose")
    end
end

function M.toggleDiffView()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

return M
