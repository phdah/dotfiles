local lib = require("phdah.plugins.lib")

lib.eager({ "snacks.nvim", "neural-open.nvim" })

-- GitHub `user-attachments/assets/<id>` URLs need a browser session (token
-- auth returns the login page), but the markdown API with a repo context
-- rewrites them to short-lived signed URLs. Download that once into the
-- snacks cache and return the local path. The repo comes from the Octo
-- buffer name (octo://[host/]owner/repo/...). Returns nil on failure.
local gh_failed = {} ---@type table<string, boolean>
local function gh_attachment(file, src)
    local host = src:match("^https://([^/]+)/user%-attachments/assets/[%w%-]+$")
    local path = file:match("^octo:/+(.+)$") -- snacks normalizes to octo:/
    -- `:Octo <url>` on a non-default host prefixes the buffer name with it
    if host and path and vim.startswith(path, host .. "/") then
        path = path:sub(#host + 2)
    end
    local repo = path and path:match("^([^/]+/[^/]+)/")
    if not (host and repo) or gh_failed[src] then
        return
    end
    local cache = vim.fn.stdpath("cache") .. "/snacks/image"
    local base = cache .. "/gh-" .. vim.fn.sha256(src):sub(1, 8) .. "-" .. src:match("[^/]+$")
    local found = vim.fn.glob(base .. ".*", false, true)[1]
    if found then
        return found
    end
    gh_failed[src] = true -- only try once per session, this blocks
    local md = vim.system({
        "gh", "api", "--hostname", host, "markdown",
        "-f", "text=![](" .. src .. ")", "-f", "mode=gfm", "-f", "context=" .. repo,
    }, { text = true }):wait(10000)
    local url = md.code == 0 and md.stdout:match('<img src="([^"]+)"')
    if not url or url == src then
        return
    end
    url = url:gsub("&amp;", "&")
    local out = base .. "." .. (url:gsub("%?.*", ""):match("%.(%w+)$") or "img")
    vim.fn.mkdir(cache, "p")
    -- -f and the content type check keep error pages out of the cache
    local dl = vim.system({ "curl", "-fsSL", "--max-time", "15", "-w", "%{content_type}", "-o", out .. ".tmp", url }, { text = true }):wait(20000)
    if dl.code == 0 and dl.stdout:match("^image/") then
        vim.uv.fs_rename(out .. ".tmp", out)
        gh_failed[src] = nil
        return out
    end
    vim.fn.delete(out .. ".tmp")
end

require("snacks").setup({
    bigfile = {},
    bufdelete = {},
    terminal = {},
    dashboard = {
        sections = {
            { section = "header" },
            {
                icon = " ",
                title = "Keymaps",
                section = "keys",
                indent = 2,
                padding = 1,
            },
            {
                icon = " ",
                title = "Recent Files",
                section = "recent_files",
                indent = 2,
                padding = 1,
            },
        },
        preset = {
            keys = {
                {
                    icon = " ",
                    key = "f",
                    desc = "Find File",
                    action = "<leader>ff",
                },
                {
                    icon = " ",
                    key = "n",
                    desc = "New File",
                    action = ":ene | startinsert",
                },
                {
                    icon = " ",
                    key = "g",
                    desc = "Find Text",
                    action = "<leader>fr",
                },
                {
                    icon = " ",
                    key = "r",
                    desc = "Recent Files",
                    action = "<leader>fR",
                },
                {
                    icon = " ",
                    key = "c",
                    desc = "Config",
                    action = function()
                        Snacks.picker.smart({
                            cwd = vim.fn.stdpath("config"),
                        })
                    end,
                },
                {
                    icon = " ",
                    key = "s",
                    desc = "Restore Session",
                    section = "session",
                },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
        },
    },
    notifier = {},
    gitbrowse = {
        -- Overrides the full default list (lists are not merged), so the
        -- snacks defaults are repeated here with the GHE.com entry added.
        remote_patterns = {
            { "^(https?://.*)%.git$", "%1" },
            -- GHE.com data residency: <enterprise>@<enterprise>.ghe.com:org/repo.git
            { "^[%w%-]+@([%w%-]+%.ghe%.com):(.+)$", "https://%1/%2" },
            { "^git@(.+):(.+)%.git$", "https://%1/%2" },
            { "^git@(.+):(.+)$", "https://%1/%2" },
            { "^git@(.+)/(.+)$", "https://%1/%2" },
            { "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
            { "^ssh://git@(.*)$", "https://%1" },
            { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
            { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
            { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
            { "^https://%w*@(.*)", "https://%1" },
            { "^git@(.*)", "https://%1" },
            { ":%d+", "" },
            { "%.git$", "" },
        },
        url_patterns = {
            -- Github Enterprise
            ["%.ghe%.com"] = {
                branch = "/tree/{branch}",
                file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                commit = "/commit/{commit}",
            },
        },
    },
    gh = {},
    picker = {
        layout = {
            preview = false,
        },
        win = {
            input = {
                keys = {
                    ["<C-i>"] = { "confirm", mode = { "n", "i" } },
                    ["<C-k>"] = { "<Esc>", mode = { "n", "i" }, expr = true },
                    ["<C-c>"] = { "close", mode = { "n", "i" } },
                    ["<c-h>"] = {
                        { "toggle_hidden", "toggle_ignored" },
                        mode = { "i", "n" },
                    },
                    ["<c-j>"] = false,
                    ["<C-t>"] = { "toggle_preview", mode = { "i", "n" } },
                    ["<C-f>"] = { "toggle_follow", mode = { "i", "n" } },
                    ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                    ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                },
            },
        },
        formatters = {
            file = { filename_first = true, truncate = 100 },
        },
        previewers = {
            git = {
                native = true,
            },
        },
    },
    dim = {},
    -- Inline images (local, URL via curl, ![[wikilinks]]), mermaid (mmdc)
    -- and math (pdflatex) in markdown, rendered via kitty graphics.
    image = {
        -- Max inline image size in cells (defaults are 80x40)
        doc = { max_width = 60, max_height = 20 },
        convert = {
            notify = true, -- default false hides failed conversions (e.g. mmdc)
            -- mmdc's headless Chromium dies with "No usable sandbox!" since
            -- Ubuntu 23.10+ restricts unprivileged user namespaces, so pass
            -- --no-sandbox via a puppeteer config. Otherwise snacks' default.
            mermaid = function()
                local pp = vim.fn.stdpath("cache") .. "/snacks-puppeteer.json"
                if vim.fn.filereadable(pp) == 0 then
                    vim.fn.writefile({ '{"args":["--no-sandbox"]}' }, pp)
                end
                local theme = vim.o.background == "light" and "neutral" or "dark"
                return { "-p", pp, "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
            end,
        },
        -- GitHub "blob" URLs return an HTML page, not the image; rewrite
        -- them to the raw file. Returning nil keeps the default resolving.
        resolve = function(file, src)
            local repo, path = src:match("^https://github%.com/([^/]+/[^/]+)/blob/(.+)$")
            if repo then
                return ("https://raw.githubusercontent.com/%s/%s"):format(repo, (path:gsub("%?raw=true$", "")))
            end
            return gh_attachment(file, src)
        end,
    },
    lazygit = {
        theme = {
            inactiveBorderColor = { fg = "Boolean" },
            activeBorderColor = { fg = "Boolean", bold = true },
            selectedLineBgColor = { bg = "Search" },
        },
    },
})

-- snacks only sets up image on the first BufReadPre, which never fires for
-- BufReadCmd buffers like octo://, so `nvim +"Octo <url>"` had no images.
Snacks.image.setup()

----------------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------------
local find_git_root = require("nvim-utils").Git.find_git_root

vim.keymap.set("n", "<leader>lb", function()
    Snacks.terminal.open("backlog board")
end, { desc = "(l) (b)acklog.md board open in floating terminal", silent = true })

vim.keymap.set("n", "<leader>lo", function()
    Snacks.lazygit.open()
end, { desc = "(l)azygit open in floating terminal", silent = true })

vim.keymap.set("n", "<leader>q", function()
    Snacks.bufdelete()
end, { desc = "(q)uite buffer", silent = true })

vim.keymap.set("n", "<leader>Q", function()
    Snacks.bufdelete({ force = true })
end, { desc = "(Q)uite buffer", silent = true })

vim.keymap.set("n", "<leader>ns", function()
    Snacks.notifier.show_history()
end, { desc = "(n)otifier (s)how history", silent = true })

vim.keymap.set("n", "go", function()
    Snacks.gitbrowse.open()
end, { desc = "(G)it (o)pen browser link", silent = true })

vim.keymap.set("v", "go", function()
    lib.exit_visual()
    Snacks.gitbrowse.open({
        line_start = vim.fn.line("'<"),
        line_end = vim.fn.line("'>"),
    })
end, { desc = "(G)it (o)pen browser link", silent = true })

vim.keymap.set("n", "gy", function()
    Snacks.gitbrowse({
        open = function(url)
            vim.fn.setreg("+", url)
        end,
    })
end, { desc = "(G)it (y)ank browser link", silent = true })

vim.keymap.set("v", "gy", function()
    lib.exit_visual()
    Snacks.gitbrowse({
        line_start = vim.fn.line("'<"),
        line_end = vim.fn.line("'>"),
        open = function(url)
            vim.fn.setreg("+", url)
        end,
    })
end, { desc = "(G)it (y)ank browser link", silent = true })

vim.keymap.set("n", "zf", function()
    Snacks.dim.enable()
end, { desc = "(Z)en (f)ile enable", silent = true })

vim.keymap.set("n", "zF", function()
    Snacks.dim.disable()
end, { desc = "(Z)en (F)ile disable", silent = true })

vim.keymap.set("n", "<leader>gg", function()
    Snacks.picker.lsp_definitions({ layout = { preview = true } })
end, { desc = "Goto Definition", silent = true })

vim.keymap.set("n", "gr", function()
    Snacks.picker.lsp_references({ layout = { preview = true } })
end, { desc = "References", silent = true, nowait = true })

vim.keymap.set("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation", silent = true })

vim.keymap.set("n", "<leader>gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition", silent = true })

vim.keymap.set("n", "<leader>sb", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols", silent = true })

vim.keymap.set("n", "<leader>fu", function()
    Snacks.picker.undo({ layout = { preview = true } })
end, { desc = "(f)ind (u)ndo", silent = true })

vim.keymap.set("n", "<leader>ff", function()
    require("neural-open").open({ cwd = find_git_root() })
end, { desc = "(f)ind (f)iles locally", silent = true })

vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.git_log({ live = true })
end, { desc = "(f)ind (g)it diffs", silent = true })

vim.keymap.set("n", "<leader>fc", function()
    require("neural-open").open({ cwd = vim.fn.stdpath("config") })
end, { desc = "(f)ind neovim (c)onfig", silent = true })

vim.keymap.set("n", "<leader>fF", function()
    require("neural-open").open({ cwd = "~" })
end, { desc = "(f)ind (F)iles globally", silent = true })

vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.grep({
        layout = { preview = true },
        cwd = find_git_root(),
    })
end, { desc = "(f)ind g(r)ep", silent = true })

vim.keymap.set("n", "<leader>fR", function()
    Snacks.picker.recent()
end, { desc = "(f)ind (R)ecent", silent = true })

vim.keymap.set("n", "<leader>fp", function()
    Snacks.picker.projects()
end, { desc = "(f)ind (p)rojects", silent = true })

vim.keymap.set("n", "<leader>f*", function()
    Snacks.picker.grep_word({
        layout = { preview = true },
        cwd = find_git_root(),
    })
end, { desc = "(f)ind (*) search", silent = true })

vim.keymap.set("v", "<leader>f*", function()
    lib.exit_visual()
    Snacks.picker.grep({
        layout = { preview = true },
        cwd = find_git_root(),
        search = require("nvim-utils").String.escape_line(
            require("nvim-utils").String.get_visual_selection()
        ),
    })
end, { desc = "(f)ind (*) search", silent = true })

vim.keymap.set("n", "<leader>fh", function()
    Snacks.picker.help({ layout = { preview = true } })
end, { desc = "(f)ind (h)elp tags", silent = true })

vim.keymap.set("n", "<leader>fe", function()
    Snacks.picker.diagnostics({ layout = { preview = true } })
end, { desc = "(f)ind (e)rror", silent = true })

vim.keymap.set("n", "<leader>fk", function()
    Snacks.picker.keymaps({ layout = { preview = true } })
end, { desc = "(f)ind (k)eymaps", silent = true })

vim.keymap.set("n", "<leader>fx", function()
    Snacks.picker.explorer({
        cwd = find_git_root(),
        auto_close = true,
    })
end, { desc = "(f)ind e(x)plorer", silent = true })

vim.keymap.set("n", "z=", function()
    Snacks.picker.spelling()
end, { desc = "Spelling suggestions list", silent = true })
