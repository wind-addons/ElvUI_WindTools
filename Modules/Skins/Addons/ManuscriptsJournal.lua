local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

local function reskinProgressBar(bar)
	if not bar then
		return
	end
	bar.border:Hide()
	bar:DisableDrawLayer("BACKGROUND")
	bar.text:Point("CENTER")
	bar:SetStatusBarTexture(E.media.normTex)
	bar:CreateBackdrop()
	bar:SetHeight(15)
end

local function reskinTabs(tabsFrame)
	for _, child in pairs({ tabsFrame:GetChildren() }) do
		for _, region in pairs({ child:GetRegions() }) do
			if region:IsShown() then
				region:SetTexCoord(unpack(E.TexCoords))
				region:SetInside()
			end
		end
		S:Proxy("HandleItemButton", child)
		S:CreateBackdropShadow(child)
	end
end

function S:ManuscriptsJournal()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.manuscriptsJournal then
		return
	end

	local frame = _G.ManuscriptsJournal
	if not frame or frame.__windSkin then
		return
	end

	reskinProgressBar(frame.progressBar)
	frame.progressBar:ClearAllPoints()
	frame.progressBar:Point("TOPLEFT", frame, "TOPLEFT", 5, -25)
	frame.progressBar:SetWidth(421)

	for i = 1, 7 do
		reskinProgressBar(frame["mount" .. i .. "Bar"])
	end

	if frame.mount1Bar then
		frame["mount1Bar"]:ClearAllPoints()
		frame["mount1Bar"]:Point("TOPLEFT", frame.progressBar, "BOTTOMLEFT", 0, -5)
	end

	frame.iconsFrame:StripTextures()
	frame:SetTemplate()
	self:Proxy("HandleEditBox", frame.SearchBox)
	frame.FilterButton:StripTextures()
	frame.FilterButton:Size(85, 20)
	self:Proxy("HandleButton", frame.FilterButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
	F.MoveFrameWithOffset(frame.FilterButton, 0, -1)

	local paging = frame.PagingFrame
	if paging then
		S:Proxy("HandleNextPrevButton", paging.PrevPageButton, nil, nil, true)
		S:Proxy("HandleNextPrevButton", paging.NextPageButton, nil, nil, true)
	end

	reskinTabs(_G.ManuscriptsSideTabsFrame)
end

S:AddCallbackForAddon("ManuscriptsJournal")
