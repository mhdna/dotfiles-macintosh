return {
	s(
		"fp",
		fmt(
			[[
fmt.Println({})
]],
			{
				i(0),
			}
		)
	),
	s(
		"ff",
		fmt(
			[[
fmt.Printf({})
            ]],
			{ i(0) }
		)
	),
	s(
		"fF",
		fmt(
			[[
fmt.Fprintln({})
            ]],
			{ i(0) }
		)
	),
	s(
		"fe",
		fmt(
			[[
fmt.Fprintln(os.Stderr, err)
            ]],
			{}
		)
	),
	s(
		"e",
		fmt(
			[[
if err != nil {{
	{}
}}
            ]],
			{ i(0) }
		)
	),
}, {}

-- If you return { stuff1}, {stuff2}, stuff2 will be expanded immediately without using c-k
