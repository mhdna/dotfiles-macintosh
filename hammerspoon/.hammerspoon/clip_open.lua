-- opt+shift+o: open whatever is in the clipboard.
--
--   a link (https://…, mailto:, obsidian://, any scheme)  → opens it
--   a bare domain (github.com/x)                          → opens https://…
--   a file or folder path (/…, ~/…)                       → opens it in its app / Finder
--   a file copied in Finder                               → opens that file
--   any other text                                        → searches Google for it

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function openWith(target)
	hs.task.new("/usr/bin/open", nil, { target }):start()
end

local function openClipboard()
	local text = hs.pasteboard.getContents()

	if not text or trim(text) == "" then
		-- No text: maybe a file was copied in Finder.
		local url = hs.pasteboard.readURL()
		if url and url.url then
			hs.urlevent.openURL(url.url)
		else
			hs.alert.show("Clipboard is empty")
		end
		return
	end

	text = trim(text)

	-- A link with a scheme: https://, mailto:, obsidian://, file://, …
	if text:match("^%a[%w+.-]*://%S+$") or text:match("^mailto:%S+$") then
		hs.urlevent.openURL(text)
		return
	end

	-- A path on disk.
	if text:match("^[/~]") and not text:find("\n") then
		local path = text:gsub("^~", os.getenv("HOME"))
		if hs.fs.attributes(path) then
			openWith(path)
		else
			hs.alert.show("No such file: " .. text)
		end
		return
	end

	-- A bare domain, with or without a path: example.com, github.com/user/repo
	if not text:find("%s") and text:match("^[%w-]+%.[%w.-]*%a%a+[/:?#]?") then
		hs.urlevent.openURL("https://" .. text)
		return
	end

	-- Anything else: search for it.
	hs.urlevent.openURL("https://www.google.com/search?q=" .. hs.http.encodeForQuery(text))
end

hs.hotkey.bind({ "alt", "shift" }, "o", openClipboard)
