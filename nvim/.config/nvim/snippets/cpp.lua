return {
	s(
		"bare",
		fmt(
			[[
#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <unordered_map>
#include <set>
#include <unordered_set>
#include <stack>
#include <queue>
#include <numeric>

using std::cout;
using std::cin;
using std::endl;
using std::vector;
using std::string;
using std::map;
using std::unordered_map;
using std::set;
using std::unordered_set;
using std::stack;
using std::queue;
using std::pair;
using std::make_pair;


int main() {{
  {}
  return 0;
}}
]],
			{
				i(0),
			}
		)
	),

	s(
		"icd",
		fmt(
			[[
#include {}
            ]],
			{ i(0, "directive") }
		)
	),
}
-- If you return { stuff1}, {stuff2}, stuff2 will be expanded immediately without using c-k
