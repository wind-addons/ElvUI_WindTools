local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

local function SkinAlert(alert)
    if not alert or alert.windStyle then return end

    S:CreateBackdropShadowAfterElvUISkins(alert)

    if alert.Label and alert.Icon then
        alert.Label:ClearAllPoints()
        alert.Label:SetPoint("TOPLEFT", alert.Icon, "TOPRIGHT", 5, 2)
    end

    if alert.Icon and alert.Icon.Texture and alert.Icon.Texture.b then
        alert.Icon.Texture.b:Point("TOPLEFT", alert.Icon.Texture, "TOPLEFT", -1, 1)
        alert.Icon.Texture.b:Point("BOTTOMRIGHT", alert.Icon.Texture, "BOTTOMRIGHT", 1, -1)
        alert.Icon.Texture.b:CreateShadow(5)
    end

    if alert.SpecIcon then alert.SpecIcon.b:CreateShadow() end

    alert.windStyle = true
end

local function SkinCriteriaAlert(frame)
    if not frame or frame.windStyle then return end

    S:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Unlocked)
    F.SetFontOutline(frame.Name)

    if frame.Icon.Texture.b then
        frame.Icon.Texture.b:Point("TOPLEFT", frame.Icon.Texture, "TOPLEFT", -1, 1)
        frame.Icon.Texture.b:Point("BOTTOMRIGHT", frame.Icon.Texture, "BOTTOMRIGHT", 1, -1)
        S:CreateShadow(frame.Icon.Texture.b)

        frame.Icon.Texture:ClearAllPoints()
        frame.Icon.Texture:Point("RIGHT", frame.backdrop, "LEFT", 50, 0)
    end

    frame.windStyle = true
end

local function SkinMoneyWonAlert(frame)
    if not frame or frame.windStyle then return end

    S:CreateBackdropShadowAfterElvUISkins(frame)
    F.SetFontOutline(frame.Label)
    F.SetFontOutline(frame.Amount)

    frame.Label:ClearAllPoints()
    frame.Label:Point("TOPLEFT", frame.Icon, "TOPRIGHT", 12, -2)

    frame.Amount:ClearAllPoints()
    frame.Amount:Point("BOTTOMLEFT", frame.Icon, "BOTTOMRIGHT", 12, 2)

    frame.windStyle = true
end

function S:AlertFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.alertframes) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.alerts) then return end

    -- 成就
    hooksecurefunc(_G.AchievementAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.CriteriaAlertSystem, "setUpFunction", SkinCriteriaAlert)

    -- 遭遇
    hooksecurefunc(_G.DungeonCompletionAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GuildChallengeAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.InvasionAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.ScenarioAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.WorldQuestCompleteAlertSystem, "setUpFunction", SkinAlert)

    -- 要塞
    hooksecurefunc(_G.GarrisonFollowerAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonTalentAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonBuildingAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonMissionAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonShipMissionAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", SkinAlert)

    -- 荣誉
    hooksecurefunc(_G.HonorAwardedAlertSystem, "setUpFunction", SkinAlert)

    -- 拾取
    hooksecurefunc(_G.LegendaryItemAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.LootAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.LootUpgradeAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.MoneyWonAlertSystem, "setUpFunction", SkinMoneyWonAlert)

    -- 专业技能
    hooksecurefunc(_G.DigsiteCompleteAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.NewRecipeLearnedAlertSystem, "setUpFunction", SkinAlert)

    -- 宠物 / 坐骑
    hooksecurefunc(_G.NewPetAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.NewMountAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.NewToyAlertSystem, "setUpFunction", SkinAlert)

    -- 其它
    hooksecurefunc(_G.EntitlementDeliveredAlertSystem, "setUpFunction", SkinAlert)
    hooksecurefunc(_G.RafRewardDeliveredAlertSystem, "setUpFunction", SkinAlert)
end

S:AddCallback('AlertFrames')
