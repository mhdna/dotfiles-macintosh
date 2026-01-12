// settings.theme = `
//
// .sk_theme {
//     font-family: Input Sans Condensed, Charcoal, sans-serif;
//     font-size: 10pt;
//     background: #24272e;
//     color: #abb2bf;
// }
// .sk_theme tbody {
//     color: #fff;
// }
// .sk_theme input {
//     color: #d0d0d0;
// }
// .sk_theme .url {
//     color: #61afef;
// }
// .sk_theme .annotation {
//     color: #56b6c2;
// }
// .sk_theme .omnibar_highlight {
//     color: #528bff;
// }
// .sk_theme .omnibar_timestamp {
//     color: #e5c07b;
// }
// .sk_theme .omnibar_visitcount {
//     color: #98c379;
// }
// .sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
//     background: #303030;
// }
// .sk_theme #sk_omnibarSearchResult ul li.focused {
//     background: #3e4452;
// }
// #sk_status, #sk_find {
//     font-size: 20pt;
// }`;

// api.map("<Ctrl-i>", "<Ctrl-ش>");
//
// 
// Keymaps
// an example to create a new mapping `ctrl-y`
// api.mapkey('<ctrl-y>', 'Show me the money', function() {
//     Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
// });
// api.map('zb', '<Alt-s>');

// unmapAllExcept(['<Ctrl-p>, <Ctrl-n>'], /.*docs\.google'.com.*/);
// switch tabs
// api.unmap('R');
// api.unmap('E');
// api.mapkey('K', '#3Go one tab right', function() {
//   api.RUNTIME("nextTab");
// }); //map('K', 'R');
// api.mapkey('J', '#3Go one tab left', function() {
//   api.RUNTIME("previousTab");
// });
// api.mapkey('S', '#8Open opened URL in current tab', 'Normal.openOmnibar({type: "URLs", extra: "getTabURLs"})');
// api.mapkey('H', '#4Go back in history', function() {
//   history.go(-1);
// }, { repeatIgnore: true });
// api.mapkey('L', '#4Go forward in history', function() {
//   history.go(1);
// }, { repeatIgnore: true });
// unmapAllExcept(['<Ctrl-p>, <Ctrl-n>'], /.*docs\.google'.com.*/);
// addSearchAlias('d',  'ddg', 'https://duckduckgo.com/?q=', 's');
// addSearchAlias('dh', 'docker', 'https://hub.docker.com/search?type=image&q=', 's');
// addSearchAlias('fh', 'flathub', 'https://flathub.org/apps/search/', 's');
// addSearchAlias('gh', 'github', 'https://github.com/search?q=', 's');
// addSearchAlias('pdb', 'proton', 'https://www.protondb.com/search?q=', 's');
// addSearchAlias('r', 'reddit', 'https://libreddit.spike.codes/r/', 's');
// addSearchAlias('st', 'steam', 'https://store.steampowered.com/search/?term=', 's');
// addSearchAlias('wiki', 'wikipedia', 'https://en.wikipedia.org/wiki/Special:Search/', 's');
// addSearchAlias('y', 'yt', 'https://invidious.snopyta.org/search?q=', 's');
