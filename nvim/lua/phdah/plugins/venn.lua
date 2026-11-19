local lib = require("phdah.plugins.lib")

local load = lib.once(function()
    lib.load({ "venn.nvim" })
    -- A 4th line style "r" (venn ships s/d/b): rounded corners, dashed lines.
    -- Keys are venn's up/down/left/right directions.
    local venn = require("venn")
    for dirs, ch in pairs({
        [" r r"] = "╭",
        [" rr "] = "╮",
        ["r  r"] = "╰",
        ["r r "] = "╯",
        ["  rr"] = "┄",
        ["rr  "] = "┆",
    }) do
        venn.set_line(vim.split(dirs, ""), ch)
    end
end)

----------------------------------------------------------------------------
-- Box colors. Plain text can't hold colors, so each color is its own line
-- style (which survives copy/paste and is visible to an LLM), and every
-- markdown window highlights the style's characters:
--   thin ┌─┐ default | double ╔═╗ green | heavy ┏━┓ yellow | dashed ╭┄╮ red
----------------------------------------------------------------------------
local styles = {
    VennGreen = { "#a3be8c", "[═║╔╗╚╝╠╣╦╩╬╒╓╕╖╘╙╛╜╞╟╡╢╤╥╧╨╪╫]" },
    VennYellow = {
        "#ebcb8b",
        "[━┃┏┓┗┛┣┫┳┻╋┍┎┑┒┕┖┙┚┝┞┟┠┡┢┥┦┧┨┩┪┭┮┯┰┱┲┵┶┷┸┹┺┽┾┿╀╁╂╃╄╅╆╇╈╉╊]",
    },
    VennRed = { "#bf616a", "[╭╮╰╯┄┆]" },
}

-- `:colorscheme` clears highlight groups, so (re)define them on every one.
-- `default` lets a user/colorscheme override them.
local function set_highlights()
    for group, style in pairs(styles) do
        vim.api.nvim_set_hl(0, group, { fg = style[1], default = true })
    end
    vim.api.nvim_set_hl(0, "VennSelect", { fg = "#88C0D0", bold = true, default = true })
    vim.api.nvim_set_hl(0, "VennNoVisual", {})
end
set_highlights()

-- Matches are window-local: add them when a window shows markdown, drop
-- them when it switches to something else.
local function colorize()
    local ids = vim.w.venn_matches
    if vim.bo.filetype == "markdown" and not ids then
        ids = {}
        for group, style in pairs(styles) do
            ids[#ids + 1] = vim.fn.matchadd(group, style[2])
        end
        vim.w.venn_matches = ids
    elseif vim.bo.filetype ~= "markdown" and ids then
        for _, id in ipairs(ids) do
            pcall(vim.fn.matchdelete, id)
        end
        vim.w.venn_matches = nil
    end
end

local group = vim.api.nvim_create_augroup("phdah.venn.colors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, { group = group, callback = colorize })

-- { window, line, virtual column } under the mouse, or nil when it's not
-- over the text area of `win` (when given): another window, the border,
-- statusline, number column, ... The virtual column is computed from the
-- screen column, since getmousepos()'s `column` stops at the end of the
-- text and draw mode works past it.
local function mouse_pos(win)
    local m = vim.fn.getmousepos()
    if m.line == 0 or (win and m.winid ~= win) then
        return nil
    end
    local info = vim.fn.getwininfo(m.winid)[1]
    local col = m.wincol - info.textoff + info.leftcol
    if col < 1 then
        return nil
    end
    return { m.winid, m.line, col }
end

-- Previews (box outline while selecting, arrow while right-dragging) are
-- colored extmark overlays, so the buffer never changes until you commit.
-- Vim's usual line-wise Visual highlight is hidden in draw mode via
-- 'winhighlight'. Highlights are (re)defined in enable(), since
-- `:colorscheme` clears them.
local ns = vim.api.nvim_create_namespace("phdah.venn.select")

-- Overlay `text` at virtual column `col` (1-based) of line `lnum` in `win`.
local function put(win, lnum, col, text)
    local leftcol = vim.api.nvim_win_call(win, vim.fn.winsaveview).leftcol
    vim.api.nvim_buf_set_extmark(vim.api.nvim_win_get_buf(win), ns, lnum - 1, 0, {
        virt_text = { { text, "VennSelect" } },
        virt_text_pos = "overlay",
        virt_text_win_col = col - 1 - leftcol,
    })
end

-- Right-drag draws an arrow from press to release: horizontal first, then
-- vertical. venn joins the corner and puts the arrowhead on the last
-- segment, pointing in the drag direction; the preview mimics that.
-- If the mouse leaves the window's text area mid-drag, the arrow stays at
-- the last valid position (`arrow_end`) instead of going out of bounds.
local arrow_start, arrow_end
local function arrow_press()
    arrow_start = mouse_pos()
    arrow_end = arrow_start
end
local function arrow_drag()
    local start = arrow_start
    if not start then
        return
    end
    arrow_end = mouse_pos(start[1]) or arrow_end
    local win, l1, c1, l2, c2 = start[1], start[2], start[3], arrow_end[2], arrow_end[3]
    vim.api.nvim_buf_clear_namespace(vim.api.nvim_win_get_buf(win), ns, 0, -1)
    local horizontal, vertical = c1 ~= c2, l1 ~= l2
    if horizontal then
        local text = string.rep("─", math.abs(c2 - c1) + 1)
        if vertical then
            -- the corner replaces the last horizontal cell (at c2)
            local corner = (c2 > c1) and (l2 > l1 and "┐" or "┘") or (l2 > l1 and "┌" or "└")
            text = c2 > c1 and text:sub(1, -4) .. corner or corner .. text:sub(4)
        else
            text = c2 > c1 and text:sub(1, -4) .. "►" or "◄" .. text:sub(4)
        end
        put(win, l1, math.min(c1, c2), text)
    end
    if vertical then
        local step = l2 > l1 and 1 or -1
        for l = horizontal and l1 + step or l1, l2, step do
            put(win, l, c2, l == l2 and (step > 0 and "▼" or "▲") or "│")
        end
    end
end
local function arrow_release()
    local start = arrow_start
    arrow_start = nil
    if not start then
        return
    end
    local stop = mouse_pos(start[1]) or arrow_end
    local win, l1, c1, l2, c2 = start[1], start[2], start[3], stop[2], stop[3]
    vim.api.nvim_buf_clear_namespace(vim.api.nvim_win_get_buf(win), ns, 0, -1)
    local keys = ""
    if c1 ~= c2 then
        keys = keys .. ("%dG%d|<C-v>%d|:VBox<CR>"):format(l1, c1, c2)
    end
    if l1 ~= l2 then
        keys = keys .. ("%dG%d|<C-v>%dG%d|:VBox<CR>"):format(l1, c2, l2, c2)
    end
    if keys ~= "" then
        vim.cmd("silent normal! " .. vim.keycode(keys))
    end
end

-- Blank out everything on/inside the selected rectangle (visual `d` in
-- draw mode). Characters become spaces so the rest of the drawing doesn't
-- shift; trailing whitespace is trimmed. One undo step.
local function erase()
    local l1, l2 = vim.fn.line("v"), vim.fn.line(".")
    local c1, c2 = vim.fn.virtcol("v"), vim.fn.virtcol(".")
    if vim.fn.mode() == "V" then
        c1, c2 = 1, math.huge
    end
    l1, l2 = math.min(l1, l2), math.max(l1, l2)
    c1, c2 = math.min(c1, c2), math.max(c1, c2)
    vim.cmd("normal! " .. vim.keycode("<Esc>"))
    local lines = vim.api.nvim_buf_get_lines(0, l1 - 1, l2, false)
    for i, line in ipairs(lines) do
        local out, col = {}, 1
        for ch in line:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            local w = vim.api.nvim_strwidth(ch)
            out[#out + 1] = (col >= c1 and col <= c2) and string.rep(" ", w) or ch
            col = col + w
        end
        lines[i] = (table.concat(out):gsub("%s+$", ""))
    end
    vim.api.nvim_buf_set_lines(0, l1 - 1, l2, false, lines)
end

-- Buffer-local "draw mode": HJKL draw lines (arrowheads are added where a
-- line ends), in visual mode w/g/y/r draw a box around the selection
-- (keyboard <C-v> or a left mouse drag) in one of the color styles above
-- and d erases it, and a right mouse drag draws an arrow. Mouse is globally off in settings.lua, so it's switched on only
-- while drawing and restored afterwards.
local maps = {
    { "n", "H", "<C-v>h:VBox<CR>" },
    { "n", "J", "<C-v>j:VBox<CR>" },
    { "n", "K", "<C-v>k:VBox<CR>" },
    { "n", "L", "<C-v>l:VBox<CR>" },
    -- The *O variants draw "over": existing lines they cross are merged
    -- (┼, ├, ...) instead of being overwritten, where venn has a character
    -- for that mix of styles.
    { "v", "w", ":VBoxO<CR>" }, -- thin, default color
    { "v", "g", ":VBoxDO<CR>" }, -- double, green
    { "v", "y", ":VBoxHO<CR>" }, -- heavy, yellow
    { "v", "r", ":<C-u>lua require('venn').draw_box_over('r')<CR>" }, -- dashed, red
    { "v", "d", erase },
    { "n", "<RightMouse>", arrow_press },
    { "n", "<RightDrag>", arrow_drag },
    { "n", "<RightRelease>", arrow_release },
    -- A second right click within 'mousetime' arrives as <2-RightMouse>,
    -- which (unmapped) opens the default PopUp menu.
    { "n", "<2-RightMouse>", arrow_press },
    { "n", "<3-RightMouse>", arrow_press },
    { "n", "<4-RightMouse>", arrow_press },
}

-- Character at each virtual column (1-based) of `line`, in one pass.
local function columns(line)
    local cols, col = {}, 1
    for ch in line:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        cols[col] = ch
        col = col + vim.api.nvim_strwidth(ch)
    end
    return cols
end

-- venn.parse() scans its whole charset per call, so cache it per char.
local parsed = {}
local function parse(ch)
    if parsed[ch] == nil then
        parsed[ch] = require("venn").parse(ch) or false
    end
    return parsed[ch] and vim.list_slice(parsed[ch]) or { " ", " ", " ", " " }
end

-- Character `w` (VBoxO) will put at virtual column `col` (`cols` from
-- columns()): the existing character's line directions (venn's
-- parse/gen; index 1-4 is up/down/left/right) plus `dirs`. Mirrors venn's
-- draw_box_over().
local function merged(cols, col, dirs)
    local o = parse(cols[col] or " ")
    local clean = { " ", " ", " ", " " }
    for _, d in ipairs(dirs) do
        o[d], clean[d] = "s", "s"
    end
    local venn = require("venn")
    return venn.gen(o) or venn.gen(clean)
end

-- While in visual mode, outline the box w/g/y/r would draw (in the thin
-- style, since the key isn't known yet), crossings included.
local function preview(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    if not vim.fn.mode():find("^[vV\22]") then
        return
    end
    local win = vim.api.nvim_get_current_win()
    local l1, l2 = vim.fn.line("v"), vim.fn.line(".")
    local c1, c2 = vim.fn.virtcol("v"), vim.fn.virtcol(".")
    l1, l2 = math.min(l1, l2), math.max(l1, l2)
    c1, c2 = math.min(c1, c2), math.max(c1, c2)
    local w = c2 - c1 + 1
    if l1 == l2 then
        put(win, l1, c1, string.rep("─", w))
        return
    elseif w == 1 then
        for l = l1, l2 do
            put(win, l, c1, "│")
        end
        return
    end
    local lines = vim.api.nvim_buf_get_lines(buf, l1 - 1, l2, false)
    local function border(line, first, last)
        local cols = columns(line)
        local text = { merged(cols, c1, first) }
        for c = c1 + 1, c2 - 1 do
            text[#text + 1] = merged(cols, c, { 3, 4 })
        end
        text[#text + 1] = merged(cols, c2, last)
        return table.concat(text)
    end
    put(win, l1, c1, border(lines[1], { 2, 4 }, { 2, 3 }))
    put(win, l2, c1, border(lines[#lines], { 1, 4 }, { 1, 3 }))
    for l = l1 + 1, l2 - 1 do
        local cols = columns(lines[l - l1 + 1])
        put(win, l, c1, merged(cols, c1, { 1, 2 }))
        put(win, l, c2, merged(cols, c2, { 1, 2 }))
    end
end

-- `win` is the window whose window-local options get changed; pass nil
-- when that window is already gone (nothing to undo then).
local function enable(buf, win)
    load()
    if vim.b[buf].venn_enabled then
        return
    end
    for _, m in ipairs(maps) do
        vim.keymap.set(m[1], m[2], m[3], { buffer = buf, silent = true })
    end
    vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
        group = vim.api.nvim_create_augroup("phdah.venn.select." .. buf, { clear = true }),
        buffer = buf,
        callback = function()
            preview(buf)
        end,
    })
    vim.b[buf].venn_ve = vim.wo[win].virtualedit
    vim.b[buf].venn_whl = vim.wo[win].winhighlight
    vim.b[buf].venn_mouse = vim.o.mouse
    vim.wo[win].virtualedit = "all"
    local whl = vim.wo[win].winhighlight
    vim.wo[win].winhighlight = (whl ~= "" and whl .. "," or "") .. "Visual:VennNoVisual"
    vim.o.mouse = "a"
    vim.b[buf].venn_enabled = true
end

local function disable(buf, win)
    if not vim.b[buf].venn_enabled then
        return
    end
    for _, m in ipairs(maps) do
        vim.keymap.del(m[1], m[2], { buffer = buf })
    end
    vim.api.nvim_del_augroup_by_name("phdah.venn.select." .. buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    if win then
        vim.wo[win].virtualedit = vim.b[buf].venn_ve
        vim.wo[win].winhighlight = vim.b[buf].venn_whl
    end
    vim.o.mouse = vim.b[buf].venn_mouse
    vim.b[buf].venn_enabled = nil
end

vim.keymap.set("n", "<leader>D", function()
    local buf, win = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
    if vim.b[buf].venn_enabled then
        disable(buf, win)
        vim.notify("Draw mode off")
    else
        enable(buf, win)
        vim.notify("Draw mode on")
    end
end, { desc = "(D)raw mode toggle (venn)" })

----------------------------------------------------------------------------
-- Draw scratch pad: one persistent (file-backed, survives restarts) snacks
-- scratch buffer in a float, opened with draw mode on. Padded to
-- `PAD_LINES` lines, since the cursor can only go past the end of a line,
-- not past the last line. <leader>ld again (or q) closes it.
----------------------------------------------------------------------------
local PAD_LINES = 50

local function pad(buf, win)
    local lines = math.max(PAD_LINES, vim.api.nvim_win_get_height(win))
    local missing = lines - vim.api.nvim_buf_line_count(buf)
    if missing > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(string.rep("\n", missing - 1), "\n"))
    end
end

vim.keymap.set("n", "<leader>ld", function()
    local win = Snacks.scratch.open({
        name = "Draw",
        ft = "markdown",
        filekey = { cwd = false, branch = false, count = false },
        win = {
            width = 0.8, -- fractions of the editor size
            height = 0.8,
            wo = { colorcolumn = "" },
        },
    })
    if not win then
        return -- it was already open, so snacks closed it instead
    end
    local buf = win.buf
    local function clear()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        pad(buf, win.win)
    end
    pad(buf, win.win)
    enable(buf, win.win)
    -- Only the scratch buffer gets these, so they never leak elsewhere.
    vim.keymap.set("n", "<leader>r", clear, { buffer = buf, desc = "(r)eset draw scratch pad" })
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(win.win),
        once = true,
        callback = function()
            disable(buf, nil)
        end,
    })
    vim.api.nvim_buf_create_user_command(buf, "DrawClear", clear, { desc = "Reset the draw scratch pad to empty lines" })
end, { desc = "(l) (d)raw scratch pad in floating window" })
