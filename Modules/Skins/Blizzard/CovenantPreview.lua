local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_CovenantPreviewUI()
	if not self:CheckDB("covenantPreview") then
		return
	end

	self:CreateShadow(_G.CovenantPreviewFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantPreviewUI")
