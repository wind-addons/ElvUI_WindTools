local W, F, E, L = unpack(select(2, ...))
local M = E:GetModule("Misc")
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_LootRoll()
    if not (E.private.general.lootRoll and E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.lootRoll) then
        return
    end

    self:SecureHook(
        M,
        "LootRoll_Create",
        function(_, index)
            local frame = _G["ElvUI_LootRollFrame" .. index]
            if frame and not frame.__windSkin then
                self:CreateShadow(frame)
                frame.__windSkin = true
            end
        end
    )
end

S:AddCallback("ElvUI_LootRoll")
