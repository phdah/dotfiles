local lib = require("phdah.plugins.lib")

-- Local plugin (not managed by vim.pack): its `plugin/dbee.lua` eagerly
-- calls require("dbee") as soon as it's sourced, so (to keep this
-- genuinely lazy) its runtimepath entry is only added once triggered,
-- same as nvim-utils is added eagerly in plugins/init.lua because it has
-- no `plugin/` files to worry about.
local nvim_dbee_dir = vim.fn.expand("~/repos/privat/nvim-dbee")

local load = lib.once(function()
    -- cmp-dbee's setup() silently skips registering its source unless
    -- require("cmp") works, which blink.compat provides.
    require("phdah.plugins.blink")()
    lib.load({ "nui.nvim" })
    vim.opt.rtp:prepend(vim.fn.expand("~/repos/privat/cmp-dbee"))
    vim.opt.rtp:prepend(nvim_dbee_dir)
    require("cmp-dbee").setup({})

    -- Equivalent of lazy.nvim's old `build = function() require("dbee").install("go") end`:
    -- vim.pack has no post-install hook for local, non-managed plugins, so
    -- build the backend binary here, the first time it's missing.
    if vim.fn.executable(require("dbee.install").bin()) == 0 then
        require("dbee").install("go")
    end

    require("dbee").setup({
        editor = {
            -- see drawer comment.
            window_options = {},
            buffer_options = {},

            -- directory where to store the scratchpads.
            -- directory = "path/to/scratchpad/dir",

            open_note_on_start = false,

            -- mappings for the buffer
            mappings = {
                -- run what's currently selected on the active connection
                { key = "<C-s>", mode = "v", action = "run_selection" },
                -- run the whole file on the active connection
                { key = "<C-s>", mode = "n", action = "run_file" },
                { key = "<C-y>", mode = "n", action = "run_under_cursor" },
            },
        },
        result = {
            mappings = {
                { key = "L", mode = "", action = "page_next" },
                { key = "H", mode = "", action = "page_prev" },
                { key = "J", mode = "", action = "page_last" },
                { key = "K", mode = "", action = "page_first" },
                { key = "<C-c>", mode = "", action = "cancel_call" },
                -- yank rows as csv/json
                { key = "yaj", mode = "n", action = "yank_current_json" },
                { key = "yaj", mode = "v", action = "yank_selection_json" },
                { key = "yaJ", mode = "", action = "yank_all_json" },
                { key = "yac", mode = "n", action = "yank_current_csv" },
                { key = "yac", mode = "v", action = "yank_selection_csv" },
                { key = "yaC", mode = "", action = "yank_all_csv" },
            },
            focus_result = false,
        },
    })

    -- A runtimepath entry added after startup doesn't get its `plugin/`
    -- files sourced, and that's where the :Dbee command is defined.
    vim.cmd.source(nvim_dbee_dir .. "/plugin/dbee.lua")

    local auGroup = vim.api.nvim_create_augroup("nvim-dbee-custom", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = auGroup,
        pattern = "sql",
        callback = function()
            vim.opt_local.commentstring = "-- %s"
        end,
    })
end)

-- Rebuild the Go backend binary, e.g. after updating the plugin.
vim.api.nvim_create_user_command("DbeeInstall", function()
    load()
    require("dbee").install("go")
end, {})
vim.keymap.set("n", "<leader>ö", function()
    load()
    require("dbee").toggle()
    require("nvim-utils").Mouse:toggle()
end, { desc = "Toggle dbee", silent = true })
vim.keymap.set("n", "<leader>ä", function()
    load()
    require("dbee").open()
end, { desc = "Toggle dbee", silent = true })
vim.keymap.set("v", "<C-s>", function()
    load()
    require("dbee").run_selection()
end, { desc = "Run dbee selection outside of dbee UI", silent = true })
