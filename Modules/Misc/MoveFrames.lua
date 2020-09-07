local W, F, E, L = unpack(select(2, ...))
local MF = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")
local _G = _G

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
        ["OpenMailFrame"] = {
            "OpenMailSender"
        }
    },
    ["PVEFrame"] = {
        "LFGListApplicationViewerScrollFrame",
        "LFGListSearchPanelScrollFrame"
    },
    ["WorldMapFrame"] = {
        "QuestMapFrame"
    }
}

local BlizzardFramesLoadOnDemand = {
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
        "ArtifactFrame",
        "ArtifactRelicForgeFrame"
    },
    ["Blizzard_AuctionHouseUI"] = {
        "AuctionHouseFrame"
    },
    ["Blizzard_AuctionUI"] = {
        "AuctionFrame"
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
            ["CalendarCreateEventFrame"] = {
                "CalendarCreateEventInviteListScrollFrame"
            }
        }
    },
    ["Blizzard_ChallengesUI"] = {
        "ChallengesKeystoneFrame"
    },
    ["Blizzard_Collections"] = {
        "CollectionsJournal",
        "WardrobeFrame"
    },
    ["Blizzard_Communities"] = {
        "CommunitiesFrame",
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
        "GarrisonLandingPage",
        "GarrisonMissionFrame",
        "GarrisonCapacitiveDisplayFrame",
        "GarrisonBuildingFrame",
        "GarrisonRecruiterFrame",
        "GarrisonRecruitSelectFrame",
        "GarrisonShipyardFrame",
        "OrderHallMissionFrame",
        "BFAMissionFrame",
        "GarrisonMonumentFrame"
    },
    ["Blizzard_GlyphUI"] = {
        "GlyphFrame"
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
    ["Blizzard_QuestChoice"] = {
        "QuestChoiceFrame"
    },
    ["Blizzard_ScrappingMachineUI"] = {
        "ScrappingMachineFrame"
    },
    ["Blizzard_TalentUI"] = {
        "PlayerTalentFrame"
    },
    ["Blizzard_TradeSkillUI"] = {
        "TradeSkillFrame"
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

local function OnMouseDown(frame, button)
    if button == "LeftButton" then
        if frame.MoveFrame:IsMovable() then
            frame.MoveFrame:StartMoving()
        end
    end
end

local function OnMouseUp(frame, button)
    if button == "LeftButton" then
        frame.MoveFrame:StopMovingOrSizing()
    end
end

function MF:HandleFrames(frameTable, mainFrame)
    for key, value in pairs(frameTable) do
        if type(key) == "number" and type(value) == "string" then
            if _G[value] then
                self:HandleFrame(_G[value], mainFrame)
            else
                F.DebugMessage(self, format("Cannot find the frame: %s", value))
            end
        elseif type(key) == "string" and type(value) == "table" then
            self:HandleFrames(value, mainFrame or _G[key])
            self:HandleFrame(_G[key], mainFrame)
        end
    end
end

function MF:HandleFrame(frame, mainFrame)
    if not frame then
        F.DebugMessage(self, format("Cannot find the frame: %s", value))
        return
    end

    if InCombatLockdown() and frame:IsProtected() then
        return
    end

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)

    mainFrame = mainFrame or frame
    frame.MoveFrame = mainFrame

    frame:EnableMouse(true)
    frame:HookScript("OnMouseDown", OnMouseDown)
    frame:HookScript("OnMouseUp", OnMouseUp)
end

function MF:Test()
end

function MF:Initialize()
    self.db = E.private.WT.misc
    if not self.db then
        return
    end

    if self.db.moveBlizzardFrames then
        self:HandleFrames(BlizzardFrames)
    end
end

W:RegisterModule(MF:GetName())
