local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs

S:AddCallbackForAddon("AngryKeystones", nil, S:CreateAddonCheck("angryKeystones"))

function S:AngryKeystones()
	hooksecurefunc(_G.ScenarioObjectiveTracker.ChallengeModeBlock, "Activate", function(block)
		if block and block.TimerFrame and not block.TimerFrame.__windSkin then
			for _, bar in pairs({ block.TimerFrame.Bar2, block.TimerFrame.Bar3 }) do
				bar:SetTexture(E.media.blankTex)
				bar:Width(2)
				bar:SetAlpha(0.618)
				bar:Height(bar:GetHeight() + 2)
			end
			block.TimerFrame.__windSkin = true
		end
	end)
end
