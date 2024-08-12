require("markview").setup({
    modes = {"n", "no", "c", "i"}, -- Change these modes
    -- to what you need

    hybrid_modes = {"n", "i"}, -- Uses this feature on
    -- normal mode

    -- This is nice to have
    callbacks = {
        on_enable = function(_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].conecalcursor = "nc";
        end
    }
})
