----------------------------------------------------------------------------
-- Every plugin's source, keyed by name (the directory name `vim.pack`
-- derives from the repo - the same name `load()`/`eager()` below use).
-- This is the one place that lists every plugin that exists; what each
-- one actually does (triggers, config, keymaps) lives in its own module
-- under this directory.
--
-- IMPORTANT: a plugin's directory only stays dormant until `vim.pack.add()`
-- is actually called for it - at that point its `plugin/`/`ftdetect/`
-- files get queued for Nvim's automatic post-startup "load-plugins" step
-- regardless of the `load` option (see `:help :packadd`: "the plugins
-- will then be loaded during the load-plugins initialization step").
-- That step runs once, automatically, right after `init.lua` finishes -
-- so pre-registering a plugin here and merely deferring *which* files get
-- sourced does NOT make it lazy; it still activates at startup, just one
-- step later. Real laziness means not calling `vim.pack.add()` for a
-- plugin at all until the moment it's actually needed (see `load()`
-- below) - this table only exists so every module can share one place to
-- look up a URL by name.
----------------------------------------------------------------------------
local SPECS = {
    ["nord.nvim"] = { src = "https://github.com/shaunsingh/nord.nvim" },
    ["nvim-treesitter"] = { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    ["marks.nvim"] = { src = "https://github.com/chentoast/marks.nvim" },
    ["gitsigns.nvim"] = { src = "https://github.com/lewis6991/gitsigns.nvim" },
    ["mini.surround"] = { src = "https://github.com/echasnovski/mini.surround" },
    ["mini.ai"] = { src = "https://github.com/echasnovski/mini.ai", version = vim.version.range("*") },
    ["snacks.nvim"] = { src = "https://github.com/folke/snacks.nvim" },
    ["neural-open.nvim"] = { src = "https://github.com/dtormoen/neural-open.nvim" },
    ["vimtex"] = { src = "https://github.com/lervag/vimtex" },
    ["flash.nvim"] = { src = "https://github.com/folke/flash.nvim" },

    ["diffview.nvim"] = { src = "https://github.com/sindrets/diffview.nvim" },
    ["nvim-colorizer.lua"] = { src = "https://github.com/catgoose/nvim-colorizer.lua" },
    ["oil.nvim"] = { src = "https://github.com/stevearc/oil.nvim" },
    ["nvim-web-devicons"] = { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    ["octo.nvim"] = { src = "https://github.com/pwntester/octo.nvim" },
    ["plenary.nvim"] = { src = "https://github.com/nvim-lua/plenary.nvim" },
    ["telescope.nvim"] = { src = "https://github.com/nvim-telescope/telescope.nvim" },
    ["mason.nvim"] = { src = "https://github.com/williamboman/mason.nvim" },
    ["mason-tool-installer.nvim"] = { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    ["nvim-jdtls"] = { src = "https://github.com/mfussenegger/nvim-jdtls" },
    ["blink.cmp"] = { src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
    ["blink.compat"] = { src = "https://github.com/saghen/blink.compat", version = vim.version.range("*") },
    ["LuaSnip"] = { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2") },
    ["blink-emoji.nvim"] = { src = "https://github.com/moyiz/blink-emoji.nvim" },
    ["blink-cmp-git"] = { src = "https://github.com/Kaiser-Yang/blink-cmp-git" },
    ["nvim-comment"] = { src = "https://github.com/terrortylor/nvim-comment" },
    ["nui.nvim"] = { src = "https://github.com/MunifTanjim/nui.nvim" },
    ["snake.nvim"] = { src = "https://github.com/Febri-i/snake.nvim" },
    ["fscreen.nvim"] = { src = "https://github.com/Febri-i/fscreen.nvim" },
    ["nvim-dap-ui"] = { src = "https://github.com/rcarriga/nvim-dap-ui" },
    ["nvim-dap"] = { src = "https://github.com/mfussenegger/nvim-dap" },
    ["one-small-step-for-vimkind"] = { src = "https://github.com/jbyuki/one-small-step-for-vimkind" },
    ["nvim-dap-virtual-text"] = { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    ["local-lua-debugger-vscode"] = { src = "https://github.com/tomblind/local-lua-debugger-vscode" },
    ["nvim-nio"] = { src = "https://github.com/nvim-neotest/nvim-nio" },
    ["mason-nvim-dap.nvim"] = { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
    ["cmp-dap"] = { src = "https://github.com/rcarriga/cmp-dap" },
    ["nvim-metals"] = { src = "https://github.com/scalameta/nvim-metals" },
    ["quickbuf.nvim"] = { src = "https://github.com/tjgao/quickbuf.nvim" },
    ["nvim-statusline"] = { src = "https://github.com/phdah/nvim-statusline" },
    ["neogen"] = { src = "https://github.com/danymat/neogen" },
    ["quicker.nvim"] = { src = "https://github.com/stevearc/quicker.nvim" },
    ["gen.nvim"] = { src = "https://github.com/David-Kunz/gen.nvim" },
    ["golf"] = { src = "https://github.com/vuciv/golf" },
    ["snipe-marks"] = { src = "https://github.com/phdah/snipe-marks" },
    ["snipe.nvim"] = { src = "https://github.com/leath-dub/snipe.nvim" },
    ["csvview.nvim"] = { src = "https://github.com/hat0uma/csvview.nvim" },
    ["yank-path.nvim"] = { src = "https://github.com/ywpkwon/yank-path.nvim" },
    ["opencode.nvim"] = { src = "https://github.com/sudo-tee/opencode.nvim" },
    ["obsidian.nvim"] = { src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range("*") },
    ["render-markdown.nvim"] = { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    ["live-preview.nvim"] = { src = "https://github.com/brianhuster/live-preview.nvim" },
}

local M = {}

local function resolve_specs(names)
    local specs = {}
    for i, name in ipairs(names) do
        specs[i] = SPECS[name]
    end
    return specs
end

-- Install (if needed) and fully load `names` right now: real laziness -
-- see the note on `SPECS` above for why this can't just pre-register
-- every plugin once and selectively `:packadd` them later. Calling
-- `vim.pack.add()` for the first time *after* `init.lua` has finished
-- sourcing makes it default to a full, immediate load (sourcing
-- `plugin/`/`ftdetect/` files too - see `:help vim.pack.add()`), exactly
-- matching lazy.nvim's "load on trigger" behaviour. `confirm = false`
-- avoids popping up an interactive install-confirmation buffer in the
-- middle of an editing session for whatever triggered the load.
function M.load(names)
    vim.pack.add(resolve_specs(names), { confirm = false })
end

-- Install (if needed) and immediately, synchronously source `names`'
-- `plugin/`/`ftdetect/` files - forcing `load = true` regardless of
-- startup timing, instead of leaving it to the (here, undesirable)
-- default described above. Used only by the "always on" plugin modules,
-- required first from plugins/init.lua, so `settings.lua` (required
-- immediately after, see `phdah/init.lua`) is guaranteed to see every
-- eager plugin fully active - this is what fixes the old
-- "colorscheme/plugin loaded after my settings already ran" ordering bug.
function M.eager(names)
    vim.pack.add(resolve_specs(names), { load = true })
end

-- Wrap a loader so that, no matter how many keys/commands/filetypes end up
-- sharing a plugin, the actual load+configure step only ever runs once.
function M.once(fn)
    local done = false
    return function(...)
        if done then
            return
        end
        done = true
        return fn(...)
    end
end

local function augroups_for(event)
    local ids = {}
    for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = event })) do
        if autocmd.group then
            ids[autocmd.group] = true
        end
    end
    return ids
end

local trigger_count = 0

-- Run `loader` the first time any of `events` fires (optionally narrowed
-- to `pattern`, e.g. a filetype), then re-fire that event for the
-- triggering buffer, but only for the augroups the loader just created.
-- That way the plugin's own autocmds still apply to the occurrence that
-- triggered the load, without re-running everyone else's (same as
-- lazy.nvim's event replay).
function M.on_event(events, loader, pattern)
    trigger_count = trigger_count + 1
    local trigger = vim.api.nvim_create_augroup("phdah.lazy_trigger." .. trigger_count, {})
    vim.api.nvim_create_autocmd(events, {
        group = trigger,
        pattern = pattern,
        callback = function(args)
            vim.api.nvim_del_augroup_by_id(trigger)
            local before = augroups_for(args.event)
            loader()
            for group in pairs(augroups_for(args.event)) do
                if not before[group] then
                    vim.api.nvim_exec_autocmds(args.event, {
                        group = group,
                        buffer = args.buf,
                        data = args.data,
                        modeline = false,
                    })
                end
            end
        end,
    })
end

-- Leave visual mode right away, so the '< and '> marks (and a '<,'>
-- command range) point at the current selection instead of the previous
-- one. Needed by visual-mode keymaps with a Lua callback rhs; a ":...<CR>"
-- rhs leaves visual mode on its own.
function M.exit_visual()
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
end

-- Define `names` the moment any of them is typed but doesn't exist yet.
-- Nvim re-runs the original command (args/bang/range intact) once
-- CmdUndefined returns, as long as the command now exists.
-- See `:help CmdUndefined`.
function M.on_command(names, loader)
    vim.api.nvim_create_autocmd("CmdUndefined", {
        pattern = names,
        once = true,
        callback = loader,
    })
end

return M
