local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local MF = W.Modules.MoveFrames

local _G = _G
local pairs = pairs
local unpack = unpack

local CreateFrame = CreateFrame

do
	function S:TinyInspect_SkinListPanel(unit, parent, ilevel, maxLevel)
		if not parent or not parent.inspectFrame then
			return
		end

		local frame = parent.inspectFrame
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 5, 0)

		if parent.inspectFrameHolder then
			parent.inspectFrameHolder:Show()
			return
		end

		self:StripEdgeTextures(frame)

		frame.closeButton:ClearAllPoints()
		frame.closeButton:SetPoint("BOTTOMLEFT", 3, 3)

		if frame.specicon then
			frame.specicon:SetMask("")
			frame.specicon:Size(35)
			frame.specicon:SetTexCoord(unpack(E.TexCoords))
		end

		if frame.spectext then
			F.SetFontOutline(frame.spectext, E.db.general.font)
		end

		for i = 1, 20 do
			if frame["item" .. i] then
				F.SetFontOutline(frame["item" .. i].itemString, E.db.general.font)
				F.SetFontOutline(frame["item" .. i].levelString, "Montserrat")
			end
		end

		local inspectFrameHolder = CreateFrame("Frame", nil, parent)
		inspectFrameHolder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		inspectFrameHolder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		inspectFrameHolder:SetTemplate("Transparent")
		self:CreateShadow(inspectFrameHolder)

		self:SecureHookScript(frame.closeButton, "OnClick", function()
			inspectFrameHolder:Hide()
		end)

		self:SecureHookScript(parent, "OnHide", function()
			inspectFrameHolder:Hide()
		end)

		if MF:IsRunning() then
			MF:HandleFrame(inspectFrameHolder, parent.MoveFrame or parent)
			frame.MoveFrame = inspectFrameHolder.MoveFrame
		end

		inspectFrameHolder:Show()
		parent.inspectFrameHolder = inspectFrameHolder
		frame:SetParent(inspectFrameHolder)
	end
end

do
	local DeleteBorders = {
		"Bg",
		"BorderBottomLeft",
		"BorderBottomMiddle",
		"BorderBottomRight",
		"BorderLeftMiddle",
		"BorderRightMiddle",
		"BorderTopMiddle",
		"BorderTopLeft",
		"BorderTopRight",
	}

	function S:TinyInspect_SkinStatsPanel(frame, unit)
		local statsFrame = frame.statsFrame
		if not statsFrame then
			return
		end

		if frame.statsFrameHolder then
			frame.statsFrameHolder:Show()
			return
		end

		for _, regionKey in pairs(DeleteBorders) do
			if statsFrame[regionKey] then
				statsFrame[regionKey]:Kill()
			end
		end

		for i = 1, 20 do
			F.SetFontOutline(statsFrame["stat" .. i].Label, E.db.general.font)
			F.SetFontOutline(statsFrame["stat" .. i].Value, E.db.general.font)
			F.SetFontOutline(statsFrame["stat" .. i].PlayerValue, E.db.general.font)
		end

		for _, region in pairs({ statsFrame:GetRegions() }) do
			if region:GetTexture() == "Interface\\Tooltips\\UI-Tooltip-Background" then
				region:ClearAllPoints()
				region:SetPoint("TOPLEFT", statsFrame, "TOPRIGHT", -58, -1)
				region:SetPoint("BOTTOMRIGHT", statsFrame, "BOTTOMRIGHT", 0, 1)
			end
		end

		local statsFrameHolder = CreateFrame("Frame", nil, frame)
		statsFrameHolder:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", 0, -1)
		statsFrameHolder:SetPoint("BOTTOMRIGHT", statsFrame, "BOTTOMRIGHT", 0, 1)
		statsFrameHolder:CreateBackdrop("Transparent")
		statsFrameHolder.backdrop:SetFrameLevel(statsFrame:GetFrameLevel())
		statsFrameHolder.backdrop:SetFrameStrata(statsFrame:GetFrameStrata())
		self:CreateShadow(statsFrameHolder, 5)

		local OldExpandButtonOnClick = frame.expandButton:GetScript("OnClick")
		frame.expandButton:SetScript("OnClick", function(self)
			OldExpandButtonOnClick(self)
			if statsFrame:IsShown() then
				statsFrameHolder:Show()
			else
				statsFrameHolder:Hide()
			end
		end)

		statsFrame:SetScript("OnHide", function(self)
			statsFrameHolder:Hide()
		end)

		if MF and MF.db and MF.db.enable then
			local parent = frame:GetParent()
			MF:HandleFrame(statsFrameHolder, parent.MoveFrame or parent)
		end

		statsFrameHolder:Show()
		frame.statsFrameHolder = statsFrameHolder
		statsFrame:SetParent(statsFrameHolder)

		self:SecureHook(statsFrame, "SetPoint", function(_, _, _, _, _, y)
			if y ~= 0 then
				statsFrame:ClearAllPoints()
				statsFrame:SetPoint("TOPLEFT", statsFrame:GetParent(), "TOPRIGHT", 5, 0)
			end
		end)
	end
end

function S:TinyInspect()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tinyInspect then
		return
	end

	self:DisableAddOnSkin("TinyInspect")

	if _G.ShowInspectItemListFrame then
		self:SecureHook("ShowInspectItemListFrame", "TinyInspect_SkinListPanel")
	end

	if _G.ShowInspectItemStatsFrame then
		self:SecureHook("ShowInspectItemStatsFrame", "TinyInspect_SkinStatsPanel")
	end
end

S:AddCallbackForAddon("TinyInspect")
