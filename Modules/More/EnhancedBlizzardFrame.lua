-- 原作 BlizzMove
-- 框架和函数进行了增减
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EBF = E:NewModule('Wind_EnhancedBlizzardFrame', 'AceEvent-3.0')
local HelpInfoRecord = {}

local _G = _G
local tinsert = tinsert
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local InCombatLockdown = InCombatLockdown
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local UpdateUIPanelPositions = UpdateUIPanelPositions

local movableFrames = {
    "AddonList",
    "AudioOptionsFrame",
    "BankFrame",
    "BattlefieldFrame",
    "CharacterFrame",
    "ChatConfigFrame",
    "CraftFrame",
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
    "MailFrame",
    "MerchantFrame",
    "OpenMailFrame",
    "PVEFrame",
    "PVPReadyDialog",
    "PetStableFrame",
    "PetitionFrame",
    "QuestFrame",
    "QuestLogFrame",
    "QuestLogPopupDetailFrame",
    "RaidBrowserFrame",
    "RaidInfoFrame",
    "RaidParentFrame",
    "ReadyCheckFrame",
    "ReportCheatingDialog",
    "RolePollPopup",
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
    "WorldStateScoreFrame"
}

local movableFramesLoadOnDemand = {
    ["Blizzard_AchievementUI"] = {"AchievementFrame", "AchievementFrameHeader"},
    ["Blizzard_AlliedRacesUI"] = {"AlliedRacesFrame"},
    ["Blizzard_ArchaeologyUI"] = {"ArchaeologyFrame"},
    ["Blizzard_ArtifactUI"] = {"ArtifactFrame", "ArtifactRelicForgeFrame"},
    ["Blizzard_AuctionHouseUI"] = {"AuctionHouseFrame"},
    ["Blizzard_AuctionUI"] = {"AuctionFrame"},
    ["Blizzard_AzeriteEssenceUI"] = {"AzeriteEssenceUI"},
    ["Blizzard_AzeriteRespecUI"] = {"AzeriteRespecFrame"},
    ["Blizzard_AzeriteUI"] = {"AzeriteEmpoweredItemUI"},
    ["Blizzard_BarberShopUI"] = {"BarberShopFrame"},
    ["Blizzard_BindingUI"] = {"KeyBindingFrame"},
    ["Blizzard_BlackMarketUI"] = {"BlackMarketFrame"},
    ["Blizzard_Calendar"] = {"CalendarCreateEventFrame", "CalendarFrame"},
    ["Blizzard_ChallengesUI"] = {"ChallengesKeystoneFrame"},
    ["Blizzard_Collections"] = {"CollectionsJournal", "WardrobeFrame"},
    ["Blizzard_Communities"] = {
        "CommunitiesFrame",
        "CommunitiesGuildLogFrame",
        "CommunitiesGuildNewsFiltersFrame",
        "CommunitiesGuildTextEditFrame"
    },
    ["Blizzard_Contribution"] = {"ContributionCollectionFrame"},
    ["Blizzard_DeathRecap"] = {"DeathRecapFrame"},
    ["Blizzard_EncounterJournal"] = {"EncounterJournal"},
    ["Blizzard_FlightMap"] = {"FlightMapFrame"},
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
    ["Blizzard_GlyphUI"] = {"GlyphFrame"},
    ["Blizzard_GMChatUI"] = {"GMChatStatusFrame"},
    ["Blizzard_GMSurveyUI"] = {"GMSurveyFrame"},
    ["Blizzard_GuildBankUI"] = {"GuildBankFrame"},
    ["Blizzard_GuildControlUI"] = {"GuildControlUI"},
    ["Blizzard_GuildUI"] = {"GuildFrame"},
    ["Blizzard_InspectUI"] = {"InspectFrame"},
    ["Blizzard_IslandsPartyPoseUI"] = {"IslandsPartyPoseFrame"},
    ["Blizzard_IslandsQueueUI"] = {"IslandsQueueFrame"},
    ["Blizzard_ItemAlterationUI"] = {"TransmogrifyFrame"},
    ["Blizzard_ItemInteractionUI"] = {"ItemInteractionFrame"},
    ["Blizzard_ItemSocketingUI"] = {"ItemSocketingFrame"},
    ["Blizzard_ItemUpgradeUI"] = {"ItemUpgradeFrame"},
    ["Blizzard_LookingForGuildUI"] = {"LookingForGuildFrame"},
    ["Blizzard_MacroUI"] = {"MacroFrame"},
    ["Blizzard_ObliterumUI"] = {"ObliterumForgeFrame"},
    ["Blizzard_OrderHallUI"] = {"OrderHallTalentFrame"},
    ["Blizzard_PVPMatch"] = {"PVPMatchResults"},
    ["Blizzard_PVPUI"] = {"PVPMatchScoreboard"},
    ["Blizzard_ReforgingUI"] = {"ReforgingFrame"},
    ["Blizzard_QuestChoice"] = {"QuestChoiceFrame"},
    ["Blizzard_ScrappingMachineUI"] = {"ScrappingMachineFrame"},
    ["Blizzard_TalentUI"] = {"PlayerTalentFrame"},
    ["Blizzard_TradeSkillUI"] = {"TradeSkillFrame"},
    ["Blizzard_TrainerUI"] = {"ClassTrainerFrame"},
    ["Blizzard_VoidStorageUI"] = {"VoidStorageFrame"},
    ["Blizzard_WarboardUI"] = {"WarboardQuestChoiceFrame"},
    ["Blizzard_WarfrontsPartyPoseUI"] = {"WarfrontsPartyPoseFrame"}
}

local noSaveFrames = {
    "GarrisonMissionFrame",
    "OrderHallMissionFrame",
    "BFAMissionFrame",
    "VideoOptionsFrame",
    "InterfaceOptionsFrame",
    "HelpFrame",
    "GameMenuFrame",
    "GossipFrame"
}

local function OnSetPoint(self)
    if self.WindMoveFramesBypassHook then return end

    EBF:RestoreFramePoints(self, self:GetName())
end

local function OnSizeUpdate(self)
    local clampDistance = 40
    local clampWidth = (self:GetWidth() - clampDistance) or 0
    local clampHeight = (self:GetHeight() - clampDistance) or 0

    self:SetClampRectInsets(clampWidth, -clampWidth, -clampHeight, clampHeight)
end

local function OnMouseDown(self, button)
    if button ~= "LeftButton" then return end

    if self.moveFrame:IsMovable() then self.moveFrame:StartMoving() end
end

local function OnMouseUp(self, button)
    if button ~= "LeftButton" then return end

    self.moveFrame:StopMovingOrSizing()

    local storePoints = true
    if IsShiftKeyDown() then
        EBF:ResetFramePoints(self.moveFrame, self.moveFrame:GetName())
        storePoints = false
    end

    if IsControlKeyDown() then
        EBF:ResetFrameScale(self.moveFrame)
        storePoints = false
    end

    if storePoints then
        EBF:StoreFramePoints(self.moveFrame, self.moveFrame:GetName())
        EBF:InformUser("move")
    end
end

local function OnMouseWheelChildren(self, delta)
    local returnValue = false

    for _, childFrame in pairs({self:GetChildren()}) do
        local OnMouseWheel = childFrame:GetScript("OnMouseWheel")

        if OnMouseWheel and MouseIsOver(childFrame) then
            OnMouseWheel(childFrame, delta)
            returnValue = true
        end

        returnValue = OnMouseWheelChildren(childFrame, delta) or returnValue
    end

    return returnValue
end

local function OnMouseWheel(self, delta)
    if not OnMouseWheelChildren(self, delta) and IsControlKeyDown() then
        local scale = self.moveFrame:GetScale() or 1

        scale = scale + 0.1 * delta

        if scale > 1.5 then scale = 1.5 end
        if scale < 0.5 then scale = 0.5 end

        self.moveFrame:SetScale(scale)

        EBF:InformUser("scale")
    end
end

function EBF:CreateMoveHandleAtPoint(parentFrame, anchorPoint, relativePoint, offX, offY)
    if not parentFrame then return nil end

    local handleFrame = CreateFrame("Frame", "Wind_MoveFrameHandle" .. parentFrame:GetName(), parentFrame)
    handleFrame:EnableMouse(true)
    handleFrame:SetClampedToScreen(true)
    handleFrame:SetPoint(anchorPoint, parentFrame, relativePoint, offX, offY)
    handleFrame:SetHeight(16)
    handleFrame:SetWidth(16)

    handleFrame.texture = handleFrame:CreateTexture()
    handleFrame.texture:SetTexture("Interface/Buttons/UI-Panel-BiggerButton-Up")
    handleFrame.texture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    handleFrame.texture:SetAllPoints()

    return handleFrame
end

local movableFramesWithHandle = {
    ["CharacterFrame"] = {
        PaperDollFrame,
        PetPaperDollFrame,
        CompanionFrame,
        ReputationFrame,
        SkillFrame,
        HonorFrame,
        TokenFrame
    },
    ["ColorPickerFrame"] = {EBF:CreateMoveHandleAtPoint(ColorPickerFrame, "CENTER", "TOPRIGHT", -8, -8)},
    ["MailFrame"] = {SendMailFrame}
}

function EBF:SetMoveHandle(moveFrame, handleFrame)
    if not moveFrame then return end

    moveFrame:SetMovable(true)
    moveFrame:SetClampedToScreen(true)

    OnSizeUpdate(moveFrame)

    hooksecurefunc(moveFrame, "SetPoint", OnSetPoint)
    hooksecurefunc(moveFrame, "SetWidth", OnSizeUpdate)
    hooksecurefunc(moveFrame, "SetHeight", OnSizeUpdate)

    if not handleFrame then handleFrame = moveFrame end

    handleFrame.moveFrame = moveFrame
    handleFrame:HookScript("OnMouseDown", OnMouseDown)
    handleFrame:HookScript("OnMouseUp", OnMouseUp)
    handleFrame:HookScript("OnMouseWheel", OnMouseWheel)

    handleFrame:EnableMouse(true)
    handleFrame:EnableMouseWheel(true)
end

function EBF:InformUser(action)
    if not self.db.help_info then return end
    if not HelpInfoRecord[action] then
        HelpInfoRecord[action] = true

        if action == "move" then
            print(L["WindTools"] .. ": " .. L["You just moved a frame. SHIFT+Click to reset the position."])
        else
            print(L["WindTools"] .. ": " .. L["You just resized a frame. CTRL+Click to reset the scale."])
        end
    end
end

function EBF:ResetFrameScale(frame)
    if InCombatLockdown() and frame:IsProtected() then return end -- Cancel function in combat, can't use protected functions.

    frame:SetScale(1)
end

function EBF:ResetFramePoints(frame, frameName)
    if InCombatLockdown() and frame:IsProtected() then return end -- Cancel function in combat, can't use protected functions.

    if self.db.frame_points[frameName] then
        self.db.frame_points[frameName] = nil

        UpdateUIPanelPositions(frame)
    end
end

function EBF:RestoreFramePoints(frame, frameName)
    if not self.db.remember then return end
    if InCombatLockdown() and frame:IsProtected() then return end -- Cancel function in combat, can't use protected functions.

    if self.db.frame_points[frameName] and self.db.frame_points[frameName][1] then
        frame:ClearAllPoints()

        for curPoint = 1, #self.db.frame_points[frameName] do
            if self.db.frame_points[frameName][curPoint] then
                frame.WindMoveFramesBypassHook = true -- Used to block SetPoint hook from causing an infinite loop.
                frame:SetPoint(EBF.db.frame_points[frameName][curPoint].anchorPoint,
                               EBF.db.frame_points[frameName][curPoint].relativeFrame,
                               EBF.db.frame_points[frameName][curPoint].relativePoint,
                               EBF.db.frame_points[frameName][curPoint].offX,
                               EBF.db.frame_points[frameName][curPoint].offY)
                frame.WindMoveFramesBypassHook = nil
            end
        end
    end
end

function EBF:StoreFramePoints(frame, frameName)
    if not self.db.remember then return end
    if noSaveFrames[frameName] then return end

    local numPoints = frame:GetNumPoints()

    if numPoints then
        self.db.frame_points[frameName] = {}

        for curPoint = 1, numPoints do
            self.db.frame_points[frameName][curPoint] = {}
            self.db.frame_points[frameName][curPoint].anchorPoint, self.db.frame_points[frameName][curPoint]
                .relativeFrame, self.db.frame_points[frameName][curPoint].relativePoint, self.db.frame_points[frameName][curPoint]
                .offX, self.db.frame_points[frameName][curPoint].offY = frame:GetPoint(curPoint)
        end
    end
end

function EBF:ADDON_LOADED(_, addon)
    local list = movableFramesLoadOnDemand[addon]
    if list then for _, frame in pairs(list) do self:SetMoveHandle(_G[frame]) end end
    -- 部分框架没有全局名
    if addon == 'Blizzard_Communities' then
        self:SetMoveHandle(_G.ClubFinderGuildFinderFrame.RequestToJoinFrame)
        self:SetMoveHandle(_G.CommunitiesFrame.RecruitmentDialog)
    end
end

function EBF:VehicleScale()
    local frame = _G.VehicleSeatIndicator
    local frameScale = self.db.vehicleSeatScale
    frame:SetScale(frameScale)
    if frame.mover then frame.mover:SetSize(frameScale * frame:GetWidth(), frameScale * frame:GetHeight()) end
end

function EBF:MoveNormalFrames()
    for _, frame in pairs(movableFrames) do self:SetMoveHandle(_G[frame]) end

    for frame, handles in pairs(movableFramesWithHandle) do
        for _, handle in pairs(handles) do self:SetMoveHandle(_G[frame], handle) end
    end
end

function EBF:CheckESLBlizzMove()
    if IsAddOnLoaded("BlizzMove") then
        message("WindTools" .. " " .. L["Move Blizzard frame is conflict with BlizzMove. \nPlease disable one of them."])
        return true
    end

    if E.private and E.private.sle and E.private.sle.module then
        if E.private.sle.module.blizzmove.enable then
            message("WindTools" .. " " ..
                        L["Move Blizzard frame is conflict with Shadow&Light.\nPlease cancel the duplicate option."])
            return true
        end
    end
    return false;
end

function EBF:ErrorFrameSize() _G["UIErrorsFrame"]:SetSize(self.db.errorframe.width, self.db.errorframe.height) end

function EBF:Initialize()
    if not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["enabled"] then return end

    self.db = E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]
    tinsert(WT.UpdateAll, function()
        EBF.db = E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]
        EBF:ErrorFrameSize()
    end)

    -- 去除之前模块的残留信息
    if self.db.points then self.db.points = nil end
    if not self.db.frame_points then self.db.frame_points = {} end
    if not self.db.remember then self.db.frame_points = nil end
    if not self.db.moveframe or self:CheckESLBlizzMove() then return end
    self:MoveNormalFrames()
    self:RegisterEvent("ADDON_LOADED")
    if self.db.moveelvbag then self:SetMoveHandle(_G.ElvUI_ContainerFrame) end
    self:ErrorFrameSize()
end

local function InitializeCallback() EBF:Initialize() end

E:RegisterModule(EBF:GetName(), InitializeCallback)
