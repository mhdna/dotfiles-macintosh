local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("cs", {
  s(
    {
      name = "C# comment",
      trig = "xc",
      desc = "A C# doc comment with starting <summary> XML tag.",
    },
    fmt(
      [[
        /// <summary>
        /// {description}
        /// </summary>
      ]],
      { description = i(1) }
    )
  ),
  s({
    name = "C# DisplayAttribute",
    trig = "dis",
    desc = "A C# DisplayAttribute call with the Name property.",
  }, fmt('[Display(Name = "{name}")]', { name = i(1) })),
})

ls.add_snippets("comment", {
  s(
    {
      name = "C# exception comment",
      trig = "xe",
      desc = "A C# doc comment <exception> XML tag.",
    },
    fmt(
      [[<exception cref="{member}">{description}</exception>]],
      { member = i(1), description = i(2) }
    )
  ),
  s({
    name = "C# inheritdoc comment",
    trig = "xi",
    desc = "A C# doc comment <inheritdoc> XML tag.",
  }, fmt([[<inheritdoc cref="{member}" />]], { member = i(1) })),
  s(
    {
      name = "C# param comment",
      trig = "xp",
      desc = "A C# doc comment <param> XML tag.",
    },
    fmt(
      [[<param name="{name}">{description}</param>]],
      { name = i(1), description = i(2) }
    )
  ),
  s({
    name = "C# paramref comment",
    trig = "xpr",
    desc = "A C# doc comment <paramref> XML tag.",
  }, fmt([[<paramref name="{name}" />]], { name = i(1) })),
  s({
    name = "C# remarks comment",
    trig = "xrem",
    desc = "A C# doc comment <remarks> XML tag.",
  }, fmt([[<remarks>{description}</remarks>]], { description = i(1) })),
  s({
    name = "C# returns comment",
    trig = "xret",
    desc = "A C# doc comment <returns> XML tag.",
  }, fmt([[<returns>{description}</returns>]], { description = i(1) })),
  s({
    name = "C# see-cref comment",
    trig = "xsec",
    desc = "A C# doc comment <see cref> XML tag.",
  }, fmt([[<see cref="{member}" />]], { member = i(1) })),
  s({
    name = "C# see-href comment",
    trig = "xseh",
    desc = "A C# doc comment <see href> XML tag.",
  }, fmt([[<see href="{url}" />]], { url = i(1) })),
  s({
    name = "C# see-langword comment",
    trig = "xsel",
    desc = "A C# doc comment <see langword> XML tag.",
  }, fmt([[<see langword="{keyword}" />]], { keyword = i(1, "null") })),
  s({
    name = "C# seealso-cref comment",
    trig = "xsac",
    desc = "A C# doc comment <seealso cref> XML tag.",
  }, fmt([[<seealso cref="{member}" />]], { member = i(1) })),
  s({
    name = "C# seealso-href comment",
    trig = "xsah",
    desc = "A C# doc comment <seealso href> XML tag.",
  }, fmt([[<seealso href="{url}" />]], { url = i(1) })),
  s({
    name = "C# summary comment",
    trig = "xsum",
    desc = "A C# doc comment <summary> XML tag.",
  }, fmt([[<summary>{description}</summary>]], { description = i(1) })),
  s(
    {
      name = "C# typeparam comment",
      trig = "xtp",
      desc = "A C# doc comment <typeparam> XML tag.",
    },
    fmt(
      [[<typeparam name="{name}">{description}</typeparam>]],
      { name = i(1), description = i(2) }
    )
  ),
  s({
    name = "C# typeparamref comment",
    trig = "xtpr",
    desc = "A C# doc comment <typeparamref> XML tag.",
  }, fmt([[<typeparamref name="{name}" />]], { name = i(1) })),
})
