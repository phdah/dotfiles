-- Limit the height of comletions window
vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 5

-- Setup
local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = " ",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
    Misc = " ",
}

local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)  -- Use LuaSnip's lsp_expand function
        end,
    },
    sources = cmp.config.sources(
        {
            -- List of possible sources https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'treesitter' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'rg' },
            -- { name = 'cmp-dbee' },
        }
    ),
    formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
    vim_item.menu = (
        {
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            treesitter = "[TS]",
            dap = "[DAP]",
            path = "[Path]",
            rg = "[rg]",
        }
    )[entry.source.name]
    return vim_item
        end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping(
                { i = cmp.mapping.close(), c = cmp.mapping.close() }
                ),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if luasnip.expandable() then
                    luasnip.expand()
                else
                    cmp.confirm({
                        select = true,
                    })
                end
            else
                fallback()
            end
        end),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i"}),--, "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i"}),--, "s" }),
    }
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources(
        {
            -- Apparently there is an issue with 'path',
            -- see https://github.com/hrsh7th/nvim-cmp/issues/874#issuecomment-1090099590
            -- I might be able to specify the order of priority
            -- but will remove if still creating issue
            -- Still being an issue. Comment out for now
            { name = 'cmdline' },
            { name = 'path' },
        }
    ),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-----------------------------------------------
-- Commands to start and stop autocompletion --
-----------------------------------------------

vim.api.nvim_create_user_command('CmpStart', function()
    require('cmp').setup.buffer({ enabled = true })
end, {})

vim.api.nvim_create_user_command('CmpStop', function()
    require('cmp').setup.buffer({ enabled = false })
end, {})

-------------------------
-- Auto completion DAP --
-------------------------

require("cmp").setup({
    enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
    end
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

-- NOTE: Currently not working
------------------------------
-- Auto completion for DBee --
------------------------------
-- require("cmp-dbee").setup({})
-- cmp.setup.filetype({"sql", "mysql", "plsql"}, {
--     sources = cmp.config.sources{
--         { name = 'cmp-dbee' }
--     }
-- })

