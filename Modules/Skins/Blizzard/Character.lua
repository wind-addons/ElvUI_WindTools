local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:CharacterFrame()
    if not self:CheckDB("character") then
        return
    end

    -- 角色面板
    self:CreateShadow(_G.CharacterFrame)
    self:CreateShadow(_G.GearManagerDialogPopup)
    self:CreateShadow(_G.EquipmentFlyoutFrameButtons)
    for i = 1, 4 do
        self:ReskinTab(_G["CharacterFrameTab" .. i])
    end

    -- 代币窗口
    self:CreateShadow(_G.TokenFramePopup)

    -- 去除人物模型背景
    local CharacterModelFrame = _G.CharacterModelFrame
    CharacterModelFrame:DisableDrawLayer("BACKGROUND")
    CharacterModelFrame:DisableDrawLayer("BORDER")
    CharacterModelFrame:DisableDrawLayer("OVERLAY")
    if CharacterModelFrame.backdrop then
        CharacterModelFrame.backdrop:Kill()
    end

    -- 声望
    self:CreateShadow(_G.ReputationDetailFrame)
end

S:AddCallback("CharacterFrame")
