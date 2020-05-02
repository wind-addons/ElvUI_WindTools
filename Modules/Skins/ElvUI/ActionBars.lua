local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')
local AB = E:GetModule('ActionBars')

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ElvUI_ActionBars()
    if not (E.private.actionbar.enable and E.private.WT.skins.elvui.enable) then return end
    if not (E.private.WT.skins.elvui.actionbar or E.private.WT.skins.elvui.actionbarBackdrop) then return end

    -- 常规动作条
    local actionBarList = {
        "ElvUI_Bar1",
        "ElvUI_Bar2",
        "ElvUI_Bar3",
        "ElvUI_Bar4",
        "ElvUI_Bar5",
        "ElvUI_Bar6",
        "ElvUI_StanceBar",
        "PetAction"
    }

    for _, bar in pairs(actionBarList) do
        if _G[bar] then
            if E.private.WT.skins.elvui.actionbar then
                for i = 1, 12 do
                    local button = _G[bar .. "Button" .. i]
                    if button and button.backdrop then S:CreateShadow(button.backdrop) end
                end
            end

            if E.private.WT.skins.elvui.actionbarBackdrop then
                if _G[bar].backdrop and _G[bar].backdrop:IsShown() then S:CreateShadow(_G[bar].backdrop) end
            end
        end
    end

    -- 特殊技能
    if E.private.WT.skins.elvui.actionbar then
        if _G.ZoneAbilityFrame and _G.ZoneAbilityFrame.SpellButton then
            S:CreateShadow(_G.ZoneAbilityFrame.SpellButton)
        end

        S:CreateShadow(_G.ExtraActionButton1)
    end

    hooksecurefunc(AB, "StyleButton",
                       function(_, button) if button.backdrop then S:CreateShadow(button.backdrop) end end)
end

S:AddCallback('ElvUI_ActionBars')
