-- LSP keymaps
vim.api.nvim_set_keymap(
    "n",
    "<leader>gv",
    ":lua vim.cmd('vsplit'); vim.cmd('wincmd l'); vim.lsp.buf.definition(); vim.cmd('normal! zz')<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "K",
    ":lua vim.lsp.buf.hover()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.rename)

-- Diagnostic / Error
vim.api.nvim_set_keymap(
    "n",
    "<leader>dh",
    ":lua vim.diagnostic.open_float()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>en",
    ":lua vim.diagnostic.goto_next()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>eN",
    ":lua vim.diagnostic.goto_prev()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>ef",
    ":lua vim.lsp.buf.code_action()<CR>",
    { noremap = true, silent = true }
)

-- Lint
vim.api.nvim_set_keymap("n", "<C-CR>", ":Lint<CR>", { noremap = true, silent = true })

-- Terminal keymaps
vim.api.nvim_set_keymap(
    "n",
    "<leader>vt",
    ":belowright sp | term<CR>",
    { noremap = true, silent = true }
)

-- Quickfix list
vim.api.nvim_set_keymap("n", "co", ":copen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "cl", ":cclose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "cn", ":cnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "cp", ":cprev<CR>", { noremap = true, silent = true })

-- Buffer control
vim.api.nvim_set_keymap("n", "<C-m>", ":noh<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":bn<CR>", { noremap = true, silent = true })

-- Window control
vim.api.nvim_set_keymap(
    "n",
    "<S-Right>",
    ":vertical resize +3<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<S-Left>",
    ":vertical resize -3<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<S-Up>",
    ":resize +1<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<S-Down>",
    ":resize -1<CR>",
    { noremap = true, silent = true }
)

-- Open vertical split
vim.api.nvim_set_keymap(
    "n",
    "<leader>vv",
    ":vsplit<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>vh",
    ":split<CR>",
    { noremap = true, silent = true }
)

-- Delete line and insert empty line
vim.api.nvim_set_keymap("n", "<leader>dd", "Vc<Esc>", { noremap = true, silent = true })

-- Spell checking
vim.api.nvim_set_keymap(
    "n",
    "<leader>z",
    ":setlocal spell! spelllang=en_us<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>Z", "1z=", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "zl", "]szz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "zh", "[szz", { noremap = true, silent = true })

-- Center search
vim.api.nvim_set_keymap("n", "gg", "ggzz", { noremap = true })
vim.api.nvim_set_keymap("n", "G", "Gzz", { noremap = true })
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true })
vim.api.nvim_set_keymap("n", "j", "jzz", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "kzz", { noremap = true })
vim.api.nvim_set_keymap("n", "g*", "g*zz", { noremap = true })
vim.api.nvim_set_keymap("n", "g#", "g#zz", { noremap = true })
vim.api.nvim_set_keymap("n", "#", "#zz", { noremap = true })
vim.api.nvim_set_keymap("n", "*", "*zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Open line above and below
vim.api.nvim_set_keymap("n", "<leader>o", "o<Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>O", "O<Esc>", { noremap = true })

-- Git gutter commands
vim.keymap.set("n", "gj", function()
    if vim.wo.diff then
        vim.cmd("normal! ]c")
    else
        require("gitsigns").nav_hunk("next")
    end
    vim.cmd("normal! zz")
end, { noremap = true, silent = true })
vim.keymap.set("n", "gk", function()
    if vim.wo.diff then
        vim.cmd("normal! [c")
    else
        require("gitsigns").nav_hunk("prev")
    end
    vim.cmd("normal! zz")
end, { noremap = true, silent = true })

-- Jump between code blocks
vim.api.nvim_set_keymap("n", "<leader>j", "}zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>k", "{zz", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>j", "}zzk", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>k", "{zzj", { noremap = true })

-- Toggle number and sign column
vim.api.nvim_set_keymap(
    "n",
    "<leader>no",
    ":set invrelativenumber invnumber<CR>:GitGutterToggle<CR>",
    { noremap = true, silent = true }
)

-- Command line remaps
vim.api.nvim_set_keymap("c", "<D-Left>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("c", "<D-Right>", "<End>", { noremap = true })
vim.api.nvim_set_keymap("c", "<M-Left>", "<S-Left>", { noremap = true })
vim.api.nvim_set_keymap("c", "<M-Right>", "<S-Right>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-k>", "<C-c>", { noremap = true })
