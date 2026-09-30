local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local unpack = unpack

local hooksecurefunc = hooksecurefunc

function S:ExtraQuestButton()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.extraQuestButton then
		return
	end

	local button = _G.ExtraQuestButton
	if not button then
		return
	end

	if button.Artwork then
		button.Artwork:SetAlpha(0)
		hooksecurefunc(button.Artwork, "SetAlpha", function(self, alpha)
			if alpha ~= 0 then
				self:SetAlpha(0)
			end
		end)
	end

	if button.Mask then
		button.Mask:Hide()
	end

	button:SetNormalTexture(E.ClearTexture)
	button:SetHighlightTexture(E.ClearTexture)
	button:SetPushedTexture(E.ClearTexture)
	button:SetCheckedTexture(E.ClearTexture)

	button:SetTemplate("Transparent")
	button:StyleButton()
	S:CreateShadow(button)

	if button.Icon then
		button.Icon:SetDrawLayer("ARTWORK")
		button.Icon:SetTexCoord(unpack(E.TexCoords))
		button.Icon:SetInside()
	end

	if button.Cooldown then
		E:RegisterCooldown(button.Cooldown)
	end

	if button.Count then
		F.SetFont(button.Count)
	end

	if button.HotKey then
		F.SetFont(button.HotKey)
	end
end

S:AddCallbackForAddon("ExtraQuestButton")
