local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ChromieTimeUI", nil, "chromieTime")

function S:Blizzard_ChromieTimeUI()
	self:CreateShadow(_G.ChromieTimeFrame)
	F.SetFont(_G.ChromieTimeFrame.Title.Text)
	F.SetFont(_G.ChromieTimeFrame.SelectButton.Text)
end
