-- llama gen
vim.api.nvim_set_keymap('n', '<C-g>', ':Gen Chat<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-g>', ':Gen Ask<CR>',
                        {noremap = true, silent = true})

-- LSP keymaps
vim.api.nvim_set_keymap('n', '<leader>gg',
                        ":lua vim.lsp.buf.definition(); vim.cmd('normal! zz')<CR>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gv',
                        ":lua vim.cmd('vsplit'); vim.cmd('wincmd l'); vim.lsp.buf.definition(); vim.cmd('normal! zz')<CR>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>',
                        {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gr",
               function() return ":IncRename " .. vim.fn.expand("<cword>") end,
               {expr = true, noremap = true, silent = true})

-- Diagnostic / Error
vim.api.nvim_set_keymap('n', '<leader>dh',
                        ':lua vim.diagnostic.open_float()<CR>',
                        {noremap = true, silent = true})
vim.keymap.set("n", "<leader>en", ":lua vim.diagnostic.goto_next()<CR>",
               {noremap = true, silent = true})
vim.keymap.set("n", "<leader>eN", ":lua vim.diagnostic.goto_prev()<CR>",
               {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ef", ":lua vim.lsp.buf.code_action()<CR>",
               {noremap = true, silent = true})

-- Lint
vim.api.nvim_set_keymap('n', '<C-CR>', ':Lint<CR>',
                        {noremap = true, silent = true})

-- Terminal keymaps
vim.api.nvim_set_keymap('n', '<leader>vt', ":belowright sp | term<CR>",
                        {noremap = true, silent = true})

-- Vim Explorer
vim.api.nvim_set_keymap('n', '<leader>-', ':Oil --float<CR>',
                        {noremap = true, silent = true})

-- Quickfix list
vim.api
    .nvim_set_keymap('n', 'cn', ':cnext<CR>', {noremap = true, silent = true})
vim.api
    .nvim_set_keymap('n', 'cp', ':cprev<CR>', {noremap = true, silent = true})

-- Flash jump
vim.api.nvim_set_keymap('n', 'ss', '<cmd>lua require("flash").jump()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'ss', '<cmd>lua require("flash").jump()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('o', 'ss', '<cmd>lua require("flash").jump()<CR>',
                        {noremap = true, silent = true})

-- Flash Treesitter
vim.api.nvim_set_keymap('n', 'sS', '<cmd>lua require("flash").treesitter()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'sS', '<cmd>lua require("flash").treesitter()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('o', 'sS', '<cmd>lua require("flash").treesitter()<CR>',
                        {noremap = true, silent = true})

-- Git conflict
vim.api.nvim_set_keymap('n', 'cl', ':GitConflictListQf<CR>', {silent = true})
vim.api
    .nvim_set_keymap('n', 'co', ':GitConflictChooseOurs<CR>', {silent = true})
vim.api.nvim_set_keymap('n', 'ct', ':GitConflictChooseTheirs<CR>',
                        {silent = true})
vim.api
    .nvim_set_keymap('n', 'c0', ':GitConflictChooseBoth<CR>', {silent = true})
vim.api
    .nvim_set_keymap('n', 'cb', ':GitConflictChooseNone<CR>', {silent = true})
-- TODO: Add 'zz' after next and prev
vim.api.nvim_set_keymap('n', 'cj', ':GitConflictNextConflict<CR>',
                        {silent = true})
vim.api.nvim_set_keymap('n', 'ck', ':GitConflictPrevConflict<CR>',
                        {silent = true})

-- lazygit
vim.api.nvim_set_keymap('n', '<C-l>',
                        ':FloatermNew --width=0.9 --height=0.9 lazygit<CR>',
                        {noremap = true, silent = true})

-- Octo GitHub pull requests
vim.api.nvim_set_keymap('n', '<C-o>', ':Octo<CR>',
                        {noremap = true, silent = true})

-- Dap keymaps
vim.api.nvim_set_keymap('n', '<leader>b',
                        ':lua require("dap").toggle_breakpoint()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("dap").continue()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("phdah.nvim-dap").dapui_terminate()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require("dap").step_into()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>m', ':lua require("dap").step_over()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>e', ':lua require("dap").step_out()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>CB',
                        ':lua require("dap").clear_breakpoints()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>r',
                        ':lua require("dapui").open({reset = true})<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>B',
                        ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition (key==\'value\'): "))<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':DapNvimDebugee<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ds', ':DapNvimSource<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dy',
                        ':lua require("phdah.nvim-dap").start_repl()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<leader>dr',
                        ':lua require("phdah.nvim-dap").send_to_repl()<CR>',
                        {noremap = true, silent = true})

-- Execute vim line in shell
vim.api.nvim_set_keymap('n', '<leader><Enter>', ':.!zsh<CR>',
                        {noremap = true, silent = true})

-- Buffer control
vim.api.nvim_set_keymap('n', '<C-m>', ':noh<CR>',
                        {noremap = true, silent = true})
vim.api
    .nvim_set_keymap('n', '<C-n>', ':bn<CR>', {noremap = true, silent = true})

-- Close buffers
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>Q', ':bd!<CR>',
                        {noremap = true, silent = true})

-- Window control
vim.api.nvim_set_keymap('n', '<S-Right>', ':vertical resize +3<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Left>', ':vertical resize -3<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Up>', ':resize +1<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Down>', ':resize -1<CR>',
                        {noremap = true, silent = true})

-- Open vertical split
vim.api.nvim_set_keymap('n', '<leader>vv', ':vsplit<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>vh', ':split<CR>',
                        {noremap = true, silent = true})

-- Delete line and insert empty line
vim.api.nvim_set_keymap('n', '<leader>dd', 'Vc<Esc>',
                        {noremap = true, silent = true})

-- DBee database
vim.api.nvim_set_keymap('n', '<leader>ö',
                        ':lua require("dbee").toggle(); require("nvim-utils").Mouse:toggle()<CR>',
                        {noremap = true, silent = true})

-- Browse files
vim.api.nvim_set_keymap('n', '<leader>ff',
                        ':lua require("phdah.telescope").find_files_git()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fF',
                        ":lua require('telescope').extensions.smart_open.smart_open({cwd='~'})<CR>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fr',
                        ':lua require("phdah.telescope").live_grep_git()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f*',
                        ':lua require("phdah/telescope").grep_string_git()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fh',
                        ':lua require("telescope.builtin").help_tags()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fc',
                        ':lua require("phdah.telescope").telescope_diff_from_history()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope diagnostics<CR>',
                        {noremap = true, silent = true})

-- Spell checking
vim.api.nvim_set_keymap('n', '<leader>z',
                        ':setlocal spell! spelllang=en_us<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'z=',
                        ":lua require('telescope.builtin').spell_suggest()<CR>",
                        {noremap = true, silent = true})
vim.api
    .nvim_set_keymap('n', '<leader>Z', '1z=', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'zl', ']szz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'zh', '[szz', {noremap = true, silent = true})

-- Line toggle comment
vim.api.nvim_set_keymap('n', '<leader>\'', ':CommentToggle<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<leader>\'', ':CommentToggle<CR>',
                        {noremap = true, silent = true})

-- Center search
vim.api.nvim_set_keymap('n', 'gg', 'ggzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'G', 'Gzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'n', 'nzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'jzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'kzz', {noremap = true})
vim.api.nvim_set_keymap('n', 'g*', 'g*zz', {noremap = true})
vim.api.nvim_set_keymap('n', 'g#', 'g#zz', {noremap = true})
vim.api.nvim_set_keymap('n', '#', '#zz', {noremap = true})
vim.api.nvim_set_keymap('n', '*', '*zz', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', {noremap = true})

-- Open line above and below
vim.api.nvim_set_keymap('n', '<leader>o', 'o<Esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>O', 'O<Esc>', {noremap = true})

-- Git gutter commands
vim.api.nvim_set_keymap('n', 'gj',
                        ':lua require("gitsigns").nav_hunk("next")<CR>zz',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gk',
                        ':lua require("gitsigns").nav_hunk("prev")<CR>zz',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gu', ':lua require("gitsigns").reset_hunk()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gU',
                        ':lua require("gitsigns").undo_stage_hunk()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gd',
                        ':lua require("gitsigns").preview_hunk()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gD', ':lua require("gitsigns").diffthis()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gs', ':lua require("gitsigns").stage_hunk()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gb', ':lua require("gitsigns").blame_line()<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'gs',
                        [[:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>]],
                        {noremap = true, silent = true})

-- Jump between code blocks
vim.api.nvim_set_keymap('n', '<leader>j', '}zz', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>k', '{zz', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>j', '}zzk', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>k', '{zzj', {noremap = true})

-- Toggle number and sign column
vim.api.nvim_set_keymap('n', '<leader>n',
                        ':set invrelativenumber invnumber<CR>:GitGutterToggle<CR>',
                        {noremap = true, silent = true})

-- Toggle markdown preview
vim.api.nvim_set_keymap('n', '<leader>MD', ':MarkdownPreviewToggle<CR>',
                        {noremap = true, silent = true})

-- Command line remaps
vim.api.nvim_set_keymap('c', '<D-Left>', '<Home>', {noremap = true})
vim.api.nvim_set_keymap('c', '<D-Right>', '<End>', {noremap = true})
vim.api.nvim_set_keymap('c', '<M-Left>', '<S-Left>', {noremap = true})
vim.api.nvim_set_keymap('c', '<M-Right>', '<S-Right>', {noremap = true})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-c>', {noremap = true})

