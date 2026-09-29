local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ChromieTimeUI")
data.toggle = "chromieTime"

local _G = _G

function S:Blizzard_ChromieTimeUI()
	self:CreateShadow(_G.ChromieTimeFrame)
	F.SetFont(_G.ChromieTimeFrame.Title.Text)
	F.SetFont(_G.ChromieTimeFrame.SelectButton.Text)
end

