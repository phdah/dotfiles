local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "yank-path.nvim" })
    -- use_oil=false: unlike lazy.nvim, vim.pack makes every plugin's Lua
    -- module `require`-able immediately (even before it's actually
    -- "loaded"/set up). yank-path's optional oil.nvim integration only
    -- pcall-guards the `require("oil")` itself, not the `oil.get_current_dir()`
    -- call after it, so it throws whenever oil hasn't been set up yet
    -- (e.g. this is the first lazy plugin touched in the session).
    require("yank-path").setup({ default_mapping = false, use_oil = false })
end)

vim.keymap.set("n", "<leader>yp", function()
    load()
    vim.cmd("YankPath")
end, { desc = "Yank file path" })
