local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:Blizzard_RemixArtifactUI()
	if not self:CheckDB("remixArtifact") then
		return
	end

	local RemixArtifactFrame = _G.RemixArtifactFrame
	if not RemixArtifactFrame then
		return
	end

	RemixArtifactFrame:SetTemplate("Transparent")
	self:CreateShadow(RemixArtifactFrame)

	if RemixArtifactFrame.Background then
		RemixArtifactFrame.Background:Kill()
	end
	if RemixArtifactFrame.BorderContainer then
		RemixArtifactFrame.BorderContainer:Kill()
	end

	if RemixArtifactFrame.ButtonsParent then
		RemixArtifactFrame.ButtonsParent.Overlay:Kill()
	end

	if RemixArtifactFrame.Model then
		F.InternalizeMethod(RemixArtifactFrame.Model, "SetLight")
		hooksecurefunc(RemixArtifactFrame.Model, "SetLight", function(model, enabled, lightValues)
			if lightValues.ambientIntensity then
				lightValues.ambientIntensity = 0.3
				F.CallMethod(model, "SetLight", enabled, lightValues)
			end
		end)
	end

	if RemixArtifactFrame.Currency then
		local UnspentPointsCount = RemixArtifactFrame.Currency.UnspentPointsCount
		F.SetFont(UnspentPointsCount)
		F.InternalizeMethod(UnspentPointsCount, "SetText")
		hooksecurefunc(UnspentPointsCount, "SetText", function(currency, raw)
			local after = self:StyleTextureString(raw)
			if after ~= raw then
				F.CallMethod(currency, "SetText", after)
			end
		end)
	end

	if RemixArtifactFrame.Header then
		F.SetFont(RemixArtifactFrame.Header.Title)
	end

	self:CreateShadow(RemixArtifactFrame)
end

S:AddCallbackForAddon("Blizzard_RemixArtifactUI")
