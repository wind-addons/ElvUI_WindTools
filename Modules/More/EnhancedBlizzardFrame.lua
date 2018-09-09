-- 原作：ElvUI_S&L 的一个增强组件
-- 原作者：ElvUI_S&L (https://www.tukui.org/addons.php?id=38)
-- 修改：houshuu
-------------------
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EBF = E:NewModule("Wind_EnhancedBlizzardFrame", 'AceHook-3.0', 'AceEvent-3.0')
local _G = _G

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing
local InCombatLockdown = InCombatLockdown

EBF.Frames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"BonusRollFrame",
	"BonusRollLootWonFrame",
	"BonusRollMoneyWonFrame",
	"CharacterFrame",
	"ChannelFrame",
	"ChatConfigFrame",
	"DressUpFrame",
	"FriendsFrame",
	"FriendsFriendsFrame",
	"GossipFrame",
	"GuildInviteFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemTextFrame",
	"LFDRoleCheckPopup",
	"LFGDungeonReadyDialog",
	"LFGDungeonReadyStatus",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"OpenMailFrame",
	"PVEFrame",
	"PetStableFrame",
	"PetitionFrame",
	"QuestFrame",
	"QuestLogPopupDetailFrame",
	"RaidBrowserFrame",
	"RaidInfoFrame",
	"RaidParentFrame",
	"ReadyCheckFrame",
	"ReportCheatingDialog",
	"RolePollPopup",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"SplashFrame",
	"StackSplitFrame",
	-- "StaticPopup1",
	"StaticPopup2",
	"StaticPopup3",
	"StaticPopup4",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"WorldMapFrame",
	"GameMenuFrame",
	"PVPReadyDialog",
}
EBF.AddonsList = {
	["Blizzard_AchievementUI"] = { "AchievementFrame" },
	["Blizzard_ArchaeologyUI"] = { "ArchaeologyFrame" },
	["Blizzard_AuctionUI"] = { "AuctionFrame" },
	["Blizzard_BarberShopUI"] = { "BarberShopFrame" },
	["Blizzard_BindingUI"] = { "KeyBindingFrame" },
	["Blizzard_BlackMarketUI"] = { "BlackMarketFrame" },
	["Blizzard_Calendar"] = { "CalendarCreateEventFrame", "CalendarFrame", "CalendarViewEventFrame", "CalendarViewHolidayFrame" },
	["Blizzard_ChallengesUI"] = { "ChallengesKeystoneFrame" }, -- 'ChallengesLeaderboardFrame'
	["Blizzard_Collections"] = { "CollectionsJournal" },
	["Blizzard_Communities"] = { "CommunitiesFrame", "CommunitiesGuildLogFrame","CommunitiesGuildRecruitmentFrame","CommunitiesSettingsDialog"},
	["Blizzard_EncounterJournal"] = { "EncounterJournal" },
	["Blizzard_GarrisonUI"] = { "GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame", "GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame", "GarrisonShipyardFrame" },
	["Blizzard_GMChatUI"] = { "GMChatStatusFrame" },
	["Blizzard_GMSurveyUI"] = { "GMSurveyFrame" },
	["Blizzard_GuildBankUI"] = { "GuildBankFrame" },
	["Blizzard_GuildControlUI"] = { "GuildControlUI" },
	["Blizzard_GuildUI"] = { "GuildFrame", "GuildLogFrame" },
	["Blizzard_InspectUI"] = { "InspectFrame" },
	["Blizzard_ItemAlterationUI"] = { "TransmogrifyFrame" },
	["Blizzard_ItemSocketingUI"] = { "ItemSocketingFrame" },
	["Blizzard_ItemUpgradeUI"] = { "ItemUpgradeFrame" },
	["Blizzard_LookingForGuildUI"] = { "LookingForGuildFrame" },
	["Blizzard_MacroUI"] = { "MacroFrame" },
	["Blizzard_OrderHallUI"] = { "OrderHallTalentFrame" },
	["Blizzard_QuestChoice"] = { "QuestChoiceFrame" },
	["Blizzard_TalentUI"] = { "PlayerTalentFrame" },
	-- ["Blizzard_TalkingHeadUI"] = { "TalkingHeadFrame" },
	["Blizzard_TradeSkillUI"] = { "TradeSkillFrame" },
	["Blizzard_TrainerUI"] = { "ClassTrainerFrame" },
	["Blizzard_VoidStorageUI"] = { "VoidStorageFrame" },
	["Blizzard_ScrappingMachineUI"] = { "ScrappingMachineFrame" },
	["Blizzard_GuildUI"] = { "GuildFrame" },
	["Blizzard_AzeriteUI"] = { "AzeriteEmpoweredItemUI" },
}
EBF.CombatLockFrames = {
	["SpellBookFrame"] = true,
}
EBF.NeedFixFrames = {
	["HelpFrame"] = true,
	["VideoOptionsFrame"] = true,
	["InterfaceOptionsFrame"] = true,
}

local function LoadPosition(self)
	if self.IsMoving == true then return end

	local Name = self:GetName()
	if EBF.CombatLockFrames[Name] and InCombatLockdown() then
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		return
	end

	if not self:GetPoint() then
		self:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
	end

	if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember and E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name] then
		self:ClearAllPoints()
		self:SetPoint(unpack(E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name]))
	end
	
	if Name == "QuestFrame" then
		_G["GossipFrame"]:Hide()
	elseif Name == "GossipFrame" then
		_G["QuestFrame"]:Hide()
	end

	if EBF.NeedFixFrames[Name] then
		_G["GameMenuFrame"]:Hide()
	end
end

local function OnDragStart(self)
	self.IsMoving = true
	self:StartMoving()
end

local function OnDragStop(self)
	self:StopMovingOrSizing()
	self.IsMoving = false
	local Name = self:GetName()
	if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember then
		local a, b, c, d, e = self:GetPoint()
		if self:GetParent() then 
			b = self:GetParent():GetName() or UIParent
		else
			b = UIParent
		end
		if Name == "QuestFrame" or Name == "GossipFrame" then
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points["GossipFrame"] = {a, b, c, d, e}
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points["QuestFrame"] = {a, b, c, d, e}
		else
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name] = {a, b, c, d, e}
		end
	else
		self:SetUserPlaced(false)
	end
end

function EBF:MakeMovable(Name)
	local frame = _G[Name]
	if not frame then
		print("Frame to move doesn't exist: "..(frameName or "Unknown"))
		return
	end

	if Name == "AchievementFrame" then AchievementFrameHeader:EnableMouse(false) end

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:HookScript("OnShow", LoadPosition)
	frame:HookScript("OnDragStart", OnDragStart)
	frame:HookScript("OnDragStop", OnDragStop)

	if EBF.CombatLockFrames[Name] then
		frame:HookScript("OnHide", function(self)
			self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		end)
		frame:HookScript("OnEvent", function(self, event)
			if event == "PLAYER_REGEN_ENABLED" then
				if self:IsVisible() then
					LoadPosition(self)
				end
				self:UnregisterEvent('PLAYER_REGEN_ENABLED')
			end
		end)
	end

	if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember then
		frame.ignoreFramePositionManager = true
		if UIPanelWindows[Name] then
			for Key in pairs(UIPanelWindows[Name]) do
				if Key == 'area' or Key == "pushable" then
					UIPanelWindows[Name][Key] = nil
				end
			end
		end
		if not UISpecialFrames[Name] then tinsert(UISpecialFrames, Name) end
	end

	C_Timer.After(0, function()
		if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember and E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name] then
			if not frame:GetPoint() then
				frame:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
			end

			frame:ClearAllPoints()
			frame:SetPoint(unpack(E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name]))
		end
	end)
end

function EBF:Addons(event, addon)
	addon = EBF.AddonsList[addon]
	if not addon then return end
	if type(addon) == "table" then
		for i = 1, #addon do
			EBF:MakeMovable(addon[i])
		end
	else
		EBF:MakeMovable(addon)
	end
	EBF.addonCount = EBF.addonCount + 1
	if EBF.addonCount == #EBF.AddonsList then EBF:UnregisterEvent(event) end
end

function EBF:VehicleScale()
	local frame = _G["VehicleSeatIndicator"]
	local frameScale = E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["vehicleSeatScale"]
	frame:SetScale(frameScale)
	if frame.mover then
		frame.mover:SetSize(frameScale * frame:GetWidth(), frameScale * frame:GetHeight())
	end
end

function EBF:ErrorFrameSize()
	_G["UIErrorsFrame"]:SetSize(self.db.errorframe.width, self.db.errorframe.height) --512 x 60
end

function EBF:Initialize()
	if not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["enabled"] then return end
	
	self.db = E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]
	EBF.addonCount = 0
	if self.db.moveframe then
		for i = 1, #EBF.Frames do
			EBF:MakeMovable(EBF.Frames[i])
		end
		if self.db.moveelvbag then
			EBF:MakeMovable("ElvUI_ContainerFrame")
		end
		self:RegisterEvent("ADDON_LOADED", "Addons")
		
		-- Check Forced Loaded AddOns
		for AddOn, Table in pairs(EBF.AddonsList) do
			if IsAddOnLoaded(AddOn) then
				for _, frame in pairs(Table) do
					EBF:MakeMovable(frame)
				end
			end
		end
	end
	hooksecurefunc(VehicleSeatIndicator,"SetPoint", EBF.VehicleScale)
	EBF:ErrorFrameSize()
	function EBF:ForUpdateAll()
		EBF:VehicleScale()
		EBF:ErrorFrameSize()
	end
end

local function InitializeCallback()
	EBF:Initialize()
end
E:RegisterModule(EBF:GetName(), InitializeCallback)