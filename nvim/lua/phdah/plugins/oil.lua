local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "nvim-web-devicons", "oil.nvim" })

    require("oil").setup({
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
                return name == ".." or name == ".git"
            end,
        },
        float = { padding = 2, max_width = 0, max_height = 0 },
        win_options = { wrap = true, winblend = 0 },
        keymaps = { ["<leader>-"] = "actions.close" },
    })
end)

lib.on_event("FileType", load, "netrw")
vim.keymap.set("n", "<leader>-", function()
    load()
    vim.cmd("Oil --float")
end, { desc = "Oil float" })
