local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local MF = W.Modules.MoveFrames
local C = W.Utilities.Color
local ET = W:NewModule("EventTracker", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local floor = floor
local format = format
local ipairs = ipairs
local pairs = pairs
local unpack = unpack

local CreateFrame = CreateFrame
local GetCurrentRegion = GetCurrentRegion
local GetLocale = GetLocale
local GetServerTime = GetServerTime

local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_Timer_NewTicker = C_Timer.NewTicker

local eventList = {
    "CommunityFeast",
    "SiegeOnDragonbaneKeep"
}

local function secondToTime(second)
    local hour = floor(second / 3600)
    local min = floor((second - hour * 3600) / 60)
    local sec = floor(second - hour * 3600 - min * 60)

    if hour == 0 then
        return format("%02d:%02d", min, sec)
    else
        return format("%02d:%02d:%02d", hour, min, sec)
    end
end

local function reskinStatusBar(bar)
    bar:SetFrameLevel(bar:GetFrameLevel() + 1)
    bar:StripTextures()
    bar:CreateBackdrop("Transparent")
    bar:SetStatusBarTexture(E.media.normTex)
    E:RegisterStatusBar(bar)
end

local functionFactory = {
    loopTimer = {
        init = function(self, args)
            self.icon = self:CreateTexture(nil, "ARTWORK")
            self.statusBar = CreateFrame("StatusBar", nil, self)
            self.name = self.statusBar:CreateFontString(nil, "OVERLAY")
            self.timerText = self.statusBar:CreateFontString(nil, "OVERLAY")
            self.runningTip = self.statusBar:CreateFontString(nil, "OVERLAY")

            reskinStatusBar(self.statusBar)

            self.statusBar.spark = self.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
            self.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
            self.statusBar.spark:SetBlendMode("ADD")
            self.statusBar.spark:SetPoint("CENTER", self.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
            self.statusBar.spark:SetSize(4, 26)
        end,
        setup = function(self, args)
            self.icon:SetTexture(args.icon)
            self.icon:SetTexCoord(unpack(E.TexCoords))
            self.icon:SetSize(22, 22)
            self.icon:ClearAllPoints()
            self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)

            self.statusBar:ClearAllPoints()
            self.statusBar:SetPoint("TOPLEFT", self, "LEFT", 26, 2)
            self.statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 6)

            self.timerText:SetFont(E.media.normFont, 13, "OUTLINE")
            self.timerText:ClearAllPoints()
            self.timerText:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -6)

            self.name:SetFont(E.media.normFont, 13, "OUTLINE")
            self.name:ClearAllPoints()
            self.name:SetPoint("TOPLEFT", self, "TOPLEFT", 30, -6)
            self.name:SetText(args.label)

            self.runningTip:SetFont(E.media.normFont, 10, "OUTLINE")
            self.runningTip:SetText(args.runningText)
            self.runningTip:SetPoint("CENTER", self.statusBar, "BOTTOM", 0, 0)
        end,
        ticker = {
            interval = 0.3,
            onUpdate = function(self, args)
                self.isCompleted = C_QuestLog_IsQuestFlaggedCompleted(args.questID)
                self.icon:SetDesaturated(self.isCompleted)

                local timeOver = GetServerTime() - args.startTimestamp
                timeOver = timeOver % args.interval
                if timeOver < args.duration then
                    -- event ending tracking timer
                    local timeLeft = args.duration - timeOver
                    self.timerText:SetText(C.StringByTemplate(secondToTime(timeLeft), "success"))
                    self.statusBar:SetMinMaxValues(0, args.duration)
                    self.statusBar:SetValue(timeOver)
                    self.statusBar:SetStatusBarColor(C.RGBFromTemplate("success"))
                    self.runningTip:Show()
                    E:Flash(self.runningTip, 1, true)
                    self.isRunning = true
                else
                    -- normal tracking timer
                    local timeLeft = args.interval - timeOver
                    self.timerText:SetText(secondToTime(timeLeft))
                    self.statusBar:SetMinMaxValues(0, args.interval)
                    self.statusBar:SetValue(timeLeft)
                    self.statusBar:SetStatusBarColor(unpack(args.barColor))
                    E:StopFlash(self.runningTip)
                    self.runningTip:Hide()
                    self.isRunning = false
                end
            end
        },
        tooltip = {
            onEnter = function(self, args)
                _G.GameTooltip:ClearLines()
                _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 8)
                _G.GameTooltip:SetText(F.GetIconString(args.icon, 16, 16) .. " " .. args.eventName, 1, 1, 1)
                _G.GameTooltip:AddDoubleLine(L["Location"], args.location, 1, 1, 1)
                _G.GameTooltip:AddDoubleLine(L["Interval"], secondToTime(args.interval), 1, 1, 1)
                _G.GameTooltip:AddDoubleLine(L["Duration"], secondToTime(args.duration), 1, 1, 1)
                _G.GameTooltip:AddLine(" ")
                if self.isRunning then
                    _G.GameTooltip:AddDoubleLine(L["Status"], C.StringByTemplate(L["In Progress"], "success"), 1, 1, 1)
                else
                    _G.GameTooltip:AddDoubleLine(L["Status"], C.StringByTemplate(L["Waiting"], "danger"), 1, 1, 1)
                end

                if self.isCompleted then
                    _G.GameTooltip:AddDoubleLine(
                        L["Weekly Reward"],
                        C.StringByTemplate(L["Completed"], "success"),
                        1,
                        1,
                        1
                    )
                else
                    _G.GameTooltip:AddDoubleLine(
                        L["Weekly Reward"],
                        C.StringByTemplate(L["Not Completed"], "danger"),
                        1,
                        1,
                        1
                    )
                end

                _G.GameTooltip:Show()
            end,
            onLeave = function(self, args)
                _G.GameTooltip:Hide()
            end
        }
    }
}

local eventData = {
    CommunityFeast = {
        dbKey = "communityFeast",
        args = {
            icon = 4687629,
            type = "loopTimer",
            questID = 70893,
            duration = 15 * 60,
            interval = 3.5 * 60 * 60,
            barColor = {0, 120 / 255, 215 / 255},
            eventName = L["Community Feast"],
            location = C_Map_GetMapInfo(2024).name,
            label = L["Feast"],
            runningText = L["Cooking"],
            startTimestamp = (function()
                local timestampTable = {
                    [1] = 1670776200, -- NA
                    [2] = 1670770800, -- KR
                    [3] = 1670774400, -- EU
                    [4] = 1670779800, -- TW
                    [5] = 1670779800 -- CN
                }
                local region = GetCurrentRegion()
                -- TW is not a real region, so we need to check the client language if player in KR
                if region == 2 and GetLocale() ~= "koKR" then
                    region = 4
                end

                return timestampTable[region]
            end)()
        }
    },
    SiegeOnDragonbaneKeep = {
        dbKey = "siegeOnDragonbaneKeep",
        args = {
            icon = 236469,
            type = "loopTimer",
            questID = 70866,
            duration = 15 * 60,
            interval = 2 * 60 * 60,
            eventName = L["Siege On Dragonbane Keep"],
            label = L["Dragonbane Keep"],
            location = C_Map_GetMapInfo(2022).name,
            barColor = {209 / 255, 52 / 255, 56 / 255},
            runningText = L["In Progress"],
            startTimestamp = (function()
                local timestampTable = {
                    [1] = 1670774400, -- NA
                    [2] = 1670770800, -- KR
                    [3] = 1670774400, -- EU
                    [4] = 1670770800, -- TW
                    [5] = 1670770800 -- CN
                }
                local region = GetCurrentRegion()
                -- TW is not a real region, so we need to check the client language if player in KR
                if region == 2 and GetLocale() ~= "koKR" then
                    region = 4
                end

                return timestampTable[region]
            end)()
        }
    }
}

local trackers = {
    pool = {}
}

function trackers:get(event)
    if self.pool[event] then
        self.pool[event]:Show()
        return self.pool[event]
    end

    local data = eventData[event]

    local frame = CreateFrame("Frame", "WTEventTracker" .. event, ET.frame)
    frame:SetSize(220, 30)

    if functionFactory[data.args.type] then
        local functions = functionFactory[data.args.type]
        if functions.init then
            functions.init(frame, data.args)
        end

        if functions.setup then
            functions.setup(frame, data.args)
        end

        if functions.ticker then
            functions.ticker.onUpdate(frame, data.args)
            frame.tickerInstance =
                C_Timer_NewTicker(
                functions.ticker.interval,
                function()
                    if not (ET and ET.frame and ET.frame:IsShown()) then
                        return
                    end
                    if not _G.WorldMapFrame:IsShown() or not frame:IsShown() then
                        return
                    end
                    functions.ticker.onUpdate(frame, data.args)
                end
            )
        end

        if functions.tooltip then
            frame:SetScript(
                "OnEnter",
                function()
                    functions.tooltip.onEnter(frame, data.args)
                end
            )

            frame:SetScript(
                "OnLeave",
                function()
                    functions.tooltip.onLeave(frame, data.args)
                end
            )
        end
    end

    self.pool[event] = frame

    return frame
end

function trackers:disable(event)
    if self.pool[event] then
        self.pool[event]:Hide()
    end
end

function ET:ConstructFrame()
    if not _G.WorldMapFrame or self.frame then
        return
    end

    local frame = CreateFrame("Frame", "WTEventTracker", _G.WorldMapFrame)
    frame:SetFrameStrata("MEDIUM")
    frame:SetPoint("TOPLEFT", _G.WorldMapFrame.backdrop, "BOTTOMLEFT", 0, -3)
    frame:SetPoint("TOPRIGHT", _G.WorldMapFrame.backdrop, "BOTTOMRIGHT", 0, -3)
    frame:SetHeight(30)
    frame:SetTemplate("Transparent")
    S:CreateShadowModule(frame)

    if E.private.WT.misc.moveFrames.enable then
        MF:HandleFrame(frame, _G.WorldMapFrame)
    end

    self.frame = frame
end

function ET:UpdateTrackers()
    local lastTracker = nil

    if not self.frame then
        self:ConstructFrame()
    end

    for _, event in ipairs(eventList) do
        local data = eventData[event]
        local tracker = self.db.event[data.dbKey] and trackers:get(event) or trackers:disable(event)
        if tracker then
            tracker:ClearAllPoints()
            tracker:SetPoint("LEFT", lastTracker or self.frame, lastTracker and "RIGHT" or "LEFT", 4, 0)
            lastTracker = tracker
        end
    end
end

function ET:Initialize()
    self.db = E.db.WT.maps.eventTracker

    if not self.db or not self.db.enable then
        return
    end

    self:UpdateTrackers()
end

function ET:ProfileUpdate()
    self:Initialize()
    if self.frame then
        self.frame:SetShown(self.db.enable)
    end
end

F.Developer.DelayInitialize(ET, 5)

W:RegisterModule(ET:GetName())
