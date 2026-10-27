local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "obsidian.nvim" })
    require("obsidian").setup({
        legacy_commands = false,
        ui = { enable = false },
        workspaces = {
            { name = "work", path = "~/vaults/work" },
            {
                name = "personal",
                path = "~/repos/privat/knowledge-vault/",
                overrides = {
                    templates = {
                        folder = "data/templates",
                        date_format = "YYYY-MM-DD",
                        time_format = "HH:mm",
                    },
                    daily_notes = {
                        enabled = true,
                        folder = "data/personal/running/daily",
                        date_format = "YYYY-MM-DD",
                        template = "template.md",
                        workdays_only = false,
                    },
                },
            },
            { name = "ava", path = "~/stuff/project-vault" },
            {
                name = "running",
                path = "~/repos/privat/obsidian-notes/running",
                overrides = {
                    templates = {
                        folder = "templates",
                        date_format = "YYYY-MM-DD",
                        time_format = "HH:mm",
                    },
                    daily_notes = {
                        enabled = true,
                        folder = "daily",
                        date_format = "YYYY-MM-DD",
                        template = "running-daily.md",
                        workdays_only = false,
                    },
                },
            },
        },
        picker = { name = "snacks.picker" },
    })
end)

lib.on_event("FileType", load, "markdown")
lib.on_command("Obsidian", load)
