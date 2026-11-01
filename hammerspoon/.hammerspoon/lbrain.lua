-- LBrain: a second brain. Capture words, phrases, info, news and journal lines in one keystroke; they
-- go to lbrain-server (leevant.com/lbrain, also fed by the phone), and this Mac puts each in the
-- Obsidian vault and, for what's worth memorizing, in Anki through AnkiConnect.
--
--   ctrl+cmd+j   a list of everything: add a word/phrase/info (the back is filled in for you),
--                a todo (→ Calendar/Inbox.md, Tasks-plugin format), a journal line (⌘⏎ opens today's
--                note instead), a news line, the calendar (opens Obsidian's drag-calendar view), open today's
--                journal or the news in Obsidian, sync now. Type to filter, ⏎ to pick.
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
	local headers = { Authorization = "Bearer " .. cfg.token, ["Content-Type"] = "application/json", ["Cache-Control"] = "no-cache" }
	-- never from the URL cache: an answer from before the server's route existed (the shop's page) stuck around
	hs.http.doAsyncRequest(cfg.server .. path, method, body and hs.json.encode(body) or nil, headers, function(status, text)
		local data = nil
		if text and text ~= "" then
			local ok, decoded = pcall(hs.json.decode, text)
			if ok then data = decoded end
		end
		callback(status, data, text)
	end, "reloadIgnoringLocalCacheData")
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
	hs.http.doAsyncRequest(cfg.server .. "/v1/audio/" .. item.id, "GET", nil, { Authorization = "Bearer " .. cfg.token, ["Cache-Control"] = "no-cache" }, function(status, bytes)
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
		elseif dest == "todo" then
			ok, err = V.appendTodo(cfg.vault, item)
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
			local function fail(err)
				startAnki()
				done(false, err)
			end
			local function addNote()
				ankiCall("addNote", { note = note }, function(_, err)
					if err and not err:lower():find("duplicate") then return fail(err) end
					toVault(audioName)
				end)
			end
			-- a single card (just the text) needs its one-field note type; make it the first time
			local function ensureModel(next)
				if not item.single then return next() end
				ankiCall("modelNames", {}, function(names, err)
					if err then return fail(err) end
					for _, name in ipairs(names or {}) do
						if name == note.modelName then return next() end
					end
					ankiCall("createModel", V.SINGLE_MODEL, function(_, err2)
						if err2 then return fail(err2) end
						next()
					end)
				end)
			end
			local function add()
				ankiCall("createDeck", { deck = note.deckName }, function()
					ensureModel(addNote)
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

-- ---------------------------------------------------------------- the calendar

local DRAG_CALENDAR = "/.obsidian/plugins/drag-calendar/data.json"

-- Events from the drag-calendar plugin plus every open dated todo in the vault, around month `ym`.
local function calendarData(ym)
	local data = hs.json.read(cfg.vault .. DRAG_CALENDAR) or {}
	local snap = V.snapshot(data.events or {}, V.scanTasks(cfg.vault), ym)
	snap.weekStart = (data.settings or {}).weekStart == 0 and 0 or 1
	return snap
end

-- The phone can't read the vault, so the Mac sends it the month.
local function pushCalendar()
	if not cfg then return end
	local ok, snap = pcall(calendarData, os.date("%Y-%m"))
	if ok then request("PUT", "/v1/calendar", snap, function() end) end
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
				pushCalendar()
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
  body { margin: 0; padding: 16px 18px; background: #2b2c2e; color: #e4e4e6; font: 15px -apple-system, "SF Pro Text", sans-serif; border: 1px solid #56585c; border-radius: 12px; min-height: calc(100vh - 34px); }
  html { background: transparent; }
  .x { position: absolute; top: 8px; right: 10px; width: 26px; height: 26px; line-height: 26px; text-align: center; border-radius: 13px; cursor: pointer; opacity: .55; font-size: 14px; user-select: none; z-index: 10; }
  .x:hover { opacity: 1; background: #444649; }
  .chips { display: flex; gap: 6px; margin-bottom: 10px; flex-wrap: wrap; }
  .chip { padding: 4px 10px; border-radius: 12px; border: 1px solid #56585c; cursor: pointer; user-select: none; font-size: 13px; }
  .chip.on { background: #a1796a; border-color: #a1796a; color: #fff; }
  textarea, input { width: 100%; box-sizing: border-box; background: #353638; color: inherit; border: 1px solid #56585c; border-radius: 8px; padding: 8px 10px; font: inherit; margin-bottom: 8px; outline: none; }
  textarea:focus, input:focus { border-color: #a1796a; }
  textarea { resize: none; }
  label { font-size: 12px; opacity: .65; display: block; margin: 2px 0 3px; }
  .row { display: flex; gap: 10px; align-items: center; }
  .row input[type=text] { flex: 1; }
  .hint { font-size: 12px; opacity: .55; margin-top: 4px; }
  #status { color: #f0c049; font-size: 12px; min-height: 16px; }
  .hide { display: none; }
  .pick { border: 1px solid #56585c; border-radius: 10px; padding: 8px 10px; background: #353638; }
  .pickhead { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; font-size: 15px; }
  .arrow { cursor: pointer; padding: 0 14px; font-size: 22px; line-height: 22px; user-select: none; }
  #pickGrid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 3px; }
  #pickGrid div { text-align: center; padding: 9px 0; border-radius: 8px; cursor: pointer; font-size: 15px; }
  #pickGrid .dow { cursor: default; opacity: .5; font-size: 12px; padding: 3px 0; }
  #pickGrid .other { opacity: .35; }
  #pickGrid .today { box-shadow: inset 0 0 0 1.5px #a1796a; }
  #pickGrid .on { background: #a1796a; color: #fff; }
  #pickGrid div:not(.dow):hover { background: #444649; }
  #pickGrid .on:hover { background: #a1796a; }
</style>
<div class="x" onclick="post({ type: 'close' })">✕</div>
<div id="chips" class="chips"></div>
<div id="cats" class="chips"></div>
<textarea id="text" rows="__ROWS__" dir="auto" placeholder="__PLACEHOLDER__" autofocus></textarea>
<div id="card" class="__CARDCLASS__">
  <div id="backBlock">
  <label>Back (meaning, translation) <span id="status"></span></label>
  <textarea id="back" rows="3" dir="auto"></textarea>
  <label>Example</label>
  <input id="example" type="text" dir="auto">
  </div>
  <div class="row">
    <input id="topic" type="text" placeholder="topic (info: history, go…)">
    <label style="margin:0;white-space:nowrap"><input id="memorize" type="checkbox" style="width:auto;margin:0 4px 0 0"> make a card</label>
  </div>
  <div class="row" style="margin-top:2px">
    <label style="margin:0"><input id="single" type="checkbox" style="width:auto;margin:0 4px 0 0" onchange="onSingle()"> just the text, no front/back (a list or fact to read through)</label>
  </div>
</div>
<div id="todo" class="__TODOCLASS__">
  <div class="row" style="margin-bottom:8px">
    <label style="margin:0;white-space:nowrap">Due: <b id="dueLabel">none</b></label>
    <div class="chip" onclick="setDue(0)">Today</div>
    <div class="chip" onclick="setDue(1)">Tomorrow</div>
    <div class="chip" onclick="setDue(7)">+ week</div>
    <div class="chip" onclick="setDue(null)">None</div>
  </div>
  <div class="pick">
    <div class="pickhead"><span class="arrow" onclick="pickMonth(-1)">‹</span><b id="pickTitle"></b><span class="arrow" onclick="pickMonth(1)">›</span></div>
    <div id="pickGrid"></div>
  </div>
</div>
<div class="hint">__HINT__</div>
<script>
const MODE = "__MODE__";
const KINDS = [["en_word","EN word"],["en_phrase","EN phrase"],["ar_word","AR word"],["ar_phrase","AR phrase"],["info","Info"]];
const CATS = __CATS__;
let kind = "en_word", category = "__CATEGORY__", seq = 0, timer = null, backEdited = false;
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
function onSingle() {
  const on = $("single").checked;
  $("backBlock").style.display = on ? "none" : "";
  if (on) { $("text").rows = 6; $("status").textContent = ""; } else { $("text").rows = 2; ask(); }
}
function drawCats() {
  if (MODE !== "card") return;
  $("cats").innerHTML = "";
  if (kind === "info") return;
  CATS.forEach((c, i) => {
    const el = document.createElement("div");
    el.className = "chip" + (category === c.id ? " on" : "");
    el.textContent = (i + 6) + " " + c.label;
    el.onclick = () => setCategory(c.id);
    $("cats").appendChild(el);
  });
}
function setCategory(id) {
  category = category === id ? "" : id;
  const c = CATS.find(x => x.id === category);
  if (c && c.single && !$("single").checked) { $("single").checked = true; onSingle(); }
  drawCats();
}
function setKind(k) {
  kind = k;
  $("memorize").checked = k !== "info";
  drawChips();
  drawCats();
  ask();
}
function ask() {
  if (MODE !== "card" || $("single").checked) return;
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
  if (e.kind && e.kind !== kind && !backEdited) { kind = e.kind; $("memorize").checked = kind !== "info"; drawChips(); drawCats(); }
  if (!backEdited) $("back").value = e.back || "";
  if (!$("example").value) $("example").value = e.example || "";
  if (!$("topic").value) $("topic").value = e.topic || "";
};
let dueVal = "", pickYM = null;
const ymd = d => d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0");
function setDue(days) {
  if (days === null) dueVal = "";
  else { const d = new Date(Date.now() + days * 86400000); dueVal = ymd(d); pickYM = [d.getFullYear(), d.getMonth()]; }
  drawPicker();
}
function pickDay(s) { dueVal = dueVal === s ? "" : s; drawPicker(); }
function pickMonth(n) { const d = new Date(pickYM[0], pickYM[1] + n, 1); pickYM = [d.getFullYear(), d.getMonth()]; drawPicker(); }
function drawPicker() {
  if (MODE !== "todo") return;
  if (!pickYM) { const n = new Date(); pickYM = [n.getFullYear(), n.getMonth()]; }
  const [y, m] = pickYM, today = ymd(new Date());
  $("dueLabel").textContent = dueVal || "none";
  $("pickTitle").textContent = new Date(y, m, 1).toLocaleDateString(undefined, { month: "long", year: "numeric" });
  const lead = (new Date(y, m, 1).getDay() + 6) % 7; // Monday first
  let html = ["Mo","Tu","We","Th","Fr","Sa","Su"].map(n => '<div class="dow">' + n + "</div>").join("");
  for (let i = 0; i < 42; i++) {
    const d = new Date(y, m, 1 - lead + i), s = ymd(d);
    html += '<div class="' + (d.getMonth() !== m ? "other " : "") + (s === today ? "today " : "") + (s === dueVal ? "on" : "") + '" onclick="pickDay(\'' + s + '\')">' + d.getDate() + "</div>";
  }
  $("pickGrid").innerHTML = html;
}
function save() {
  const text = $("text").value.trim();
  if (!text) return;
  if (MODE === "todo") {
    post({ type: "save", text, due: dueVal });
  } else if (MODE === "card") {
    const single = $("single").checked;
    post({ type: "save", kind, text, back: single ? "" : $("back").value.trim(), example: single ? "" : $("example").value.trim(),
           topic: $("topic").value.trim(), memorize: $("memorize").checked, single, category: kind === "info" ? "" : category });
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
  if (MODE === "card" && (e.metaKey || e.altKey) && e.code.startsWith("Digit")) {
    const n = parseInt(e.code.slice(5), 10);
    const k = KINDS[n - 1];
    if (k) { e.preventDefault(); setKind(k[0]); }
    else if (n >= 6 && CATS[n - 6] && kind !== "info") { e.preventDefault(); setCategory(CATS[n - 6].id); }
  }
});
drawChips();
drawCats();
drawPicker();
if (category) { const c = CATS.find(x => x.id === category); if (c && c.single) { $("single").checked = true; onSingle(); } }
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

local function openPanel(mode, preset)
	if not cfg then cfg = loadConfig() end
	if not cfg then return end
	closePanel()
	local card = mode == "card"
	preset = preset or {}
	local cats = {}
	for _, c in ipairs(V.CATEGORIES) do cats[#cats + 1] = { id = c.id, label = c.label, single = c.single or false } end
	local catsJson = hs.json.encode(cats)
	local page = PAGE:gsub("__CATS__", function() return catsJson end)
		:gsub("__CATEGORY__", preset.category or "")
		:gsub("__MODE__", mode)
		:gsub("__ROWS__", card and "2" or "5")
		:gsub("__CARDCLASS__", card and "" or "hide")
		:gsub("__TODOCLASS__", mode == "todo" and "" or "hide")
		:gsub("__PLACEHOLDER__", card and "a word, a phrase or something you learned" or (mode == "news" and "news for today" or (mode == "todo" and "a todo" or "journal")))
		:gsub("__HINT__", card and "⏎ save · ⎋ cancel · ⌘1–5 kind · ⌘6–9 category · ⇧⏎ new line" or (mode == "journal" and "⏎ save · ⌘⏎ open today's note · ⎋ cancel" or "⏎ save · ⎋ cancel · ⇧⏎ new line"))

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
				submit({ kind = body.kind, text = body.text, back = body.back, example = body.example, topic = body.topic, memorize = body.memorize, single = body.single or nil, category = body.category ~= "" and body.category or nil })
			elseif mode == "todo" then
				submit({ kind = "todo", text = body.text, due = body.due ~= "" and body.due or nil, memorize = false })
			else
				submit({ kind = mode, text = body.text, memorize = false })
			end
		end
	end)

	local screen = hs.screen.mainScreen():frame()
	local w, h = 560, card and 420 or (mode == "todo" and 600 or 230)
	panel = hs.webview.new({ x = screen.x + (screen.w - w) / 2, y = screen.y + math.max(20, math.min(screen.h * 0.22, screen.h - h - 40)), w = w, h = h }, {}, uc)
	panel:windowStyle({ "borderless" })
		:transparent(true)
		:shadow(true)
		:windowTitle(card and "LBrain" or (mode == "news" and "LBrain · news" or (mode == "todo" and "LBrain · todo" or "LBrain · journal")))
		:level(hs.drawing.windowLevels.floating)
		:allowTextEntry(true)
		:html(page)
		:show()
		:bringToFront(true)
	local win = panel:hswindow()
	if win then win:focus() end
	panelWindowMode = mode
end

-- ---------------------------------------------------------------- the calendar

-- The calendar is the drag-calendar plugin's own view inside Obsidian: bring Obsidian forward and
-- press the plugin's "Open calendar" hotkey (ctrl+alt+C, its default).
local function openCalendar()
	local running = hs.application.get("Obsidian") ~= nil
	hs.application.launchOrFocus("Obsidian")
	hs.timer.doAfter(running and 0.4 or 4, function() hs.eventtap.keyStroke({ "ctrl", "alt" }, "c", 0) end)
end

-- ---------------------------------------------------------------- menu bar and hotkeys

local function buildMenu()
	return {
		{ title = "Add word / phrase / info", fn = function() openPanel("card") end },
		{ title = "Add news", fn = function() openPanel("news") end },
		{ title = "Add to journal", fn = function() openPanel("journal") end },
		{ title = "Add a todo", fn = function() openPanel("todo") end },
		{ title = "Calendar", fn = openCalendar },
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

-- One shortcut: ctrl+cmd+j opens a list; type to filter, ⏎ to pick.
local ACTIONS = {
	{ text = "Word, phrase or info", subText = "a card for Anki + the vault", fn = function() openPanel("card") end },
	{ text = "Use more", subText = "words/phrases to start using (no back)", fn = function() openPanel("card", { category = "use_more" }) end },
	{ text = "Funny", subText = "a funny word or phrase", fn = function() openPanel("card", { category = "funny" }) end },
	{ text = "Slang", subText = "slang or dialect", fn = function() openPanel("card", { category = "slang" }) end },
	{ text = "Idioms & proverbs", subText = "sayings", fn = function() openPanel("card", { category = "idiom" }) end },
	{ text = "Todo", subText = "with an optional due date", fn = function() openPanel("todo") end },
	{ text = "Journal", subText = "a line in today's note", fn = function() openPanel("journal") end },
	{ text = "News", subText = "a line under today's date", fn = function() openPanel("news") end },
	{ text = "Calendar", subText = "in Obsidian (drag-calendar)", fn = openCalendar },
	{ text = "Open today's journal", subText = "in Obsidian", fn = function()
		if not cfg then cfg = loadConfig() end
		if cfg then openTodayInObsidian() end
	end },
	{ text = "Open news", subText = "in Obsidian", fn = function()
		if not cfg then cfg = loadConfig() end
		if cfg then hs.urlevent.openURL("obsidian://open?vault=" .. hs.http.encodeForQuery(cfg.vault:match("([^/]+)$")) .. "&file=" .. hs.http.encodeForQuery("Journal/Events And News")) end
	end },
	{ text = "Sync now", subText = function() return lastSync end, fn = function() M.sync() end },
}

local chooser = hs.chooser.new(function(choice)
	if choice then
		-- after the chooser has closed, so the panel it opens gets the keyboard
		hs.timer.doAfter(0.05, ACTIONS[choice.index].fn)
	end
end)
chooser:placeholderText("LBrain")
chooser:rows(#ACTIONS)
chooser:searchSubText(true)

hs.hotkey.bind({ "ctrl", "cmd" }, "j", function()
	if chooser:isVisible() then return chooser:hide() end
	local choices = {}
	for i, a in ipairs(ACTIONS) do
		choices[i] = { text = a.text, subText = type(a.subText) == "function" and a.subText() or a.subText, index = i }
	end
	chooser:choices(choices)
	chooser:query("")
	chooser:show()
end)

M.timer = hs.timer.doEvery(SYNC_EVERY, M.sync)
hs.timer.doAfter(3, M.sync)

return M
