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
local pairs = pairs
local select = select
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local GetUnitName = GetUnitName
local IsAddOnLoaded = IsAddOnLoaded
local IsInGroup = IsInGroup
local UnitClassBase = UnitClassBase

local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

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

function LL:InitalizeRightPanel()
    if LL.rightPanel then
        return
    end

    local frame = CreateFrame("Frame", nil, _G.PVEFrame)
    frame:SetWidth(200)
    frame:SetPoint("TOPLEFT", _G.PVEFrame, "TOPRIGHT", 3, 0)
    frame:SetPoint("BOTTOMLEFT", _G.PVEFrame, "BOTTOMRIGHT", 3, 0)
    frame:SetTemplate("Transparent")
    S:CreateShadowModule(frame)

    hooksecurefunc(
        frame,
        "Show",
        function()
            if _G.RaiderIO_ProfileTooltipAnchor then
                if not _G.RaiderIO_ProfileTooltipAnchor.__SetPoint then
                    _G.RaiderIO_ProfileTooltipAnchor.__SetPoint = _G.RaiderIO_ProfileTooltipAnchor.SetPoint
                    _G.RaiderIO_ProfileTooltipAnchor.SetPoint = function(arg1, arg2, arg3, arg4, arg5)
                        if arg2 then
                            arg2 = frame:IsShown() and frame or _G.PVEFrame
                        end
                        _G.RaiderIO_ProfileTooltipAnchor:__SetPoint(arg1, arg3, arg3, arg4, arg5)
                    end
                end
                local point = {_G.RaiderIO_ProfileTooltipAnchor:GetPoint(1)}
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
        function()
            if _G.RaiderIO_ProfileTooltipAnchor then
                if not _G.RaiderIO_ProfileTooltipAnchor.__SetPoint then
                    _G.RaiderIO_ProfileTooltipAnchor.__SetPoint = _G.RaiderIO_ProfileTooltipAnchor.SetPoint
                    _G.RaiderIO_ProfileTooltipAnchor.SetPoint = function(arg1, arg2, arg3, arg4, arg5)
                        if arg2 then
                            arg2 = frame:IsShown() and frame or _G.PVEFrame
                        end
                        _G.RaiderIO_ProfileTooltipAnchor:__SetPoint(arg1, arg3, arg3, arg4, arg5)
                    end
                end
                local point = {_G.RaiderIO_ProfileTooltipAnchor:GetPoint(1)}
                if #point > 0 then
                    _G.RaiderIO_ProfileTooltipAnchor:ClearAllPoints()
                    _G.RaiderIO_ProfileTooltipAnchor:SetPoint(unpack(point))
                end
            end
        end
    )

    local currAffixIndex = 0
    local currAffixes = C_MythicPlus.GetCurrentAffixes()

    if currAffixes then
        for i = 1, #affixLoop do
            local affixes = affixLoop[i]
            if affixes[1] == currAffixes[1].id and affixes[2] == currAffixes[2].id and affixes[3] == currAffixes[3].id then
                currAffixIndex = i
                break
            end
        end
    end

    if currAffixIndex then
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
            local fileDataID = select(3, C_ChallengeMode.GetAffixInfo(affixLoop[currAffixIndex][i]))
            affix:SetTexture(fileDataID)
            affix:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end

        frame.affix:SetScript(
            "OnEnter",
            function()
                _G.GameTooltip:SetOwner(frame, "ANCHOR_TOP")
                _G.GameTooltip:ClearLines()
                _G.GameTooltip:AddLine(L["Next Affixes"])
                for i = 1, 4 do
                    local name, description, fileDataID = C_ChallengeMode.GetAffixInfo(affixLoop[nextAffixIndex][i])
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

    LL.rightPanel = frame
end

function LL:UpdateRightPanel()
    if not LL.rightPanel then
        self:InitalizeRightPanel()
    end

    LL.rightPanel:Show()
end

function LL:PVEFrame_Show()
    -- self:UpdateRightPanel()
    self:RequestKeystoneData()
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

    self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
    self:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")
    self:SecureHook(_G.PVEFrame, "Show", "PVEFrame_Show")

    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RequestKeystoneData")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "RequestKeystoneData")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "RequestKeystoneData")

    openRaidLib.RequestKeystoneDataFromParty()
    E:Delay(2, self.RequestKeystoneData, self)
    E:Delay(2, self.UpdatePartyKeystoneFrame, self)
end

F.Developer.DelayInitialize(LL, 1)

W:RegisterModule(LL:GetName())
