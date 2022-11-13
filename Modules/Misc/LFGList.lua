local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local LL = W:NewModule("LFGList", "AceHook-3.0")
local LSM = E.Libs.LSM
local LFGPI = W.Utilities.LFGPlayerInfo
local C = W.Utilities.Color

local gsub = gsub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor

local stopMeetingStoneRendering = false

local RoleIconTextures = {
    FFXIV = {
        TANK = W.Media.Icons.ffxivTank,
        HEALER = W.Media.Icons.ffxivHealer,
        DAMAGER = W.Media.Icons.ffxivDPS
    },
    HEXAGON = {
        TANK = W.Media.Icons.hexagonTank,
        HEALER = W.Media.Icons.hexagonHealer,
        DAMAGER = W.Media.Icons.hexagonDPS
    },
    SUNUI = {
        TANK = W.Media.Icons.sunUITank,
        HEALER = W.Media.Icons.sunUIHealer,
        DAMAGER = W.Media.Icons.sunUIDPS
    },
    LYNUI = {
        TANK = W.Media.Icons.lynUITank,
        HEALER = W.Media.Icons.lynUIHealer,
        DAMAGER = W.Media.Icons.lynUIDPS
    },
    DEFAULT = {
        TANK = E.Media.Textures.Tank,
        HEALER = E.Media.Textures.Healer,
        DAMAGER = E.Media.Textures.DPS
    }
}

function LL:UpdateAdditionalText(button, score, best)
    local db = self.db.additionalText

    if not db.enable or not button.Name or not button.ActivityName then
        return
    end

    if not db.template or not score or not best then
        return
    end

    if db.shortenDescription then
        local commentText = button.ActivityName:GetText()
        commentText = gsub(commentText, "%([^%)]+%)", "")
        button.ActivityName:SetText(commentText)
    end

    local target = button[db.target == "TITLE" and "Name" or "ActivityName"]

    local text = target:GetText()

    if db.target == "COMMENT" then
        text = gsub(text, "%([^%)]+%)", "")
    end

    local result = db.template

    result = gsub(result, "{{score}}", score)
    result = gsub(result, "{{best}}", best)
    result = gsub(result, "{{text}}", text)

    target:SetText(result)
end

function LL:MemberDisplay_SetActivity(memberDisplay, activity)
    memberDisplay.resultID = activity and activity.GetID and activity:GetID() or nil
end

function LL:HandleMeetingStone()
    if IsAddOnLoaded("MeetingStone") or IsAddOnLoaded("MeetingStonePlus") then
        local meetingStone = LibStub("AceAddon-3.0"):GetAddon("MeetingStone")

        if not meetingStone then
            return
        end

        local profile = meetingStone:GetModule("Profile")

        -- Special check for MeetingStone Happy Version
        local showClassIco = profile:GetSetting("showclassico")
        if profile.Getshowclassico then
            showClassIco = profile:Getshowclassico()
        end

        if showClassIco then
            stopMeetingStoneRendering = true
        end

        local memberDisplay = meetingStone:GetClass("MemberDisplay")

        if memberDisplay and memberDisplay.SetActivity then
            self:Hook(memberDisplay, "SetActivity", "MemberDisplay_SetActivity")
        end
    end
end

function LL:ReskinIcon(parent, icon, role, data)
    local class = data and data[1]
    local spec = data and data[2]
    local isLeader = data and data[3]

    if role then
        if self.db.icon.reskin then
            -- if not class and spec info, use square style instead
            local pack = self.db.icon.pack
            if pack == "SPEC" and (not class or not spec) then
                pack = "SQUARE"
            end

            if pack == "SQUARE" then
                icon:SetTexture(W.Media.Textures.ROLES)
                icon:SetTexCoord(F.GetRoleTexCoord(role))
            elseif pack == "SPEC" then
                local tex = LFGPI.GetIconTextureWithClassAndSpecName(class, spec)
                icon:SetTexture(tex)
                icon:SetTexCoord(unpack(E.TexCoords))
            else
                icon:SetTexture(RoleIconTextures[pack][role])
                icon:SetTexCoord(0, 1, 0, 1)
            end
        end

        icon:Size(self.db.icon.size)

        if self.db.icon.border and not icon.backdrop then
            icon:CreateBackdrop("Transparent")
        end

        icon:SetAlpha(self.db.icon.alpha)
        if icon.backdrop then
            icon.backdrop:SetAlpha(self.db.icon.alpha)
        end
    else
        icon:SetAlpha(0)
        if icon.backdrop then
            icon.backdrop:SetAlpha(0)
        end
    end

    if self.db.icon.leader then
        if not icon.leader then
            local leader = parent:CreateTexture(nil, "OVERLAY")
            leader:SetTexture(W.Media.Icons.leader)
            leader:Size(10, 8)
            leader:SetPoint("BOTTOM", icon, "TOP", 0, 1)
            icon.leader = leader
        end

        icon.leader:SetShown(isLeader)
    end

    -- Create bar in class color behind
    if class and self.db.line.enable then
        if not icon.line then
            local line = parent:CreateTexture(nil, "ARTWORK")
            line:SetTexture(LSM:Fetch("statusbar", self.db.line.tex) or E.media.normTex)
            line:Size(self.db.line.width, self.db.line.height)
            line:Point("TOP", icon, "BOTTOM", self.db.line.offsetX, self.db.line.offsetY)
            icon.line = line
        end

        local color = E:ClassColor(class, false)
        icon.line:SetVertexColor(color.r, color.g, color.b)
        icon.line:SetAlpha(self.db.line.alpha)
    elseif icon.line then
        icon.line:SetAlpha(0)
    end
end

function LL:UpdateEnumerate(Enumerate)
    local button = Enumerate:GetParent():GetParent()

    if not button.resultID or stopMeetingStoneRendering then
        return
    end

    local result = C_LFGList_GetSearchResultInfo(button.resultID)
    local info = C_LFGList_GetActivityInfoTable(result.activityID)

    if not result then
        return
    end

    local cache = {
        TANK = {},
        HEALER = {},
        DAMAGER = {}
    }

    for i = 1, result.numMembers do
        local role, class, _, spec = C_LFGList_GetSearchResultMemberInfo(button.resultID, i)
        tinsert(cache[role], {class, spec, i == 1})
    end

    for i = 5, 1, -1 do -- The index of icon starts from right
        local icon = Enumerate["Icon" .. i]
        if icon and icon.SetTexture then
            if #cache.TANK > 0 then
                self:ReskinIcon(Enumerate, icon, "TANK", cache.TANK[1])
                tremove(cache.TANK, 1)
            elseif #cache.HEALER > 0 then
                self:ReskinIcon(Enumerate, icon, "HEALER", cache.HEALER[1])
                tremove(cache.HEALER, 1)
            elseif #cache.DAMAGER > 0 then
                self:ReskinIcon(Enumerate, icon, "DAMAGER", cache.DAMAGER[1])
                tremove(cache.DAMAGER, 1)
            else
                self:ReskinIcon(Enumerate, icon)
            end
        end
    end

    if self.db.additionalText.enable and result and info and info.isMythicPlusActivity then
        local scoreText, bestText

        local score = result.leaderOverallDungeonScore or 0
        local color = score and C_ChallengeMode_GetDungeonScoreRarityColor(score) or {r = 1.0, g = 1.0, b = 1.0}
        scoreText = C.StringWithRGB(score, color)

        local bestRun = result.leaderDungeonScoreInfo and result.leaderDungeonScoreInfo.bestRunLevel
        if bestRun then
            local template = result.leaderDungeonScoreInfo.finishedSuccess and "success" or "greyLight"
            bestText = C.StringByTemplate("+" .. result.leaderDungeonScoreInfo.bestRunLevel, template)
        end

        self:UpdateAdditionalText(button, scoreText, bestText)
    end
end

function LL:UpdateRoleCount(RoleCount)
    if RoleCount.TankIcon then
        self:ReskinIcon(nil, RoleCount.TankIcon, "TANK")
    end
    if RoleCount.HealerIcon then
        self:ReskinIcon(nil, RoleCount.HealerIcon, "HEALER")
    end
    if RoleCount.DamagerIcon then
        self:ReskinIcon(nil, RoleCount.DamagerIcon, "DAMAGER")
    end
end

function LL:Initialize()
    if IsAddOnLoaded("PremadeGroupsFilter") then
        self.StopRunning = "PremadeGroupsFilter"
        return
    end

    self.db = E.private.WT.misc.lfgList
    if not self.db.enable then
        return
    end

    self:HandleMeetingStone()
    self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
    self:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")
end

W:RegisterModule(LL:GetName())
