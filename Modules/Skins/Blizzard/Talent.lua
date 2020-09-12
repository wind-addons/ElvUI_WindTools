local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BlizzardTalent()
    if not E.global.general.showMissingTalentAlert then
        return
    end

    if not self:CheckDB(nil, "talent") then
        return
    end

    local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
    if TalentMicroButtonAlert and (not TalentMicroButtonAlert.shadow) then
        -- 防止重复扩大
        TalentMicroButtonAlert:SetWidth(TalentMicroButtonAlert:GetWidth() + 50)
        TalentMicroButtonAlert.Text:SetWidth(TalentMicroButtonAlert.Text:GetWidth() + 50)
    end

    self:CreateShadow(TalentMicroButtonAlert)
end

function S:Blizzard_TalentUI()
    if not self:CheckDB("talent") then
        return
    end

    self:CreateShadow(_G.PlayerTalentFrame)
    self:CreateShadow(_G.PlayerTalentFrameTalentsPvpTalentFrameTalentList)
    for i = 1, 3 do
        self:ReskinTab(_G["PlayerTalentFrameTab" .. i])
    end
end

S:AddCallback("BlizzardTalent")
S:AddCallbackForAddon("Blizzard_TalentUI")
