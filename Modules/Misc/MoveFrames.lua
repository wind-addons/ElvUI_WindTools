local W, F, E, L = unpack(select(2, ...))
local MF = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")

local BlizzardFrames = {
    "AddonList",
    "AudioOptionsFrame",
    "BankFrame",
    "ChatConfigFrame",
    "CinematicFrame",
    "CharacterFrame",
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
    "PetitionFrame",
    "PetStableFrame",
    "PVEFrame",
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
    "WorldMapFrame"
}

local BlizzardSubFrames = {
    ["CharacterFrame"] = {
        "PaperDollFrame",
        "PetPaperDollFrame",
        "CompanionFrame",
        "ReputationFrame",
        "SkillFrame",
        "HonorFrame",
        "TokenFrame"
    },
    ["MailFrame"] = {
        "SendMailFrame",
        ["OpenMailFrame"] = {
            "OpenMailSender",
            "OpenMailFrameInset"
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

function MF:HandleFrame(frame, hookFrame)
    if not frame or (InCombatLockdown() and frame:IsProtected()) then
        return
    end

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)

    hookFrame = hookFrame or frame
    hookFrame.MoveFrame = frame

    hookFrame:EnableMouse(true)
    hookFrame:HookScript("OnMouseDown", OnMouseDown)
    hookFrame:HookScript("OnMouseUp", OnMouseUp)
end

function MF:Test()
    for _, frameName in pairs(BlizzardFrames) do
        if not _G[frameName] then
            print(frameName)
        end
    end
end

function MF:Initialize()
    self.db = E.private.WT.misc
    if not self.db then
        return
    end

    if self.db.moveBlizzardFrames then
        for _, frameName in pairs(BlizzardFrames) do
            self:HandleFrame(_G[frameName])
        end
    end
end

W:RegisterModule(MF:GetName())
