function date(time)
	if time == null then
		return os.date("%Y-%m-%d ")
	else
		return os.date("%Y-%m-%d %a %R")
	end
end

function template(deck_name)
	local template = "%%DECKNAME " .. deck_name .. [[

%%MODELNAME Basic
%%TAGS {}
%Front
{}
%Front
%Back
{}
%Back]]
return 	fmt(template,
			{
				i(1),
				i(2),
				i(3),
			}
		)
end

return {
	s("p", {
		t("[Programming]"),
	}),
	s("c", {
		t("[Computer]"),
	}),
	s("e", {
		t("[English]"),
	}),
	s("a", {
		t("[Arabic]"),
	}),
	s("k", {
		t("[Knowledge]"),
	}),
	s(
		"english-word",
		template("[English] Words")
	),
	s(
		"english-phrase",
		template("[English] Phrases")
	),
	s(
		"arabic-phrase",
		template("[Arabic] Phrases")
	),
	s(
		"arabic-word",
		template("[Arabic] Words")
	),
	s (
	"basic",
	 fmt([[
%%DECKNAME {}
%%MODELNAME Basic
%%TAGS {}
%Front
{}
%Front
%Back
{}
%Back
]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
			}
		)
	)
}
