-- Highlight signs to jump to
vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
vim.g.qs_accepted_chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', '_', 'å', 'ä', 'ö', 'Å', 'Ä', 'Ö'
}

-- Set highlight groups for QuickScope
vim.cmd [[
  highlight QuickScopePrimary guifg=#ff0000 gui=underline ctermfg=DarkRed cterm=underline
  highlight QuickScopeSecondary guifg=#ff0000 gui=underline ctermfg=DarkMagenta cterm=underline
]]
