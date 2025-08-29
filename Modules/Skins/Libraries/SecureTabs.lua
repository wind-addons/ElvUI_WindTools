local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local type = type
local select = select
local pairs = pairs
local tInsertUnique = tInsertUnique

function S:ReskinSecureTabs(lib, panel)
	if lib.tabs[panel] then
		for _, tab in pairs(lib.tabs[panel]) do
			if not tab.__wind then
				self:Proxy("HandleTab", tab)
			end
		end
	end

	if lib.covers[panel] then
		for _, cover in pairs(lib.covers[panel]) do
			if not cover.__wind then
				self:Proxy("HandleTab", cover)
			end
		end
	end
end

function S:SecureTabs(lib)
	if lib.Add and lib.Update then
		E:Delay(2, print, 1)
		self:SecureHook(lib, "Add", "ReskinSecureTabs")
		self:SecureHook(lib, "Update", "ReskinSecureTabs")
	end

	local existingPanel = {}
	for panel in pairs(lib.tabs) do
		tInsertUnique(existingPanel, panel)
	end
	for panel in pairs(lib.covers) do
		tInsertUnique(existingPanel, panel)
	end

	for _, panel in pairs(existingPanel) do
		self:ReskinSecureTabs(lib, panel)
	end
end

S:AddCallbackForLibrary("SecureTabs-2.0", "SecureTabs")
