require("markview").setup({
    preview = {
        enable = true,
        filetypes = {
            "md",
            "rmd",
            "quarto",
            "markdown",
            "octo",
            "Avante",
            "copilot-chat",
            "opencode_output",
        },
        modes = { "n", "no", "c", "i" },
        hybrid_modes = { "n", "i" },
    },
})
