return {
	-- A simple "Hello, world!" text node
	s(
		{ trig = "hi" }, -- Table of snippet parameters
		{ -- Table of snippet nodes
			t("Hello, world!"),
		}
	),
	s(
		{ trig = "try" },
		fmta(
			[[
	   try {
	     <>
	   } catch (error) {
	     <>
	   }
	   ]],
			{
				i(1),
				i(2),
			}
		)
	),
}
