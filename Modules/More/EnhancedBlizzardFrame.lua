-- 原作：ElvUI_S&L 的一个增强组件
-- 原作者：ElvUI_S&L (https://www.tukui.org/addons.php?id=38)
-- 修改：houshuu, SomeBlu
-------------------
local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = unpack(select(2, ...))
local WT = E:GetModule("WindTools")
local EBF = E:NewModule("Wind_EnhancedBlizzardFrame", 'AceHook-3.0', 'AceEvent-3.0')
local _G = _G

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

EBF.Frames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"DressUpFrame",
	"FriendsFrame",
	"FriendsFriendsFrame",
	"GameMenuFrame",
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
	"PVPReadyDialog",
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
	"StaticPopup1",
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
}

EBF.TempOnly = {
	["BonusRollFrame"] = true,
	["BonusRollLootWonFrame"] = true,
	["BonusRollMoneyWonFrame"] = true,
}

EBF.AddonsList = {
	["Blizzard_AchievementUI"] = { "AchievementFrame" },
	["Blizzard_AlliedRacesUI"] = { "AlliedRacesFrame" },
	["Blizzard_ArchaeologyUI"] = { "ArchaeologyFrame" },
	["Blizzard_AuctionUI"] = { "AuctionFrame" },
	["Blizzard_AzeriteEssenceUI"] = { "AzeriteEssenceUI" },
	["Blizzard_AzeriteRespecUI"] = { "AzeriteRespecFrame" },
	["Blizzard_AzeriteUI"] = { "AzeriteEmpoweredItemUI" },
	["Blizzard_BarberShopUI"] = { "BarberShopFrame" },
	["Blizzard_BindingUI"] = { "KeyBindingFrame" },
	["Blizzard_BlackMarketUI"] = { "BlackMarketFrame" },
	["Blizzard_Calendar"] = { "CalendarCreateEventFrame", "CalendarFrame" },
	["Blizzard_ChallengesUI"] = { "ChallengesKeystoneFrame" }, -- 'ChallengesLeaderboardFrame'
	["Blizzard_Collections"] = { "CollectionsJournal", "WardrobeFrame" },
	["Blizzard_Communities"] = { "CommunitiesFrame" },
	["Blizzard_EncounterJournal"] = { "EncounterJournal" },
	["Blizzard_GarrisonUI"] = {
		"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame",
		"GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame",
		"GarrisonShipyardFrame", "OrderHallMissionFrame", "BFAMissionFrame",
	},
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
	["Blizzard_ScrappingMachineUI"] = { "ScrappingMachineFrame" },
	["Blizzard_TalentUI"] = { "PlayerTalentFrame" },
	["Blizzard_TradeSkillUI"] = { "TradeSkillFrame" },
	["Blizzard_TrainerUI"] = { "ClassTrainerFrame" },
	["Blizzard_VoidStorageUI"] = { "VoidStorageFrame" },
}

EBF.ExlusiveFrames = {
	["QuestFrame"] = { "GossipFrame", },
	["GossipFrame"] = { "QuestFrame", },
	["GameMenuFrame"] = { "VideoOptionsFrame", "InterfaceOptionsFrame", "HelpFrame",},
	["VideoOptionsFrame"] = { "GameMenuFrame",},
	["InterfaceOptionsFrame"] = { "GameMenuFrame",},
	["HelpFrame"] = { "GameMenuFrame",},
}

EBF.NoSpecialFrames = {
	["StaticPopup1"] = true,
	["StaticPopup2"] = true,
	["StaticPopup3"] = true,
	["StaticPopup4"] = true,
}

EBF.FramesAreaAlter = {
	["GarrisonMissionFrame"] = "left",
	["OrderHallMissionFrame"] = "left",
	["BFAMissionFrame"] = "left",
}

EBF.SpecialDefaults = {
	["GarrisonMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
	["OrderHallMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
	["BFAMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
}

local function OnDragStart(self)
	self.IsMoving = true
	self:StartMoving()
end

local function OnDragStop(self)
	self:StopMovingOrSizing()
	local Name = self:GetName()
	if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember and not EBF.TempOnly[Name]  then
		local a, b, c, d, e = self:GetPoint()
		if self:GetParent() then 
			b = self:GetParent():GetName() or UIParent
			if not _G[b] then b = UIParent end
		else
			b = UIParent
		end
		if Name == "QuestFrame" or Name == "GossipFrame" then
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points["GossipFrame"] = {a, b, c, d, e}
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points["QuestFrame"] = {a, b, c, d, e}
		else
			E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name] = {a, b, c, d, e}
		end
		self:SetUserPlaced(true)
	else
		self:SetUserPlaced(false)
	end
	self.IsMoving = false
end

local function LoadPosition(self)
	if self.IsMoving == true then return end
	local Name = self:GetName()

	if not self:GetPoint() then
		if EBF.SpecialDefaults[Name] then
			local a,b,c,d,e = unpack(E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name])
			self:SetPoint(a,b,c,d,e, true)
		else
			self:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116, true)
		end
		OnDragStop(self)
	end

	if E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].remember and E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name] then
		self:ClearAllPoints()
		local a,b,c,d,e = unpack(E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].points[Name])
		self:SetPoint(a,b,c,d,e, true)
	end
	
	if EBF.ExlusiveFrames[Name] then
		for _, name in pairs(EBF.ExlusiveFrames[Name]) do _G[name]:Hide() end
	end
end

function EBF:RewritePoint(anchor, parent, point, x, y, called)
	if not called then LoadPosition(self) end
end

function EBF:MakeMovable(Name)
	local frame = _G[Name]
	if not frame then
		print("Frame to move doesn't exist: "..(frameName or "Unknown"), "error")
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
	frame:HookScript("OnHide", OnDragStop)
	hooksecurefunc(frame, "SetPoint", self.RewritePoint)

	frame.ignoreFramePositionManager = true
	if self.FramesAreaAlter[Name] then
		if UIPanelWindows[Name] and UIPanelWindows[Name].area then UIPanelWindows[Name].area = self.FramesAreaAlter[Name] end
	end
end

function EBF:Addons(event, addon)
	addon = self.AddonsList[addon]
	if not addon then return end
	if type(addon) == "table" then
		for i = 1, #addon do
			self:MakeMovable(addon[i])
		end
	else
		self:MakeMovable(addon)
	end
	self.addonCount = self.addonCount + 1
	if self.addonCount == #self.AddonsList then self:UnregisterEvent(event) end
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

local ToDelete = {
	["CalendarViewEventFrame"] = true,
	["CalendarViewHolidayFrame"] = true,
}

function EBF:Initialize()
	if not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["enabled"] then return end
	
	self.db = E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]
	self.addonCount = 0

	for Name, _ in pairs(ToDelete) do
		if self.db.points[Name] then self.db.points[Name] = nil end
	end
	
	PVPReadyDialog:Hide()

	if self.db.moveframe then
		for Name, _ in pairs(self.TempOnly) do
			if self.db.points[Name] then self.db.points[Name] = nil end
		end

		for i = 1, #self.Frames do
			self:MakeMovable(self.Frames[i])
		end
		if self.db.moveelvbag then
			self:MakeMovable("ElvUI_ContainerFrame")
		end
		self:RegisterEvent("ADDON_LOADED", "Addons")
		
		-- Check Forced Loaded AddOns
		for AddOn, Table in pairs(self.AddonsList) do
			if IsAddOnLoaded(AddOn) then
				for _, frame in pairs(Table) do
					self:MakeMovable(frame)
				end
			end
		end
	end
	hooksecurefunc(VehicleSeatIndicator,"SetPoint", self.VehicleScale)
	self:ErrorFrameSize()
end

local function InitializeCallback()
	EBF:Initialize()
end
E:RegisterModule(EBF:GetName(), InitializeCallback)
