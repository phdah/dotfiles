-- No setup() call here - settings.lua's generic FileType autocmd calls
-- require("nvim-treesitter") itself to install/start parsers per buffer.
-- Must be eager so that autocmd (registered by settings.lua, sourced
-- right after plugins/init.lua) never races a buffer opened before
-- treesitter is on the runtimepath.

-- Equivalent of lazy.nvim's old `build = ":TSUpdate"`: rebuild installed
-- parsers whenever nvim-treesitter itself is updated, so they never fall
-- behind the plugin's queries. Must be registered before vim.pack.add().
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local d = ev.data
        if d.spec.name == "nvim-treesitter" and d.kind == "update" then
            if not d.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

require("phdah.plugins.lib").eager({ "nvim-treesitter" })
