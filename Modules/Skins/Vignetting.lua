local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local CreateFrame = CreateFrame

function S:UpdateVignetting()
	local frame = self.VignettingFrame
	local level = E.db.WT.skins.vignetting.level / 100
	if frame and level then
		frame:SetAlpha(level)
	end
end

function S:Vignetting()
	if not E.db.WT.skins.vignetting.enable then
		return
	end

	local frame = CreateFrame("Frame", "ShadowBackground", _G.UIParent)
	frame:SetPoint("TOPLEFT")
	frame:SetPoint("BOTTOMRIGHT")
	frame:SetFrameLevel(0)
	frame:SetFrameStrata("BACKGROUND")
	frame.tex = frame:CreateTexture()
	frame.tex:SetTexture(W.Media.Textures.vignetting)
	frame.tex:SetAllPoints(frame)

	self.VignettingFrame = frame
	self:UpdateVignetting()
end

function S:UpdateVignettingConfig()
	if not E.db.WT.skins.vignetting.enable then
		if self.VignettingFrame then
			self.VignettingFrame:Hide()
		end
	else
		if not self.VignettingFrame then
			self:Vignetting()
			return
		end
		self.VignettingFrame:Show()
		self:UpdateVignetting()
	end
end

S:AddCallback("Vignetting")
S:AddCallbackForUpdate("UpdateVignettingConfig")
