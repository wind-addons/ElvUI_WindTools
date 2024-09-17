local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local unpack = unpack

function S:SkinAlert(alert)
	if not alert or alert.__windSkin then
		return
	end

	self:CreateBackdropShadow(alert)

	F.SetFrameFontOutline(alert)

	if alert.EncounterIcon and alert.EncounterIcon.PortraitBorder then
		alert.EncounterIcon.PortraitBorder:Hide()
	end

	alert.__windSkin = true
end

function S:SkinAchievementAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Unlocked)
	F.SetFontOutline(frame.Name, nil, "+4")
	frame.Name.SetFont = E.noop
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

	frame.__windSkin = true
end

function S:SkinGuildChallengeAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)
	F.SetFrameFontOutline(frame)

	frame.__windSkin = true
end

function S:SkinCriteriaAlert(frame)
	if not frame or frame.__windSkin or not frame.hooked then
		return
	end

	self:CreateBackdropShadow(frame)

	frame:SetWidth(frame:GetWidth() + 10)

	F.SetFontOutline(frame.Unlocked, nil, "+1")
	F.SetFontOutline(frame.Name, nil, "+3")

	if frame.Icon.Texture.b then
		frame.Icon.Texture.b:Point("TOPLEFT", frame.Icon.Texture, "TOPLEFT", -1, 1)
		frame.Icon.Texture.b:Point("BOTTOMRIGHT", frame.Icon.Texture, "BOTTOMRIGHT", 1, -1)
		S:CreateShadow(frame.Icon.Texture.b)

		frame.Icon.Texture:ClearAllPoints()
		frame.Icon.Texture:Point("LEFT", frame.backdrop, "LEFT", 10, 0)
	end

	frame.__windSkin = true
end

function S:SkinMoneyWonAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)
	F.SetFontOutline(frame.Label)
	F.SetFontOutline(frame.Amount, nil, "+1")

	frame.Label:ClearAllPoints()
	frame.Label:Point("TOP", frame.backdrop, "TOP", 24, -5)
	frame.Label:SetJustifyH("CENTER")
	frame.Label:SetJustifyV("TOP")

	frame.Amount:ClearAllPoints()
	local xOffset = (180 - frame.Amount:GetStringWidth()) / 2
	frame.Amount:Point("BOTTOMLEFT", frame.Icon, "BOTTOMRIGHT", xOffset, 2)

	frame.__windSkin = true
end

function S:SkinNewRecipeLearnedAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)
	F.SetFontOutline(frame.Name, nil, "+4")
	F.SetFontOutline(frame.Title)

	if frame.Icon.b then
		frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
		frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
	end

	frame.__windSkin = true
end

function S:SkinInvasionAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	for _, child in pairs({ frame:GetChildren() }) do
		if child.template and child.template == "Default" then
			for _, region in pairs({ child:GetRegions() }) do
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
	for _, region in pairs({ frame:GetRegions() }) do
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
		frame.Title:SetJustifyH("CENTER")

		-- 地区
		F.SetFontOutline(frame.ZoneName, nil, "+2")
		frame.ZoneName:ClearAllPoints()
		frame.ZoneName:Point("TOP", frame.Title, "BOTTOM", 0, -5)
		frame.ZoneName:SetJustifyH("CENTER")
	end

	frame.__windSkin = true
end

function S:SkinWorldQuestCompleteAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	for _, child in pairs({ frame:GetChildren() }) do
		if child.template and child.template == "Default" then
			for _, region in pairs({ child:GetRegions() }) do
				if region.b then
					frame.Icon = region
					region:ClearAllPoints()
					region:Point("LEFT", frame.backdrop, "LEFT", 12, 0)
					break
				end
			end
		end
	end

	F.SetFontOutline(frame.ToastText, nil, "+2")
	F.SetFontOutline(frame.QuestName, nil, "+2")

	frame.__windSkin = true
end

function S:SkinLootUpgradeAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.TitleText)
	frame.TitleText:ClearAllPoints()
	frame.TitleText:Point("TOP", frame.backdrop, 30, -12)
	frame.TitleText:SetJustifyH("CENTER")
	frame.TitleText:SetJustifyV("TOP")

	local texts = { frame.BaseQualityItemName, frame.UpgradeQualityItemName, frame.WhiteText, frame.WhiteText2 }

	for _, text in pairs(texts) do
		F.SetFontOutline(text, nil, "+2")
		text:ClearAllPoints()
		text:Point("BOTTOM", frame.backdrop, 30, 12)
		text:SetJustifyH("CENTER")
		text:SetJustifyV("BOTTOM")
	end

	frame.__windSkin = true
end

function S:SkinLootAlert(frame)
	if not frame or frame.__windSkin then
		return
	end
	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Label)

	if frame.Label and frame.Label.GetNumPoints and frame.Label:GetNumPoints() == 1 then
		local point, relativeTo, relativePoint, x, y = frame.Label:GetPoint(1)
		frame.Label:ClearAllPoints()
		frame.Label:SetPoint(point, relativeTo, relativePoint, x + 1, y - 5)
	end

	F.SetFontOutline(frame.RollValue)
	F.SetFontOutline(frame.ItemName)

	frame.__windSkin = true
end

function S:SkinLegendaryItemAlert(frame)
	if not frame or frame.__windSkin then
		return
	end
	self:CreateBackdropShadow(frame)

	frame.Icon:ClearAllPoints()
	frame.Icon:Point("LEFT", frame.backdrop, "LEFT", 16, 0)

	F.SetFontOutline(frame.ItemName, nil, "+1")
	frame.ItemName:ClearAllPoints()
	frame.ItemName:Point("BOTTOM", frame.backdrop, "BOTTOM", 32, 16)
	frame.ItemName:SetJustifyH("CENTER")
	frame.ItemName:SetJustifyV("BOTTOM")

	for _, region in pairs({ frame:GetRegions() }) do
		if region:IsObjectType("FontString") and region ~= frame.ItemName then
			F.SetFontOutline(region)
			region:ClearAllPoints()
			region:Point("TOP", frame.backdrop, "TOP", 32, -16)
			region:SetJustifyH("CENTER")
			region:SetJustifyV("TOP")
			break
		end
	end

	frame.__windSkin = true
end

function S:SkinDigsiteCompleteAlert(frame)
	if not frame or frame.__windSkin then
		return
	end
	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Title)
	F.SetFontOutline(frame.DigsiteType, nil, "+2")

	frame.__windSkin = true
end

function S:SkinRafRewardDeliveredAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Title, nil, "+1")
	frame.Title:ClearAllPoints()
	frame.Title:Point("BOTTOM", frame.backdrop, "BOTTOM", 24, 16)
	frame.Title:SetJustifyH("CENTER")
	frame.Title:SetJustifyV("BOTTOM")

	F.SetFontOutline(frame.Description)
	frame.Description:ClearAllPoints()
	frame.Description:Point("TOP", frame.backdrop, "TOP", 24, -16)
	frame.Description:SetJustifyH("CENTER")
	frame.Description:SetJustifyV("TOP")

	frame.__windSkin = true
end

function S:SkinNewItemAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Label)
	frame.Label:ClearAllPoints()
	frame.Label:Point("TOP", frame.backdrop, "TOP", 32, -13)
	frame.Label:SetJustifyH("CENTER")
	frame.Label:SetJustifyV("TOP")

	F.SetFontOutline(frame.Name, nil, "+1")
	frame.Name:ClearAllPoints()
	frame.Name:Point("BOTTOM", frame.backdrop, "BOTTOM", 32, 15)
	frame.Name:SetJustifyH("CENTER")
	frame.Name:SetJustifyV("BOTTOM")

	if frame.Icon.b then
		frame.Icon.b:ClearAllPoints()
		frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
		frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
	end

	frame.__windSkin = true
end

function S:SkinGarrisonTalentAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	F.SetFontOutline(frame.Title, nil, "+5")
	frame.Title:ClearAllPoints()
	frame.Title:Point("TOP", frame.backdrop, "TOP", 26, -18)
	frame.Title:SetJustifyH("CENTER")
	frame.Title:SetJustifyV("TOP")

	F.SetFontOutline(frame.Name)
	frame.Name:ClearAllPoints()
	frame.Name:Point("BOTTOM", frame.backdrop, "BOTTOM", 26, 15)
	frame.Name:SetJustifyH("CENTER")
	frame.Name:SetJustifyV("BOTTOM")

	frame.__windSkin = true
end

function S:SkinGarrisonBuildingAlert(frame)
	if not frame or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame)

	frame.Icon:ClearAllPoints()
	frame.Icon:Point("LEFT", frame.backdrop, "LEFT", 12, 0)

	F.SetFontOutline(frame.Title, nil, "+1")
	frame.Title:ClearAllPoints()
	frame.Title:Point("TOP", frame.backdrop, "TOP", 26, -13)
	frame.Title:SetJustifyH("CENTER")
	frame.Title:SetJustifyV("TOP")

	F.SetFontOutline(frame.Name, nil, "+1")
	frame.Name:ClearAllPoints()
	frame.Name:Point("BOTTOM", frame.backdrop, "BOTTOM", 26, 15)
	frame.Name:SetJustifyH("CENTER")
	frame.Name:SetJustifyV("BOTTOM")

	frame.__windSkin = true
end

function S:SkinAlertRewardIcons(frame)
	if frame.RewardFrames then
		for i = 1, frame.numUsedRewardFrames do
			local reward = frame.RewardFrames[i]
			if not reward.__windSkin then
				for _, region in pairs({ reward:GetRegions() }) do
					if region:GetObjectType() == "Texture" and region:GetTexture() == 337498 then
						region:SetTexture("")
					end
				end

				reward.texture:SetMask("")
				reward.texture:SetTexCoord(unpack(E.TexCoords))
				reward.texture:ClearAllPoints()
				reward.texture:SetInside(reward, 7, 7)
				reward.texture:CreateBackdrop()
				self:CreateBackdropShadow(reward.texture)
				reward.__windSkin = true
			end
		end
	end
end

function S:AlertFrames()
	if not self:CheckDB("alertframes", "alerts") then
		return
	end

	-- Achievements
	self:SecureHook(_G.AchievementAlertSystem, "setUpFunction", "SkinAchievementAlert")
	self:SecureHook(_G.CriteriaAlertSystem, "setUpFunction", "SkinCriteriaAlert")
	self:SecureHook(_G.MonthlyActivityAlertSystem, "setUpFunction", "SkinCriteriaAlert")

	-- Encounters
	self:SecureHook(_G.DungeonCompletionAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.GuildChallengeAlertSystem, "setUpFunction", "SkinGuildChallengeAlert")
	self:SecureHook(_G.InvasionAlertSystem, "setUpFunction", "SkinInvasionAlert")
	self:SecureHook(_G.ScenarioAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.WorldQuestCompleteAlertSystem, "setUpFunction", "SkinWorldQuestCompleteAlert")

	-- Garrisons
	self:SecureHook(_G.GarrisonFollowerAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.GarrisonTalentAlertSystem, "setUpFunction", "SkinGarrisonTalentAlert")
	self:SecureHook(_G.GarrisonBuildingAlertSystem, "setUpFunction", "SkinGarrisonBuildingAlert")
	self:SecureHook(_G.GarrisonMissionAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.GarrisonShipMissionAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", "SkinAlert")

	-- Loot
	self:SecureHook(_G.LegendaryItemAlertSystem, "setUpFunction", "SkinLegendaryItemAlert")
	self:SecureHook(_G.LootAlertSystem, "setUpFunction", "SkinLootAlert")
	self:SecureHook(_G.LootUpgradeAlertSystem, "setUpFunction", "SkinLootUpgradeAlert")
	self:SecureHook(_G.MoneyWonAlertSystem, "setUpFunction", "SkinMoneyWonAlert")
	self:SecureHook(_G.HonorAwardedAlertSystem, "setUpFunction", "SkinMoneyWonAlert")
	self:SecureHook(_G.EntitlementDeliveredAlertSystem, "setUpFunction", "SkinAlert")
	self:SecureHook(_G.RafRewardDeliveredAlertSystem, "setUpFunction", "SkinRafRewardDeliveredAlert")

	-- Professions
	self:SecureHook(_G.DigsiteCompleteAlertSystem, "setUpFunction", "SkinDigsiteCompleteAlert")
	self:SecureHook(_G.NewRecipeLearnedAlertSystem, "setUpFunction", "SkinNewRecipeLearnedAlert")

	-- Pets/Mounts
	self:SecureHook(_G.NewPetAlertSystem, "setUpFunction", "SkinNewItemAlert")
	self:SecureHook(_G.NewMountAlertSystem, "setUpFunction", "SkinNewItemAlert")
	self:SecureHook(_G.NewToyAlertSystem, "setUpFunction", "SkinNewItemAlert")

	-- Cosmetics
	self:SecureHook(_G.NewCosmeticAlertFrameSystem, "setUpFunction", "SkinNewItemAlert")

	-- Reward Icons
	self:SecureHook("StandardRewardAlertFrame_AdjustRewardAnchors", "SkinAlertRewardIcons")
end

S:AddCallback("AlertFrames")
