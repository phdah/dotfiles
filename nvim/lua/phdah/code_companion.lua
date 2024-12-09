require("codecompanion").setup({
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                schema = {model = {default = "llama3.1"}}
            })
        end
    },
    strategies = {
        chat = {adapter = "ollama"},
        inline = {adapter = "ollama"},
        cmd = {adapter = "ollama"}
    }
})
