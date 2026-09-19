-- ctrl+space: a bare, borderless input box (no dropdown/list underneath).
-- Type a command, hit enter -> runs via zsh (aliases loaded), shows output
-- as a brief alert, box disappears immediately. Escape or losing focus
-- dismisses it without running anything.
local WIDTH = 480
local HEIGHT = 44

local HTML = [[
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
	html, body { margin: 0; padding: 0; background: transparent; }
	body {
		display: flex;
		align-items: center;
		height: 100vh;
		box-sizing: border-box;
	}
	input {
		width: 100%;
		height: 100%;
		box-sizing: border-box;
		border: none;
		outline: none;
		background: rgba(30, 30, 30, 0.92);
		color: #f0f0f0;
		font: 18px Menlo, monospace;
		padding: 0 14px;
		border-radius: 10px;
	}
	input::placeholder { color: #888; }
</style>
</head>
<body>
	<input id="cmd" type="text" placeholder="Run command..." autofocus spellcheck="false">
	<script>
		var input = document.getElementById("cmd");
		input.focus();

		input.addEventListener("keydown", function (e) {
			if (e.key === "Enter") {
				var value = input.value.trim();
				if (value.length > 0) {
					webkit.messageHandlers.quickShell.postMessage({ action: "run", cmd: value });
				}
			} else if (e.key === "Escape") {
				webkit.messageHandlers.quickShell.postMessage({ action: "cancel" });
			}
		});

		window.addEventListener("blur", function () {
			webkit.messageHandlers.quickShell.postMessage({ action: "cancel" });
		});
	</script>
</body>
</html>
]]

local function centeredFrame()
	local screen = hs.screen.mainScreen():frame()
	return {
		x = screen.x + (screen.w - WIDTH) / 2,
		y = screen.y + (screen.h - HEIGHT) / 2 - 100,
		w = WIDTH,
		h = HEIGHT,
	}
end

local ALERT_DURATION = 4
local escWatcher = nil

local function dismissOutputEarly()
	if escWatcher then
		escWatcher:stop()
		escWatcher = nil
	end
	hs.alert.closeAll(0)
end

local function showOutput(text)
	hs.alert.show(text, { textFont = "Menlo", radius = 8 }, hs.screen.mainScreen(), ALERT_DURATION)

	escWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if event:getKeyCode() == hs.keycodes.map["escape"] then
			dismissOutputEarly()
			return true
		end
		return false
	end)
	escWatcher:start()

	hs.timer.doAfter(ALERT_DURATION, function()
		if escWatcher then
			escWatcher:stop()
			escWatcher = nil
		end
	end)
end

local userContent = hs.webview.usercontent.new("quickShell")
local box = hs.webview.new(centeredFrame(), { developerExtrasEnabled = false }, userContent)
box:windowStyle("borderless")
box:allowTextEntry(true)
box:transparent(true)
box:level(hs.drawing.windowLevels.modalPanel)
box:closeOnEscape(true)
box:html(HTML)

userContent:setCallback(function(message)
	local body = message.body
	box:hide()

	if body.action == "run" then
		hs.task
			.new("/bin/zsh", function(exitCode, stdOut, stdErr)
				local output = (stdOut or "") .. (stdErr or "")
				output = output:gsub("%s+$", "")
				if output == "" then
					output = "(no output, exit " .. exitCode .. ")"
				end
				showOutput(output)
			end, { "-i", "-c", body.cmd })
			:start()
	end
end)

hs.hotkey.bind({ "ctrl" }, "space", function()
	box:frame(centeredFrame())
	box:show()
	box:bringToFront(true)

	local win = box:hswindow()
	if win then
		win:focus()
	end

	box:evaluateJavaScript([[document.getElementById("cmd").value = ""; document.getElementById("cmd").focus();]])
end)
