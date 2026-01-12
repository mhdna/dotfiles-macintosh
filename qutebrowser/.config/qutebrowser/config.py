config.source("scripts/redirector.py")
config.load_autoconfig()
c.new_instance_open_target = "tab"
c.downloads.position = "bottom"
c.tabs.position = "top"
# c.statusbar.position = "bottom"

config.set("zoom.default", 120)
config.set("window.hide_decoration", false)

config.set("url.default_page", "about:blank")
config.set("url.start_pages", "about:blank")  # http://127.0.0.1:8080

c.spellcheck.languages = ["en-US"]

c.confirm_quit = ["downloads"]  # always
# c.downloads.location.directory = "$XDG_DOWNLOAD_DIR/browser"
c.downloads.location.prompt = True

c.content.notifications.enabled = False
c.scrolling.smooth = False
c.content.autoplay = False
c.tabs.background = True

# Per site settings
# Javascript
c.content.javascript.enabled = True
# config.set('content.javascript.enabled', False, '*://www.google.com/')
# c.content.javascript.can_access_clipboard = False
c.content.javascript.can_open_tabs_automatically = False
# config.set('content.images', True, '*://keyma.sh/')

c.messages.timeout = 5000

c.auto_save.session = True

config.set(
    "url.searchengines",
    {
        "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",  # "https://www.searx.be/search?q={}",
        "g": "https://www.google.com/?q={}",
        "s": "https://www.startpage.com/do/search?q={}",
        "im": "https://www.imdb.com/find/?q={}",
        "i": "https://duckduckgo.com/?q={}&ia=images&iax=images",
        "d": "https://duckduckgo.com/?q={}",
        "aw": "https://wiki.archlinux.org/?search={}",
        "w": "https://en.wikipedia.org/wiki/Special:Search/{}",
        "wa": "https://ar.wikipedia.org/wiki/Special:Search/{}",
        "wi": "https://wiby.me/?q={}",
        "dic": "https://www.dict.cc/?s={}",
        "u": "https://rd.vern.cc/define.php?term={}",
        "ur": "https://www.urbandictionary.com/define.php?term=%7B{}%7D",
        "y": "yewtu.be/search?q={}",
        "yt": "https://www.youtube.com/results?search_query={}",
        "yy": "https://yandex.com/images/search?text={}",
        "m": "https://www.google.com/maps?q={}",
    },
)

# unbind
config.unbind("<ctrl+q>")
config.unbind("ad")
config.bind("m", "cmd-set-text -s :quickmark-load ")
config.bind("M", "quickmark-save")
config.unbind("u")
config.unbind("d")
config.bind("d", "scroll-page 0 0.5")
config.bind("u", "scroll-page 0 -0.5")

config.unbind("b")
config.bind("bb", "spawn --userscript bm_list")
config.bind("br", "spawn --userscript bm_list")
config.bind("bt", "spawn --userscript bm_list -t")
config.bind("baa", "spawn --userscript bm_add {url}")
config.bind("baA", "hint links spawn --userscript bm_add {hint-url}")
config.bind("bar", "spawn --userscript bm_add {url} readlater")
config.bind("baR", "hint links spawn --userscript bm_add {hint-url} readlater")
# config.bind("baw", "spawn --userscript bm_add {url} watchlater")
# config.bind("baW", "hint links spawn --userscript bm_add {hint-url} watchlater")
config.bind("bac", "spawn --userscript bm_add {clipboard}")
config.bind("baW", "hint links spawn --userscript bm_add {clipboard}")
config.bind("bd", "spawn --userscript bm_del {url}")
config.bind("<Ctrl+o>", "spawn --userscript opendownload")

# basic remaps
config.bind("<Ctrl+Shift+p>", "open -p")
config.bind("T", "open -t")
config.bind("t", "cmd-set-text -s :tab-focus ")
config.bind("x", "tab-close")
config.bind("X", "undo")
config.bind("cr", "config-source")
# reload quickmakrs
config.bind("cq", "spawn --userscript reload-quickmarks")

# true fullscreen
config.bind(
    ";;",
    "config-cycle statusbar.show in-mode always ;; config-cycle tabs.show switching always;; config-cycle content.notifications.enabled true false",
)

# print
config.bind(
    "pr",
    "spawn --userscript print",
)
config.bind(
    "pa",
    "spawn --userscript print -a",
)
config.bind(
    "<Ctrl+Alt+r>",
    "spawn bach -c 'echo {url}{title} >> ~/dox/notes/todo.txt && notify-send -t 1500 'Read Later''",
)
# clipboard
config.bind("pt", "open -t -- {clipboard}")
# yank
config.bind("yP", "yank pretty-url")

# yank phone
config.bind(
    "yp",
    "spawn kdeconnect-cli --refresh && kdeconnect-cli --share-text {url} --device 415a811582e4a899",
)
config.bind(
    ";p", "hint links spawn kdeconnect-cli --share-text {url} --device 415a811582e4a899"
)
config.set("colors.webpage.darkmode.enabled", True)
# Command mode

# emacs-like command mode key bindings
# config.bind('<Ctrl+b>', 'rl-beginning-of-line', mode='command')
# config.bind('<Ctrl+e>', 'rl-end-of-line', mode='command')
# config.bind('<Ctrl+l>', 'rl-forward-delete-char', mode='command')
# config.bind('<Ctrl+h>', 'rl-backward-delete-char', mode='command')
# config.bind('<Alt+l>', 'rl-forward-char', mode='command')
# config.bind('<Alt+Shift+l>', 'rl-forward-word', mode='command')
# config.bind('<Alt+h>', 'rl-backward-char', mode='command')
# config.bind('<Alt+Shift+h>', 'rl-backward-word', mode='command')
# config.bind('<Alt+k>', 'completion-item-focus prev', mode='command')
# config.bind('<Alt+j>', 'completion-item-focus next', mode='command')

config.bind("<Ctrl+b>", "rl-beginning-of-line", mode="prompt")
config.bind("<Ctrl+d>", "rl-delete-char", mode="prompt")
config.bind("<Ctrl+e>", "rl-end-of-line", mode="prompt")

config.bind("gm", "tab-give")

config.bind("<Alt+p>", "tab-pin")
# userscripts
config.bind("gs", "spawn --userscript selection.sh")
# config.bind("b", "spawn --userscript bm_list")
# config.bind("B", "spawn --userscript bm_add")
# config.bind(",B", "spawn bm delete {url}")
# config.bind("ap", "spawn --userscript qutepocket")

config.bind(",R", "spawn --userscript readability")

config.unbind("gf")
config.bind("gS", "view-source")

config.bind("gh", "home")
config.bind("gH", "history")
config.bind(",ce", "config-edit")
config.bind("cd", "download-clear")
config.bind("cD", "download-cancel")
config.bind("cm", "clear-messages")

config.bind("<Ctrl+Shift+o>", "download-open")
config.bind("<Ctrl+Shift+r>", "restart")
# config.bind("<Ctrl+b>", "bookmark-list")
# config.bind("<Ctrl+Shift+b>", "bookmark-del")
config.bind("D", "hint images download")
config.bind("<Ctrl+Shift+i>", "config-cycle colors.webpage.darkmode.enabled ;; restart")
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("<Alt+j>", "tab-move -")
config.bind("<Alt+k>", "tab-move +")

config.bind("ya", "hint links yank")
config.bind("yA", "hint -r links yank")
config.bind("cf", "hint -r links")
config.bind(",p", "config-cycle -p content.plugins ;; reload")
config.bind(",rta", "open {url}top/?sort=top&t=all")
config.bind(",rtv", 'spawn st -e "rtv {url}"')
config.bind(",b", "spawn -d firefox {url}")
config.bind(",m", "hint links spawn mpv $1 {hint-url}")
config.bind(",M", "spawn -d mpv {url}")
config.bind(",a", "hint links spawn -d mpv --profile=pseudo-gui --loop=inf {hint-url}")
config.bind(",A", "spawn -d mpv  --profile=pseudo-gui --loop=inf {url}")
config.bind("Q", "spawn --userscript qr")

config.bind(",d", "hint links spawn yt-menu {hint-url}")

c.aliases["pr"] = "print --pdf "

config.set("fonts.default_family", "mono")
config.set("fonts.default_size", "15pt")
# config.set('fonts.contextmenu', 'bold default_size default_family')
# config.set('fonts.statusbar', 'bold default_size default_family')
# config.set('fonts.completion.entry', 'bold default_size default_family')
# config.set('fonts.contextmenu', 'bold default_size default_family')
config.set("fonts.hints", "bold 14pt default_family")
# config.set('fonts.prompts', 'bold default_size default_family')
# config.set('fonts.tabs.selected', 'bold default_size default_family')
# config.set('fonts.tabs.unselected', 'bold default_size default_family')
# config.set('fonts.downloads', 'bold default_size default_family')
# # config.set ('fonts.web.family.fixed', 'Sans')
# config.set('fonts.web.family.sans_serif', 'Sans')
# config.set('fonts.web.family.serif', 'Serif')

# config.source('gruvbox.py')


# search current selection
config.bind(",g", "spawn --userscript qute_search -g")
