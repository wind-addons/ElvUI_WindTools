local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame

local data = S:AddCallback("ElvUI_CastBars", function()
	return E.private.unitframe.enable and E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.castBars and true
		or false
end)

function data:SkinCastBar(frame) -- self is the UnitFrames module, not data
	if not frame or not frame.Castbar or not frame.Castbar.backdrop or not frame.db or not frame.db.castbar then
		return
	end

	local db = frame.db.castbar

	if not frame.Castbar.windShadowBackdrop then
		frame.Castbar.windShadowBackdrop = CreateFrame("Frame", nil, frame.Castbar)
		frame.Castbar.windShadowBackdrop:SetFrameStrata(frame.Castbar.backdrop:GetFrameStrata())
		frame.Castbar.windShadowBackdrop:SetFrameLevel(frame.Castbar.backdrop:GetFrameLevel() or 1)
	end

	local windBg = frame.Castbar.windShadowBackdrop
	local iconBg = frame.Castbar.ButtonIcon.bg

	if not db.iconAttached then
		if not windBg.mode or windBg.mode ~= "NotAttach" then
			-- Icon shadow
			S:CreateShadow(frame.Castbar.ButtonIcon.bg)
			if frame.Castbar.ButtonIcon.bg.shadow then
				frame.Castbar.ButtonIcon.bg.shadow:Show()
			end

			-- Bar shadow
			windBg:ClearAllPoints()
			windBg:SetAllPoints(frame.Castbar.backdrop)
			windBg.mode = "NotAttach"
		end
	else
		if not windBg.mode or windBg.mode ~= "Attach" then
			-- Disable icon shadow
			if frame.Castbar.ButtonIcon.bg.shadow then
				frame.Castbar.ButtonIcon.bg.shadow:Hide()
			end

			-- |-- Icon --| ---------------- Time Bar ---------------|
			-- |---------------- windShadowBackdrop -----------------|
			windBg:ClearAllPoints()
			windBg:Point("TOPRIGHT", frame.Castbar.backdrop, "TOPRIGHT")
			windBg:Point("BOTTOMRIGHT", frame.Castbar.backdrop, "BOTTOMRIGHT")
			windBg:Point("TOPLEFT", iconBg, "TOPLEFT")
			windBg:Point("BOTTOMLEFT", iconBg, "BOTTOMLEFT")
			windBg.mode = "Attach"
		end
	end

	S:CreateShadow(windBg)
end

function S:ElvUI_CastBars()
	if not self:IsHooked(UF, "Configure_Castbar") then
		self:SecureHook(UF, "Configure_Castbar", data.SkinCastBar)
	end
end
