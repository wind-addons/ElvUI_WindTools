-- 原作：ElvUI_S&L 的一个增强组件
-- 原作者：ElvUI_S&L (https://www.tukui.org/addons.php?id=38)
-- 修改：houshuu
-------------------
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EBF = E:NewModule("EnhancedBlizzardFrame", 'AceHook-3.0', 'AceEvent-3.0')
local _G = _G

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

P["WindTools"]["Enhanced Blizzard Frame"] = {
	["enabled"] = true,
	["moveframe"] = true,
	["moveelvbag"] = false,
	["remember"] = true,
	["points"] = {},
	["rumouseover"] = false,
	["errorframe"] = {
		["height"] = 60,
		["width"] = 512,
	},
	["vehicleSeatScale"] = 1,
}

local function InsertOptions()
	local Options = {
		moveframes = {
			order = 11,
			type = "group",
			name = L["Move Frames"],
			guiInline = true,
			disabled = not E.db.WindTools["Enhanced Blizzard Frame"].enabled,
			get = function(info) return E.db.WindTools["Enhanced Blizzard Frame"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Enhanced Blizzard Frame"][ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				moveframe = {
					order = 10,
					type = "toggle",
					name = L["Move Blizzard Frame"],
				},
				moveelvbag = {
					order = 12,
					type = "toggle",
					name = L["Move ElvUI Bag"],
					disabled = not E.db.WindTools["Enhanced Blizzard Frame"].moveframe,
				},
				remember = {
					order = 13,
					type = "toggle",
					name = L["Remember Position"],
					disabled = not E.db.WindTools["Enhanced Blizzard Frame"].moveframe,
				},
			}
		},
		errorframe = {
			order = 12,
			type = "group",
			name = L["Error Frame"],
			guiInline = true,
			get = function(info) return E.db.WindTools["Enhanced Blizzard Frame"].errorframe[ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Enhanced Blizzard Frame"].errorframe[ info[#info] ] = value; EBF:ErrorFrameSize() end,
			args = {
				width = {
					order = 1,
					name = L["Width"],
					type = "range",
					min = 100, max = 1000, step = 1,
				},
				height = {
					order = 2,
					name = L["Height"],
					type = "range",
					min = 30, max = 300, step = 15,
				},
			},
		},
		others = {
			order = 13,
			type = "group",
			name = L["Other Setting"],
			guiInline = true,
			args = {
				rumouseover = {
					order = 1,
					type = "toggle",
					name = L["Raid Utility Mouse Over"],
					get = function(info) return E.db.WindTools["Enhanced Blizzard Frame"].rumouseover end,
					set = function(info, value) E.db.WindTools["Enhanced Blizzard Frame"].rumouseover = value; M:RUReset() end,
				},
				vehicleSeatScale = {
					order = 2,
					type = 'range',
					name = L["Vehicle Seat Scale"],
					min = 0.1, max = 3, step = 0.01,
					isPercent = true,
					get = function(info) return E.db.WindTools["Enhanced Blizzard Frame"][ info[#info] ] end,
					set = function(info, value) E.db.WindTools["Enhanced Blizzard Frame"][ info[#info] ] = value; EBF:VehicleScale() end,
				},
			}
		}
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["More Tools"].args["Enhanced Blizzard Frame"].args[k] = v
	end
end

EBF.Frames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"BonusRollFrame",
	"BonusRollLootWonFrame",
	"BonusRollMoneyWonFrame",
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
	["Blizzard_Communities"] = { "CommunitiesFrame" },
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
	["Blizzard_TalkingHeadUI"] = { "TalkingHeadFrame" },
	["Blizzard_TradeSkillUI"] = { "TradeSkillFrame" },
	["Blizzard_TrainerUI"] = { "ClassTrainerFrame" },
	["Blizzard_VoidStorageUI"] = { "VoidStorageFrame" },
}

local function LoadPosition(self)
	if self.IsMoving == true then return end
	local Name = self:GetName()
	if not self:GetPoint() then
		self:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
	end

	if E.db.WindTools["Enhanced Blizzard Frame"].remember and E.db.WindTools["Enhanced Blizzard Frame"].points[Name] then
		self:ClearAllPoints()
		self:SetPoint(unpack(E.db.WindTools["Enhanced Blizzard Frame"].points[Name]))
	end
	
	if Name == "QuestFrame" then
		_G["GossipFrame"]:Hide()
	elseif Name == "GossipFrame" then
		_G["QuestFrame"]:Hide()
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
	if E.db.WindTools["Enhanced Blizzard Frame"].remember then
		local a, b, c, d, e = self:GetPoint()
		if self:GetParent() then 
			b = self:GetParent():GetName() or UIParent
		else
			b = UIParent
		end
		if Name == "QuestFrame" or Name == "GossipFrame" then
			E.db.WindTools["Enhanced Blizzard Frame"].points["GossipFrame"] = {a, b, c, d, e}
			E.db.WindTools["Enhanced Blizzard Frame"].points["QuestFrame"] = {a, b, c, d, e}
		else
			E.db.WindTools["Enhanced Blizzard Frame"].points[Name] = {a, b, c, d, e}
		end
	else
		self:SetUserPlaced(false)
	end
end


function EBF:MakeMovable(Name)
	local frame = _G[Name]
	if not frame then
		SLE:ErrorPrint("Frame to move doesn't exist: "..(frameName or "Unknown"))
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

	if E.db.WindTools["Enhanced Blizzard Frame"].remember then
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
		if E.db.WindTools["Enhanced Blizzard Frame"].remember and E.db.WindTools["Enhanced Blizzard Frame"].points[Name] then
			if not frame:GetPoint() then
				frame:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
			end

			frame:ClearAllPoints()
			frame:SetPoint(unpack(E.db.WindTools["Enhanced Blizzard Frame"].points[Name]))
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
	local frameScale = self.db["vehicleSeatScale"]
	frame:SetScale(frameScale)
	if frame.mover then
		frame.mover:SetSize(frameScale * frame:GetWidth(), frameScale * frame:GetHeight())
	end
end

function EBF:ErrorFrameSize()
	_G["UIErrorsFrame"]:SetSize(self.db.errorframe.width, self.db.errorframe.height) --512 x 60
end

function EBF:Initialize()
	if not E.db.WindTools["Enhanced Blizzard Frame"]["enabled"] then return end
	
	self.db = E.db.WindTools["Enhanced Blizzard Frame"]
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

WT.ToolConfigs["Enhanced Blizzard Frame"] = InsertOptions
E:RegisterModule(EBF:GetName())