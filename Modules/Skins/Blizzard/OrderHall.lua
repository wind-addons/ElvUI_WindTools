local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_OrderHallUI()
	if not self:CheckDB("orderhall", "orderHall") then
		return
	end

	self:CreateShadow(_G.OrderHallTalentFrame)

	local bar = _G.OrderHallCommandBar
	if bar then
		self:CreateShadow(bar)
		F.SetFontOutline(bar.AreaName)
		F.SetFontOutline(bar.Currency)
		bar.AreaName:ClearAllPoints()
		bar.AreaName:SetPoint("CENTER", 0, 0)
	end
end

S:AddCallbackForAddon("Blizzard_OrderHallUI")
