local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local LL = W:NewModule("LFGList", "AceHook-3.0", "AceEvent-3.0")
local LSM = E.Libs.LSM
local LFGPI = W.Utilities.LFGPlayerInfo
local C = W.Utilities.Color
local openRaidLib = LibStub("LibOpenRaid-1.0", true)

local _G = _G
local floor = floor
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = max
local min = min
local pairs = pairs
local select = select
local sort = sort
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local type = type
local unpack = unpack
local wipe = wipe

local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTime = GetTime
local GetUnitName = GetUnitName
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsInGroup = IsInGroup
local LoadAddOn = LoadAddOn
local UnitClassBase = UnitClassBase
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local WeeklyRewards_LoadUI = WeeklyRewards_LoadUI

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetApplicationInfo = C_LFGList.GetApplicationInfo
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local C_MythicPlus = C_MythicPlus
local C_MythicPlus_GetCurrentAffixes = C_MythicPlus.GetCurrentAffixes
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory

local RoleIconTextures = {
    PHILMOD = {
        TANK = W.Media.Icons.philModTank,
        HEALER = W.Media.Icons.philModHealer,
        DAMAGER = W.Media.Icons.philModDPS
    },
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

local mythicKeystoneDungeons = {
    [2] = L["[ABBR] Temple of the Jade Serpent"],
    [165] = L["[ABBR] Shadowmoon Burial Grounds"],
    [200] = L["[ABBR] Halls of Valor"],
    [210] = L["[ABBR] Court of Stars"],
    [399] = L["[ABBR] Ruby Life Pools"],
    [400] = L["[ABBR] The Nokhud Offensive"],
    [401] = L["[ABBR] The Azure Vault"],
    [402] = L["[ABBR] Algeth'ar Academy"]
}

local activityIDToMapID = {
    [1192] = 2,
    [1193] = 165,
    [461] = 200,
    [466] = 210,
    [1176] = 399,
    [1184] = 400,
    [1180] = 401,
    [1160] = 402
}

local vaultItemLevel = {
    0,
    382,
    385,
    385,
    389,
    389,
    392,
    395,
    395,
    398,
    402,
    405,
    408,
    408,
    411,
    415,
    415,
    418,
    418,
    421
}

local affixLoop = {
    {10, 6, 14, 132},
    {9, 11, 12, 132},
    {10, 8, 3, 132},
    {9, 6, 124, 132},
    {10, 123, 1, 132},
    {9, 8, 13, 132},
    {10, 7, 124, 132},
    {9, 123, 14, 132},
    {10, 11, 13, 132},
    {9, 7, 3, 132}
}

local avaliableSortMode = {
    "DEFAULT",
    "OVERALL_SCORE",
    "DUNGEON_SCORE"
}

local sortMode = {
    ["DUNGEON_SCORE"] = {
        text = L["Dungeon Score"],
        tooltip = L["Leader's Dungeon Score"],
        func = function(a, b)
            local _a = (a and a.dungeonScore or 0)
            local _b = (b and b.dungeonScore or 0)
            return _a > _b and 1 or _a < _b and -1 or 0
        end
    },
    ["OVERALL_SCORE"] = {
        text = L["Overall Score"],
        tooltip = L["Leader's Overall Score"],
        func = function(a, b)
            local _a = (a and a.overallScore or 0)
            local _b = (b and b.overallScore or 0)
            return _a > _b and 1 or _a < _b and -1 or 0
        end
    },
    ["DEFAULT"] = {
        text = L["Default"],
        tooltip = L["Default"]
    }
}

local function getKeystoneLevelColor(level)
    if level < 5 then
        return "ffffffff"
    elseif level < 10 then
        return "ff1eff00"
    elseif level < 15 then
        return "ff0070dd"
    elseif level < 20 then
        return "ffa335ee"
    else
        return "ffff8000"
    end
end

function LL:GetPlayerDB(key)
    local globalDB = E.global.WT.misc.lfgList

    if not globalDB then
        return
    end

    if not globalDB[E.myrealm] then
        globalDB[E.myrealm] = {}
    end

    if not globalDB[E.myrealm][E.myname] then
        globalDB[E.myrealm][E.myname] = {}
    end

    if not globalDB[E.myrealm][E.myname][key] then
        globalDB[E.myrealm][E.myname][key] = {}
    end

    return globalDB[E.myrealm][E.myname][key]
end

function LL:UpdateAdditionalText(button, score, best)
    local db = self.db.additionalText

    if not db.enable or not button.Name or not button.ActivityName then
        return
    end

    if not db.template or not score or not best then
        return
    end

    if db.shortenDescription then
        local descriptionText = button.ActivityName:GetText()
        descriptionText = gsub(descriptionText, "%([^%)]+%)", "")
        button.ActivityName:SetText(descriptionText)
    end

    local target = button[db.target == "TITLE" and "Name" or "ActivityName"]

    local text = target:GetText()

    local result = db.template

    result = gsub(result, "{{score}}", score)
    result = gsub(result, "{{best}}", best)
    result = gsub(result, "{{text}}", text)

    target:SetText(result)
end

function LL:MemberDisplay_SetActivity(memberDisplay, activity)
    memberDisplay.resultID = activity and activity.GetID and activity:GetID() or nil
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

    if parent then
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
        elseif parent and icon.line then
            icon.line:SetAlpha(0)
        end
    end
end

function LL:UpdateEnumerate(Enumerate)
    local button = Enumerate:GetParent():GetParent()

    if not button.resultID then
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

function LL:InitializePartyKeystoneFrame()
    local frame = CreateFrame("Frame", "WTPartyKeystoneFrame", _G.ChallengesFrame)
    frame:SetSize(200, 150)
    frame:SetTemplate("Transparent")

    frame:SetPoint("BOTTOMRIGHT", _G.ChallengesFrame, "BOTTOMRIGHT", -8, 85)

    frame.lines = {}

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    F.SetFontWithDB(frame.title, self.db.partyKeystone.font)
    frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -10)
    frame.title:SetJustifyH("LEFT")
    frame.title:SetText(W.Title .. " - " .. L["Keystone"])

    frame.button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    frame.button:SetSize(60, self.db.partyKeystone.font.size + 4)
    F.SetFontWithDB(frame.button.Text, self.db.partyKeystone.font)
    F.SetFontOutline(frame.button.Text, nil, "-2")
    frame.button:SetText(L["More"])
    frame.button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
    S:ESProxy("HandleButton", frame.button)
    frame.button:SetScript(
        "OnClick",
        function()
            if _G.SlashCmdList["KEYSTONE"] then
                _G.SlashCmdList["KEYSTONE"]("")
            else
                F.Print(L["You need to install Details! first."])
            end
        end
    )

    for i = 1, 5 do
        local yOffset = (2 + self.db.partyKeystone.font.size) * (i - 1) + 5

        local rightText = frame:CreateFontString(nil, "OVERLAY")
        F.SetFontWithDB(rightText, self.db.partyKeystone.font)
        rightText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, yOffset)
        rightText:SetJustifyH("RIGHT")
        rightText:SetWidth(90)

        local leftText = frame:CreateFontString(nil, "OVERLAY")
        F.SetFontWithDB(leftText, self.db.partyKeystone.font)
        leftText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -100, yOffset)
        leftText:SetJustifyH("LEFT")
        leftText:SetWidth(90)

        frame.lines[i] = {
            left = leftText,
            right = rightText
        }
    end

    LL.partyKeystoneFrame = frame
end

function LL:UpdatePartyKeystoneFrame()
    if not self.db.partyKeystone.enable then
        if LL.partyKeystoneFrame then
            LL.partyKeystoneFrame:Hide()
        end
        return
    end

    if not LL.partyKeystoneFrame then
        self:InitializePartyKeystoneFrame()
    end

    local frame = LL.partyKeystoneFrame

    local scale = self.db.partyKeystone.font.size / 12
    local heightIncrement = floor(8 * scale)
    local blockWidth = floor(95 * scale)
    local cache = {}

    for i = 1, 5 do
        local unitID = i == 1 and "player" or "party" .. i - 1
        local data = openRaidLib.GetKeystoneInfo(unitID)
        local mapID = data and data.mythicPlusMapID
        if mapID and mythicKeystoneDungeons[mapID] then
            local level = data.level
            local playerClass = UnitClassBase(unitID)
            local playerName = GetUnitName(unitID, false)
            local texture = select(4, C_ChallengeMode_GetMapUIInfo(tonumber(mapID)))

            tinsert(
                cache,
                {
                    level = level,
                    name = mythicKeystoneDungeons[mapID],
                    player = F.CreateClassColorString(playerName, playerClass),
                    icon = texture
                }
            )
        end
    end

    F.SetFontWithDB(frame.title, self.db.partyKeystone.font)

    frame.button:SetSize(floor(60 * scale), self.db.partyKeystone.font.size + 4)
    F.SetFontWithDB(frame.button.Text, self.db.partyKeystone.font)
    F.SetFontOutline(frame.button.Text, nil, "-2")

    for i = 1, 5 do
        local yOffset = (heightIncrement + self.db.partyKeystone.font.size) * (i - 1) + 10

        F.SetFontWithDB(frame.lines[i].right, self.db.partyKeystone.font)
        frame.lines[i].right:ClearAllPoints()
        frame.lines[i].right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, yOffset)
        frame.lines[i].right:SetJustifyH("RIGHT")
        frame.lines[i].right:SetWidth(blockWidth)

        F.SetFontWithDB(frame.lines[i].left, self.db.partyKeystone.font)
        frame.lines[i].left:ClearAllPoints()
        frame.lines[i].left:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -blockWidth - 9, yOffset)
        frame.lines[i].left:SetWidth(blockWidth)

        if cache[i] then
            frame.lines[i].right:SetText(cache[i].player)
            frame.lines[i].left:SetText(
                format(
                    "|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t |c%s%s (%s)|r",
                    cache[i].icon,
                    getKeystoneLevelColor(cache[i].level),
                    cache[i].name,
                    cache[i].level
                )
            )
        else
            frame.lines[i].right:SetText("")
            frame.lines[i].left:SetText("")
        end
    end

    frame:SetSize(
        blockWidth * 2 + 20,
        20 + (heightIncrement + self.db.partyKeystone.font.size) * #cache + self.db.partyKeystone.font.size
    )
    frame:Show()
end

function LL:RequestKeystoneData()
    if IsInGroup() then
        openRaidLib.RequestKeystoneDataFromParty()
    end

    E:Delay(0.5, self.UpdatePartyKeystoneFrame, self)
    E:Delay(2, self.UpdatePartyKeystoneFrame, self)
end

LL.refreshRequestTimestamp = 0
LL.scheduledRefreshTimestamp = 0
LL.lastRefreshTimestamp = 0

function LL:RefreshSearchAt(timestamp)
    if self.refreshRequestTimestamp ~= timestamp then
        return
    end

    local now = GetTime()

    if now < self.lastRefreshTimestamp + 5 then
        E:Delay(self.lastRefreshTimestamp + 5.05 - now, self.RefreshSearchAt, self, timestamp)
        return
    end

    if
        _G.PVEFrame:IsVisible() and _G.LFGListFrame.activePanel == _G.LFGListFrame.SearchPanel and
            _G.LFGListFrame.SearchPanel:IsVisible() and
            _G.LFGListFrame.SearchPanel.categoryID == 2
     then
        _G.LFGListFrame.SearchPanel.RefreshButton:Click()
    end

    self.lastRefreshTimestamp = timestamp
end

function LL:RefreshSearch()
    if not self.db.rightPanel.enable or not self.db.rightPanel.autoRefresh then
        return
    end

    local now = GetTime()

    if self.refreshRequestTimestamp == now then
        return
    end

    self.refreshRequestTimestamp = now
    self.scheduledRefreshTimestamp = max(now + 1, self.lastRefreshTimestamp + 5)

    E:Delay(1, self.RefreshSearchAt, self, now)
end

function LL:InitalizeRightPanel()
    if self.rightPanel then
        return
    end

    local frame = CreateFrame("Frame", nil, _G.PVEFrame)
    frame:SetWidth(200)
    frame:SetPoint("TOPLEFT", _G.PVEFrame, "TOPRIGHT", 3, 0)
    frame:SetPoint("BOTTOMLEFT", _G.PVEFrame, "BOTTOMRIGHT", 3, 0)
    frame:SetTemplate("Transparent")
    S:CreateShadowModule(frame)
    if E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning then
        local MF = W.Modules.MoveFrames
        MF:HandleFrame(frame, "PVEFrame")
    end

    hooksecurefunc(
        frame,
        "Show",
        function(f)
            if _G.RaiderIO_ProfileTooltipAnchor then
                local point = {_G.RaiderIO_ProfileTooltipAnchor:GetPoint(1)}

                if not _G.RaiderIO_ProfileTooltipAnchor.__SetPoint then
                    _G.RaiderIO_ProfileTooltipAnchor.__SetPoint = _G.RaiderIO_ProfileTooltipAnchor.SetPoint
                    _G.RaiderIO_ProfileTooltipAnchor.SetPoint = function(_, arg1, arg2, arg3, arg4, arg5)
                        if arg2 and (arg2 == _G.PVEFrame or arg2 == f) then
                            arg2 = f:IsShown() and f or _G.PVEFrame
                        end
                        _G.RaiderIO_ProfileTooltipAnchor:__SetPoint(arg1, arg2, arg3, arg4, arg5)
                    end
                end

                if #point > 0 then
                    _G.RaiderIO_ProfileTooltipAnchor:ClearAllPoints()
                    _G.RaiderIO_ProfileTooltipAnchor:SetPoint(unpack(point))
                end
            end
        end
    )

    hooksecurefunc(
        frame,
        "Hide",
        function(f)
            if _G.RaiderIO_ProfileTooltipAnchor then
                local point = {_G.RaiderIO_ProfileTooltipAnchor:GetPoint(1)}

                if not _G.RaiderIO_ProfileTooltipAnchor.__SetPoint then
                    _G.RaiderIO_ProfileTooltipAnchor.__SetPoint = _G.RaiderIO_ProfileTooltipAnchor.SetPoint
                    _G.RaiderIO_ProfileTooltipAnchor.SetPoint = function(_, arg1, arg2, arg3, arg4, arg5)
                        if arg2 and (arg2 == _G.PVEFrame or arg2 == f) then
                            arg2 = f:IsShown() and f or _G.PVEFrame
                        end
                        _G.RaiderIO_ProfileTooltipAnchor:__SetPoint(arg1, arg2, arg3, arg4, arg5)
                    end
                end

                if #point > 0 then
                    _G.RaiderIO_ProfileTooltipAnchor:ClearAllPoints()
                    _G.RaiderIO_ProfileTooltipAnchor:SetPoint(unpack(point))
                end
            end
        end
    )

    local currAffixIndex = 0
    local currAffixes = C_MythicPlus_GetCurrentAffixes()

    if currAffixes then
        for i = 1, #affixLoop do
            local affixes = affixLoop[i]
            if affixes[1] == currAffixes[1].id and affixes[2] == currAffixes[2].id and affixes[3] == currAffixes[3].id then
                currAffixIndex = i
                break
            end
        end
    end

    if currAffixIndex and currAffixIndex ~= 0 then
        local nextAffixIndex = (currAffixIndex + 1) % #affixLoop
        if nextAffixIndex == 0 then
            nextAffixIndex = #affixLoop
        end

        frame.affix = CreateFrame("Frame", nil, frame)
        frame.affix:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        frame.affix:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
        frame.affix:SetHeight(32)

        local width = frame.affix:GetWidth()
        local space = (width - 32 * 4) / 3
        for i = 1, 4 do
            local affix = frame.affix:CreateTexture(nil, "ARTWORK")
            affix:SetSize(32, 32)
            affix:SetPoint("LEFT", frame.affix, "LEFT", (i - 1) * (32 + space), 0)
            local fileDataID = select(3, C_ChallengeMode_GetAffixInfo(affixLoop[currAffixIndex][i]))
            affix:SetTexture(fileDataID)
            affix:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end

        frame.affix:SetScript(
            "OnEnter",
            function()
                _G.GameTooltip:SetOwner(frame.affix, "ANCHOR_BOTTOM")
                _G.GameTooltip:ClearLines()
                _G.GameTooltip:AddLine(F.GetWindStyleText(L["Next Affixes"]))
                for i = 1, 4 do
                    local name, description, fileDataID = C_ChallengeMode_GetAffixInfo(affixLoop[nextAffixIndex][i])
                    _G.GameTooltip:AddLine(" ")
                    _G.GameTooltip:AddLine(format("|T%d:16:18:0:0:64:64:4:60:7:57:255:255:255|t %s", fileDataID, name))
                    _G.GameTooltip:AddLine(description, 1, 1, 1, true)
                end
                _G.GameTooltip:Show()
            end
        )

        frame.affix:SetScript(
            "OnLeave",
            function()
                _G.GameTooltip:Hide()
            end
        )
    end

    local filters = CreateFrame("Frame", nil, frame)
    if frame.affix then
        filters:SetPoint("TOPLEFT", frame.affix, "BOTTOMLEFT", 0, -10)
        filters:SetPoint("TOPRIGHT", frame.affix, "BOTTOMRIGHT", 0, -10)
    else
        filters:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        filters:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    end

    filters:SetHeight(6 * 8 + 28 * 4 + 32 * 3)
    filters.buttons = {}

    local filterButtonWidth = (filters:GetWidth() - 8) / 2

    local function addSetActive(obj)
        obj.SetActive = function(f, active)
            local r, g, b = unpack(E.media.rgbvaluecolor)
            if active then
                f:SetBackdropBorderColor(r, g, b)
                f:SetBackdropColor(r, g, b, 0.5)
            else
                f:SetBackdropBorderColor(0, 0, 0)
                f:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
            end
            f.active = active
        end
    end

    for i, mapID in ipairs({2, 165, 200, 210, 399, 400, 401, 402}) do
        local filterButton = CreateFrame("Frame", nil, filters)
        filterButton:SetTemplate()
        filterButton:SetSize(filterButtonWidth, 28)
        local yOffset = -6 * floor((i + 1) / 2) - 28 * floor((i - 1) / 2)
        local anchorPoint = i % 2 == 1 and "TOPLEFT" or "TOPRIGHT"
        filterButton:SetPoint(anchorPoint, filters, anchorPoint, 0, yOffset)

        filterButton.tex = filterButton:CreateTexture(nil, "ARTWORK")
        filterButton.tex:SetSize(20, 20)
        filterButton.tex:SetPoint("LEFT", filterButton, "LEFT", 4, 0)
        local texture = select(4, C_ChallengeMode_GetMapUIInfo(tonumber(mapID)))
        filterButton.tex:SetTexture(texture)

        filterButton.name = filterButton:CreateFontString(nil, "OVERLAY")
        filterButton.name:SetFont(E.media.normFont, 12, "OUTLINE")
        filterButton.name:SetPoint("LEFT", filterButton.tex, "RIGHT", 8, 0)
        filterButton.name:SetText(mythicKeystoneDungeons[mapID])

        addSetActive(filterButton)

        filterButton:SetScript(
            "OnMouseDown",
            function(btn, button)
                if button == "LeftButton" then
                    local dfDB = self:GetPlayerDB("dungeonFilter")
                    btn:SetActive(not btn.active)
                    dfDB[mapID] = btn.active
                    LL:RefreshSearch()
                end
            end
        )

        filters.buttons[mapID] = filterButton
    end

    -- Leader Overall Score
    local leaderScore = CreateFrame("Frame", nil, filters)
    leaderScore:SetSize(filters:GetWidth(), 32)
    leaderScore:SetPoint("TOP", filters, "TOP", 0, -6 * 5 - 28 * 4)
    leaderScore:SetTemplate()

    leaderScore.text = leaderScore:CreateFontString(nil, "OVERLAY")
    leaderScore.text:SetFont(E.media.normFont, 11, "OUTLINE")
    leaderScore.text:SetPoint("LEFT", leaderScore, "LEFT", 8, 0)
    leaderScore.text:SetText(L["Leader Score Over"])

    leaderScore.editBox = CreateFrame("EditBox", nil, leaderScore)
    leaderScore.editBox:SetFont(E.media.normFont, 12, "OUTLINE")
    leaderScore.editBox:SetSize(40, 20)
    leaderScore.editBox:SetJustifyH("CENTER")
    leaderScore.editBox:SetPoint("RIGHT", leaderScore, "RIGHT", -5, 0)
    leaderScore.editBox:SetAutoFocus(false)
    leaderScore.editBox:SetScript(
        "OnEscapePressed",
        function(editBox)
            editBox:ClearFocus()
        end
    )

    leaderScore.editBox:SetScript(
        "OnEnterPressed",
        function(editBox)
            local dfDB = self:GetPlayerDB("dungeonFilter")

            local text = editBox:GetText()
            if text == "" then
                text = 0
                editBox:SetText(0)
            end

            dfDB.leaderScore = tonumber(text) or 0
            editBox:SetText(tostring(dfDB.leaderScore))
            editBox:ClearFocus()
            LL:RefreshSearch()
        end
    )

    S:ESProxy("HandleEditBox", leaderScore.editBox)

    addSetActive(leaderScore)

    leaderScore:SetScript(
        "OnEnter",
        function(btn)
            _G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
            _G.GameTooltip:AddLine(F.GetWindStyleText(L["Leader Score"]), 1, 1, 1)
            _G.GameTooltip:AddLine(L["The overall mythic+ score of the leader."], 1, 1, 1, true)
            _G.GameTooltip:Show()
        end
    )

    leaderScore:SetScript(
        "OnLeave",
        function(btn)
            _G.GameTooltip:Hide()
        end
    )

    leaderScore:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" then
                local dfDB = self:GetPlayerDB("dungeonFilter")
                btn:SetActive(not btn.active)
                dfDB.leaderScoreEnable = btn.active
                LL:RefreshSearch()
            end
        end
    )

    filters.leaderScore = leaderScore

    -- Leader Dungeon Score
    local leaderDungeonScore = CreateFrame("Frame", nil, filters)
    leaderDungeonScore:SetSize(filters:GetWidth(), 32)
    leaderDungeonScore:SetPoint("TOP", filters, "TOP", 0, -6 * 6 - 28 * 4 - 32)
    leaderDungeonScore:SetTemplate()

    leaderDungeonScore.text = leaderDungeonScore:CreateFontString(nil, "OVERLAY")
    leaderDungeonScore.text:SetFont(E.media.normFont, 11, "OUTLINE")
    leaderDungeonScore.text:SetPoint("LEFT", leaderDungeonScore, "LEFT", 8, 0)
    leaderDungeonScore.text:SetText(L["Dungeon Score Over"])

    leaderDungeonScore.editBox = CreateFrame("EditBox", nil, leaderDungeonScore)
    leaderDungeonScore.editBox:SetFont(E.media.normFont, 12, "OUTLINE")
    leaderDungeonScore.editBox:SetSize(40, 20)
    leaderDungeonScore.editBox:SetJustifyH("CENTER")
    leaderDungeonScore.editBox:SetPoint("RIGHT", leaderDungeonScore, "RIGHT", -5, 0)
    leaderDungeonScore.editBox:SetAutoFocus(false)
    leaderDungeonScore.editBox:SetScript(
        "OnEscapePressed",
        function(editBox)
            editBox:ClearFocus()
        end
    )

    leaderDungeonScore.editBox:SetScript(
        "OnEnterPressed",
        function(editBox)
            local dfDB = self:GetPlayerDB("dungeonFilter")

            local text = editBox:GetText()
            if text == "" then
                text = 0
                editBox:SetText(0)
            end

            dfDB.leaderDungeonScore = tonumber(text) or 0
            editBox:SetText(tostring(dfDB.leaderDungeonScore))
            editBox:ClearFocus()
            LL:RefreshSearch()
        end
    )

    S:ESProxy("HandleEditBox", leaderDungeonScore.editBox)

    addSetActive(leaderDungeonScore)

    leaderDungeonScore:SetScript(
        "OnEnter",
        function(btn)
            _G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
            _G.GameTooltip:AddLine(F.GetWindStyleText(L["Leader's Dungeon Score"]), 1, 1, 1)
            _G.GameTooltip:AddLine(L["The recruited dungeon mythic+ score of the leader."], 1, 1, 1, true)
            _G.GameTooltip:Show()
        end
    )

    leaderDungeonScore:SetScript(
        "OnLeave",
        function(btn)
            _G.GameTooltip:Hide()
        end
    )

    leaderDungeonScore:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" then
                local dfDB = self:GetPlayerDB("dungeonFilter")
                btn:SetActive(not btn.active)
                dfDB.leaderDungeonScoreEnable = btn.active
                LL:RefreshSearch()
            end
        end
    )

    filters.leaderDungeonScore = leaderDungeonScore

    -- Role Available
    local roleAvailable = CreateFrame("Frame", nil, filters)
    roleAvailable:SetSize(filters:GetWidth(), 32)
    roleAvailable:SetPoint("TOP", filters, "TOP", 0, -6 * 7 - 28 * 4 - 32 * 2)
    roleAvailable:SetTemplate()

    roleAvailable.text = roleAvailable:CreateFontString(nil, "OVERLAY")
    roleAvailable.text:SetFont(E.media.normFont, 11, "OUTLINE")
    roleAvailable.text:SetPoint("CENTER", roleAvailable, "CENTER", 0, 0)
    roleAvailable.text:SetText(L["Role Available"])
    roleAvailable.text:SetJustifyH("CENTER")

    roleAvailable:SetScript(
        "OnEnter",
        function(btn)
            _G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
            _G.GameTooltip:AddLine(F.GetWindStyleText(L["Role Available"]), 1, 1, 1)
            _G.GameTooltip:AddLine(
                format(
                    "%s %s %s",
                    L["Enable this filter will only show the group that fits you or your group members to join."],
                    L["It will check the role of current party members if you are in a group."],
                    L["Otherwise, it will filter with your current specialization."]
                ),
                1,
                1,
                1,
                true
            )
            _G.GameTooltip:Show()
        end
    )

    roleAvailable:SetScript(
        "OnLeave",
        function(btn)
            _G.GameTooltip:Hide()
        end
    )

    addSetActive(roleAvailable)

    roleAvailable:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" then
                local dfDB = self:GetPlayerDB("dungeonFilter")
                btn:SetActive(not btn.active)
                dfDB.roleAvailableEnable = btn.active
                LL:RefreshSearch()
            end
        end
    )

    filters.roleAvailable = roleAvailable

    frame.filters = filters

    local vaultStatus = CreateFrame("Frame", nil, frame)
    vaultStatus:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
    vaultStatus:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
    vaultStatus:SetHeight(32)
    vaultStatus:SetTemplate()

    addSetActive(vaultStatus)

    vaultStatus.text = vaultStatus:CreateFontString(nil, "OVERLAY")
    vaultStatus.text:SetFont(E.media.normFont, 13, "OUTLINE")
    vaultStatus.text:SetPoint("CENTER", vaultStatus, "CENTER", 0, 0)
    vaultStatus.text:SetJustifyH("CENTER")

    vaultStatus:SetScript(
        "OnEnter",
        function(btn)
            vaultStatus:SetActive(true)

            btn.update()
            if not btn.cache then
                return
            end

            _G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
            _G.GameTooltip:AddLine(F.GetWindStyleText(L["The Great Vault"]), 1, 1, 1)
            _G.GameTooltip:AddLine(" ")

            for i = 1, 8 do
                if btn.cache[i] then
                    local level = btn.cache[i].level
                    local name, _, _, tex = C_ChallengeMode_GetMapUIInfo(btn.cache[i].mapID)
                    _G.GameTooltip:AddDoubleLine(
                        format(
                            "|c%s%s|r  |T%s:14:16:0:0:64:64:4:60:7:57:255:255:255|t %s",
                            getKeystoneLevelColor(level),
                            level,
                            tex,
                            name
                        ),
                        vaultItemLevel[min(level, 20)],
                        1,
                        1,
                        1,
                        (i == 1 or i == 4 or i == 8) and 0 or 1,
                        1,
                        (i == 1 or i == 4 or i == 8) and 0 or 1
                    )
                else
                    break
                end
            end

            if #btn.cache == 0 then
                _G.GameTooltip:AddLine(L["No weekly runs found."], 1, 1, 1)
            end

            _G.GameTooltip:AddLine(" ")
            _G.GameTooltip:AddLine(L["Click to open the weekly rewards frame."], 1, 1, 1)

            _G.GameTooltip:Show()
        end
    )

    vaultStatus:SetScript(
        "OnLeave",
        function()
            vaultStatus:SetActive(false)
            _G.GameTooltip:Hide()
        end
    )

    vaultStatus:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" and not InCombatLockdown() then
                WeeklyRewards_ShowUI()
            end
        end
    )

    vaultStatus.update = function()
        local vaultStatusCache = {}
        local runHistory = C_MythicPlus_GetRunHistory(false, true)
        local comparison = function(entry1, entry2)
            if (entry1.level == entry2.level) then
                return entry1.mapChallengeModeID < entry2.mapChallengeModeID
            else
                return entry1.level > entry2.level
            end
        end

        sort(runHistory, comparison)

        for i = 1, #runHistory do
            local mapID = runHistory[i].mapChallengeModeID
            tinsert(
                vaultStatusCache,
                {
                    mapID = runHistory[i].mapChallengeModeID,
                    level = runHistory[i].level,
                    score = runHistory[i].score
                }
            )
        end

        local vaultItemString = "|cff666666" .. L["No Mythic+ Runs"] .. "|r"

        if #vaultStatusCache > 0 then
            vaultItemString =
                format("|c%s%s|r", getKeystoneLevelColor(vaultStatusCache[1].level), vaultStatusCache[1].level)
        end

        if #vaultStatusCache > 3 then
            vaultItemString =
                vaultItemString ..
                " / " .. format("|c%s%s|r", getKeystoneLevelColor(vaultStatusCache[4].level), vaultStatusCache[4].level)
        end

        if #vaultStatusCache > 7 then
            vaultItemString =
                vaultItemString ..
                " / " .. format("|c%s%s|r", getKeystoneLevelColor(vaultStatusCache[8].level), vaultStatusCache[8].level)
        end

        vaultStatus.cache = vaultStatusCache
        vaultStatus.text:SetText(vaultItemString)
    end

    frame.vaultStatus = vaultStatus

    local sortPanel = CreateFrame("Frame", nil, frame)
    sortPanel:SetPoint("BOTTOMLEFT", vaultStatus, "TOPLEFT", 0, 8)
    sortPanel:SetPoint("BOTTOMRIGHT", vaultStatus, "TOPRIGHT", 0, 8)
    sortPanel:SetHeight(32)

    local sortModeButton = CreateFrame("Frame", nil, sortPanel)
    sortModeButton:SetPoint("RIGHT", sortPanel, "RIGHT", 0, 0)
    sortModeButton:SetSize(32, 32)
    sortModeButton:SetTemplate()
    sortModeButton.tex = sortModeButton:CreateTexture(nil, "OVERLAY")
    sortModeButton.tex:SetSize(24, 24)
    sortModeButton.tex:SetPoint("CENTER", sortModeButton, "CENTER", 0, 0)
    sortModeButton.tex:SetTexture(W.Media.Textures.arrowDown)
    sortModeButton.tex:SetTexCoord(0, 1, 0, 1)
    sortModeButton.tex:SetVertexColor(1, 1, 1)

    addSetActive(sortModeButton)

    sortModeButton:SetScript(
        "OnEnter",
        function(btn)
            sortModeButton:SetActive(true)

            _G.GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 4, -34)
            _G.GameTooltip:AddLine(btn.descending and L["Descending"] or L["Ascending"], 1, 1, 1)
            _G.GameTooltip:Show()
        end
    )

    sortModeButton:SetScript(
        "OnLeave",
        function()
            sortModeButton:SetActive(false)
            _G.GameTooltip:Hide()
        end
    )

    sortModeButton:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" then
                local dfDB = self:GetPlayerDB("dungeonFilter")

                btn.descending = not btn.descending
                btn.tex:SetRotation(btn.descending and 0 or 3.14)
                LL:RefreshSearch()
                dfDB.sortDescending = btn.descending

                _G.GameTooltip:ClearLines()
                _G.GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 4, -34)
                _G.GameTooltip:AddLine(btn.descending and L["Descending"] or L["Ascending"], 1, 1, 1)
                _G.GameTooltip:Show()
            end
        end
    )

    sortPanel.sortModeButton = sortModeButton

    local sortByButton = CreateFrame("Frame", nil, sortPanel)
    sortByButton:SetPoint("LEFT", sortPanel, "LEFT", 0, 0)
    sortByButton:SetPoint("RIGHT", sortModeButton, "LEFT", -6, 0)
    sortByButton:SetHeight(32)
    sortByButton:SetTemplate()

    addSetActive(sortByButton)

    sortByButton.text = sortByButton:CreateFontString(nil, "OVERLAY")
    sortByButton.text:SetFont(E.media.normFont, 12, "OUTLINE")
    sortByButton.text:SetPoint("CENTER", sortByButton, "CENTER", 0, 0)

    sortByButton.title = sortByButton:CreateFontString(nil, "OVERLAY")
    sortByButton.title:SetFont(E.media.normFont, 12, "OUTLINE")
    sortByButton.title:SetPoint("CENTER", sortByButton, "TOP", 0, 0)
    sortByButton.title:SetText(F.GetWindStyleText(L["Sort by"]))
    sortByButton.title:Hide()

    sortByButton:SetScript(
        "OnEnter",
        function(btn)
            sortByButton:SetActive(true)
            sortByButton.title:Show()

            local tooltip = btn.sortBy and sortMode[btn.sortBy] and sortMode[btn.sortBy].tooltip
            _G.GameTooltip:SetOwner(btn, "ANCHOR_LEFT", -4, -34)
            _G.GameTooltip:AddLine(tooltip or "", 1, 1, 1)
            _G.GameTooltip:Show()
        end
    )

    sortByButton:SetScript(
        "OnLeave",
        function()
            sortByButton:SetActive(false)
            sortByButton.title:Hide()
            _G.GameTooltip:Hide()
        end
    )

    sortByButton:SetScript(
        "OnMouseDown",
        function(btn, button)
            if button == "LeftButton" then
                local dfDB = self:GetPlayerDB("dungeonFilter")

                if btn.sortBy then
                    local currentModeID
                    for i, mode in ipairs(avaliableSortMode) do
                        if mode == btn.sortBy then
                            currentModeID = i
                            break
                        end
                    end

                    btn.sortBy = currentModeID and avaliableSortMode[currentModeID + 1] or avaliableSortMode[1]
                end

                sortByButton.text:SetText(sortMode[btn.sortBy].text)
                LL:RefreshSearch()
                dfDB.sortBy = btn.sortBy

                local tooltip = btn.sortBy and sortMode[btn.sortBy] and sortMode[btn.sortBy].tooltip
                _G.GameTooltip:ClearLines()
                _G.GameTooltip:SetOwner(btn, "ANCHOR_LEFT", -4, -34)
                _G.GameTooltip:AddLine(tooltip or "", 1, 1, 1)
                _G.GameTooltip:Show()

                sortByButton.UpdatePosition()
            end
        end
    )

    sortByButton.UpdatePosition = function()
        if sortByButton.sortBy == "DEFAULT" then
            sortModeButton:Hide()
            sortByButton:ClearAllPoints()
            sortByButton:SetPoint("LEFT", sortPanel, "LEFT", 0, 0)
            sortByButton:SetPoint("RIGHT", sortPanel, "RIGHT", 0, 0)
        else
            sortModeButton:Show()
            sortByButton:ClearAllPoints()
            sortByButton:SetPoint("LEFT", sortPanel, "LEFT", 0, 0)
            sortByButton:SetPoint("RIGHT", sortModeButton, "LEFT", -6, 0)
        end
    end

    sortPanel.sortByButton = sortByButton
    frame.sortPanel = sortPanel
    self.rightPanel = frame
end

function LL:UpdateRightPanel()
    if not self.db.rightPanel.enable then
        if self.rightPanel then
            self.rightPanel:Hide()
        end
        return
    end

    if
        not (_G.PVEFrame:IsVisible() and _G.LFGListFrame.activePanel == _G.LFGListFrame.SearchPanel and
            _G.LFGListFrame.SearchPanel:IsVisible() and
            _G.LFGListFrame.SearchPanel.categoryID == 2)
     then
        if self.rightPanel then
            self.rightPanel:Hide()
        end
        return
    end

    if not self.rightPanel then
        self:InitalizeRightPanel()
    end

    if not _G.LFGListFrame.SearchPanel:IsShown() or not _G.LFGListFrame.SearchPanel.categoryID == 2 then
        self.rightPanel:Hide()
    end

    local dfDB = self:GetPlayerDB("dungeonFilter")
    for mapID, btn in pairs(self.rightPanel.filters.buttons) do
        if dfDB[mapID] then
            btn:SetActive(true)
        else
            btn:SetActive(false)
        end
    end

    if dfDB.leaderScoreEnable then
        self.rightPanel.filters.leaderScore:SetActive(true)
    else
        self.rightPanel.filters.leaderScore:SetActive(false)
    end

    self.rightPanel.filters.leaderScore.editBox:SetText(dfDB.leaderScore or 0)

    if dfDB.leaderDungeonScoreEnable then
        self.rightPanel.filters.leaderDungeonScore:SetActive(true)
    else
        self.rightPanel.filters.leaderDungeonScore:SetActive(false)
    end

    self.rightPanel.filters.leaderDungeonScore.editBox:SetText(dfDB.leaderDungeonScore or 0)

    if dfDB.roleAvailableEnable then
        self.rightPanel.filters.roleAvailable:SetActive(true)
    else
        self.rightPanel.filters.roleAvailable:SetActive(false)
    end

    self.rightPanel.vaultStatus.update()
    self.rightPanel.vaultStatus:SetActive(false)

    if dfDB.sortDescending == nil then
        dfDB.sortDescending = true
    end

    if dfDB.sortDescending then
        self.rightPanel.sortPanel.sortModeButton.descending = true
        self.rightPanel.sortPanel.sortModeButton.tex:SetRotation(0)
    else
        self.rightPanel.sortPanel.sortModeButton.descending = false
        self.rightPanel.sortPanel.sortModeButton.tex:SetRotation(3.14)
    end

    self.rightPanel.sortPanel.sortModeButton:SetActive(false)

    if dfDB.sortBy then
        self.rightPanel.sortPanel.sortByButton.sortBy = dfDB.sortBy
        self.rightPanel.sortPanel.sortByButton.text:SetText(sortMode[dfDB.sortBy].text)
    else
        self.rightPanel.sortPanel.sortByButton.sortBy = avaliableSortMode[1]
        self.rightPanel.sortPanel.sortByButton.text:SetText(sortMode[avaliableSortMode[1]].text)
    end

    self.rightPanel.sortPanel.sortByButton:SetActive(false)
    self.rightPanel.sortPanel.sortByButton.UpdatePosition()

    self.rightPanel:Show()
end

function LL:ResortSearchResults(results)
    if _G.LFGListFrame.SearchPanel.categoryID ~= 2 then
        return
    end

    if not self.db.enable or not self.db.rightPanel.enable or not results or #results == 0 then
        return false
    end

    local dfDB = self:GetPlayerDB("dungeonFilter")

    local filterMap = {}
    local numFilter = 0
    for mapID, _ in pairs(mythicKeystoneDungeons) do
        if dfDB[mapID] then
            filterMap[mapID] = true
            numFilter = numFilter + 1
        end
    end

    local partyMember = {
        TANK = 0,
        HEALER = 0,
        DAMAGER = 0
    }

    local sortDatabase = {}

    if dfDB.roleAvailableEnable then
        if IsInGroup() then
            local playerRole = UnitGroupRolesAssigned("player")
            if partyMember[playerRole] then
                partyMember[playerRole] = partyMember[playerRole] + 1
            end

            local numMembers = GetNumGroupMembers()
            if numMembers >= 2 then
                for i = 1, numMembers - 1 do
                    local role = UnitGroupRolesAssigned("party" .. i)
                    if partyMember[role] then
                        partyMember[role] = partyMember[role] + 1
                    end
                end
            end
        else
            local specIndex = GetSpecialization()
            local role = specIndex and select(5, GetSpecializationInfo(specIndex))
            if partyMember[role] then
                partyMember[role] = partyMember[role] + 1
            end
        end
    end

    local pendingResults = {}
    local waitForSortingResults = {}

    for _, resultID in ipairs(results) do
        local pendingStatus = select(3, C_LFGList_GetApplicationInfo(resultID))
        if pendingStatus then
            tinsert(pendingResults, resultID)
        else
            local verified = false

            local sortCache = {
                id = resultID,
                overallScore = 0,
                dungeonScore = 0
            }

            local searchResultInfo = C_LFGList_GetSearchResultInfo(resultID)

            if searchResultInfo.leaderOverallDungeonScore then
                sortCache.overallScore = searchResultInfo.leaderOverallDungeonScore
            end

            if searchResultInfo.leaderDungeonScoreInfo and searchResultInfo.leaderDungeonScoreInfo.mapScore then
                sortCache.dungeonScore = searchResultInfo.leaderDungeonScoreInfo.mapScore
            end

            if numFilter == 0 then
                verified = true
            else
                local activityID = searchResultInfo.activityID
                local mapID = activityIDToMapID[activityID]
                if mapID and filterMap[mapID] then
                    verified = true
                end
            end

            if verified and dfDB.leaderScoreEnable and dfDB.leaderScore and dfDB.leaderScore > 0 then
                if not sortCache.overallScore or sortCache.overallScore < dfDB.leaderScore then
                    verified = false
                end
            end

            if verified and dfDB.leaderDungeonScoreEnable and dfDB.leaderDungeonScore and dfDB.leaderDungeonScore > 0 then
                if not sortCache.dungeonScore or sortCache.dungeonScore < dfDB.leaderDungeonScore then
                    verified = false
                end
            end

            if verified and dfDB.roleAvailableEnable then
                local roleCache = {
                    TANK = partyMember.TANK,
                    HEALER = partyMember.HEALER,
                    DAMAGER = partyMember.DAMAGER
                }

                for i = 1, searchResultInfo.numMembers do
                    local role = C_LFGList_GetSearchResultMemberInfo(resultID, i)
                    if roleCache[role] then
                        roleCache[role] = roleCache[role] + 1
                    end
                end

                if roleCache.TANK > 1 or roleCache.HEALER > 1 or roleCache.DAMAGER > 3 then
                    verified = false
                end
            end

            if verified then
                tinsert(waitForSortingResults, sortCache)
            end
        end
    end

    local sortBy = dfDB.sortBy or avaliableSortMode[1]
    if sortMode[sortBy].func then
        sort(
            waitForSortingResults,
            function(a, b)
                if not a or not b then
                    return false
                end

                local result = sortMode[sortBy].func(a, b)
                result = dfDB.sortDescending and result or result * -1
                return result == 1
            end
        )
    end

    wipe(results)

    for _, result in ipairs(pendingResults) do
        tinsert(results, result)
    end

    for _, result in ipairs(waitForSortingResults) do
        tinsert(results, result.id)
    end

    _G.LFGListFrame.SearchPanel.totalResults = #results
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

    if not IsAddOnLoaded("Blizzard_ChallengesUI") then
        LoadAddOn("Blizzard_ChallengesUI")
    end

    C_MythicPlus.RequestCurrentAffixes()
    C_MythicPlus.RequestMapInfo()

    self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
    self:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")
    self:SecureHook(_G.PVEFrame, "Show", "RequestKeystoneData")
    self:SecureHook("LFGListFrame_SetActivePanel", "UpdateRightPanel")
    self:SecureHook("LFGListUtil_SortSearchResults", "ResortSearchResults")
    self:SecureHook(
        "LFGListSearchPanel_DoSearch",
        function()
            LL.lastRefreshTimestamp = GetTime()
        end
    )

    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RequestKeystoneData")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "RequestKeystoneData")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "RequestKeystoneData")

    openRaidLib.RequestKeystoneDataFromParty()
    E:Delay(2, self.RequestKeystoneData, self)
    E:Delay(2, self.UpdatePartyKeystoneFrame, self)
end

W:RegisterModule(LL:GetName())
