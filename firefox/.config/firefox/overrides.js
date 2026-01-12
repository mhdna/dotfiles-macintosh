// disable alt triggering menubar (probably needs to be at the beginning)
user_pref("ui.key.menuAccessKeyFocuses", false);

user_pref("browser.tabs.hoverPreview.enabled", false);

// user_pref("privacy.resistFingerprinting", false);

// for dark reader and vim bindings to work on restricted domains
user_pref("extensions.webextensions.restrictedDomains", "");
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);

// hide new tab logo
user_pref(
  "browser.newtabpage.activity-stream.logowordmark.AlwaysVisible",
  false,
);

// warn when closing with multiple tabs open
user_pref("browser.tabs.warnOnClose", true);

// a more compact ui
// user_pref("browser.uidensity", 1);

// disable Ctrl+q quit shortcut
user_pref("browser.quitShortcut.disabled", 1);

// toggle Firefox sync
// user_pref("identity.fxaccounts.enabled", true);

user_pref("browser.fullscreen.autohide", false);

user_pref("browser.toolbars.bookmarks.visibility", "newtab"); // always

// don't ask on download
user_pref("browser.download.alwaysOpenPanel", false);

user_pref("browser.bookmarks.autoExportHTML", true);

user_pref("browser.startup.page", 1);
// user_pref("browser.bookmarks.file", "~/personal/bookmarks.html");
user_pref("browser.startup.homepage", "about:home"); // about:home ,about:blank
// blank newtab
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.bookmarks.editDialog.maxRecentFolders", 1000);

// disable threedots menu trigger using keyboard
user_pref("browser.urlbar.resultMenu.keyboardAccessible", false);

// zoom text only (false = onlytext)
user_pref("browser.zoom.full", true);

// default zoom level
user_pref("apz.doubletapzoom.defaultzoomin", 1.2);

// disable firefox-view
user_pref("browser.tabs.firefox-view", false);

// Control-tab to cycle recent tabs
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// user_pref("extensions.pocket.enabled", false);

// enable searching from urlbar
user_pref("keyword.enabled", true);
// // disable the Twitter/R*ddit/Faceberg ads in the URL bar
// user_pref("browser.urlbar.quicksuggest.enabled", false);
// user_pref("browser.urlbar.suggest.topsites", false); // [FF78+]
// user_pref("signon.prefillForms", false);
// enable autocompletion when typing stuff in the urlbar
// user_pref("browser.urlbar.autoFill", true);
// highlight search matches
user_pref("findbar.highlightAll", true);
// allow access to http sites
user_pref("dom.security.https_only_mode", false);
// I don't know what this is, but when it's true localhost websites don't open
// user_pref("network.dns.disableIPv6", false);
// disable push notifications
user_pref("dom.push.enabled", false);
// save history
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
// search and form history
// user_pref("browser.formfill.enable", false);
// user_pref("privacy.clearOnShutdown.cache", false);
// user_pref("privacy.clearOnShutdown.downloads", false);
// user_pref("privacy.clearOnShutdown.formdata", false);
// user_pref("privacy.clearOnShutdown.history", false);
// user_pref("privacy.clearOnShutdown.sessions", false);
// maximum window size
// user_pref("privacy.window.maxInnerWidth", 1200);
// user_pref("privacy.window.maxInnerHeight", 1000);
// disable website is now full screen warning
user_pref("full-screen-api.warning.timeout", 0);
// no smooth scrolling
user_pref("general.smoothScroll", false);
// // This could otherwise cause some issues on bank logins and other annoying sites:
// user_pref("network.http.referer.XOriginPolicy", 0);
// Fix the issue where right mouse button instantly clicks
user_pref("ui.context_menus.after_mouseup", true);
// Disable letterboxing
// user_pref("privacy.resistFingerprinting.letterboxing", false);
// /* Zoom compatibility settings */
// user_pref("media.peerconnection.enabled", true); // 2001
// user_pref("media.peerconnection.ice.no_host", false); // 2001 [may or may not be required]
// /* needed for screensharing */
// // user_pref("dom.webaudi");
// // user_pref("media.getusermedia.screensharing.enabled", true);
// user_pref("webgl.disabled", false);// NEEDED FOR ZOOM
// /* 2012: limit WebGL ***/
// user_pref("webgl.min_capability_mode", false); // NEEDED FOR ZOOM
// user_pref("privacy.resistFingerprinting", false); //breaks zoom if true!o.enabled", true); // 2510
// user_pref("browser.search.suggest.enabled", true);
// user_pref("browser.urlbar.suggest.searches", true);

// // allow man in the middle
// user_pref("security.cert_pinning.enforcement_level", 1);
