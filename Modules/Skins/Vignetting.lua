local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local CreateFrame = CreateFrame

local data = S:AddCallback("Vignetting", function()
	return E.db.WT.skins.vignetting.enable and true or false
end)
S:AddCallbackForUpdate("UpdateVignettingConfig")

function data:UpdateVignetting()
	local frame = self.VignettingFrame
	local level = E.db.WT.skins.vignetting.level / 100
	if frame and level then
		frame:SetAlpha(level)
	end
end

function S:Vignetting()
	local frame = CreateFrame("Frame", "ShadowBackground", _G.UIParent)
	frame:Point("TOPLEFT")
	frame:Point("BOTTOMRIGHT")
	frame:SetFrameLevel(0)
	frame:SetFrameStrata("BACKGROUND")
	frame.tex = frame:CreateTexture()
	frame.tex:SetTexture(W.Media.Textures.vignetting)
	frame.tex:SetAllPoints(frame)

	data.VignettingFrame = frame
	data:UpdateVignetting()
end

-- Entry point used by Options and the update callback
function S:UpdateVignettingConfig()
	if not E.db.WT.skins.vignetting.enable then
		if data.VignettingFrame then
			data.VignettingFrame:Hide()
		end
	else
		if not data.VignettingFrame then
			self:Vignetting()
			return
		end
		data.VignettingFrame:Show()
		data:UpdateVignetting()
	end
end
