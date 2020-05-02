local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:BlizzardTalent()
    if not E.global.general.showMissingTalentAlert then return end

    local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
    if not TalentMicroButtonAlert.shadow then
        -- 防止重复扩大
        TalentMicroButtonAlert:SetWidth(TalentMicroButtonAlert:GetWidth() + 50)
        TalentMicroButtonAlert.Text:SetWidth(TalentMicroButtonAlert.Text:GetWidth() + 50)
    end
    
    S:CreateShadow(TalentMicroButtonAlert)
end

--S:AddCallbackForAddon('Blizzard_TalentUI')
S:AddCallback('BlizzardTalent')