local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:CharacterFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.character) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.character) then return end

    S:CreateShadow(_G.CharacterFrame)
    for i = 1, 4 do S:CreateTabShadow(_G["CharacterFrameTab" .. i]) end

    -- 去除人物模型背景
    local CharacterModelFrame = _G.CharacterModelFrame
    CharacterModelFrame:SetTemplate("Transparent")
    CharacterModelFrame:DisableDrawLayer("BACKGROUND")
    CharacterModelFrame:DisableDrawLayer("BORDER")
    CharacterModelFrame:DisableDrawLayer("OVERLAY")
    if CharacterModelFrame.backdrop then CharacterModelFrame.backdrop:Kill() end
end

S:AddCallback('CharacterFrame')