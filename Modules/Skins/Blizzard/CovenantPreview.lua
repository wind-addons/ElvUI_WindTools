local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_CovenantPreviewUI()
	if not self:CheckDB("covenantPreview") then
		return
	end

	self:CreateShadow(_G.CovenantPreviewFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantPreviewUI")
