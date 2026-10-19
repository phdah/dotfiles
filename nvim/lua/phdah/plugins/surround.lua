require("phdah.plugins.lib").eager({ "mini.surround" })

-- No keymaps to register here: mini.surround's own setup() below installs
-- its default sa/sd/sf/sF/sh/sr mappings.
require("mini.surround").setup({
    custom_surroundings = {
        ["("] = {
            input = { "%b()", "^.%s*().-()%s*.$" },
            output = { left = "(", right = ")" },
        },
        ["["] = {
            input = { "%b[]", "^.%s*().-()%s*.$" },
            output = { left = "[", right = "]" },
        },
        ["{"] = {
            input = { "%b{}", "^.%s*().-()%s*.$" },
            output = { left = "{", right = "}" },
        },
        ["<"] = {
            input = { "%b<>", "^.%s*().-()%s*.$" },
            output = { left = "<", right = ">" },
        },
    },
})
