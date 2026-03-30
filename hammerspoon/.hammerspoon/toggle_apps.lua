function toggleApp(bundleID)
	local lastApp = nil
	local app = hs.application.get(bundleID)

	if app and app:isFrontmost() then
		if lastApp then
			lastApp:activate()
		end
	else
		lastApp = hs.application.frontmostApplication()
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

hs.hotkey.bind({ "alt" }, "a", function()
	toggleApp("net.whatsapp.WhatsApp")
end)

hs.hotkey.bind({ "alt" }, "c", function()
	toggleApp("com.apple.calculator")
end)
