local lib = require("phdah.plugins.lib")

lib.on_event({ "BufReadPre", "BufNewFile" }, function()
    lib.load({ "mini.ai" })
    require("mini.ai").setup({ n_lines = 500 })
end)
