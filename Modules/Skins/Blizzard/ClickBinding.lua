local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ClickBindingUI()
	if not self:CheckDB("binding", "clickBinding") then
		return
	end

	self:CreateShadow(_G.ClickBindingFrame)
	self:CreateShadow(_G.ClickBindingFrame.TutorialFrame)
end

S:AddCallbackForAddon("Blizzard_ClickBindingUI")
