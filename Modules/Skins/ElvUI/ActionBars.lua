local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local AB = E:GetModule("ActionBars")

local _G = _G
local hooksecurefunc = hooksecurefunc
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local function SkinBar(bar, type)
    if not (bar and bar.backdrop) then
        return
    end

    if E.private.WT.skins.elvui.actionBarsBackdrop then
        if bar.db.backdrop then
            if not bar.backdrop.shadow then
                S:CreateShadow(bar.backdrop)
            end
            bar.backdrop.shadow:Show()
        else
            if bar.backdrop.shadow then
                bar.backdrop.shadow:Hide()
            end
        end
    end

    if E.private.WT.skins.elvui.actionBarsButton then
        if type == "PLAYER" then
            for i = 1, NUM_ACTIONBAR_BUTTONS do
                local button = bar.buttons[i]
                S:CreateShadow(button.backdrop)
            end
        elseif type == "PET" then
            for i = 1, NUM_PET_ACTION_SLOTS do
                local button = _G["PetActionButton" .. i]
                S:CreateShadow(button.backdrop)
            end
        elseif type == "STANCE" then
            for i = 1, NUM_STANCE_SLOTS do
                local button = _G["ElvUI_StanceBarButton" .. i]
                S:CreateShadow(button.backdrop)
            end
        end
    end
end

function S:ElvUI_ActionBars()
    if not (E.private.actionbar.enable and E.private.WT.skins.elvui.enable) then
        return
    end
    if not (E.private.WT.skins.elvui.actionBarsButton or E.private.WT.skins.elvui.actionBarsBackdrop) then
        return
    end

    -- 常规动作条
    for id = 1, 10 do
        local bar = _G["ElvUI_Bar" .. id]
        SkinBar(bar, "PLAYER")
    end

    hooksecurefunc(
        AB,
        "PositionAndSizeBar",
        function(self, barName)
            local bar = self.handledBars[barName]
            SkinBar(bar, "PLAYER")
        end
    )

    -- 宠物动作条
    SkinBar(_G.ElvUI_BarPet, "PET")
    hooksecurefunc(
        AB,
        "PositionAndSizeBarPet",
        function()
            SkinBar(_G.ElvUI_BarPet, "PET")
        end
    )

    -- 姿态条
    SkinBar(_G.ElvUI_StanceBar, "STANCE")
    hooksecurefunc(
        AB,
        "PositionAndSizeBarShapeShift",
        function()
            SkinBar(_G.ElvUI_StanceBar, "STANCE")
        end
    )

    if not E.private.WT.skins.elvui.actionBarsButton then
        return
    end

    -- 特殊技能
    if _G.ZoneAbilityFrame and _G.ZoneAbilityFrame.SpellButton then
        S:CreateShadow(_G.ZoneAbilityFrame.SpellButton)
    end

    -- 离开载具
    S:CreateShadow(_G.MainMenuBarVehicleLeaveButton)

    -- 额外动作条
    for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
        local button = _G["ExtraActionButton" .. i]
        if button then
            S:CreateShadow(button)
        end
    end
end

S:AddCallback("ElvUI_ActionBars")
