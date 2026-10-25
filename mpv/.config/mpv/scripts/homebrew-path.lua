-- mpv launched from Finder/Dock gets launchd's bare PATH, so scripts that
-- shell out (gallery-thumbgen runs ffmpeg/ffprobe) can't find Homebrew tools.
-- Prepend Homebrew's bin dirs to the process PATH so every subprocess sees them.
local ffi = require("ffi")
ffi.cdef("int setenv(const char *name, const char *value, int overwrite);")

local path = os.getenv("PATH") or "/usr/bin:/bin"
for _, dir in ipairs({ "/usr/local/bin", "/opt/homebrew/bin" }) do
    if not (":" .. path .. ":"):find(":" .. dir .. ":", 1, true) then
        path = dir .. ":" .. path
    end
end
ffi.C.setenv("PATH", path, 1)
