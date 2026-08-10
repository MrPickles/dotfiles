return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          selection = {
            -- Do not let Enter accept a completion that the user did not
            -- explicitly select first.
            preselect = false,
            auto_insert = false,
          },
        },
      },
      sources = {
        min_keyword_length = function(ctx)
          -- Keep trigger-character (for example, `object.`) and manual
          -- completion immediate, but wait for a useful prefix when typing
          -- an identifier normally.
          if ctx.trigger.initial_kind == "keyword" then
            return 3
          end
          return 0
        end,
      },
    },
  },
}
