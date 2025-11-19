local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local C = W.Utilities.Color

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

---@param button ItemButton
local function ReskinItemButton(button)
	if not button.icon or not button.IconBorder or not button.IconOverlay then
		return
	end

	S:Proxy("HandleItemButton", button, true)
	S:Proxy("HandleIconBorder", button.IconBorder, button.backdrop)
	button.IconBorder:Hide()
end

local function ReskinClassListFrame(frame)
	local ClassInset = frame.ClassInset
	if ClassInset then
		ClassInset:StripTextures()
		ClassInset:SetTemplate("Transparent")

		local Tabs = ClassInset.Tabs
		if Tabs then
			for _, tab in pairs(Tabs) do
				S:Proxy("HandleTab", tab)
				S:ReskinTab(tab)
				tab.Text:ClearAllPoints()
				tab.Text:Point("CENTER", tab, "CENTER", 0, 0)
				F.InternalizeMethod(tab.Text, "SetPoint", true)
			end
		end
	end

	local ClassScrollBar = frame.ClassScrollBar
	if ClassScrollBar then
		S:Proxy("HandleTrimScrollBar", ClassScrollBar)
	end

	local ClassScrollBox = frame.ClassScrollBox
	if ClassScrollBox then
		hooksecurefunc(ClassScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(function(frame)
				if frame.__windSkin then
					return
				end

				frame.__windSkin = true

				frame.background:Kill()
				frame.countBG:Kill()

				S:Proxy("HandleIcon", frame.classIcon)
				S:Proxy("HandleIcon", frame.specIcon)

				local HightlightTexture = frame:GetHighlightTexture()
				if HightlightTexture then
					HightlightTexture:SetTexture(E.Media.Textures.White8x8)
					HightlightTexture:SetVertexColor(1, 1, 1, 0.3)
					S:Reposition(HightlightTexture, frame, 0, -5, -5, 0, -2)
				end

				local hilightFrame = frame.hilightFrame
				if hilightFrame and hilightFrame.ActiveTexture then
					hilightFrame.ActiveTexture:SetTexture(E.Media.Textures.White8x8)
					hilightFrame.ActiveTexture:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-500", 0.3))
					hilightFrame.ActiveTexture:ClearAllPoints()
					hilightFrame.ActiveTexture:SetAllPoints(frame.specIcon)
				end

				local selectedTexture = frame.selectedTexture
				if selectedTexture then
					selectedTexture:SetTexture(E.Media.Textures.White8x8)
					selectedTexture:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-400", 0.3))
					S:Reposition(selectedTexture, frame, -1, -4, -4, 0, -2)
				end

				local heroIcon = frame.heroIcon
				if heroIcon then
					heroIcon:Size(32)
					F.Move(heroIcon, -8, 0)
				end

				if W.ChineseLocale then
					local className = frame.className
					if className then
						F.SetFont(frame.className, nil, "-2")
					end

					local specName = frame.specName
					if specName then
						F.SetFont(frame.specName, nil, "-2")
					end

					local name = frame.name
					if name then
						F.SetFont(frame.name, nil, "-1")
					end
				end
			end)
		end)
	end
end

local function ReskinStatsFrame(frame)
	local StatsInset = frame.StatsInset
	if StatsInset then
		StatsInset:StripTextures()
		StatsInset:SetTemplate("Transparent")
		StatsInset:SetBackdropBorderColor(1, 1, 1, 0.2)
	end

	local stats = frame.stats
	if stats then
		F.Move(stats, 0, 10)
	end

	local statsBorder = frame.statsBorder
	if statsBorder then
		statsBorder:StripTextures()
		for _, region in pairs({ statsBorder:GetRegions() }) do
			if region:IsObjectType("FontString") then
				F.SetFont(region)
				F.Move(region, 0, -10)
				return
			end
		end
	end
end

local function ReskinTalentsListFrame(frame)
	local TalentsInset = frame.TalentsInset
	if TalentsInset then
		TalentsInset:StripTextures()
		TalentsInset:SetTemplate("Transparent")
		TalentsInset:SetBackdropBorderColor(1, 1, 1, 0.2)
	end

	local TalentsScrollBar = frame.TalentsScrollBar
	if TalentsScrollBar then
		S:Proxy("HandleTrimScrollBar", TalentsScrollBar)
	end

	local TalentsScrollBox = frame.TalentsScrollBox
	if TalentsScrollBox then
		F.Move(TalentsScrollBox.ScrollTarget, 0, 5)
		hooksecurefunc(TalentsScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(function(frame)
				if frame.__windSkin then
					return
				end

				frame.__windSkin = true

				frame.background:Kill()
				frame:SetTemplate()

				local talentBox = frame.talentBox
				if talentBox then
					talentBox:StripTextures()
					S:Proxy("HandleEditBox", talentBox.EditBox)
					S:Proxy("HandleTrimScrollBar", talentBox.ScrollBar)
				end
			end)
		end)
	end

	local talentsBorder = frame.talentsBorder
	if talentsBorder then
		talentsBorder:StripTextures()
		for _, region in pairs({ talentsBorder:GetRegions() }) do
			if region:IsObjectType("FontString") then
				F.SetFont(region)
				F.Move(region, 0, -10)
				return
			end
		end
	end
end

local function ReskinTraitsTreeFrame(frame)
	local TraitsInset = frame.TraitsInset
	if TraitsInset then
		TraitsInset:StripTextures()
		TraitsInset:SetTemplate("Transparent")
		TraitsInset:SetBackdropBorderColor(1, 1, 1, 0.2)

		local Tabs = TraitsInset.Tabs
		if Tabs then
			for _, tab in pairs(Tabs) do
				S:Proxy("HandleTab", tab)
				tab:SetTemplate("Default")
				tab.Text:ClearAllPoints()
				tab.Text:Point("CENTER", tab, "CENTER", 0, 0)
				F.InternalizeMethod(tab.Text, "SetPoint", true)
			end
		end
	end

	local traitsBorder = frame.traitsBorder
	if traitsBorder then
		traitsBorder:StripTextures()
		for _, region in pairs({ traitsBorder:GetRegions() }) do
			if region:IsObjectType("FontString") then
				F.SetFont(region)
				F.Move(region, 0, -10)
				return
			end
		end
	end
end

local function ReskinEquipmentsListFrameScrollContent(content)
	if content.__windSkin then
		return
	end

	content.__windSkin = true

	content:StripTextures()
	content:SetTemplate()

	local NineSlice = content.NineSlice
	if NineSlice then
		content.NineSlice:SetAlpha(0)
	end

	local background = content.background
	if background then
		background:SetAlpha(0)
	end

	local titleBar = content.titleBar
	if titleBar then
		content.titleBar:StripTextures()
	end

	for _, child in pairs({ content:GetChildren() }) do
		ReskinItemButton(child)
	end
end
local function ReskinEquipmentsListFrame(frame)
	local EquipmentsInset = frame.EquipmentsInset
	if EquipmentsInset then
		F.Move(EquipmentsInset, 2, 0)
		EquipmentsInset:StripTextures()
		EquipmentsInset:SetTemplate("Transparent")
		EquipmentsInset:SetBackdropBorderColor(1, 1, 1, 0.2)
	end

	local EquipmentsScrollBar = frame.EquipmentsScrollBar
	if EquipmentsScrollBar then
		S:Proxy("HandleTrimScrollBar", EquipmentsScrollBar)
	end

	for _, child in pairs({ frame:GetChildren() }) do
		ReskinItemButton(child)
	end

	local EquipmentsScrollBox = frame.EquipmentsScrollBox
	if EquipmentsScrollBox then
		hooksecurefunc(EquipmentsScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(ReskinEquipmentsListFrameScrollContent)
		end)
	end

	local equipmentsBorder = frame.equipmentsBorder
	if equipmentsBorder then
		equipmentsBorder:StripTextures()
		for _, region in pairs({ equipmentsBorder:GetRegions() }) do
			if region:IsObjectType("FontString") then
				F.SetFont(region)
				F.Move(region, 0, -10)
				return
			end
		end
	end
end

local function ReskinMurlokExport(frame)
	S:Proxy("HandlePortraitFrame", frame)
	S:CreateShadow(frame)
	frame:SetTemplate("Transparent")

	local MaximizeMinimizeButton = frame.MaximizeMinimizeButton
	S:Proxy("HandleMaxMinFrame", MaximizeMinimizeButton)

	local ClassListFrame = frame.ClassListFrame
	if ClassListFrame then
		ReskinClassListFrame(ClassListFrame)
	end

	local StatsFrame = frame.StatsFrame
	if StatsFrame then
		ReskinStatsFrame(StatsFrame)
	end

	local TalentsListFrame = frame.TalentsListFrame
	if TalentsListFrame then
		ReskinTalentsListFrame(TalentsListFrame)
	end

	local TraitsTreeFrame = frame.TraitsTreeFrame
	if TraitsTreeFrame then
		ReskinTraitsTreeFrame(TraitsTreeFrame)
	end

	local EquipmentsListFrame = frame.EquipmentsListFrame
	if EquipmentsListFrame then
		ReskinEquipmentsListFrame(EquipmentsListFrame)
	end
end

function S:MurlokExport()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.murlokExport then
		return
	end

	if _G.UIMurlokExport then
		ReskinMurlokExport(_G.UIMurlokExport)
	end
end

S:AddCallbackForAddon("MurlokExport")
