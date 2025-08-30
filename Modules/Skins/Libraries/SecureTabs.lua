local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, table, table
local S = W.Modules.Skins

local _G = _G
local type = type
local select = select
local pairs = pairs
local tInsertUnique = tInsertUnique

local function reskinTab(lib, panel)
	if lib.tabs[panel] then
		for _, tab in pairs(lib.tabs[panel]) do
			if not tab.__wind then
				S:Proxy("HandleTab", tab)
				S:ReskinTab(tab)
				tab:Hide()
				tab:Show() -- Fix the text ... issue
				tab.__wind = true
			end
		end
	end
end

local function reskinCoverTab(lib, panel)
	local cover = lib.covers[panel]
	if cover and not cover.__wind then
		S:Proxy("HandleTab", cover)
		cover.backdrop.Center:SetAlpha(0)
		cover:SetPushedTextOffset(0, 0)
		cover.__wind = true
	end
end

function S:SecureTabs(lib)
	if lib.Add and lib.Update then
		self:SecureHook(lib, "Add", reskinTab)
		self:SecureHook(lib, "Update", reskinCoverTab)
	end

	if lib.tabs then
		for panel in pairs(lib.tabs) do
			reskinTab(lib, panel)
		end
	end

	if lib.covers then
		for panel in pairs(lib.covers) do
			reskinCoverTab(lib, panel)
		end
	end
end

S:AddCallbackForLibrary("SecureTabs-2.0", "SecureTabs")
