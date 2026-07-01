-- hs
-- 	.loadSpoon("AppWindowSwitcher")
-- 	:setLogLevel("debug") -- uncomment for console debug log
-- 	:bindHotkeys({
-- 		["com.apple.Terminal"] = { cmd, "t" },
-- 		[{
-- 			"com.apple.Safari",
-- 			"com.google.Chrome",
-- 			"com.kagi.kagimacOS",
-- 			"com.microsoft.edgemac",
-- 			"org.mozilla.firefox",
-- 		}] = { cmd, "q" },
-- 		["Hammerspoon"] = { cmd, "h" },
-- 		[{ "O", "o" }] = { cmd, "o" },
-- 	})
--
--
--
-- ---------------------------------------------------------
-- APP SWITCHER FUNCTIONS - DO NOT EDIT THIS!
-- SCROLL DOWN TO THE KEYBOARD SHORTCUTS SECTION
-- ---------------------------------------------------------

local function cycleApplicationWindows(appObject)
	local visibleWindows = appObject:visibleWindows()
	local trulyVisibleWindows = {}

	for _, win in ipairs(visibleWindows) do
		local meetsCriteria = true
		if not win:isVisible() then
			meetsCriteria = false
		end

		if win:subrole() ~= "AXStandardWindow" then
			meetsCriteria = false
		end

		if meetsCriteria then
			table.insert(trulyVisibleWindows, win)
		end
	end

	if #trulyVisibleWindows <= 1 then
		return
	end

	table.sort(trulyVisibleWindows, function(a, b)
		return a:id() < b:id()
	end)

	local currentWindow = appObject:focusedWindow()
	local found = false

	for i, win in ipairs(trulyVisibleWindows) do
		if win:id() > currentWindow:id() then
			win:focus()
			found = true
			break
		end
	end

	if not found then
		trulyVisibleWindows[1]:focus()
	end
end

local function activateOrLaunch(bundleID)
	local frontmostApp = hs.application.frontmostApplication()

	if frontmostApp and frontmostApp:bundleID() == bundleID then
		cycleApplicationWindows(frontmostApp)
	else
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

local previousApp = nil

local function activateOrToggle(bundleID)
	local frontmostApp = hs.application.frontmostApplication()

	if frontmostApp and frontmostApp:bundleID() == bundleID then
		if previousApp then
			previousApp:activate()
		end
	else
		previousApp = frontmostApp
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

-- hs.hotkey.bind({ "alt" }, "f", function()
-- 	activateOrToggle("com.apple.finder")
-- end)

hs.hotkey.bind({ "alt" }, "s", function()
	activateOrToggle("com.apple.systempreferences")
end)

hs.hotkey.bind({ "alt" }, "g", function()
	activateOrToggle("com.apple.QuickTimePlayerX")
end)

-- hs.hotkey.bind({ "alt" }, "w", function()
-- 	activateOrToggle("org.mozilla.firefox")
-- end)

hs.hotkey.bind({ "alt" }, "e", function()
	activateOrToggle("org.gnu.Emacs")
end)

hs.hotkey.bind({ "alt" }, "v", function()
	-- activateOrToggle("com.vscodium")
	-- activateOrToggle("com.neovide.neovide")
	-- activateOrToggle("org.alacritty")
	activateOrToggleKitty("/opt/homebrew/bin/tmux a", "custom-tmux-window")
end)

hs.hotkey.bind({ "alt" }, "n", function()
	activateOrToggle("md.obsidian")
end)

-- hs.hotkey.bind({ "alt" }, "v", function()
-- 	activateOrToggle("dev.zed.Zed")
-- end)

-- hs.hotkey.bind({ "alt", "cmd" }, "c", function()
-- 	activateOrToggle("org.hammerspoon.Hammerspoon")
-- end)

hs.hotkey.bind({ "alt", "shift" }, "v", function()
	activateOrToggle("com.obsproject.obs-studio")
end)

hs.hotkey.bind({ "alt", "shift" }, "d", function()
	activateOrToggle("com.hnc.Discord")
end)

hs.hotkey.bind({ "alt" }, "w", function()
	-- activateOrToggle("org.mozilla.firefox")
	activateOrToggle("com.brave.Browser")
end)

hs.hotkey.bind({ "alt" }, "p", function()
	activateOrToggle("com.microsoft.Powerpoint")
end)

-- Switch to Messages by pressing Option+Enter
-- hs.hotkey.bind({ "alt" }, "e", function()
-- 	activateOrToggle("org.gnu.Emacs")
-- end)

-- -- Switch to Messages by pressing Option+Enter
-- hs.hotkey.bind({ "alt" }, "t", function()
-- 	activateOrToggle("net.kovidgoyal.kitty")
-- 	-- activateOrToggle("com.github.wez.wezterm")
-- 	-- activateOrToggle("org.alacritty")
-- end)

-- com.apple.MobileSMS

-- Switch to Apple Mail by pressing Command+F2
hs.hotkey.bind({ "cmd" }, "F2", function()
	activateOrToggle("com.apple.mail")
end)

-- Switch to Passwords by pressing F3 without any modifiers
hs.hotkey.bind({}, "F3", function()
	activateOrToggle("com.apple.Passwords")
end)

-- print current window bundle id
hs.hotkey.bind({ "alt", "shift" }, "c", function()
	-- copy it from clipboard
	hs.pasteboard.setContents(hs.application.frontmostApplication():bundleID())
	hs.alert.show(hs.application.frontmostApplication():bundleID())
end)

local function openKittyWith(cmd, title)
	local full = string.format(
		[[nohup /opt/homebrew/bin/kitty --directory ~ --title "%s" zsh -c '%s' >/dev/null 2>&1 &]],
		title,
		cmd
	)
	hs.execute(full)
end

local function findKittyWindow(title)
	for _, w in ipairs(hs.window.allWindows()) do
		local app = w:application()
		if app and app:name() == "kitty" and w:title() == title then
			return w
		end
	end
	return nil
end

local previousWindow = nil

local function activateOrToggleKitty(cmd, title)
	local frontmost = hs.application.frontmostApplication()
	local frontWin = hs.window.focusedWindow()
	local kittyWin = findKittyWindow(title)

	if frontWin and frontWin:title() == title then
		-- already on this kitty window, toggle back
		if previousWindow then
			previousWindow:focus()
		end
	elseif kittyWin then
		-- window exists but not focused
		previousWindow = frontWin
		kittyWin:focus()
	else
		-- doesn't exist, spawn it
		previousWindow = frontWin
		openKittyWith(cmd, title)
		hs.timer.doAfter(0.2, function()
			local w = findKittyWindow(title)
			if w then
				w:focus()
			end
		end)
	end
end

hs.hotkey.bind({ "alt" }, "r", function()
	activateOrToggleKitty("source /Users/mahdi/.zshrc; /Users/mahdi/bin/lfrun /Users/mahdi", "custom-lf-window")
end)

hs.hotkey.bind({ "alt", "shift" }, "g", function()
	activateOrToggleKitty("/opt/homebrew/bin/htop", "custom-htop-window")
end)

hs.hotkey.bind({ "alt" }, "g", function()
	activateOrToggleKitty("zsh; source /Users/mahdi/.zshrc/", "custom-git-window")
end)

hs.hotkey.bind({ "alt" }, "t", function()
	activateOrToggleKitty("/opt/homebrew/bin/tmux a", "custom-tmux-window")
end)
hs.hotkey.bind({ "alt" }, "v", function()
	activateOrToggleKitty("/opt/homebrew/bin/tmux a", "custom-tmux-window")
end)

hs.hotkey.bind({ "alt", "shift" }, "n", function()
	activateOrToggleKitty("source /Users/mahdi/.zshrc; zsh", "custom-notes-window")
end)

hs.hotkey.bind({ "alt", "shift" }, "c", function()
	local pos = hs.mouse.absolutePosition()
	local text = string.format("%d,%d", math.floor(pos.x), math.floor(pos.y))

	hs.pasteboard.setContents(text)
	hs.alert.show("Copied: " .. text)
end)
