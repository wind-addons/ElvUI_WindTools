local W, F, E, L = unpack(select(2, ...))
local MF = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local format = format
local pairs = pairs
local strsplit = strsplit
local type = type

local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded

local BlizzardFrames = {
    "AddonList",
    "AudioOptionsFrame",
    "BankFrame",
    "ChatConfigFrame",
    "CinematicFrame",
    "DestinyFrame",
    "DressUpFrame",
    "FriendsFrame",
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
    "MerchantFrame",
    "PetitionFrame",
    "PetStableFrame",
    "PlayerReportFrame",
    "PVPReadyDialog",
    "QuestFrame",
    "QuestLogPopupDetailFrame",
    "RaidBrowserFrame",
    "RaidParentFrame",
    "ReadyCheckFrame",
    "ReportCheatingDialog",
    "SpellBookFrame",
    "SplashFrame",
    "StackSplitFrame",
    "StaticPopup1",
    "StaticPopup2",
    "StaticPopup3",
    "StaticPopup4",
    "TabardFrame",
    "TaxiFrame",
    "TradeFrame",
    "TutorialFrame",
    "VideoOptionsFrame",
    ["CharacterFrame"] = {
        "PaperDollFrame",
        "ReputationFrame",
        "TokenFrame"
    },
    ["MailFrame"] = {
        "SendMailFrame",
        "OpenMailFrame",
        "OpenMailSender"
    },
    ["PVEFrame"] = {
        "LFGListApplicationViewerScrollFrame",
        "LFGListSearchPanelScrollFrame"
    },
    ["WorldMapFrame"] = {
        "QuestMapFrame"
    }
}

local BlizzardFramesOnDemand = {
    ["Blizzard_AchievementUI"] = {
        ["AchievementFrame"] = {
            "AchievementFrameHeader",
            "AchievementFrameAchievementsContainer",
            "AchievementFrameCategoriesContainer"
        }
    },
    ["Blizzard_AlliedRacesUI"] = {
        "AlliedRacesFrame"
    },
    ["Blizzard_ArchaeologyUI"] = {
        "ArchaeologyFrame"
    },
    ["Blizzard_ArtifactUI"] = {
        "ArtifactFrame"
    },
    ["Blizzard_AuctionHouseUI"] = {
        "AuctionHouseFrame"
    },
    ["Blizzard_AzeriteEssenceUI"] = {
        "AzeriteEssenceUI"
    },
    ["Blizzard_AzeriteRespecUI"] = {
        "AzeriteRespecFrame"
    },
    ["Blizzard_AzeriteUI"] = {
        "AzeriteEmpoweredItemUI"
    },
    ["Blizzard_BindingUI"] = {
        "KeyBindingFrame"
    },
    ["Blizzard_BlackMarketUI"] = {
        "BlackMarketFrame"
    },
    ["Blizzard_Calendar"] = {
        ["CalendarFrame"] = {
            "CalendarCreateEventFrame",
            "CalendarCreateEventInviteListScrollFrame",
            "CalendarViewEventFrame",
            "CalendarViewEventFrame.HeaderFrame",
            "CalendarViewEventInviteListScrollFrame",
            "CalendarViewHolidayFrame"
        }
    },
    ["Blizzard_ChallengesUI"] = {
        "ChallengesKeystoneFrame"
    },
    ["Blizzard_Channels"] = {
        "ChannelFrame",
        "CreateChannelPopup"
    },
    ["Blizzard_Collections"] = {
        "CollectionsJournal",
        "WardrobeFrame"
    },
    ["Blizzard_Communities"] = {
        "ClubFinderGuildFinderFrame.RequestToJoinFrame",
        ["CommunitiesFrame"] = {
            "ClubFinderCommunityAndGuildFinderFrame.CommunityCards.ListScrollFrame"
        },
        "CommunitiesFrame.RecruitmentDialog",
        "CommunitiesGuildLogFrame",
        "CommunitiesGuildNewsFiltersFrame",
        "CommunitiesGuildTextEditFrame"
    },
    ["Blizzard_Contribution"] = {
        "ContributionCollectionFrame"
    },
    ["Blizzard_DeathRecap"] = {
        "DeathRecapFrame"
    },
    ["Blizzard_EncounterJournal"] = {
        "EncounterJournal"
    },
    ["Blizzard_FlightMap"] = {
        "FlightMapFrame"
    },
    ["Blizzard_GarrisonUI"] = {
        "GarrisonBuildingFrame",
        "GarrisonCapacitiveDisplayFrame",
        ["GarrisonLandingPage"] = {
            "GarrisonLandingPageReportListListScrollFrame",
            "GarrisonLandingPageFollowerListListScrollFrame"
        },
        "GarrisonMissionFrame",
        "GarrisonMonumentFrame",
        "GarrisonRecruiterFrame",
        "GarrisonRecruitSelectFrame",
        "GarrisonShipyardFrame",
        "OrderHallMissionFrame",
        "BFAMissionFrame"
    },
    ["Blizzard_GMChatUI"] = {
        "GMChatStatusFrame"
    },
    ["Blizzard_GMSurveyUI"] = {
        "GMSurveyFrame"
    },
    ["Blizzard_GuildBankUI"] = {
        "GuildBankFrame"
    },
    ["Blizzard_GuildControlUI"] = {
        "GuildControlUI"
    },
    ["Blizzard_GuildUI"] = {
        "GuildFrame"
    },
    ["Blizzard_InspectUI"] = {
        "InspectFrame"
    },
    ["Blizzard_IslandsPartyPoseUI"] = {
        "IslandsPartyPoseFrame"
    },
    ["Blizzard_IslandsQueueUI"] = {
        "IslandsQueueFrame"
    },
    ["Blizzard_ItemAlterationUI"] = {
        "TransmogrifyFrame"
    },
    ["Blizzard_ItemInteractionUI"] = {
        "ItemInteractionFrame"
    },
    ["Blizzard_ItemSocketingUI"] = {
        "ItemSocketingFrame"
    },
    ["Blizzard_ItemUpgradeUI"] = {
        "ItemUpgradeFrame"
    },
    ["Blizzard_LookingForGuildUI"] = {
        "LookingForGuildFrame"
    },
    ["Blizzard_MacroUI"] = {
        "MacroFrame"
    },
    ["Blizzard_ObliterumUI"] = {
        "ObliterumForgeFrame"
    },
    ["Blizzard_OrderHallUI"] = {
        "OrderHallTalentFrame"
    },
    ["Blizzard_PVPMatch"] = {
        "PVPMatchResults"
    },
    ["Blizzard_PVPUI"] = {
        "PVPMatchScoreboard"
    },
    ["Blizzard_ReforgingUI"] = {
        "ReforgingFrame"
    },
    ["Blizzard_ScrappingMachineUI"] = {
        "ScrappingMachineFrame"
    },
    ["Blizzard_TalentUI"] = {
        "PlayerTalentFrame"
    },
    ["Blizzard_TalkingHeadUI"] = {
        "TalkingHeadFrame"
    },
    ["Blizzard_TradeSkillUI"] = {
        ["TradeSkillFrame"] = {
            "TradeSkillFrame.RecipeList"
        }
    },
    ["Blizzard_TrainerUI"] = {
        "ClassTrainerFrame"
    },
    ["Blizzard_VoidStorageUI"] = {
        "VoidStorageFrame"
    },
    ["Blizzard_WarboardUI"] = {
        "WarboardQuestChoiceFrame"
    },
    ["Blizzard_WarfrontsPartyPoseUI"] = {
        "WarfrontsPartyPoseFrame"
    }
}

function MF:HandleFrame(frameName, mainFrameName)
    local frame = _G
    local mainFrame

    local path = {strsplit(".", frameName)}
    for i = 1, #path do
        frame = frame[path[i]]
    end

    if mainFrameName then
        mainFrame = _G
        path = {strsplit(".", mainFrameName)}
        for i = 1, #path do
            mainFrame = mainFrame[path[i]]
        end
    end

    if frame then
        if InCombatLockdown() and frame:IsProtected() or frame.MoveFrame then
            return
        end

        frame:SetMovable(true)
        frame:SetClampedToScreen(true)

        mainFrame = mainFrame or frame
        frame.MoveFrame = mainFrame

        frame:EnableMouse(true)

        frame:HookScript(
            "OnMouseDown",
            function(self, button)
                if button == "LeftButton" then
                    if self.MoveFrame:IsMovable() then
                        self.MoveFrame:StartMoving()
                    end
                end
            end
        )

        frame:HookScript(
            "OnMouseUp",
            function(self, button)
                if button == "LeftButton" then
                    self.MoveFrame:StopMovingOrSizing()
                end
            end
        )

    else
        F.DebugMessage(self, format("Cannot find the frame: %s", frame))
    end
end

function MF:HandleFramesWithTable(table)
    for key, value in pairs(table) do
        if type(key) == "number" and type(value) == "string" then
            self:HandleFrame(value)
        elseif type(key) == "string" and type(value) == "table" then
            self:HandleFrame(key)
            for _, subFrameName in pairs(value) do
                self:HandleFrame(subFrameName, key)
            end
        end
    end
end

function MF:HandleAddon(_, addon)
    local frameTable = BlizzardFramesOnDemand[addon]
    if not frameTable then
        return
    end

    self:HandleFramesWithTable(frameTable)
end

function MF:Initialize()
    self.db = E.private.WT.misc
    if not self.db then
        return
    end

    if self.db.moveBlizzardFrames then
        -- 全局变量中已经存在的窗体
        self:HandleFramesWithTable(BlizzardFrames)

        -- 为后续载入插件注册事件
        self:RegisterEvent("ADDON_LOADED", "HandleAddon")

        -- 检查当前已经载入的插件
        for addon in pairs(BlizzardFramesOnDemand) do
            if IsAddOnLoaded(addon) then
                self:HandleAddon(nil, addon)
            end
        end
    end
end

W:RegisterModule(MF:GetName())
