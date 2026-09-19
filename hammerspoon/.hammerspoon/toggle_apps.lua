local lastApps = {}

function toggleApp(bundleID)
	local app = hs.application.get(bundleID)

	if app and app:isFrontmost() then
		local lastApp = lastApps[bundleID]
		if lastApp then
			lastApp:activate()
		end
	else
		lastApps[bundleID] = hs.application.frontmostApplication()
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end
