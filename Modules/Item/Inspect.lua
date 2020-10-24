local W, F, E, L = unpack(select(2, ...))
local IL = W:NewModule("Inspect", "AceEvent-3.0", "AceHook-3.0") -- Modified from TinyInspect
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local MF = W:GetModule("MoveFrames")

local _G = _G
local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local guids, inspecting = {}, false

local testDB = {
    enable = true,
    player = true,
    inspect = true,
    playerOnInspect = true
}
local slots = {
    {index = 1, name = HEADSLOT},
    {index = 2, name = NECKSLOT},
    {index = 3, name = SHOULDERSLOT},
    {index = 5, name = CHESTSLOT},
    {index = 6, name = WAISTSLOT},
    {index = 7, name = LEGSSLOT},
    {index = 8, name = FEETSLOT},
    {index = 9, name = WRISTSLOT},
    {index = 10, name = HANDSSLOT},
    {index = 11, name = FINGER0SLOT},
    {index = 12, name = FINGER1SLOT},
    {index = 13, name = TRINKET0SLOT},
    {index = 14, name = TRINKET1SLOT},
    {index = 15, name = BACKSLOT},
    {index = 16, name = MAINHANDSLOT},
    {index = 17, name = SECONDARYHANDSLOT}
}

-- TinyInspect API
local function ReInspect(unit)
    local guid = UnitGUID(unit)
    if not guid then
        return
    end
    local data = guids[guid]
    if not data then
        return
    end
    LibSchedule:AddTask(
        {
            identity = guid,
            timer = 0.5,
            elasped = 0.5,
            expired = GetTime() + 3,
            data = data,
            unit = unit,
            onExecute = function(self)
                local count, ilevel, _, weaponLevel, isArtifact, maxLevel = LibItemInfo:GetUnitItemLevel(self.unit)
                if (ilevel <= 0) then
                    return true
                end
                if (count == 0 and ilevel > 0) then
                    self.data.timer = time()
                    self.data.ilevel = ilevel
                    self.data.maxLevel = maxLevel
                    self.data.weaponLevel = weaponLevel
                    self.data.isArtifact = isArtifact
                    LibEvent:trigger("UNIT_REINSPECT_READY", self.data)
                    return true
                end
            end
        }
    )
end

local function GetInspectSpec(unit)
    local specID, specName
    if unit == "player" then
        specID = GetSpecialization()
        specName = select(2, GetSpecializationInfo(specID))
    else
        specID = GetInspectSpecialization(unit)
        if specID and specID > 0 then
            specName = select(2, GetSpecializationInfoByID(specID))
        end
    end
    return specName or ""
end

local function GetInspectItemListFrame(parent)
    if not parent.inspectFrame then
        local itemfont = "ChatFontNormal"
        local frame = CreateFrame("Frame", nil, parent)
        local height = parent:GetHeight()
        height = height < 424 and 424 or height

        frame:Size(160, height - 2)
        frame:SetFrameLevel(0)
        frame:Point("LEFT", parent, "RIGHT", 5, 0)
        frame:CreateBackdrop("Transparent")
        S:CreateShadow(frame.backdrop)
        frame.portrait = CreateFrame("Frame", nil, frame, "GarrisonFollowerPortraitTemplate")
        frame.portrait:Point("TOPLEFT", frame, "TOPLEFT", 16, -10)
        frame.portrait:SetScale(0.8)
        frame.title = frame:CreateFontString(nil, "ARTWORK")
        F.SetFontWithDB(
            frame.title,
            {
                name = E.db.general.font,
                size = 16,
                style = "OUTLINE"
            }
        )
        frame.title:Point("TOPLEFT", frame, "TOPLEFT", 66, -14)
        frame.level = frame:CreateFontString(nil, "ARTWORK")
        frame.level:Point("TOPLEFT", frame, "TOPLEFT", 66, -38)
        F.SetFontWithDB(
            frame.level,
            {
                name = E.db.general.font,
                size = 14,
                style = "OUTLINE"
            }
        )

        local itemframe
        local fontsize = W.Locale:sub(1, 2) == "zh" and 12 or 9
        local backdrop = {
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            tile = true,
            tileSize = 8,
            edgeSize = 1,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
        for i, v in ipairs(slots) do
            itemframe = CreateFrame("Button", nil, frame, "BackdropTemplate")
            itemframe:Size(120, (height - 82) / #slots)
            itemframe.index = v.index
            itemframe.backdrop = backdrop
            if (i == 1) then
                itemframe:Point("TOPLEFT", frame, "TOPLEFT", 15, -70)
            else
                itemframe:Point("TOPLEFT", frame["item" .. (i - 1)], "BOTTOMLEFT")
            end
            itemframe.label = CreateFrame("Frame", nil, itemframe, "BackdropTemplate")
            itemframe.label:Size(38, 18)
            itemframe.label:Point("LEFT")
            itemframe.label:SetBackdrop(backdrop)
            itemframe.label:SetBackdropBorderColor(0, 0.9, 0.9, 0.2)
            itemframe.label:SetBackdropColor(0, 0.9, 0.9, 0.2)
            itemframe.label.text = itemframe.label:CreateFontString(nil, "ARTWORK")
            itemframe.label.text:SetFont(UNIT_NAME_FONT, fontsize, "THINOUTLINE")
            itemframe.label.text:Size(34, 14)
            itemframe.label.text:Point("CENTER", 1, 0)
            itemframe.label.text:SetText(v.name)
            itemframe.label.text:SetTextColor(0, 0.9, 0.9)
            itemframe.levelString = itemframe:CreateFontString(nil, "ARTWORK")
            F.SetFontWithDB(
                itemframe.levelString,
                {
                    name = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    size = 13,
                    style = "OUTLINE"
                }
            )
            itemframe.levelString:Point("LEFT", itemframe.label, "RIGHT", 4, 0)
            itemframe.levelString:SetJustifyH("RIGHT")
            itemframe.itemString = itemframe:CreateFontString(nil, "ARTWORK")
            F.SetFontWithDB(
                itemframe.itemString,
                {
                    name = E.db.general.font,
                    size = 13,
                    style = "OUTLINE"
                }
            )
            itemframe.itemString:SetHeight(16)
            itemframe.itemString:Point("LEFT", itemframe.levelString, "RIGHT", 2, 0)
            itemframe:SetScript(
                "OnEnter",
                function(self)
                    local r, g, b, a = self.label:GetBackdropColor()
                    if a then
                        self.label:SetBackdropColor(r, g, b, a + 0.5)
                    end
                    if self.link or (self.level and self.level > 0) then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetInventoryItem(self:GetParent().unit, self.index)
                        GameTooltip:Show()
                    end
                end
            )
            itemframe:SetScript(
                "OnLeave",
                function(self)
                    local r, g, b, a = self.label:GetBackdropColor()
                    if a then
                        self.label:SetBackdropColor(r, g, b, abs(a - 0.5))
                    end
                    GameTooltip:Hide()
                end
            )
            itemframe:SetScript(
                "OnDoubleClick",
                function(self)
                    if (self.link) then
                        ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                        ChatEdit_InsertLink(self.link)
                    end
                end
            )
            frame["item" .. i] = itemframe
            LibEvent:trigger("INSPECT_ITEMFRAME_CREATED", itemframe)
        end

        frame.closeButton =
            CreateFrame("Button", "WTCompatibiltyFrameCloseButton", frame, "UIPanelCloseButton, BackdropTemplate")
        frame.closeButton:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT")
        ES:HandleCloseButton(frame.closeButton)
        frame.closeButton:SetScript(
            "OnClick",
            function(self)
                self:GetParent():Hide()
            end
        )

        parent:HookScript(
            "OnHide",
            function(self)
                frame:Hide()
            end
        )

        if MF and MF.db and MF.db.moveBlizzardFrames then
            MF:HandleFrame(frame.backdrop, parent.MoveFrame or parent)
            frame.MoveFrame = frame.backdrop.MoveFrame
        end

        parent.inspectFrame = frame
        LibEvent:trigger("INSPECT_FRAME_CREATED", frame, parent)
    end

    return parent.inspectFrame
end

local function ShowInspectItemListFrame(unit, parent, ilevel, maxLevel)
    if not parent:IsShown() then
        return
    end

    local frame = GetInspectItemListFrame(parent)
    local class = select(2, UnitClass(unit))
    local color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
    frame.unit = unit
    frame.portrait:SetLevel(UnitLevel(unit))
    frame.portrait.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b)
    frame.portrait.LevelBorder:SetVertexColor(color.r, color.g, color.b)
    SetPortraitTexture(frame.portrait.Portrait, unit)
    frame.title:SetText(UnitName(unit))
    frame.title:SetTextColor(color.r, color.g, color.b)
    frame.level:SetText(format("%s %0d", L["Item Level"], ilevel))
    frame.level:SetTextColor(1, 0.82, 0)
    local _, name, level, link, quality
    local itemframe, mframe, oframe, itemwidth
    local width = 160
    local formats = "%3s"
    if (maxLevel) then
        formats = "%" .. string.len(floor(maxLevel)) .. "s"
    end
    for i, v in ipairs(slots) do
        _, level, name, link, quality = LibItemInfo:GetUnitItemInfo(unit, v.index)
        itemframe = frame["item" .. i]
        itemframe.name = name
        itemframe.link = link
        itemframe.level = level
        itemframe.quality = quality
        itemframe.itemString:SetWidth(0)
        if (level > 0) then
            itemframe.levelString:SetText(format(formats, level))
            itemframe.itemString:SetText(link or name)
        else
            itemframe.levelString:SetText(format(formats, ""))
            itemframe.itemString:SetText("")
        end
        if (link and IsCorruptedItem(link)) then
            itemframe.levelString:SetTextColor(0.5, 0.5, 1)
        else
            itemframe.levelString:SetTextColor(1, 1, 1)
        end
        itemwidth = itemframe.itemString:GetWidth()
        if (itemwidth > 208) then
            itemwidth = 208
            itemframe.itemString:SetWidth(itemwidth)
        end
        itemframe.width = itemwidth + max(64, floor(itemframe.label:GetWidth() + itemframe.levelString:GetWidth()) + 4)
        itemframe:SetWidth(itemframe.width)
        if (width < itemframe.width) then
            width = itemframe.width
        end
        if (v.index == 16) then
            mframe = itemframe
            mframe:SetAlpha(1)
        elseif (v.index == 17) then
            oframe = itemframe
            oframe:SetAlpha(1)
        end
        LibEvent:trigger("INSPECT_ITEMFRAME_UPDATED", itemframe)
    end
    if (mframe and oframe and (mframe.quality == 6 or oframe.quality == 6)) then
        level = max(mframe.level, oframe.level)
        if mframe.link then
            mframe.levelString:SetText(format(formats, level))
        end
        if oframe.link then
            oframe.levelString:SetText(format(formats, level))
        end
    end
    if (mframe and mframe.level <= 0) then
        mframe:SetAlpha(0.4)
    end
    if (oframe and oframe.level <= 0) then
        oframe:SetAlpha(0.4)
    end
    frame:SetWidth(width + 36)
    frame:Show()

    LibEvent:trigger("INSPECT_FRAME_SHOWN", frame, parent, ilevel)
    return frame
end

function IL:Inspect()
    hooksecurefunc(
        "ClearInspectPlayer",
        function()
            inspecting = false
        end
    )

    -- @trigger UNIT_INSPECT_STARTED
    hooksecurefunc(
        "NotifyInspect",
        function(unit)
            local guid = UnitGUID(unit)
            if (not guid) then
                return
            end
            local data = guids[guid]
            if (data) then
                data.unit = unit
                data.name, data.realm = UnitName(unit)
            else
                data = {
                    unit = unit,
                    guid = guid,
                    class = select(2, UnitClass(unit)),
                    level = UnitLevel(unit),
                    ilevel = -1,
                    spec = nil,
                    hp = UnitHealthMax(unit),
                    timer = time()
                }
                data.name, data.realm = UnitName(unit)
                guids[guid] = data
            end
            if (not data.realm) then
                data.realm = GetRealmName()
            end
            data.expired = time() + 3
            inspecting = data
            LibEvent:trigger("UNIT_INSPECT_STARTED", data)
        end
    )

    -- @trigger UNIT_INSPECT_READY
    LibEvent:attachEvent(
        "INSPECT_READY",
        function(this, guid)
            if (not guids[guid]) then
                return
            end
            LibSchedule:AddTask(
                {
                    identity = guid,
                    timer = 0.5,
                    elasped = 0.8,
                    expired = GetTime() + 4,
                    data = guids[guid],
                    onTimeout = function(self)
                        inspecting = false
                    end,
                    onExecute = function(self)
                        local count, ilevel, _, weaponLevel, isArtifact, maxLevel =
                            LibItemInfo:GetUnitItemLevel(self.data.unit)
                        if (ilevel <= 0) then
                            return true
                        end
                        if (count == 0 and ilevel > 0) then
                            --if (UnitIsVisible(self.data.unit) or self.data.ilevel == ilevel) then
                            self.data.timer = time()
                            self.data.name = UnitName(self.data.unit)
                            self.data.class = select(2, UnitClass(self.data.unit))
                            self.data.ilevel = ilevel
                            self.data.maxLevel = maxLevel
                            self.data.spec = GetInspectSpec(self.data.unit)
                            self.data.hp = UnitHealthMax(self.data.unit)
                            self.data.weaponLevel = weaponLevel
                            self.data.isArtifact = isArtifact
                            LibEvent:trigger("UNIT_INSPECT_READY", self.data)
                            inspecting = false
                            return true
                        --else
                        --    self.data.ilevel = ilevel
                        --    self.data.maxLevel = maxLevel
                        --end
                        end
                    end
                }
            )
        end
    )

    --裝備變更時
    LibEvent:attachEvent(
        "UNIT_INVENTORY_CHANGED",
        function(_, unit)
            if InspectFrame and InspectFrame.unit and InspectFrame.unit == unit then
                ReInspect(unit)
            end
        end
    )

    --@see InspectCore.lua
    LibEvent:attachTrigger(
        "UNIT_INSPECT_READY, UNIT_REINSPECT_READY",
        function(_, data)
            if not self.db or not self.db.inspect then
                return
            end
            if (InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == data.guid) then
                local frame = ShowInspectItemListFrame(InspectFrame.unit, InspectFrame, data.ilevel, data.maxLevel)
                LibEvent:trigger("INSPECT_FRAME_COMPARE", frame)
            end
        end
    )

    --高亮橙裝和武器
    LibEvent:attachTrigger(
        "INSPECT_ITEMFRAME_UPDATED",
        function(self, itemframe)
            local r, g, b = 0, 0.9, 0.9
            if (itemframe.quality and itemframe.quality > 4) then
                r, g, b = GetItemQualityColor(itemframe.quality)
            elseif (itemframe.name and not itemframe.link) then
                r, g, b = 0.9, 0.8, 0.4
            elseif (not itemframe.link) then
                r, g, b = 0.5, 0.5, 0.5
            end
            itemframe.label:SetBackdropBorderColor(r, g, b, 0.2)
            itemframe.label:SetBackdropColor(r, g, b, 0.2)
            itemframe.label.text:SetTextColor(r, g, b)
        end
    )

    --自己裝備列表
    LibEvent:attachTrigger(
        "INSPECT_FRAME_COMPARE",
        function(_, frame)
            if not frame then
                return
            end
            if self.db and self.db.playerOnInspect then
                local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
                local playerFrame = ShowInspectItemListFrame("player", frame, ilevel, maxLevel)
                if (frame.statsFrame) then
                    frame.statsFrame:SetParent(playerFrame)
                end
            elseif frame.statsFrame then
                frame.statsFrame:SetParent(frame)
            end
            if frame.statsFrame then
                frame.statsFrame:Point("TOPLEFT", frame.statsFrame:GetParent(), "TOPRIGHT", 1, -1)
            end
        end
    )
end

function IL:Player()
    PaperDollFrame:HookScript(
        "OnShow",
        function(frame)
            if not self.db or not self.db.player then
                return
            end
            local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
            ShowInspectItemListFrame("player", frame, ilevel, maxLevel)
        end
    )

    LibEvent:attachEvent(
        "PLAYER_EQUIPMENT_CHANGED",
        function()
            if not self.db or not self.db.player or not _G.CharacterFrame:IsShown() then
                return
            end
            local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
            ShowInspectItemListFrame("player", _G.PaperDollFrame, ilevel, maxLevel)
        end
    )
end

function IL:Test()
    self:Player()
    self:Inspect()
end

function IL:Initialize()
    self.db = testDB

    if not self.db.enable then
        return
    end
end

W:RegisterModule(IL:GetName())
