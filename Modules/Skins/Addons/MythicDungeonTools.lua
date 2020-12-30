local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local CreateFrame = CreateFrame

function S:MythicDungeonTools()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.mythicDungeonTools then
        return
    end

    if not _G.MDT then
        return
    end

    self:SecureHook(
        _G.MDT,
        "initToolbar",
        function()
            if _G.MDTFrame then
                local virtualBackground = CreateFrame("Frame", "WT_MDTSkinBackground", _G.MDTFrame)
                virtualBackground:Point("TOPLEFT", _G.MDTTopPanel, "TOPLEFT")
                virtualBackground:Point("BOTTOMRIGHT", _G.MDTSidePanel, "BOTTOMRIGHT")
                self:CreateShadow(virtualBackground)
                self:CreateShadow(_G.MDTToolbarFrame)
            end

            self:CreateShadow(_G.MDT.tooltip)
            self:CreateShadow(_G.MDT.pullTooltip)
        end
    )
end

S:AddCallbackForAddon("MythicDungeonTools")
