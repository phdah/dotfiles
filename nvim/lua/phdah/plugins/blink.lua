local lib = require("phdah.plugins.lib")

-- blink-cmp-git's "Git" source, used for octo/commit message completion.
-- Kept local to this file since it's purely config glue for blink, not an
-- independent plugin concern.
local function git_source()
    local github_default = require("blink-cmp-git.default.github")
    local commit_default = require("blink-cmp-git.default.commit")

    local function make_get_command_args(default_fn)
        return function(command, token)
            local args = default_fn(command, token)
            vim.list_extend(args, { "--hostname", require("octo.utils").get_remote_host() })
            return args
        end
    end

    return {
        module = "blink-cmp-git",
        name = "Git",
        opts = {
            commit = {
                get_command_args = make_get_command_args(commit_default.get_command_args),
            },
            git_centers = {
                github = {
                    issue = {
                        get_command_args = make_get_command_args(
                            github_default.issue.get_command_args
                        ),
                    },
                    pull_request = {
                        get_command_args = make_get_command_args(
                            github_default.pull_request.get_command_args
                        ),
                    },
                    mention = {
                        get_command_args = make_get_command_args(
                            github_default.mention.get_command_args
                        ),
                        get_documentation = function(item)
                            local doc = github_default.mention.get_documentation(item)
                            doc.get_command_args = make_get_command_args(doc.get_command_args)
                            return doc
                        end,
                    },
                },
            },
        },
    }
end

local load = lib.once(function()
    lib.load({ "LuaSnip", "blink.compat", "blink-emoji.nvim", "blink-cmp-git", "blink.cmp" })
    require("blink.compat").setup({ impersonate_nvim_cmp = false, debug = false })

    require("blink-cmp").setup({
        enabled = function()
            if vim.bo.buftype ~= "prompt" then
                return true
            end
            -- cmp-dap is lazy-loaded (see plugins/dap.lua), so it may
            -- not be on the runtimepath yet - any other "prompt"
            -- buftype buffer (e.g. a snacks picker input) can trigger
            -- this `enabled` check. If cmp-dap was never loaded, DAP
            -- was never touched this session, so this can't be a dap
            -- buffer.
            local ok, cmp_dap = pcall(require, "cmp_dap")
            return ok and cmp_dap.is_dap_buffer()
        end,
        appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
        completion = {
            accept = { auto_brackets = { enabled = true } },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                treesitter_highlighting = true,
                window = { border = "rounded" },
            },
        },
        snippets = { preset = "luasnip" },
        sources = {
            -- remember to enable your providers here
            default = { "lsp", "path", "snippets", "buffer", "emoji" },
            per_filetype = {
                -- Dap
                ["dap-repl"] = { "dap" },
                ["dapui_watches"] = { "dap" },
                ["dapui_hover"] = { "dap" },
                -- Dbee
                sql = { "dbee", "buffer" },
                octo = { "lsp", "path", "snippets", "buffer", "emoji", "git" },
                -- Vimtex citation/label/package completion via omnifunc
                tex = { inherit_defaults = true, "omni" },
            },
            providers = {
                dbee = { name = "cmp-dbee", module = "blink.compat.source" },
                dap = { name = "dap", module = "blink.compat.source" },
                lsp = { min_keyword_length = 0, score_offset = 0 },
                path = { min_keyword_length = 0 },
                snippets = { min_keyword_length = 2 },
                buffer = { min_keyword_length = 1, max_items = 5 },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = -3,
                    min_keyword_length = 1,
                },
                git = git_source(),
            },
        },
        cmdline = {
            keymap = { preset = "inherit" },
            completion = { menu = { auto_show = true } },
        },
        keymap = {
            preset = "none",
            -- Scrolling
            ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
            ["<C-n>"] = { "select_next", "fallback_to_mappings" },
            ["<up>"] = { "scroll_documentation_up", "fallback" },
            ["<down>"] = { "scroll_documentation_down", "fallback" },
            -- Actions
            ["<C-i>"] = { "accept", "fallback" },
            ["<C-e>"] = { "cancel" },
            -- Toggle info
            ["<C-o>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
            -- Snippet
            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        -- experimental signature help support
        signature = { enabled = true, window = { border = "rounded" } },
    })
end)

lib.on_event({ "InsertEnter", "CmdlineEnter" }, load)

-- Returned so plugins that depend on blink (opencode, dap, nvim-dbee) can do the full
-- blink setup before their own.
return load
