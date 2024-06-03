return {
	-- A simple "Hello, world!" text node
	s(
		{ trig = "hi" }, -- Table of snippet parameters
		{ -- Table of snippet nodes
			t("Hello, world!"),
		}
	),
	s(
		{ trig = "doc" },
		fmta(
			[[
      \documentclass{article}

      \title{<>}
      \author{Yong Zhe Rui Gabriel}
      \date{<>}
      \begin{document}
        <>
      \end{document}
    ]],
			{
				i(1),
				i(2),
				i(3),
			}
		)
	),
	s(
		{ trig = "beg" },
		fmta(
			[[
      \begin{<>}
        <>
      \end{<>}
    ]],
			{
				i(1),
				i(2),
				rep(1), -- this node repeats insert node i(1)
			}
		)
	),
	s(
		{ trig = "theorem" },
		fmta(
			[[
      \begin{theorem}{<>}{}
        <>
      \end{theorem}
    ]],
			{
				i(1),
				i(2),
			}
		)
	),
	s(
		{ trig = "note" },
		fmta(
			[[
      \begin{note}{<>}{}
        <>
      \end{note}
    ]],
			{
				i(1),
				i(2),
			}
		)
	),
	s(
		{ trig = "def" },
		fmta(
			[[
      \begin{definition}{<>}{}
        <>
      \end{definition}
    ]],
			{
				i(1),
				i(2),
			}
		)
	),
	s(
		{ trig = "align" },
		fmta(
			[[
      \begin{align*}
        <>
      \end{align*}
    ]],
			{
				i(1),
			}
		)
	),
	s(
		{ trig = "itemize" },
		fmta(
			[[
      \begin{itemize}
        \item <>
      \end{itemize}
    ]],
			{
				i(1),
			}
		)
	),
	s(
		{ trig = "enum" },
		fmta(
			[[
      \begin{enumerate}
        \item <>
      \end{enumerate}
    ]],
			{
				i(1),
			}
		)
	),
}
