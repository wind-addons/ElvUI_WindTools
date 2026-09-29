local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ItemSocketingUI")
data.toggle = "socket"
data.private = "itemSocketing"

local _G = _G

function S:Blizzard_ItemSocketingUI()
	self:CreateShadow(_G.ItemSocketingFrame)
end

