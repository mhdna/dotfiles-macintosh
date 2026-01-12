local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("gitcommit", {
  s(
    {
      name = "chore: Plugins update",
      trig = "cpu",
      desc = "A conventional commit subject for a chore commit, updating plugins",
    },
    fmt(
      [[
        chore(plugins): update

        {}
      ]],
      { i(0) }
    )
  ),
})
