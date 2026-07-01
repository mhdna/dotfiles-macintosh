const {
  Clipboard,
  Front,
  Hints,
  Normal,
  RUNTIME,
  Visual,
  aceVimMap,
  addSearchAlias,
  cmap,
  getClickableElements,
  imap,
  imapkey,
  iunmap,
  map,
  mapkey,
  readText,
  removeSearchAlias,
  tabOpenLink,
  unmap,
  unmapAllExcept,
  vmapkey,
  vunmap,
} = api;

// api.unmap("<ctrl-i>");
settings.defaultSearchEngine = "d";
// settings.smoothScroll = false;
// Prevent automatic next/previous page loads
settings.smartPageBoundary = false;

// blocklist
settings.blocklistPattern =
  /.*mail.google.com.*|.*inbox.google.com.*|.*monkeytype.com.*|.*leetcode.com.*|.*youtube.com.*/;

// set theme
api.Hints.style(
  "font-size:12pt;",
  "hint",
);

// ---- Settings ----
Hints.setCharacters("asdfgyuiopqwertnmzxcvb");
settings.defaultSearchEngine = "d";
settings.hintAlign = "left";
// settings.omnibarPosition = 'top';
settings.focusFirstCandidate = false;
settings.focusAfterClosed = "last";
settings.scrollStepSize = 200;
settings.tabsThreshold = 0;
settings.modeAfterYank = "Normal";

// ---- Map -----
// --- Hints ---
// Open Multiple Links
map("<Alt-f>", "cf");
unmap("cf");
// Open Hint in new tab
map("F", "C");
// Choose a buffer/tab
map("zt", "t");
map("t", "T");
map("T", "zt");
unmap("zt");

// --- Nav ---
// Open Clipboard URL in current tab
mapkey("p", "Open the clipboard's URL in the current tab", () => {
  Clipboard.read(function (response) {
    window.location.href = response.data;
  });
});
// Open Clipboard URL in new tab
map("P", "cc");
// Open a URL in current tab
map("o", "go");
// Edit current URL, and open in same tab
map("<Ctrl-u>", ";U");
// Edit current URL, and open in new tab
map("<Ctrl-U>", ";u");
// History Back/Forward
map("H", "S");
map("L", "D");
// Scroll Page Down/Up
// mapkey("<Ctrl-d>", "Scroll down", () => { Normal.scroll("pageDown"); });
// mapkey("<Ctrl-u>", "Scroll up", () => { Normal.scroll("pageUp"); });
// map('<Ctrl-b>', 'U');  // scroll full page up
//map('<Ctrl-f>', 'P');  // scroll full page down -- looks like we can't overwrite browser-native binding
// Next/Prev Page
// map('K', '[[');
// map('J', ']]');

// Open
// mapkey('gc', 'Open Configs', () => { tabOpenLink("about:config"); }); // doesn't work
mapkey("gh", "Open HackerNews", () => {
  tabOpenLink("https://news.ycombinator.com");
});
mapkey("gy", "Open Youtube", () => {
  tabOpenLink("https://youtube.com/");
});
mapkey("gt", "Open Github", () => {
  tabOpenLink("https://github.com");
});

mapkey("<Ctrl-i>", "#7View image in new tab", function () {
  Hints.create("img", (i) => tabOpenLink(i.src));
});

// --- Tabs ---
// Tab Delete/Undo
// map('D', 'x');
// mapkey('d', '#3Close current tab', () => { RUNTIME("closeTab"); });
// mapkey('u', '#3Restore closed tab', () => { RUNTIME("openLast"); });

// Move Tab Left/Right w/ one press
map(">", ">>");
map("<", "<<");
// Tab Next/Prev
// map("K", "R");
// map("J", "E");

// --- Misc ---
// Yank URL w/ one press (disables other yx binds)
// map('y', 'yy');
// Change focused frame
map("gf", "w");

// Emoji
// iunmap(":");

// // Misc
// unmap(';t');
// unmap('si');
// unmap('ga');
// unmap('gc');
// unmap('gn');
// unmap('gr');
// unmap('ob');
// unmap('og');
// unmap('od');
// unmap('oy');
// unmap('E');
// unmap('R');

removeSearchAlias("b", "s");
removeSearchAlias("d", "s");
removeSearchAlias("g", "s");
removeSearchAlias("h", "s");
removeSearchAlias("w", "s");
removeSearchAlias("y", "s");
removeSearchAlias("s", "s");

addSearchAlias("a", "amazon", "https://www.amazon.com/s?k=", "s");
// addSearchAlias(
//   "ap",
//   "arch pkg",
//   "https://www.archlinux.org/packages/?sort=&q=",
//   "s",
// );
// addSearchAlias(
//   "au",
//   "aur",
//   "https://aur.archlinux.org/packages/?O=0&SeB=nd&K=",
//   "s",
// );
// addSearchAlias(
//   "aw",
//   "arch wiki",
//   "https://wiki.archlinux.org/index.php?title=Special:Search&search=",
//   "s",
// );
// addSearchAlias(
//   "dc",
//   "docker",
//   "https://hub.docker.com/search?type=image&q=",
//   "s",
// );

// addSearchAlias("gh", "github", "https://github.com/search?q=", "s");
addSearchAlias("r", "reddit", "https://reddit.com/r/", "s");
// addSearchAlias('wiki', 'wikipedia', 'https://en.wikipedia.org/wiki/Special:Search/', 's');
// addSearchAlias("y", "yt", "https://youtube.com/search?q=", "s");

settings.theme = `
.sk_theme {
  font-size: 16pt;
	background: #100a14dd;
	color: #4f97d7;
}
#sk_status, #sk_find {
  font-size: 16pt;
}
.sk_theme tbody {
	color: #292d;
}
.sk_theme input {
	color: #d9dce0;
}
.sk_theme .url {
	color: #2d9574;
}
.sk_theme .annotation {
	color: #a31db1;
}
.sk_theme .omnibar_highlight {
	color: #333;
	background: #ffff00aa;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
	background: #5d4d7a55;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
	background: #5d4d7aaa;
}
.sk_theme #sk_omnibarSearchResult .omnibar_folder {
	color: #a31db1;
}
`;

// Youtube
// mapkey(
//   "<Space>",
//   "pause/resume on youtube",
//   function () {
//     var btn =
//       document.querySelector("button.ytp-ad-overlay-close-button") ||
//       document.querySelector("button.ytp-ad-skip-button") ||
//       document.querySelector("ytd-watch-flexy button.ytp-play-button");
//     btn.click();
//   },
//   { domain: /youtube.com/i },
// );

// ---- Unmap -----
// Proxy Stuff
unmap("spa");
unmap("spb");
unmap("spc");
unmap("spd");
unmap("sps");
unmap("cp");
unmap(";cp");
unmap(";ap");
// unmap("R");
// unmap("E");
unmap("S");
unmap("D");
