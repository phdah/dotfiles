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
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'rg' },
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
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
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

----------------------------------
-- Auto completion for Dadbod-ui --
----------------------------------
cmp.setup.filetype({"sql", "mysql", "plsql"}, {
    sources = cmp.config.sources{
        { name = 'vim-dadbod-completion' }
    }
})

vim.g.completion_chain_complete_list = {
    sql = {{complete_items = {'vim-dadbod-completion'}}}
}
vim.g.completion_matching_strategy_list = {'exact', 'substring'}
vim.g.completion_matching_ignore_case = 1

