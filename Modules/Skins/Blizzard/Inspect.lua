local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_InspectUI()
    if not self:CheckDB("inspect") then
        return
    end

    -- 观察面板
    self:CreateShadow(_G.InspectFrame)
    for i = 1, 4 do
        self:ReskinTab(_G["InspectFrameTab" .. i])
    end

    -- 去除人物模型背景
    local InspectModelFrame = _G.InspectModelFrame
    if InspectModelFrame then
        InspectModelFrame:DisableDrawLayer("BACKGROUND")
        InspectModelFrame:DisableDrawLayer("BORDER")
        InspectModelFrame:DisableDrawLayer("OVERLAY")
        if InspectModelFrame.backdrop then
            InspectModelFrame.backdrop:Kill()
        end
    end
end

S:AddCallbackForAddon("Blizzard_InspectUI")
