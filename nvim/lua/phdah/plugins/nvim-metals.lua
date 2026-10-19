local lib = require("phdah.plugins.lib")

lib.on_event("FileType", function()
    lib.load({ "plenary.nvim", "nvim-metals" })
    local metals_config = require("metals").bare_config()
    metals_config.on_attach = function()
        require("metals").setup_dap()
    end
    local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        group = group,
        callback = function()
            require("metals").initialize_or_attach(metals_config)
        end,
    })
end, { "scala", "sbt" })
