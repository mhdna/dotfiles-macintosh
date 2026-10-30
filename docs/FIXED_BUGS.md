# Fixed bugs

Newest first.

## 2026-10-30: Moji's emojis never appeared in Alacritty

**Symptom:** picking emojis in Moji (ctrl+cmd+space) and pressing ctrl+c closed the picker,
but nothing was typed into the terminal.

**Cause:** `hammerspoon/.hammerspoon/moji.lua` typed the emojis with `hs.eventtap.keyStrokes`,
i.e. synthetic key events carrying a Unicode string. Alacritty drops those for non-ASCII text.

**Fix:** `moji.lua` now pastes instead: it saves the clipboard, sets the emojis (marked
`org.nspasteboard.TransientType` so clipboard managers skip them), sends cmd+v and puts the old
clipboard back half a second later. No automated tests; checked by hand in Alacritty.
