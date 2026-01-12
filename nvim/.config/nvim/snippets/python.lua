return {
	s(
		"p",
		fmt(
			[[
print({})
]],
			{
				i(0),
			}
		)
	),
	s(
		"env",
		fmt(
			[[
#!/usr/bin/env python3
{}
]],
			{
				i(0),
			}
		)
	),
	s(
		"scrape",
		fmt(
			[[
from bs4 import BeautifulSoup
import requests
import lxml

url = "{}"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')
{}
]],
			{
				i(1),
				i(2),
			}
		)
	),
}

-- If you return { stuff1}, {stuff2}, stuff2 will be expanded immediately without using c-k
