-- Warn about keymaps that are a literal prefix of another keymap in the
-- same mode without `nowait`. Neovim must then wait `timeoutlen` ms after
-- the shorter one to see if you're about to type the rest of the longer
-- one, before firing it - causing input lag that's easy to miss (e.g.
-- "<leader>q" vs "<leader>qt"). This only checks global keymaps, not
-- buffer-local ones.

-- <leader>/<localleader> mapped alone (usually to <Nop>, to disable the
-- default behavior of the bare key) is an extremely common, deliberate
-- idiom that trivially "blocks" every other leader-prefixed keymap in any
-- config. It's excluded here since flagging it is never actionable.
local function is_bare_leader(lhs)
    return lhs == vim.g.mapleader or lhs == vim.g.maplocalleader
end

-- Known, deliberate multi-key schemes where the short mapping is a real,
-- meaningful action on its own (not an accidental prefix). Flagging these
-- is never actionable without breaking the plugin's own design:
--   "m"/"dm"  - marks.nvim's own default keymaps (set/delete mark),
--               vs its m0-m9/m[/m] numbered-bookmark shortcuts
--   "a"/"i"   - mini.ai's around/inside textobject dispatcher, vs its
--               "next"/"last" variants (an/al/in/il + object char)
local IGNORE_SHORT = {
    ["m"] = true,
    ["dm"] = true,
    ["a"] = true,
    ["i"] = true,
}

local function find_conflicts(mode)
    local maps = vim.api.nvim_get_keymap(mode)
    local conflicts = {}

    for _, short in ipairs(maps) do
        if short.nowait == 0 and not is_bare_leader(short.lhs) and not IGNORE_SHORT[short.lhs] then
            for _, long in ipairs(maps) do
                if
                    long.lhs ~= short.lhs
                    and #long.lhs > #short.lhs
                    and long.lhs:sub(1, #short.lhs) == short.lhs
                then
                    conflicts[#conflicts + 1] = string.format(
                        "%q blocks %q (mode %s) for up to timeoutlen=%dms; add nowait=true to %q",
                        short.lhs,
                        long.lhs,
                        mode,
                        vim.o.timeoutlen,
                        short.lhs
                    )
                end
            end
        end
    end

    return conflicts
end

local function check_all()
    local all = {}
    for _, mode in ipairs({ "n", "v", "x", "o", "i" }) do
        vim.list_extend(all, find_conflicts(mode))
    end

    if #all > 0 then
        vim.notify(
            "Keymap prefix conflicts found (input lag risk):\n" .. table.concat(all, "\n"),
            vim.log.levels.WARN
        )
    end
end

vim.api.nvim_create_user_command("CheckKeymapConflicts", check_all, {
    desc = "Warn about keymaps that block a longer keymap without nowait",
})

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(check_all)
    end,
})
