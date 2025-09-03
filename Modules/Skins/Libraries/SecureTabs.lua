local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local pairs = pairs

local function reskinTab(lib, panel)
	if lib.tabs[panel] then
		for _, tab in pairs(lib.tabs[panel]) do
			F.WaitFor(function()
				return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
			end, function()
				if not E.private.WT.skins.libraries.secureTabs then
					return
				end

				if not tab.__windSkin then
					S:Proxy("HandleTab", tab)
					S:ReskinTab(tab)
					tab:Hide()
					tab:Show() -- Fix the text ... issue
					tab.__windSkin = true
				end
			end)
		end
	end
end

local function reskinCoverTab(lib, panel)
	local cover = lib.covers[panel]
	F.WaitFor(function()
		return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
	end, function()
		if not E.private.WT.skins.libraries.secureTabs then
			return
		end

		if cover and not cover.__windSkin then
			S:Proxy("HandleTab", cover)
			cover.backdrop.Center:SetAlpha(0)
			cover:SetPushedTextOffset(0, 0)
			cover.__windSkin = true
		end
	end)
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
