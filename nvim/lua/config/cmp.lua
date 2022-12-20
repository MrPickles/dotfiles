local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

cmp.setup {
  -- Set the snippet generator. We use the "default" one written by the same author of this library.
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- Configure keyboard shortcuts for the completion menu.
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    -- Pressing tab will select the next item.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Pressing <shift-tab> will select the previous item.
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  -- Add sources to the completion engine. (These are the dependencies we configured.)
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
    {name = 'buffer'},
    {name = 'path'},
    {name = 'calc'},
  }),
  formatting = {
    -- Format completions with an emoji.
    format = lspkind.cmp_format(),
  }
}
