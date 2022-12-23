local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local CreateFrame = CreateFrame

local function reskinTooltip(tt)
    if not tt then
        return
    end
    tt:StripTextures()
    tt:SetTemplate("Transparent")
    tt.CreateBackdrop = E.noop
    tt.ClearBackdrop = E.noop
    tt.SetBackdropColor = E.noop
    if tt.backdrop and tt.backdrop.Hide then
        tt.backdrop:Hide()
    end
    tt.backdrop = nil
    S:CreateShadow(tt)
end

function S:MythicDungeonTools()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.mythicDungeonTools then
        return
    end

    if not _G.MDT then
        return
    end

    self:SecureHook(
        _G.MDT,
        "ShowInterface",
        function()
            reskinTooltip(_G.MDT.tooltip)
            reskinTooltip(_G.MDT.pullTooltip)

            if _G.MDTFrame and _G.MDTFrame.DungeonSelectionGroup then
                self:CreateShadow(_G.MDTFrame.DungeonSelectionGroup.frame)
                local shadow = _G.MDTFrame.DungeonSelectionGroup.frame.shadow
                if shadow then
                    shadow.LeftEdge:Hide()
                    shadow.TopEdge:Hide()
                    shadow.BottomLeftCorner:Hide()
                    shadow.TopLeftCorner:Hide()
                end
            end
        end
    )

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
        end
    )
end

S:AddCallbackForAddon("MythicDungeonTools")
