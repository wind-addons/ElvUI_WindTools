local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local UF = E:GetModule("UnitFrames")

local _G = _G

local CreateFrame = CreateFrame

function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
	if not frame.Castbar then
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
			self:CreateShadow(frame.Castbar.ButtonIcon.bg)
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

	self:CreateShadow(windBg)
end

function S:ElvUI_CastBars()
	if not E.private.unitframe.enable then
		return
	end
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.castBars) then
		return
	end

	self:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

S:AddCallback("ElvUI_CastBars")
