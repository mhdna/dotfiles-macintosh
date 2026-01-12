local date = function()
	Format = "%Y-%m-%d"
	return { os.date(Format) }
end
local time = function()
	Format = "%R"
	return { os.date(Format) }
end
-- local date_time = function()
-- 	Format = "%Y-%m-%d %a %R"
-- 	return { os.date(Format) }
-- end

return {
	s(
		"itemtag", -- Trigger keyword for the snippet
		fmt(
			[[
- {}	:{}:
]],
			{
				i(2),
				i(1),
			}
		)
	),

	s(
		"movie", -- Trigger keyword for the snippet
		fmt(
			[[
# {} -- {}    :{}:
## Stars: {}/10
## Degeneracy: {}/10
## Review
{}
## Summary
{}
## Quotes
- {}
]],
			{
				i(1),
				f(date, {}),
				i(2),
				i(3),
				i(4),
				i(5),
				i(6),
				i(7),
			}
		)
	),

	s(
		"redbook", -- Trigger keyword for the snippet
		fmt(
			[[
# {} ({}) -- {}    :{}:
## Stars: {}/10
## Degeneracy: {}/10
## Review
{}
## Summary
{}
]],
			{
				i(1),
				i(2),
				f(date, {}),
				i(3),
				i(4),
				i(5),
				i(6),
				i(7),
			}
		)
	),
	s(
		"news",
		fmt(
			[[
# {} -- <{}>
]],
			{
				i(1),
				f(date, {}),
			}
		)
	),

	s(
		-- diary and journal
		"dj", -- Trigger keyword for the snippet
		fmt(
			[[
## {} -- {} :{}:
{}
]],
			{
				i(1),
				f(date, {}),
				i(2),
				i(3),
			}
		)
	),
	s(
		-- diary and journal
		"t", -- Trigger keyword for the snippet
		fmt(
			[[
- Starting hour: {}
- To do: 
  - {}
  - 
  - 
  - 
- Done: 
  - 
  - 
- Complaints (Things not to do or to improve next day):
  - 
  - 
- Activities:
  - 5:00 am : {}
  - 7:00 am : 
  - 8:00 am : 
  - 9:00 am : 
  - 10:00 am : 
  - 11:00 am : 
  - 12:00 am : 
  - 1:00 pm : 
  - 2:00 pm : 
  - 3:00 pm : 
  - 4:00 pm : 
  - 5:00 pm : 
  - 6:00 pm : 
  - 7:00 pm : 
  - 8:00 pm : 
  - 9:00 pm : 
  - 10:00 pm : 
  - 11:00 pm : 
  - 12:00 pm : 
- Finishing hour: 
]],
			{
				f(time, {}),
				i(1),
				i(2),
			}
		)
	),
	s(
		-- diary and journal
		"ac", -- Trigger keyword for the snippet
		fmt(
			[[
START
Basic
## {}
Back:
{}
END
]],
			{
				i(1),
				i(2),
			}
		)
	),
	s("es", {
		t("⭐"),
	}),
	s("ec", {
		t("🧑‍🤝‍🧑"),
	}),
	s("eb", {
		t("📖"),
	}),
	s("em", {
		t("🕌"),
	}),
}
