local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

local RunNextFrame = RunNextFrame
local C_Item_GetItemInfo = C_Item.GetItemInfo

local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS

local function reskinButton(_, button)
	if not button.IsSkinned then
		S:Proxy("HandleItemButton", button, true)

		hooksecurefunc(button.SwatchTexture, "SetVertexColor", function(_, r, g, b, a)
			button.backdrop:SetBackdropColor(r, g, b, (a or 1) * 0.7)
		end)

		hooksecurefunc(button.SwatchTexture, "Hide", function()
			local r, g, b = unpack(E.media.backdropcolor)
			button.backdrop:SetBackdropColor(r, g, b, 1)
		end)

		button.iconTextureUncollected:SetTexCoord(unpack(E.TexCoords))
		button.iconTextureUncollected:SetInside(button)
		button.iconTexture:SetDrawLayer("ARTWORK")
		button.hover:SetAllPoints(button.iconTexture)
		button.slotFrameCollected:SetAlpha(0)
		button.slotFrameUncollected:SetAlpha(0)

		button.IsSkinned = true
	end

	button.name:Point("LEFT", button, "RIGHT", 4, 8)

	local r, g, b = unpack(E.media.bordercolor)

	local collected = button.iconTexture:IsShown()
	local swatchCollected = button.SwatchTexture:IsShown() and button.SwatchTexture:GetAlpha() > 0.6

	if collected or swatchCollected then
		if button.layoutData.itemID then
			local itemQuality = select(3, C_Item_GetItemInfo(button.layoutData.itemID))
			local qualityColor = ITEM_QUALITY_COLORS[itemQuality or 1]
			r, g, b = qualityColor.r, qualityColor.g, qualityColor.b
		end
		button.name:SetTextColor(0.9, 0.9, 0.9)
	else
		button.name:SetTextColor(0.4, 0.4, 0.4)
	end

	button.backdrop:SetBackdropBorderColor(r, g, b)
end

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

local function onMJTabsHide()
	if _G.CollectionsJournal_GetTab(_G.CollectionsJournal) ~= 4 then
		return
	end
	if _G.HeirloomsJournal and not _G.HeirloomsJournal:IsShown() then
		_G.HeirloomsJournal:Show()
	end
end

local function onMJTabsShow()
	if _G.HeirloomsJournal and _G.HeirloomsJournal:IsShown() then
		_G.HeirloomsJournal:Hide()
	end
end

local function reskinJournal(frame)
	if not frame or frame.__windSkin then
		return
	end

	if frame.iconsFrame then
		frame.iconsFrame:StripTextures()
	end

	local progressBar = frame.progressBar
	if progressBar then
		reskinProgressBar(progressBar)
	end

	if frame.SearchBox then
		S:Proxy("HandleEditBox", frame.SearchBox)
	end

	local filter = frame.FilterButton
	if filter then
		filter:StripTextures()
		filter:Size(85, 20)
		S:Proxy("HandleButton", filter, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
		F.Move(filter, 0, -1)
		S:Proxy("HandleCloseButton", filter.ResetButton)
	end

	local paging = frame.PagingFrame
	if paging then
		S:Proxy("HandleNextPrevButton", paging.PrevPageButton, nil, nil, true)
		S:Proxy("HandleNextPrevButton", paging.NextPageButton, nil, nil, true)
	end

	hooksecurefunc(frame, "AcquireFrame", function(self, pool, numInUse)
		if pool and pool == self.entryFrames and pool[numInUse] then
			local button = pool[numInUse]
			RunNextFrame(function()
				reskinButton(nil, button)
			end)
		end
	end)
	hooksecurefunc(frame, "UpdateButton", reskinButton)

	frame.__windSkin = true
end

function S:ManuscriptsJournal()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.manuscriptsJournal then
		return
	end

	local frame = _G.ManuscriptsJournal
	if not frame or frame.__windSkin then
		return
	end

	if _G.ManuscriptsSideTabsFrame then
		reskinTabs(_G.ManuscriptsSideTabsFrame)

		-- MJ use the HeirloomsJournal tab to show the main frame
		hooksecurefunc(_G.ManuscriptsSideTabsFrame, "Show", onMJTabsShow)
		hooksecurefunc(_G.ManuscriptsSideTabsFrame, "Hide", onMJTabsHide)
	end

	local journals = {
		_G.ManuscriptsJournal,
		_G.ShapeshiftsJournal,
		_G.SoulshapesJournal,
		_G.HexTomesJournal,
		_G.PolymorphsJournal,
		_G.GrimoiresJournal,
		_G.TameTomesJournal,
		_G.DirigibleJournal,
		_G.PepeJournal,
	}

	for _, journal in pairs(journals) do
		reskinJournal(journal)
	end

	if _G.ManuscriptsJournal then
		for i = 1, 7 do
			reskinProgressBar(_G.ManuscriptsJournal["mount" .. i .. "Bar"])
		end

		local progressBar = _G.ManuscriptsJournal.progressBar
		if progressBar then
			progressBar:ClearAllPoints()
			progressBar:Point("TOPLEFT", 10, -25)
			progressBar:Width(421)

			if _G.ManuscriptsJournal.mount1Bar then
				_G.ManuscriptsJournal["mount1Bar"]:ClearAllPoints()
				_G.ManuscriptsJournal["mount1Bar"]:Point("TOPLEFT", progressBar, "BOTTOMLEFT", 0, -5)
			end
		end
	end

	if _G.SoulshapesJournal then
		local progressBar = _G.SoulshapesJournal.progressBar
		if progressBar then
			progressBar:ClearAllPoints()
			progressBar:Point("TOPLEFT", 10, -37)
			progressBar:Width(421)
		end
	end
end

S:AddCallbackForAddon("ManuscriptsJournal")
