return {
-- A simple "Hello, world!" text node
s(
  {trig = "hi"}, -- Table of snippet parameters
  { -- Table of snippet nodes
    t("Hello, world!")
  }
),
s({trig="beg"},
  fmta(
    [[
      \begin{<>}
          <>
      \end{<>}
    ]],
    {
      i(1),
      i(2),
      rep(1),  -- this node repeats insert node i(1)
    }
  )
),
}
