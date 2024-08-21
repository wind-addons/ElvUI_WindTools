local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:DressUpFrame()
	if not self:CheckDB("dressingroom", "dressingRoom") then
		return
	end

	self:CreateShadow(_G.DressUpFrame)
	self:CreateBackdropShadow(_G.DressUpFrame.OutfitDetailsPanel)
	self:CreateBackdropShadow(_G.DressUpFrame.SetSelectionPanel) -- MOP Remix
end

S:AddCallback("DressUpFrame")
