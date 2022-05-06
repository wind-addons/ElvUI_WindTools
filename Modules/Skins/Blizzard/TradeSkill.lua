local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_TradeSkillUI()
    if not self:CheckDB("tradeskill", "tradeSkill") then
        return
    end

    self:CreateShadow(_G.TradeSkillFrame)
    self:CreateShadow(_G.TradeSkillFrame.OptionalReagentList)
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI")
