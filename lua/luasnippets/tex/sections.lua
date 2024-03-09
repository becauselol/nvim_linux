return {
	s(
		{ trig = "sec" },
		fmta([[\section{<>}]], {
			i(1),
		})
	),
	s(
		{ trig = "question" },
		fmta([[\section{Question <>}]], {
			i(1),
		})
	),
	s(
		{ trig = "ssec" },
		fmta([[\subsection{<>}]], {
			i(1),
		})
	),
	s(
		{ trig = "sssec" },
		fmta([[\subsubsection{<>}]], {
			i(1),
		})
	),
}
