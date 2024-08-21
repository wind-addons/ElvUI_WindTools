local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SetupOptions(frame)
	if frame.__windSkin then
		return
	end

	S:CreateShadow(frame)

	if frame.shadow then
		frame.shadow:SetShown(frame.template and frame.template == "Transparent")

		hooksecurefunc(frame, "SetTemplate", function(_, template)
			frame.shadow:SetShown(template and template == "Transparent")
		end)
	end

	frame.__windSkin = true
end

function S:Blizzard_PlayerChoice()
	if not self:CheckDB("playerChoice") then
		return
	end

	hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

S:AddCallbackForAddon("Blizzard_PlayerChoice")
