-- Keep the OSC always visible in a window, auto-hide it in fullscreen.
local function update(_, fs)
    mp.commandv("script-message", "osc-visibility", fs and "auto" or "always", "no-osd")
end

mp.observe_property("fullscreen", "bool", update)
