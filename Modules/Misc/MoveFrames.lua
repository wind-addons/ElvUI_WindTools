local W, F, E, L = unpack((select(2, ...)))
local MF = W.Modules.MoveFrames
local B = E:GetModule("Bags")

local _G = _G
local pairs = pairs
local strsplit = strsplit
local tDeleteItem = tDeleteItem
local type = type

local GenerateFlatClosure = GenerateFlatClosure
local InCombatLockdown = InCombatLockdown
local RunNextFrame = RunNextFrame

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local BlizzardFrames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"BonusRollFrame",
	"ChatConfigFrame",
	"CinematicFrame",
	"ContainerFrameCombinedBags",
	"DestinyFrame",
	"FriendsFrame",
	"GameMenuFrame",
	"GossipFrame",
	"GuildInviteFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"ItemTextFrame",
	"LFDRoleCheckPopup",
	"LFGDungeonReadyDialog",
	"LFGDungeonReadyStatus",
	"LootFrame",
	"MerchantFrame",
	"PetitionFrame",
	"PetStableFrame",
	"ReportFrame",
	"PVEFrame",
	"PVPReadyDialog",
	"QuestFrame",
	"QuestLogPopupDetailFrame",
	"RaidBrowserFrame",
	"RaidParentFrame",
	"ReadyCheckFrame",
	"RecruitAFriendRewardsFrame",
	"ReportCheatingDialog",
	"SettingsPanel",
	"SplashFrame",
	"TabardFrame",
	"TaxiFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	["DressUpFrame"] = {
		"DressUpFrame.OutfitDetailsPanel",
	},
	["MailFrame"] = {
		"SendMailFrame",
		"MailFrameInset",
		["OpenMailFrame"] = {
			"OpenMailFrame.OpenMailSender",
			"OpenMailFrame.OpenMailFrameInset",
		},
	},
	["WorldMapFrame"] = {
		"QuestMapFrame",
	},
}

local BlizzardFramesOnDemand = {
	["Blizzard_AchievementUI"] = {
		["AchievementFrame"] = {
			"AchievementFrame.Header",
			"AchievementFrame.SearchResults",
		},
	},
	["Blizzard_AlliedRacesUI"] = {
		"AlliedRacesFrame",
	},
	["Blizzard_ArchaeologyUI"] = {
		"ArchaeologyFrame",
	},
	["Blizzard_ArtifactUI"] = {
		"ArtifactFrame",
	},
	["Blizzard_AuctionHouseUI"] = {
		"AuctionHouseFrame",
	},
	["Blizzard_AzeriteEssenceUI"] = {
		"AzeriteEssenceUI",
	},
	["Blizzard_AzeriteRespecUI"] = {
		"AzeriteRespecFrame",
	},
	["Blizzard_AzeriteUI"] = {
		"AzeriteEmpoweredItemUI",
	},
	["Blizzard_BindingUI"] = {
		"KeyBindingFrame",
	},
	["Blizzard_BlackMarketUI"] = {
		"BlackMarketFrame",
	},
	["Blizzard_Calendar"] = {
		["CalendarFrame"] = {
			"CalendarCreateEventFrame",
			"CalendarCreateEventInviteListScrollFrame",
			"CalendarViewEventFrame",
			"CalendarViewEventFrame.HeaderFrame",
			"CalendarViewEventInviteListScrollFrame",
			"CalendarViewHolidayFrame",
		},
	},
	["Blizzard_ChallengesUI"] = {
		"ChallengesKeystoneFrame",
	},
	["Blizzard_Channels"] = {
		"ChannelFrame",
		"CreateChannelPopup",
	},
	["Blizzard_ClickBindingUI"] = {
		["ClickBindingFrame"] = {
			"ClickBindingFrame.ScrollBox",
		},
		"ClickBindingFrame.TutorialFrame",
	},
	["Blizzard_ChromieTimeUI"] = {
		"ChromieTimeFrame",
	},
	["Blizzard_Collections"] = {
		"CollectionsJournal",
		"WardrobeFrame",
	},
	["Blizzard_Communities"] = {
		"ClubFinderGuildFinderFrame.RequestToJoinFrame",
		"ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame",
		["CommunitiesFrame"] = {
			"CommunitiesFrame.GuildMemberDetailFrame",
			"CommunitiesFrame.NotificationSettingsDialog",
		},
		"CommunitiesFrame.RecruitmentDialog",
		"CommunitiesSettingsDialog",
		"CommunitiesGuildLogFrame",
		"CommunitiesGuildNewsFiltersFrame",
		"CommunitiesGuildTextEditFrame",
	},
	["Blizzard_Contribution"] = {
		"ContributionCollectionFrame",
	},
	["Blizzard_CovenantPreviewUI"] = {
		"CovenantPreviewFrame",
	},
	["Blizzard_CovenantRenown"] = {
		"CovenantRenownFrame",
	},
	["Blizzard_CovenantSanctum"] = {
		"CovenantSanctumFrame",
	},
	["Blizzard_DeathRecap"] = {
		"DeathRecapFrame",
	},
	["Blizzard_DelvesCompanionConfiguration"] = {
		"DelvesCompanionConfigurationFrame",
		"DelvesCompanionAbilityListFrame",
	},
	["Blizzard_EncounterJournal"] = {
		["EncounterJournal"] = {
			"EncounterJournal.instanceSelect.ScrollBox",
			"EncounterJournal.encounter.info.overviewScroll",
			"EncounterJournal.encounter.info.detailsScroll",
		},
	},
	["Blizzard_ExpansionLandingPage"] = {
		"ExpansionLandingPage",
	},
	["Blizzard_FlightMap"] = {
		"FlightMapFrame",
	},
	["Blizzard_GarrisonUI"] = {
		"GarrisonBuildingFrame",
		"GarrisonCapacitiveDisplayFrame",
		"GarrisonMissionFrame",
		"GarrisonMonumentFrame",
		"GarrisonRecruiterFrame",
		"GarrisonRecruitSelectFrame",
		"GarrisonShipyardFrame",
		"OrderHallMissionFrame",
		"BFAMissionFrame",
		["CovenantMissionFrame"] = {
			"CovenantMissionFrame.MissionTab",
			"CovenantMissionFrame.MissionTab.MissionPage",
			"CovenantMissionFrame.MissionTab.MissionPage.CostFrame",
			"CovenantMissionFrame.MissionTab.MissionPage.StartMissionFrame",
			"CovenantMissionFrame.MissionTab.MissionList.MaterialFrame",
			"CovenantMissionFrame.FollowerList.listScroll",
			"CovenantMissionFrame.FollowerList.MaterialFrame",
		},
		["GarrisonLandingPage"] = {
			"GarrisonLandingPageReportListListScrollFrame",
			"GarrisonLandingPageFollowerListListScrollFrame",
		},
	},
	["Blizzard_GenericTraitUI"] = {
		["GenericTraitFrame"] = {
			"GenericTraitFrame.ButtonsParent",
		},
	},
	["Blizzard_GMChatUI"] = {
		"GMChatStatusFrame",
	},
	["Blizzard_GuildBankUI"] = {
		"GuildBankFrame",
	},
	["Blizzard_GuildControlUI"] = {
		"GuildControlUI",
	},
	["Blizzard_GuildUI"] = {
		"GuildFrame",
	},
	["Blizzard_InspectUI"] = {
		"InspectFrame",
	},
	["Blizzard_IslandsPartyPoseUI"] = {
		"IslandsPartyPoseFrame",
	},
	["Blizzard_IslandsQueueUI"] = {
		"IslandsQueueFrame",
	},
	["Blizzard_ItemAlterationUI"] = {
		"TransmogrifyFrame",
	},
	["Blizzard_ItemInteractionUI"] = {
		"ItemInteractionFrame",
	},
	["Blizzard_ItemSocketingUI"] = {
		"ItemSocketingFrame",
	},
	["Blizzard_ItemUpgradeUI"] = {
		"ItemUpgradeFrame",
	},
	["Blizzard_LookingForGuildUI"] = {
		"LookingForGuildFrame",
	},
	["Blizzard_MacroUI"] = {
		"MacroFrame",
	},
	["Blizzard_MajorFactions"] = {
		"MajorFactionRenownFrame",
	},
	["Blizzard_ObliterumUI"] = {
		"ObliterumForgeFrame",
	},
	["Blizzard_OrderHallUI"] = {
		"OrderHallTalentFrame",
	},
	["Blizzard_PlayerSpells"] = {
		"HeroTalentsSelectionDialog",
		["PlayerSpellsFrame"] = {
			"PlayerSpellsFrame.TalentsFrame.ButtonsParent",
			"PlayerSpellsFrame.SpecFrame.DisabledOverlay",
		},
	},
	["Blizzard_PlayerChoice"] = {
		"PlayerChoiceFrame",
	},
	["Blizzard_Professions"] = {
		["ProfessionsFrame"] = {
			"ProfessionsFrame.CraftingPage.CraftingOutputLog",
			"ProfessionsFrame.CraftingPage.CraftingOutputLog.ScrollBox",
		},
	},
	["Blizzard_ProfessionsBook"] = {
		"ProfessionsBookFrame",
	},
	["Blizzard_ProfessionsCustomerOrders"] = {
		["ProfessionsCustomerOrdersFrame"] = {
			"ProfessionsCustomerOrdersFrame.Form",
			"ProfessionsCustomerOrdersFrame.Form.CurrentListings",
		},
	},
	["Blizzard_PVPMatch"] = {
		"PVPMatchResults",
	},
	["Blizzard_PVPUI"] = {
		"PVPMatchScoreboard",
	},
	["Blizzard_ReforgingUI"] = {
		"ReforgingFrame",
	},
	["Blizzard_ScrappingMachineUI"] = {
		"ScrappingMachineFrame",
	},
	["Blizzard_Soulbinds"] = {
		"SoulbindViewer",
	},
	["Blizzard_StableUI"] = {
		"StableFrame",
	},
	["Blizzard_SubscriptionInterstitialUI"] = {
		"SubscriptionInterstitialFrame",
	},
	["Blizzard_TalentUI"] = {
		"PlayerTalentFrame",
	},
	["Blizzard_TimeManager"] = {
		"TimeManagerFrame",
	},
	["Blizzard_TorghastLevelPicker"] = {
		"TorghastLevelPickerFrame",
	},
	["Blizzard_TrainerUI"] = {
		"ClassTrainerFrame",
	},
	["Blizzard_UIPanels_Game"] = {
		"CurrencyTransferMenu",
		["CharacterFrame"] = {
			"PaperDollFrame",
			"ReputationFrame",
			"TokenFrame",
			"TokenFramePopup",
		},
	},
	["Blizzard_VoidStorageUI"] = {
		"VoidStorageFrame",
	},
	["Blizzard_WarboardUI"] = {
		"WarboardQuestChoiceFrame",
	},
	["Blizzard_WarfrontsPartyPoseUI"] = {
		"WarfrontsPartyPoseFrame",
	},
	["Blizzard_WeeklyRewards"] = {
		"WeeklyRewardsFrame",
	},
}

local ignorePositionRememberingFrames = {
	["BonusRollFrame"] = true,
	["PlayerChoiceFrame"] = true,
}

local function getFrame(frameOrName)
	local frame

	if frameOrName then
		if frameOrName.GetName then
			frame = frameOrName
		else
			frame = _G
			local path = { strsplit(".", frameOrName) }
			for i = 1, #path do
				frame = frame[path[i]]
			end
		end
	end

	return frame
end

function MF:Remember(frame)
	if not self.db.rememberPositions or self.StopRunning then
		return
	end

	local path = frame.__windFramePath
	if not path or path == "" or ignorePositionRememberingFrames[path] then
		return
	end

	local numPoints = frame:GetNumPoints()
	if numPoints and numPoints > 0 then
		self.db.framePositions[path] = {}
		for index = 1, numPoints do
			local anchorPoint, relativeFrame, relativePoint, offX, offY = frame:GetPoint(index)
			self.db.framePositions[path][index] = {
				anchorPoint = anchorPoint,
				relativeFrame = relativeFrame,
				relativePoint = relativePoint,
				offX = offX,
				offY = offY,
			}
		end
	end
end

function MF:Reposition(frame, anchorPoint, relativeFrame, relativePoint, offX, offY, skip)
	if skip or InCombatLockdown() or not self.db or not self.db.rememberPositions or self.StopRunning then
		return
	end

	local path = frame.__windFramePath

	if path == "" or ignorePositionRememberingFrames[path] then
		self.db.framePositions[path] = nil
		return
	end

	if not path or not self.db.framePositions[path] or #self.db.framePositions[path] == 0 then
		return
	end

	frame:ClearAllPoints()
	for _, point in pairs(self.db.framePositions[path]) do
		frame:SetPoint(point.anchorPoint, point.relativeFrame, point.relativePoint, point.offX, point.offY, true)
	end
end

function MF:Frame_StartMoving(this, button)
	if InCombatLockdown() and this:IsProtected() then
		return
	end

	if button == "LeftButton" and this.MoveFrame:IsMovable() then
		this.MoveFrame:StartMoving()
	end
end

function MF:Frame_StopMoving(this, button)
	if InCombatLockdown() and this:IsProtected() then
		return
	end

	if button == "LeftButton" then
		this.MoveFrame:StopMovingOrSizing()
		MF:Remember(this.MoveFrame)
	end
end

function MF:HandleFrame(this, bindingTarget)
	local thisFrame = getFrame(this)
	local bindingTargetFrame = getFrame(bindingTarget)

	if not thisFrame or thisFrame.MoveFrame then
		return
	end

	if InCombatLockdown() and thisFrame:IsProtected() then
		F.TaskManager:AfterCombat(function()
			self:HandleFrame(this, bindingTarget)
			-- Manually trigger a reposition after combat ends
			-- Some frames may need to run the fix function first, so reposition should be run next frame to avoid issues
			RunNextFrame(function()
				local thisFrame = getFrame(this)
				if thisFrame and thisFrame.MoveFrame then
					self:Reposition(thisFrame.MoveFrame)
				end
			end)
		end)
		return
	end

	thisFrame:SetMovable(true)
	thisFrame:SetClampedToScreen(true)
	thisFrame:EnableMouse(true)
	thisFrame.MoveFrame = bindingTargetFrame or thisFrame

	thisFrame.__windFramePath = this
	if not thisFrame.MoveFrame.__windFramePath then
		thisFrame.MoveFrame.__windFramePath = bindingTarget
	end

	self:SecureHookScript(thisFrame, "OnMouseDown", "Frame_StartMoving")
	self:SecureHookScript(thisFrame, "OnMouseUp", "Frame_StopMoving")

	if not self:IsHooked(thisFrame.MoveFrame, "SetPoint") then
		self:SecureHook(thisFrame.MoveFrame, "SetPoint", "Reposition")
	end
end

function MF:HandleFramesWithTable(table, parent)
	for key, value in pairs(table) do
		if type(key) == "number" and type(value) == "string" then
			self:HandleFrame(value, parent)
		elseif type(key) == "string" and type(value) == "table" then
			self:HandleFrame(key, parent)
			self:HandleFramesWithTable(value, key)
		end
	end
end

function MF:HandleAddon(_, addon)
	local frameTable = BlizzardFramesOnDemand[addon]

	if not frameTable then
		return
	end

	self:HandleFramesWithTable(frameTable)

	-- fix from BlizzMove
	F.TaskManager:OutOfCombat(function()
		if addon == "Blizzard_Collections" then
			local checkbox = _G.WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox
			checkbox.Label:ClearAllPoints()
			checkbox.Label:SetPoint("LEFT", checkbox, "RIGHT", 2, 1)
			checkbox.Label:SetPoint("RIGHT", checkbox, "RIGHT", 160, 1)
		elseif addon == "Blizzard_EncounterJournal" then
			local replacement = function(rewardFrame)
				if rewardFrame.data then
					_G.EncounterJournalTooltip:ClearAllPoints()
				end
				self.hooks.AdventureJournal_Reward_OnEnter(rewardFrame)
			end
			self:RawHook("AdventureJournal_Reward_OnEnter", replacement, true)
			self:RawHookScript(_G.EncounterJournal.suggestFrame.Suggestion1.reward, "OnEnter", replacement)
			self:RawHookScript(_G.EncounterJournal.suggestFrame.Suggestion2.reward, "OnEnter", replacement)
			self:RawHookScript(_G.EncounterJournal.suggestFrame.Suggestion3.reward, "OnEnter", replacement)
		elseif addon == "Blizzard_Communities" then
			local dialog = _G.CommunitiesFrame.NotificationSettingsDialog
			if dialog then
				dialog:ClearAllPoints()
				dialog:SetAllPoints()
			end
		elseif addon == "Blizzard_PlayerChoice" and _G.PlayerChoiceFrame then
			_G.PlayerChoiceFrame:HookScript("OnHide", function()
				if not InCombatLockdown() or not _G.PlayerChoiceFrame:IsProtected() then
					_G.PlayerChoiceFrame:ClearAllPoints()
				end
			end)
		elseif addon == "Blizzard_PlayerSpells" and _G.HeroTalentsSelectionDialog and _G.PlayerSpellsFrame then
			local function startStopMoving(frame)
				if InCombatLockdown() and frame:IsProtected() then
					return
				end
				local backup = frame:IsMovable()
				frame:SetMovable(true)
				frame:StartMoving()
				frame:StopMovingOrSizing()
				frame:SetMovable(backup)
			end

			startStopMoving(_G.HeroTalentsSelectionDialog)
			_G.PlayerSpellsFrame:HookScript("OnShow", function(frame)
				startStopMoving(frame)
				RunNextFrame(GenerateFlatClosure(startStopMoving, frame))
			end)
			_G.HeroTalentsSelectionDialog:HookScript("OnShow", function(frame)
				startStopMoving(frame)
				RunNextFrame(GenerateFlatClosure(startStopMoving, frame))
			end)
		end
	end)
end

function MF:HandleElvUIBag(frameName)
	if not self.db.elvUIBags then
		return
	end
	local frame = B[frameName]

	if not frame or frame.__windFramePath then
		return
	end

	frame:SetScript("OnDragStart", function(frame)
		frame:StartMoving()
	end)

	if frame.helpButton then
		frame.helpButton:SetScript("OnEnter", function(frame)
			local GameTooltip = _G.GameTooltip
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, 4)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(L["Drag"] .. ":", L["Temporary Move"], 1, 1, 1)
			GameTooltip:AddDoubleLine(L["Hold Control + Right Click:"], L["Reset Position"], 1, 1, 1)
			GameTooltip:Show()
		end)
	end

	frame.__windFramePath = "ElvUI_" .. frameName
end

function MF:IsRunning()
	return E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning
end

function MF:InternalHandle(frame, bindingTarget, remember)
	if not self:IsRunning() then
		return
	end

	self:HandleFrame(frame, bindingTarget)

	if remember == false then
		frame.__windFramePath = ""
	end
end

function MF:Initialize()
	if C_AddOns_IsAddOnLoaded("BlizzMove") then
		self.StopRunning = "BlizzMove"
		return
	end

	if C_AddOns_IsAddOnLoaded("MoveAnything") then
		self.StopRunning = "MoveAnything"
		return
	end

	self.db = E.private.WT.misc.moveFrames
	if not self.db or not self.db.enable then
		return
	end

	-- Trade Skill Master Speical Handling
	if C_AddOns_IsAddOnLoaded("TradeSkillMaster") and self.db.tradeSkillMasterCompatible then
		tDeleteItem(BlizzardFrames, "MerchantFrame")
	end

	-- ElvUI Mail Frame Speical Handling
	if _G.MailFrameInset then
		_G.OpenMailFrameInset:SetParent(_G.OpenMailFrame)
		_G.MailFrameInset:SetParent(_G.MailFrame)
	end

	-- Setup Blizzard Frames that are always loaded
	self:HandleFramesWithTable(BlizzardFrames)

	if _G.BattlefieldFrame and _G.PVPParentFrame then
		_G.BattlefieldFrame:SetParent(_G.PVPParentFrame)
		_G.BattlefieldFrame:ClearAllPoints()
		_G.BattlefieldFrame:SetAllPoints()
	end

	-- Setup Blizzard Frames that are loaded on demand
	self:RegisterEvent("ADDON_LOADED", "HandleAddon")
	for addon in pairs(BlizzardFramesOnDemand) do
		if C_AddOns_IsAddOnLoaded(addon) then
			self:HandleAddon(nil, addon)
		end
	end

	-- ElvUI Bag & Bank Frames
	F.TaskManager:OutOfCombat(self.HandleElvUIBag, self, "BagFrame")
	F.TaskManager:OutOfCombat(self.HandleElvUIBag, self, "BankFrame")

	local GetBagsShown = _G.ContainerFrameSettingsManager.GetBagsShown
	self:SecureHook(_G.ContainerFrameSettingsManager, "GetBagsShown", function()
		for _, bag in pairs(GetBagsShown(_G.ContainerFrameSettingsManager) or {}) do
			bag:ClearAllPoints()
		end
	end)
end

W:RegisterModule(MF:GetName())
