local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_CovenantPreviewUI")
data.toggle = "covenantPreview"

local _G = _G

function S:Blizzard_CovenantPreviewUI()
	self:CreateShadow(_G.CovenantPreviewFrame)
end

