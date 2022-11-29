local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_Professions()
    if not self:CheckDB("tradeskill", "professions") then
        return
    end

    self:CreateShadow(_G.ProfessionsFrame)
    self:CreateBackdropShadow(_G.ProfessionsFrame.CraftingPage.CraftingOutputLog)

    for _, tab in next, { ProfessionsFrame.TabSystem:GetChildren() } do
		self:ReskinTab(tab)
	end
end

S:AddCallbackForAddon("Blizzard_Professions")
