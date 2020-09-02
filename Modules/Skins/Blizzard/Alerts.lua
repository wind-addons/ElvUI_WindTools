local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

function S:SkinAlert(alert)
    if not alert or alert.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(alert)

    F.SetFrameFontOutline(alert)

    alert.windStyle = true
end

function S:SkinAchievementAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Unlocked)
    F.SetFontOutline(frame.Name, nil, "+2")
    F.SetFontOutline(frame.GuildName)

    if frame.Icon.Texture.b then
        frame.Icon.Texture.b:Point("TOPLEFT", frame.Icon.Texture, "TOPLEFT", -1, 1)
        frame.Icon.Texture.b:Point("BOTTOMRIGHT", frame.Icon.Texture, "BOTTOMRIGHT", 1, -1)
    end

    frame.Name:ClearAllPoints()
    frame.Name:Point("TOP", frame.Unlocked, "BOTTOM", 0, -5)

    frame.GuildBanner:ClearAllPoints()
    frame.GuildBanner:Point("TOPRIGHT", frame, "TOPRIGHT", -13, -12)

    frame.GuildBorder:ClearAllPoints()
    frame.GuildBorder:Point("TOPRIGHT", frame, "TOPRIGHT", -13, -12)

    frame.windStyle = true
end

function S:SkinGuildChallengeAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)
    F.SetFrameFontOutline(frame)

    frame.windStyle = true
end

function S:SkinCriteriaAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

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

function S:SkinMoneyWonAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)
    F.SetFontOutline(frame.Label)
    F.SetFontOutline(frame.Amount, nil, "+1")

    frame.Label:ClearAllPoints()
    frame.Label:Point("TOP", frame.backdrop, "TOP", 24, -5)
    frame.Label:SetJustifyH("MIDDLE")
    frame.Label:SetJustifyV("TOP")

    frame.Amount:ClearAllPoints()
    local xOffset = (180 - frame.Amount:GetStringWidth()) / 2
    frame.Amount:Point("BOTTOMLEFT", frame.Icon, "BOTTOMRIGHT", xOffset, 2)

    frame.windStyle = true
end

function S:SkinNewRecipeLearnedAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)
    F.SetFontOutline(frame.Name)
    F.SetFontOutline(frame.Title, nil, "+2")

    if frame.Icon.b then
        frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
        frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
    end

    frame.windStyle = true
end

function S:SkinInvasionAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    for _, child in pairs({frame:GetChildren()}) do
        if child.template and child.template == "Default" then
            for _, region in pairs({child:GetRegions()}) do
                if region.b then
                    frame.Icon = region
                    region:ClearAllPoints()
                    region:Point("LEFT", frame.backdrop, "LEFT", 18, 0)
                    break
                end
            end
        end
    end

    frame.BonusStar:ClearAllPoints()
    frame.BonusStar:Point("RIGHT", frame.backdrop, "RIGHT", -10, 0)

    -- 完成标题
    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") then
            if region ~= frame.ZoneName then
                frame.Title = region
                break
            end
        end
    end

    if frame.Title then
        F.SetFontOutline(frame.Title)
        frame.Title:ClearAllPoints()
        frame.Title:Point("TOP", frame.backdrop, "TOP", 23, -31)
        frame.Title:SetJustifyH("MIDDLE")

        -- 地区
        F.SetFontOutline(frame.ZoneName, nil, "+2")
        frame.ZoneName:ClearAllPoints()
        frame.ZoneName:Point("TOP", frame.Title, "BOTTOM", 0, -5)
        frame.ZoneName:SetJustifyH("MIDDLE")
    end

    frame.windStyle = true
end

function S:SkinWorldQuestCompleteAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    for _, child in pairs({frame:GetChildren()}) do
        if child.template and child.template == "Default" then
            for _, region in pairs({child:GetRegions()}) do
                if region.b then
                    frame.Icon = region
                    region:ClearAllPoints()
                    region:Point("LEFT", frame.backdrop, "LEFT", 12, 0)
                    break
                end
            end
        end
    end

    F.SetFontOutline(frame.ToastText)
    F.SetFontOutline(frame.QuestName, nil, "+2")

    frame.windStyle = true
end

function S:SkinLootUpgradeAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.TitleText)
    frame.TitleText:ClearAllPoints()
    frame.TitleText:Point("TOP", frame.backdrop, 30, -12)
    frame.TitleText:SetJustifyH("MIDDLE")
    frame.TitleText:SetJustifyV("TOP")

    local texts = {frame.BaseQualityItemName, frame.UpgradeQualityItemName, frame.WhiteText, frame.WhiteText2}

    for _, text in pairs(texts) do
        F.SetFontOutline(text, nil, "+2")
        text:ClearAllPoints()
        text:Point("BOTTOM", frame.backdrop, 30, 12)
        text:SetJustifyH("MIDDLE")
        text:SetJustifyV("BOTTOM")
    end

    frame.windStyle = true
end

function S:SkinLootAlert(frame)
    if not frame or frame.windStyle then
        return
    end
    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Label)
    F.SetFontOutline(frame.RollValue)
    F.SetFontOutline(frame.ItemName)

    frame.windStyle = true
end

function S:SkinLegendaryItemAlert(frame)
    if not frame or frame.windStyle then
        return
    end
    self:CreateBackdropShadowAfterElvUISkins(frame)

    frame.Icon:ClearAllPoints()
    frame.Icon:Point("LEFT", frame.backdrop, "LEFT", 16, 0)

    F.SetFontOutline(frame.ItemName, nil, "+1")
    frame.ItemName:ClearAllPoints()
    frame.ItemName:Point("BOTTOM", frame.backdrop, "BOTTOM", 32, 16)
    frame.ItemName:SetJustifyH("MIDDLE")
    frame.ItemName:SetJustifyV("BOTTOM")

    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") and region ~= frame.ItemName then
            F.SetFontOutline(region)
            region:ClearAllPoints()
            region:Point("TOP", frame.backdrop, "TOP", 32, -16)
            region:SetJustifyH("MIDDLE")
            region:SetJustifyV("TOP")
            break
        end
    end

    frame.windStyle = true
end

function S:SkinDigsiteCompleteAlert(frame)
    if not frame or frame.windStyle then
        return
    end
    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Title)
    F.SetFontOutline(frame.DigsiteType, nil, "+2")

    frame.windStyle = true
end

function S:SkinRafRewardDeliveredAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Title, nil, "+1")
    frame.Title:ClearAllPoints()
    frame.Title:Point("BOTTOM", frame.backdrop, "BOTTOM", 24, 16)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetJustifyV("BOTTOM")

    F.SetFontOutline(frame.Description)
    frame.Description:ClearAllPoints()
    frame.Description:Point("TOP", frame.backdrop, "TOP", 24, -16)
    frame.Description:SetJustifyH("MIDDLE")
    frame.Description:SetJustifyV("TOP")

    frame.windStyle = true
end

function S:SkinNewItemAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    F.SetFontOutline(frame.Label)
    frame.Label:ClearAllPoints()
    frame.Label:Point("TOP", frame.backdrop, "TOP", 32, -13)
    frame.Label:SetJustifyH("MIDDLE")
    frame.Label:SetJustifyV("TOP")

    F.SetFontOutline(frame.Name, nil, "+1")
    frame.Name:ClearAllPoints()
    frame.Name:Point("BOTTOM", frame.backdrop, "BOTTOM", 32, 15)
    frame.Name:SetJustifyH("MIDDLE")
    frame.Name:SetJustifyV("BOTTOM")

    if frame.Icon.b then
        frame.Icon.b:ClearAllPoints()
        frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
        frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
    end

    frame.windStyle = true
end

function S:SkinGarrisonBuildingAlert(frame)
    if not frame or frame.windStyle then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(frame)

    frame.Icon:ClearAllPoints()
    frame.Icon:Point("LEFT", frame.backdrop, "LEFT", 12, 0)

    F.SetFontOutline(frame.Title, nil, "+1")
    frame.Title:ClearAllPoints()
    frame.Title:Point("TOP", frame.backdrop, "TOP", 26, -13)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetJustifyV("TOP")

    F.SetFontOutline(frame.Name, nil, "+1")
    frame.Name:ClearAllPoints()
    frame.Name:Point("BOTTOM", frame.backdrop, "BOTTOM", 26, 15)
    frame.Name:SetJustifyH("MIDDLE")
    frame.Name:SetJustifyV("BOTTOM")

    frame.windStyle = true
end

function S:AlertFrames()
    if not self:CheckDB("alertframes", "alerts") then
        return
    end

    -- 成就
    self:SecureHook(_G.AchievementAlertSystem, "setUpFunction", "SkinAchievementAlert")
    self:SecureHook(_G.CriteriaAlertSystem, "setUpFunction", "SkinCriteriaAlert")

    -- 遭遇
    self:SecureHook(_G.DungeonCompletionAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GuildChallengeAlertSystem, "setUpFunction", "SkinGuildChallengeAlert")
    self:SecureHook(_G.InvasionAlertSystem, "setUpFunction", "SkinInvasionAlert")
    self:SecureHook(_G.ScenarioAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.WorldQuestCompleteAlertSystem, "setUpFunction", "SkinWorldQuestCompleteAlert")

    -- 要塞
    self:SecureHook(_G.GarrisonFollowerAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GarrisonTalentAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GarrisonBuildingAlertSystem, "setUpFunction", "SkinGarrisonBuildingAlert")
    self:SecureHook(_G.GarrisonMissionAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GarrisonShipMissionAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", "SkinAlert")

    -- 拾取
    self:SecureHook(_G.LegendaryItemAlertSystem, "setUpFunction", "SkinLegendaryItemAlert")
    self:SecureHook(_G.LootAlertSystem, "setUpFunction", "SkinLootAlert")
    self:SecureHook(_G.LootUpgradeAlertSystem, "setUpFunction", "SkinLootUpgradeAlert")
    self:SecureHook(_G.MoneyWonAlertSystem, "setUpFunction", "SkinMoneyWonAlert")
    self:SecureHook(_G.HonorAwardedAlertSystem, "setUpFunction", "SkinMoneyWonAlert")

    -- 专业技能
    self:SecureHook(_G.DigsiteCompleteAlertSystem, "setUpFunction", "SkinDigsiteCompleteAlert")
    self:SecureHook(_G.NewRecipeLearnedAlertSystem, "setUpFunction", "SkinNewRecipeLearnedAlert")

    -- 宠物 / 坐骑
    self:SecureHook(_G.NewPetAlertSystem, "setUpFunction", "SkinNewItemAlert")
    self:SecureHook(_G.NewMountAlertSystem, "setUpFunction", "SkinNewItemAlert")
    self:SecureHook(_G.NewToyAlertSystem, "setUpFunction", "SkinNewItemAlert")

    -- 其它
    self:SecureHook(_G.EntitlementDeliveredAlertSystem, "setUpFunction", "SkinAlert")
    self:SecureHook(_G.RafRewardDeliveredAlertSystem, "setUpFunction", "SkinRafRewardDeliveredAlert")
end

S:AddCallback("AlertFrames")
