return {
	s({ trig = "in" }, t("\\in")),
	s({ trig = "ti" }, t("\\times")),
	s(
		{ trig = "sum" },
		fmta([[\sum_{<>}^{<>} <>]], {
			i(1),
			i(2),
			i(3),
		})
	),
}
