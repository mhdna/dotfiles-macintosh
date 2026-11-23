-- Interface language for the on-screen text Hammerspoon shows (alerts, pickers,
-- menus, the opt+/ help). It follows the macOS language list: when the first
-- preferred language is French the French strings below are used, otherwise
-- the English text in the code is shown as written. Strings missing from the
-- French table fall back to English, so adding a new string never breaks.
--
-- Use it like this:  require("i18n").t("Loading…")
-- or with printf-style arguments:  t("%s left", fmt(secs))

local M = {}

local function systemIsFrench()
	local ok, langs = pcall(function() return hs.host.locale.preferredLanguages() end)
	local first = ok and type(langs) == "table" and langs[1] or ""
	return type(first) == "string" and first:match("^fr") ~= nil
end

M.french = systemIsFrench()

local FR = {
	-- media (opt+shift+… / cmd+shift+\ now playing picker)
	["Now playing..."] = "Lecture en cours...",
	["Loading…"] = "Chargement…",
	["Nothing playing"] = "Rien en lecture",
	["▶ Playing — space to pause"] = "▶ En lecture, espace pour pause",
	["⏸ Paused — space to play"] = "⏸ En pause, espace pour lire",
	["▶ Playing — "] = "▶ En lecture : ",
	["⏸ Paused — "] = "⏸ En pause : ",
	[" — space to toggle"] = ", espace pour basculer",
	["Current"] = "Actuel",
	["Select INPUT (microphone)..."] = "Choisir l'entrée (micro)...",
	["Select OUTPUT (speakers / headphones)..."] = "Choisir la sortie (haut-parleurs / casque)...",

	-- kill_window, clip_open, script_launcher, quick_shell
	["Click a window to force kill (esc to cancel)"] = "Cliquez sur une fenêtre pour la forcer à quitter (échap pour annuler)",
	["Force killed: %s"] = "Forcée à quitter : %s",
	["Cancelled"] = "Annulé",
	["Today's report: image + PDF to drag, text copied"] = "Rapport du jour : image et PDF à glisser, texte copié",
	["Last 7 days: image + PDF to drag, text copied"] = "7 derniers jours : image et PDF à glisser, texte copié",
	["%s: ready"] = "%s : prêt",
	["%s failed:\n%s"] = "%s a échoué :\n%s",
	["(no output, exit %s)"] = "(aucune sortie, code %s)",
	["Run command..."] = "Lancer une commande...",

	-- quick_timer
	["Time's up: %s"] = "Temps écoulé : %s",
	["Time's up"] = "Temps écoulé",
	["%s timer"] = "minuteur de %s",
	["Cancel %s (%s left)"] = "Annuler %s (%s restant)",
	["New timer"] = "Nouveau minuteur",
	["Timer: "] = "Minuteur : ",
	["Timer: 5, 90s, 1h30, 2:30, 25m tea"] = "Minuteur : 5, 90s, 1h30, 2:30, 25m thé",
	["Type a time: 5, 90s, 1h30, 2:30, 25m tea"] = "Saisissez une durée : 5, 90s, 1h30, 2:30, 25m thé",
	["Start "] = "Démarrer ",
	["Cancel "] = "Annuler ",
	["ends at "] = "fin à ",
	[" left"] = " restant",
	["preset"] = "préréglage",

	-- mrec, mmix, mcam, always_on_top, finder_redirect, app_menu, file_search
	["● Recording"] = "● Enregistrement",
	["‖ Paused"] = "‖ En pause",
	["Mrec stopped"] = "Mrec arrêté",
	["Mrec isn't running"] = "Mrec n'est pas lancé",
	["Mrec save location"] = "Emplacement de l'enregistrement Mrec",
	["Saving to %s"] = "Enregistrement dans %s",
	["screen"] = "écran",
	["system audio"] = "son système",
	["mic"] = "micro",
	[" (muted)"] = " (coupé)",
	["nothing selected"] = "rien de sélectionné",
	["● Sharing audio"] = "● Partage audio",
	["Mmix stopped"] = "Mmix arrêté",
	["Mmix isn't running"] = "Mmix n'est pas lancé",
	["computer audio"] = "son de l'ordinateur",
	["computer volume"] = "volume de l'ordinateur",
	["mic volume"] = "volume du micro",
	["on"] = "activé",
	["muted"] = "coupé",
	[" (selected apps only)"] = " (applis choisies seulement)",
	[" (monitoring)"] = " (écoute)",
	["noise suppression on"] = "réduction du bruit activée",
	["Mcam zoom: "] = "Zoom Mcam : ",
	["Always on top failed: "] = "Échec de « toujours au premier plan » : ",
	["is yabai running?"] = "yabai est-il lancé ?",
	["Always on top: on"] = "Toujours au premier plan : activé",
	["Always on top: off"] = "Toujours au premier plan : désactivé",
	["Finder → lf-gui: on"] = "Finder → lf-gui : activé",
	["Finder → lf-gui: off (Finder works normally)"] = "Finder → lf-gui : désactivé (Finder fonctionne normalement)",
	["Open application..."] = "Ouvrir une application...",
	["Find files   (↩ open · ⌘↩ reveal · ⌥↩ copy path)"] = "Chercher des fichiers   (↩ ouvrir ; ⌘↩ afficher ; ⌥↩ copier le chemin)",

	-- keys_help overlay (opt+/)
	["Apps (press again to go back)"] = "Applications (rappuyer pour revenir)",
	["Launchers & menus"] = "Lanceurs et menus",
	["Windows & spaces"] = "Fenêtres et bureaux",
	["Media & system"] = "Médias et système",
	["Words (PopDefine)"] = "Mots (PopDefine)",
	["Obsidian time tracker"] = "Suivi du temps Obsidian",
	["Screen recorder (Mrec)"] = "Enregistreur d'écran (Mrec)",
	["Audio sharing (Mmix)"] = "Partage audio (Mmix)",
	["Virtual camera (Mcam)"] = "Caméra virtuelle (Mcam)",
	["Claude accounts (Mclaude)"] = "Comptes Claude (Mclaude)",
	["App time limits (Morganize)"] = "Limites de temps des applis (Morganize)",
	["Life wallpaper (Mlife)"] = "Fond d'écran de vie (Mlife)",
	["Second brain (LBrain)"] = "Second cerveau (LBrain)",
	["Hammerspoon & misc"] = "Hammerspoon et divers",
	["app launcher"] = "lanceur d'applications",
	["quick shell command"] = "commande shell rapide",
	["find files (recent first)"] = "chercher des fichiers (récents d'abord)",
	["emoji picker (ctrl+c inserts)"] = "sélecteur d'émojis (ctrl+c insère)",
	["quick timer (5, 90s, 1h30, 25m tea)"] = "minuteur rapide (5, 90s, 1h30, 25m thé)",
	["run a script"] = "lancer un script",
	["now playing (space toggles)"] = "en lecture (espace bascule)",
	["pick microphone"] = "choisir le micro",
	["pick speakers"] = "choisir les haut-parleurs",
	["this help"] = "cette aide",
	["move window"] = "déplacer la fenêtre",
	["resize window"] = "redimensionner la fenêtre",
	["stretch to full height"] = "étirer en hauteur",
	["stretch to full width"] = "étirer en largeur",
	["full screen"] = "plein écran",
	["next window of this app"] = "fenêtre suivante de cette appli",
	["cycle this app's windows"] = "parcourir les fenêtres de cette appli",
	["cycle back"] = "parcourir en arrière",
	["previous / next space"] = "bureau précédent / suivant",
	["keep window on top"] = "garder la fenêtre au premier plan",
	["kill an app: click its window"] = "forcer une appli à quitter : cliquer sur sa fenêtre",
	["volume down / up"] = "volume moins / plus",
	["brightness down / up"] = "luminosité moins / plus",
	["play / pause"] = "lecture / pause",
	["previous / next track"] = "piste précédente / suivante",
	["switch keyboard layout"] = "changer de disposition du clavier",
	["sleep"] = "veille",
	["define the selection"] = "définir la sélection",
	["live search"] = "recherche en direct",
	["saved words"] = "mots enregistrés",
	["add a word"] = "ajouter un mot",
	["start / stop"] = "démarrer / arrêter",
	["pick a card"] = "choisir une carte",
	["pause / resume"] = "pause / reprise",
	["finish card"] = "terminer la carte",
	["open its board"] = "ouvrir son tableau",
	["mute / unmute mic"] = "couper / réactiver le micro",
	["mute / unmute system audio"] = "couper / réactiver le son système",
	["record screen / audio only"] = "enregistrer l'écran ou le son seul",
	["next recording: mic on / off"] = "prochain enregistrement : micro activé / désactivé",
	["next recording: system audio on / off"] = "prochain enregistrement : son système activé / désactivé",
	["pick the save location"] = "choisir l'emplacement de sauvegarde",
	["show recorder status"] = "afficher l'état de l'enregistreur",
	["open the recorder window (vim keys)"] = "ouvrir la fenêtre de l'enregistreur (touches vim)",
	["open the Mmix window (vim keys)"] = "ouvrir la fenêtre Mmix (touches vim)",
	["play the vine boom"] = "jouer le vine boom",
	["play the Top 5 Meme 1 sound"] = "jouer le son Top 5 Meme 1",
	["play the Eddy Wally wow"] = "jouer le wow d'Eddy Wally",
	["play the anime wow"] = "jouer le wow anime",
	["play the sudden suspense sound"] = "jouer le son de suspense soudain",
	["pick a screen or window to share (vim keys)"] = "choisir un écran ou une fenêtre à partager (touches vim)",
	["zoom out / in"] = "zoom arrière / avant",
	["open the accounts window (vim keys)"] = "ouvrir la fenêtre des comptes (touches vim)",
	["switch to the next account"] = "passer au compte suivant",
	["open Morganize (vim keys)"] = "ouvrir Morganize (touches vim)",
	["redraw the wallpaper now"] = "redessiner le fond d'écran maintenant",
	["LBrain list: word, todo, journal, news, calendar (opens in Obsidian)"] = "liste LBrain : mot, tâche, journal, actualités, calendrier (s'ouvre dans Obsidian)",
	["show the desktop (again to bring windows back)"] = "afficher le bureau (encore pour revenir aux fenêtres)",
	["reload Hammerspoon"] = "recharger Hammerspoon",
	["open what's in the clipboard (link, path, or search)"] = "ouvrir le contenu du presse-papiers (lien, chemin ou recherche)",
	["Finder → LFGUI redirect on/off"] = "redirection Finder → LFGUI activée / désactivée",
	["Terminal at Finder's folder"] = "Terminal dans le dossier du Finder",
	["auto-press F+X on/off"] = "appui automatique F+X activé / désactivé",
	["Other"] = "Autres",
	["bring mpv windows forward"] = "amener les fenêtres mpv au premier plan",
	["no description yet"] = "pas encore de description",
	["Hammerspoon keys"] = "Raccourcis Hammerspoon",
	["esc / ⌥/ / click to close"] = "échap / ⌥/ / clic pour fermer",

	-- general alerts
	["configuration reloaded"] = "configuration rechargée",
	["stopped"] = "arrêté",
	["started"] = "démarré",
	["mpv isn't running"] = "mpv n'est pas lancé",
	["Clipboard is empty"] = "Le presse-papiers est vide",
	["No such file: %s"] = "Fichier introuvable : %s",
	["path copied"] = "chemin copié",
}

-- t("text") returns the French text when the system is French, else the text
-- itself. Extra arguments are applied with string.format.
function M.t(text, ...)
	local out = text
	if M.french and FR[text] then out = FR[text] end
	if select("#", ...) > 0 then return string.format(out, ...) end
	return out
end

return M
