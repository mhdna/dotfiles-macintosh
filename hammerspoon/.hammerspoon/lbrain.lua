-- LBrain: a second brain. Capture words, phrases, info, news and journal lines in one keystroke; they
-- go to lbrain-server (leevant.com/lbrain, also fed by the phone), and this Mac puts each in the
-- Obsidian vault and, for what's worth memorizing, in Anki through AnkiConnect.
--
--   ctrl+cmd+b   add a word, phrase or info (Claude fills the back; you can edit it)
--   ctrl+cmd+n   add a news line to today's heading in Events And News
--   ctrl+cmd+j   add a line to today's journal (cmd+⏎ opens today's note instead)
--
-- Also the 🧠 menu-bar item. Config: ~/.config/lbrain/config.json {server, token, vault}.
-- Captures made while the server is out of reach wait in ~/.local/share/lbrain/outbox.json.
-- Vault and card formats live in lbrain_vault.lua (tested by tests/lbrain_vault_test.lua).

local V = require("lbrain_vault")

local HOME = os.getenv("HOME")
local CONFIG = HOME .. "/.config/lbrain/config.json"
local OUTBOX = HOME .. "/.local/share/lbrain/outbox.json"
local ANKI = "http://127.0.0.1:8765"
local SYNC_EVERY = 60

local M = {}
local cfg
local menu
local pending = 0
local lastSync = "not synced yet"
local syncing = false

-- ---------------------------------------------------------------- config

local function loadConfig()
	local c = hs.json.read(CONFIG)
	if not c then
		os.execute(string.format("mkdir -p %q", HOME .. "/.config/lbrain"))
		hs.json.write({ server = "https://leevant.com/lbrain", token = "", vault = HOME .. "/personal/notes" }, CONFIG, true, true)
		hs.alert.show("LBrain: put the device token in ~/.config/lbrain/config.json", 4)
		return nil
	end
	c.server = (c.server or ""):gsub("/+$", "")
	c.vault = c.vault or (HOME .. "/personal/notes")
	if (c.token or "") == "" then
		hs.alert.show("LBrain: the token in ~/.config/lbrain/config.json is empty", 4)
		return nil
	end
	return c
end

-- ---------------------------------------------------------------- server

local function request(method, path, body, callback)
	local headers = { Authorization = "Bearer " .. cfg.token, ["Content-Type"] = "application/json" }
	hs.http.doAsyncRequest(cfg.server .. path, method, body and hs.json.encode(body) or nil, headers, function(status, text)
		local data = nil
		if text and text ~= "" then
			local ok, decoded = pcall(hs.json.decode, text)
			if ok then data = decoded end
		end
		callback(status, data, text)
	end)
end

local function newId() return (hs.host.uuid():gsub("-", ""):lower()) end

-- ---------------------------------------------------------------- outbox

local function readOutbox() return hs.json.read(OUTBOX) or {} end

local function writeOutbox(list)
	os.execute(string.format("mkdir -p %q", HOME .. "/.local/share/lbrain"))
	hs.json.write(list, OUTBOX, true, true)
end

local function queue(item)
	local list = readOutbox()
	list[#list + 1] = item
	writeOutbox(list)
end

-- ---------------------------------------------------------------- applying an item to the vault and Anki

local function epochOf(iso)
	local y, mo, d, h, mi, s = tostring(iso):match("^(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
	if not y then return os.time() end
	local utcAsLocal = os.time({ year = y, month = mo, day = d, hour = h, min = mi, sec = s })
	local now = os.time()
	return utcAsLocal + (os.time(os.date("*t", now)) - os.time(os.date("!*t", now)))
end

local function ankiCall(action, params, callback)
	local body = hs.json.encode({ action = action, version = 6, params = params })
	hs.http.doAsyncRequest(ANKI, "POST", body, { ["Content-Type"] = "application/json" }, function(status, text)
		if status ~= 200 then return callback(nil, "Anki is not answering (is AnkiConnect installed?)") end
		local ok, reply = pcall(hs.json.decode, text)
		if not ok or type(reply) ~= "table" then return callback(nil, "unreadable reply from Anki") end
		if reply.error and reply.error ~= hs.json.null then return callback(nil, tostring(reply.error)) end
		callback(reply.result)
	end)
end

local function startAnki()
	if not hs.application.get("Anki") then
		hs.task.new("/usr/bin/open", nil, { "-g", "-j", "-a", "Anki" }):start()
	end
end

-- Fetch a kept recording into the vault; calls back with its file name (or nil) and the bytes.
local function fetchAudio(item, callback)
	if not item.audio then return callback(nil, nil) end
	hs.http.doAsyncRequest(cfg.server .. "/v1/audio/" .. item.id, "GET", nil, { Authorization = "Bearer " .. cfg.token }, function(status, bytes)
		if status ~= 200 or not bytes then return callback(false) end
		local name = item.id .. ".m4a"
		local ok = V.write(cfg.vault .. "/LBrain/audio/" .. name, bytes)
		callback(ok and name or false, bytes)
	end)
end

-- done(true) when everything for this item is in place; done(false, why) leaves it waiting.
local function apply(item, done)
	local at = epochOf(item.createdAt)
	local date, time = os.date("%Y-%m-%d", at), os.date("%H:%M", at)
	local dest = V.destination(item)

	local function toVault(audioName)
		local ok, err
		if dest == "card" then
			ok, err = V.appendCard(cfg.vault, item, date, audioName)
		elseif dest == "news" then
			ok, err = V.appendNews(cfg.vault, date, item.text .. (audioName and (" ![[" .. audioName .. "]]") or ""))
		elseif dest == "journal" then
			ok, err = V.appendJournal(cfg.vault, date, time, item.text .. (audioName and (" ![[" .. audioName .. "]]") or ""))
		else
			ok, err = V.appendInbox(cfg.vault, item, date, time, audioName)
		end
		done(ok and true or false, err)
	end

	fetchAudio(item, function(audioName, bytes)
		if audioName == false then return done(false, "could not fetch the recording") end
		if dest == "card" and item.memorize then
			local note = V.ankiNote(item, audioName)
			local function add()
				ankiCall("createDeck", { deck = note.deckName }, function()
				ankiCall("addNote", { note = note }, function(_, err)
					if err and not err:lower():find("duplicate") then
						startAnki()
						return done(false, err)
					end
					toVault(audioName)
				end)
				end)
			end
			if audioName then
				ankiCall("storeMediaFile", { filename = audioName, data = hs.base64.encode(bytes) }, function(_, err)
					if err then
						startAnki()
						return done(false, err)
					end
					add()
				end)
			else
				add()
			end
		else
			toVault(audioName)
		end
	end)
end

-- ---------------------------------------------------------------- sync

local function refreshMenu()
	if not menu then return end
	menu:setTitle(pending > 0 and ("🧠 " .. pending) or "🧠")
end

local function applyAll(items, index, failed, finish)
	local item = items[index]
	if not item then return finish(failed) end
	apply(item, function(ok, err)
		if not ok then
			failed = failed + 1
			lastSync = "waiting: " .. tostring(err)
			return applyAll(items, index + 1, failed, finish)
		end
		request("POST", "/v1/items/" .. item.id .. "/applied", nil, function(status)
			if status ~= 200 then failed = failed + 1 end
			applyAll(items, index + 1, failed, finish)
		end)
	end)
end

local function flushOutbox(callback)
	local list = readOutbox()
	if #list == 0 then return callback(true) end
	local keep = {}
	local function step(i)
		local item = list[i]
		if not item then
			writeOutbox(keep)
			return callback(#keep == 0)
		end
		request("POST", "/v1/items", item, function(status)
			if status ~= 200 and status ~= 201 then
				if status == 400 then
					-- the server will never take this one; don't let it block the rest
					hs.printf("lbrain: dropping an item the server refused: %s", hs.json.encode(item))
				else
					keep[#keep + 1] = item
				end
			end
			step(i + 1)
		end)
	end
	step(1)
end

function M.sync()
	if not cfg or syncing then return end
	syncing = true
	flushOutbox(function()
		request("GET", "/v1/items?pending=1", nil, function(status, items)
			if status ~= 200 or type(items) ~= "table" then
				syncing = false
				pending = #readOutbox()
				lastSync = "server unreachable (" .. tostring(status) .. ")"
				return refreshMenu()
			end
			applyAll(items, 1, 0, function(failed)
				syncing = false
				pending = failed + #readOutbox()
				if failed == 0 then lastSync = "synced " .. os.date("%H:%M") end
				refreshMenu()
			end)
		end)
	end)
end

-- Send one captured item: to the server, or to the outbox when it can't be reached, then sync.
local function submit(item)
	item.id = item.id or newId()
	request("POST", "/v1/items", item, function(status)
		if status ~= 200 and status ~= 201 then
			queue(item)
			hs.alert.show("LBrain: server unreachable, saved to send later", 2)
		else
			hs.alert.show("LBrain: saved", 0.7)
		end
		M.sync()
	end)
end

-- ---------------------------------------------------------------- the capture panel

local PAGE = [=[
<!doctype html><meta charset="utf-8">
<style>
  :root { color-scheme: dark; }
  body { margin: 0; padding: 16px 18px; background: #2e2925; color: #e8dfd3; font: 15px -apple-system, "SF Pro Text", sans-serif; }
  .chips { display: flex; gap: 6px; margin-bottom: 10px; flex-wrap: wrap; }
  .chip { padding: 4px 10px; border-radius: 12px; border: 1px solid #786a5c; cursor: pointer; user-select: none; font-size: 13px; }
  .chip.on { background: #d97757; border-color: #d97757; color: #fff; }
  textarea, input { width: 100%; box-sizing: border-box; background: #3a342f; color: inherit; border: 1px solid #786a5c; border-radius: 8px; padding: 8px 10px; font: inherit; margin-bottom: 8px; outline: none; }
  textarea:focus, input:focus { border-color: #d97757; }
  textarea { resize: none; }
  label { font-size: 12px; opacity: .65; display: block; margin: 2px 0 3px; }
  .row { display: flex; gap: 10px; align-items: center; }
  .row input[type=text] { flex: 1; }
  .hint { font-size: 12px; opacity: .55; margin-top: 4px; }
  #status { color: #f0c049; font-size: 12px; min-height: 16px; }
  .hide { display: none; }
</style>
<div id="chips" class="chips"></div>
<textarea id="text" rows="__ROWS__" dir="auto" placeholder="__PLACEHOLDER__" autofocus></textarea>
<div id="card" class="__CARDCLASS__">
  <label>Back (meaning, translation) <span id="status"></span></label>
  <textarea id="back" rows="3" dir="auto"></textarea>
  <label>Example</label>
  <input id="example" type="text" dir="auto">
  <div class="row">
    <input id="topic" type="text" placeholder="topic (info: history, go…)">
    <label style="margin:0;white-space:nowrap"><input id="memorize" type="checkbox" style="width:auto;margin:0 4px 0 0"> make a card</label>
  </div>
</div>
<div class="hint">__HINT__</div>
<script>
const MODE = "__MODE__";
const KINDS = [["en_word","EN word"],["en_phrase","EN phrase"],["ar_word","AR word"],["ar_phrase","AR phrase"],["info","Info"]];
let kind = "en_word", seq = 0, timer = null, backEdited = false;
const $ = id => document.getElementById(id);
const post = m => window.webkit.messageHandlers.lbrain.postMessage(m);

function drawChips() {
  if (MODE !== "card") return;
  $("chips").innerHTML = "";
  KINDS.forEach(([k, label], i) => {
    const c = document.createElement("div");
    c.className = "chip" + (k === kind ? " on" : "");
    c.textContent = (i + 1) + " " + label;
    c.onclick = () => setKind(k);
    $("chips").appendChild(c);
  });
}
function setKind(k) {
  kind = k;
  $("memorize").checked = k !== "info";
  drawChips();
  ask();
}
function ask() {
  if (MODE !== "card") return;
  clearTimeout(timer);
  const text = $("text").value.trim();
  if (!text) { $("status").textContent = ""; return; }
  timer = setTimeout(() => {
    seq++;
    $("status").textContent = "· asking Claude…";
    post({ type: "enrich", kind, text, seq });
  }, 700);
}
window.enriched = (n, e, error) => {
  if (n !== seq) return;
  if (error) { $("status").textContent = "· " + error; return; }
  $("status").textContent = "";
  if (e.kind && e.kind !== kind && !backEdited) { kind = e.kind; $("memorize").checked = kind !== "info"; drawChips(); }
  if (!backEdited) $("back").value = e.back || "";
  if (!$("example").value) $("example").value = e.example || "";
  if (!$("topic").value) $("topic").value = e.topic || "";
};
function save() {
  const text = $("text").value.trim();
  if (!text) return;
  if (MODE === "card") {
    post({ type: "save", kind, text, back: $("back").value.trim(), example: $("example").value.trim(),
           topic: $("topic").value.trim(), memorize: $("memorize").checked });
  } else {
    post({ type: "save", text });
  }
}
$("text").addEventListener("input", () => { ask(); });
if (MODE === "card") {
  $("back").addEventListener("input", () => { backEdited = true; });
  $("memorize").checked = true;
}
document.addEventListener("keydown", e => {
  if (e.key === "Escape") { e.preventDefault(); post({ type: "close" }); return; }
  if (e.key === "Enter" && (e.metaKey || e.ctrlKey) && MODE === "journal") { e.preventDefault(); post({ type: "open" }); return; }
  if (e.key === "Enter" && !e.shiftKey && (e.target.id === "text" || e.target.tagName === "INPUT" || e.metaKey)) { e.preventDefault(); save(); return; }
  if (MODE === "card" && e.altKey && e.code.startsWith("Digit")) {
    const k = KINDS[parseInt(e.code.slice(5), 10) - 1];
    if (k) { e.preventDefault(); setKind(k[0]); }
  }
});
drawChips();
</script>
]=]

local panel, panelWindowMode

local function closePanel()
	if panel then
		panel:delete()
		panel = nil
	end
end

local function todayPath() return V.dayPath(cfg.vault, os.date("%Y-%m-%d")) end

local function openTodayInObsidian()
	local date = os.date("%Y-%m-%d")
	local path = V.ensureDay(cfg.vault, date, os.date("%H:%M"))
	if not path then return hs.alert.show("LBrain: could not make today's note", 2) end
	hs.urlevent.openURL("obsidian://open?vault=" .. hs.http.encodeForQuery(cfg.vault:match("([^/]+)$")) .. "&file=" .. hs.http.encodeForQuery("Journal/Days/" .. date))
end

local function openPanel(mode)
	if not cfg then cfg = loadConfig() end
	if not cfg then return end
	closePanel()
	local card = mode == "card"
	local page = PAGE:gsub("__MODE__", mode)
		:gsub("__ROWS__", card and "2" or "5")
		:gsub("__CARDCLASS__", card and "" or "hide")
		:gsub("__PLACEHOLDER__", card and "a word, a phrase or something you learned" or (mode == "news" and "news for today" or "journal"))
		:gsub("__HINT__", card and "⏎ save · ⎋ cancel · ⌥1–5 kind · ⇧⏎ new line" or (mode == "journal" and "⏎ save · ⌘⏎ open today's note · ⎋ cancel" or "⏎ save · ⎋ cancel · ⇧⏎ new line"))

	local uc = hs.webview.usercontent.new("lbrain")
	uc:setCallback(function(msg)
		local body = msg.body
		if body.type == "close" then
			closePanel()
		elseif body.type == "open" then
			closePanel()
			openTodayInObsidian()
		elseif body.type == "enrich" then
			request("POST", "/v1/enrich", { kind = body.kind, text = body.text }, function(status, data, text)
				if not panel then return end
				local js
				if status == 200 and data then
					js = string.format("enriched(%d, %s)", body.seq, hs.json.encode(data))
				else
					local why = (data and data.error) or ("error " .. tostring(status))
					js = string.format("enriched(%d, null, %s)", body.seq, hs.json.encode({ why }):sub(2, -2))
				end
				panel:evaluateJavaScript(js)
			end)
		elseif body.type == "save" then
			closePanel()
			if mode == "card" then
				submit({ kind = body.kind, text = body.text, back = body.back, example = body.example, topic = body.topic, memorize = body.memorize })
			else
				submit({ kind = mode, text = body.text, memorize = false })
			end
		end
	end)

	local screen = hs.screen.mainScreen():frame()
	local w, h = 560, card and 360 or 230
	panel = hs.webview.new({ x = screen.x + (screen.w - w) / 2, y = screen.y + screen.h * 0.22, w = w, h = h }, {}, uc)
	panel:windowStyle({ "titled", "closable", "utility" })
		:windowTitle(card and "LBrain" or (mode == "news" and "LBrain · news" or "LBrain · journal"))
		:level(hs.drawing.windowLevels.floating)
		:allowTextEntry(true)
		:html(page)
		:show()
		:bringToFront(true)
	local win = panel:hswindow()
	if win then win:focus() end
	panelWindowMode = mode
end

-- ---------------------------------------------------------------- menu bar and hotkeys

local function buildMenu()
	return {
		{ title = "Add word / phrase / info", fn = function() openPanel("card") end },
		{ title = "Add news", fn = function() openPanel("news") end },
		{ title = "Add to journal", fn = function() openPanel("journal") end },
		{ title = "-" },
		{ title = "Open today's journal", fn = function()
			if not cfg then cfg = loadConfig() end
			if cfg then openTodayInObsidian() end
		end },
		{ title = "Open news", fn = function()
			if not cfg then cfg = loadConfig() end
			if cfg then hs.urlevent.openURL("obsidian://open?vault=" .. hs.http.encodeForQuery(cfg.vault:match("([^/]+)$")) .. "&file=" .. hs.http.encodeForQuery("Journal/Events And News")) end
		end },
		{ title = "-" },
		{ title = "Sync now", fn = function() M.sync() end },
		{ title = lastSync, disabled = true },
	}
end

cfg = loadConfig()
menu = hs.menubar.new()
if menu then
	menu:setTitle("🧠")
	menu:setMenu(buildMenu)
end

hs.hotkey.bind({ "ctrl", "cmd" }, "b", function() openPanel("card") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "n", function() openPanel("news") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "j", function() openPanel("journal") end)

M.timer = hs.timer.doEvery(SYNC_EVERY, M.sync)
hs.timer.doAfter(3, M.sync)

return M
