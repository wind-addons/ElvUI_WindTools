local W, F, E, L = unpack(select(2, ...))
local TM = W:NewModule("TalentManager", "AceEvent-3.0", "AceHook-3.0")
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local unpack = unpack

local CooldownFrame_Set = CooldownFrame_Set
local CreateFrame = CreateFrame
local EasyMenu = EasyMenu
local GameTooltip = _G.GameTooltip
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetItemIcon = GetItemIcon
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTalentInfo = GetTalentInfo
local GetTalentTierInfo = GetTalentTierInfo
local IsAddOnLoaded = IsAddOnLoaded
local IsResting = IsResting
local Item = Item
local LearnPvpTalent = LearnPvpTalent
local LearnTalents = LearnTalents
local UnitLevel = UnitLevel

local AuraUtil_FindAuraByName = AuraUtil.FindAuraByName
local C_SpecializationInfo_GetPvpTalentSlotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL
local MAX_TALENT_TIERS = _G.MAX_TALENT_TIERS

-- [id] = {minLevel, maxLevel}
local itemList = {
    tome = {
        {141446, 10, 50},
        {141640, 10, 50},
        {143780, 10, 50},
        {143785, 10, 50},
        {153647, 50, 59},
        {173049, 51, 60}
    },
    codex = {
        {141333, 10, 50},
        {141641, 10, 50},
        {153646, 10, 59},
        {173048, 51, 60}
    }
}

do
    local auras = {}
    for _, data in pairs(itemList.tome) do
        local item = Item:CreateFromItemID(data[1])
        item:ContinueOnItemLoad(
            function()
                tinsert(auras, item:GetItemName())
            end
        )
    end
    for _, data in pairs(itemList.codex) do
        local item = Item:CreateFromItemID(data[1])
        item:ContinueOnItemLoad(
            function()
                tinsert(auras, item:GetItemName())
            end
        )
    end
    function TM:IsPlayerCanChangeTalent()
        if IsResting() then
            return true
        end
        for _, aura in pairs(auras) do
            if aura and AuraUtil_FindAuraByName(aura, "player", "HELPFUL") then
                return true
            end
        end
        return false
    end
end

function TM:ADDON_LOADED(_, addon)
    if addon == "Blizzard_TalentUI" then
        self:UnregisterEvent("ADDON_LOADED")
        self:BuildFrame()
        self:BuildItemButtons()
    end
end

function TM:SaveSet(setName)
    local talentString = self:GetTalentString()
    local pvpTalentTable = self.db.pvpTalent and self:GetPvPTalentTable()

    if not self.db.sets[self.specID] then
        self.db.sets[self.specID] = {}
    end

    local isSameName = false
    for key, data in pairs(self.db.sets[self.specID]) do
        if data.setName == setName then
            isSameName = true
        end
    end

    if isSameName then
        F.DebugMessage(TM, format(L["Already have a set named %s."], setName))
    elseif #self.db.sets[self.specID] == 15 then
        F.DebugMessage(TM, L["Too many sets here, please delete one of them and try again."])
    else
        tinsert(
            self.db.sets[self.specID],
            {
                setName = setName,
                talentString = talentString,
                pvpTalentTable = pvpTalentTable
            }
        )
        self:UpdateSetButtons()
    end
end

function TM:UpdateSet(setName)
    local talentString = self:GetTalentString()
    local pvpTalentTable = self.db.pvpTalent and self:GetPvPTalentTable()

    for key, data in pairs(self.db.sets[self.specID]) do
        if data.setName == setName then
            data.talentString = talentString
            data.pvpTalentTable = pvpTalentTable
            self:UpdateSetButtons()
            return
        end
    end
end

function TM:RenameSet(specID, setName, newName)
    if not self.db.sets[specID] then
        return
    end

    for key, data in pairs(self.db.sets[specID]) do
        if data.setName == setName then
            data.setName = newName
            self:UpdateSetButtons()
            return
        end
    end
end

function TM:DeleteSet(specID, setName)
    if not self.db.sets[specID] then
        return
    end

    for key, data in pairs(self.db.sets[specID]) do
        if data.setName == setName then
            tremove(self.db.sets[specID], key)
            self:UpdateSetButtons()
            return
        end
    end
end

function TM:SetTalent(talentString, pvpTalentTable)
    if talentString and talentString ~= "" then
        local talentTable = {}
        gsub(
            talentString,
            "[0-9]",
            function(char)
                tinsert(talentTable, char)
            end
        )

        if #talentTable < MAX_TALENT_TIERS then
            F.DebugMessage(TM, L["Talent string is not valid."])
        end

        local talentIDs = {}
        for tier = 1, MAX_TALENT_TIERS do
            local isAvilable, column = GetTalentTierInfo(tier, 1)
            if isAvilable and talentTable[tier] ~= 0 and talentTable[tier] ~= column then
                local talentID = GetTalentInfo(tier, talentTable[tier], 1)
                tinsert(talentIDs, talentID)
            end
        end

        if #talentIDs > 1 then
            LearnTalents(unpack(talentIDs))
        end
    end

    if self.db.pvpTalent and pvpTalentTable then
        for i = 1, 3 do
            if pvpTalentTable[i] then
                local slotInfo = C_SpecializationInfo_GetPvpTalentSlotInfo(i)
                if slotInfo.enabled and slotInfo.selectedTalentID ~= pvpTalentTable[i] then
                    LearnPvpTalent(pvpTalentTable[i], i)
                end
            end
        end
    end
end

function TM:GetTalentString()
    local talentString = ""
    for tier = 1, MAX_TALENT_TIERS do
        local isAvilable, column = GetTalentTierInfo(tier, 1)
        talentString = talentString .. (isAvilable and column or 0)
    end
    return talentString
end

function TM:GetPvPTalentTable()
    local pvpTalentTable = {}
    for tier = 1, 3 do
        local slotInfo = C_SpecializationInfo_GetPvpTalentSlotInfo(tier)
        tinsert(pvpTalentTable, slotInfo.enabled and slotInfo.selectedTalentID)
    end
    return pvpTalentTable
end

function TM:UpdatePlayerInfo()
    local specID, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
    self.specID = specID
    self.specName = specName
    self.specIcon = specIcon

    if self.frame then
        self.frame.specIcon:SetTexture(self.specIcon)
        self.frame.specName:SetText(self.specName)
    end
end

function TM:UpdateSetButtons()
    if not self.frame or not self.specID then
        return
    end

    local db = self.db.sets[self.specID]
    local numSets = db and #db or 0

    -- 更新按钮
    for i = 1, numSets do
        local button = self.frame.setButtons[i]
        button:SetText(db[i].setName)
        button.setName = db[i].setName
        button.specID = self.specID
        button.talentString = db[i].talentString
        button.pvpTalentTable = db[i].pvpTalentTable
        button:Show()
    end

    -- 隐藏不需要显示的按钮
    if numSets == 15 then
        return
    end

    for i = numSets + 1, 15 do
        local button = self.frame.setButtons[i]
        button.setName = nil
        button.specID = nil
        button.talentString = nil
        button.pvpTalentTable = nil
        button:Hide()
    end
end

function TM:ShowContextText(button)
    local menu = {
        {
            text = button.setName,
            isTitle = true,
            notCheckable = true
        },
        {
            text = L["Overwrite"],
            func = function()
                TM:UpdateSet(button.setName, true)
            end,
            notCheckable = true
        },
        {
            text = L["Rename"],
            func = function()
                E:StaticPopup_Show("WINDTOOLS_TALENT_MANAGER_RENAME_SET", nil, nil, button)
            end,
            notCheckable = true
        },
        {
            text = L["Delete"],
            func = function()
                TM:DeleteSet(button.specID, button.setName)
            end,
            notCheckable = true
        }
    }

    EasyMenu(menu, self.contextMenuFrame, "cursor", 0, 0, "MENU")
end

function TM:GetTalentTooltipLine(tier, column)
    local lineTemplate = "|T%s:12:14:0:0:32:32:2:30:4:28|t %s"
    if column == 0 then
        return format(lineTemplate, 134400, L["Not set"])
    else
        local _, name, icon = GetTalentInfo(tier, column, 1)
        return format(lineTemplate, icon, name)
    end
end

function TM:GetPvPTalentTooltipLine(id)
    local lineTemplate = "|T%s:12:14:0:0:32:32:2:30:4:28|t %s"
    if not id then
        return format(lineTemplate, 134400, L["Not set"])
    else
        local _, name, icon = GetPvpTalentInfoByID(id)
        return format(lineTemplate, icon, name)
    end
end

function TM:SetButtonTooltip(button)
    local talentTable = {}
    gsub(
        button.talentString,
        "[0-9]",
        function(char)
            tinsert(talentTable, tonumber(char))
        end
    )
    GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT", 8, 20)
    GameTooltip:SetText(button.setName)

    for tier = 1, MAX_TALENT_TIERS do
        local text = self:GetTalentTooltipLine(tier, talentTable[tier], 1)
        GameTooltip:AddLine(text, 1, 1, 1)
    end

    if self.db.pvpTalent then
        GameTooltip:AddLine(" ", 1, 1, 1)
        GameTooltip:AddLine("PvP", 1, 1, 1)
        for i = 1, 3 do
            local text = self:GetPvPTalentTooltipLine(button.pvpTalentTable and button.pvpTalentTable[i])
            GameTooltip:AddLine(text, 1, 1, 1)
        end
    end

    GameTooltip:Show()
end

function TM:BuildFrame()
    if not IsAddOnLoaded("Blizzard_TalentUI") then
        self:RegisterEvent("ADDON_LOADED")
        return
    end

    -- 在天赋页右边加上
    local frame = CreateFrame("Frame", "WTTalentManager", _G.PlayerTalentFrame)
    frame:Point("TOPLEFT", _G.PlayerTalentFrame, "TOPRIGHT", 3, -1)
    frame:Point("BOTTOMRIGHT", _G.PlayerTalentFrame, "BOTTOMRIGHT", 153, 1)
    frame:CreateBackdrop("Transparent")

    frame:EnableMouse(true)

    S:CreateShadowModule(frame.backdrop)
    S:MerathilisUISkin(frame.backdrop)

    -- 专精图标
    local tex = frame:CreateTexture(nil, "ARTWORK")
    tex:CreateBackdrop()
    tex:SetTexture(self.specIcon)
    tex:SetTexCoord(unpack(E.TexCoords))
    tex:Size(30, 30)
    tex:Point("TOPLEFT", frame, "TOPLEFT", 10, -10)
    frame.specIcon = tex

    -- 专精文字
    local text = frame:CreateFontString(nil, "ARTWORK")
    text:FontTemplate()
    text:SetWidth(90)
    text:SetJustifyH("LEFT")
    F.SetFontOutline(text)
    text:SetText(self.specName)
    text:Point("LEFT", tex, "RIGHT", 10, 0)
    frame.specName = text

    -- 新增按钮
    local newButton = CreateFrame("Button", "WTTalentManagerNewButton", frame, "UIPanelButtonTemplate")
    newButton:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 10)
    newButton:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 10)
    newButton:SetHeight(20)
    newButton:SetText(L["New Set"])
    newButton:SetScript(
        "OnClick",
        function()
            local db = self.db.sets[self.specID]
            local nextIndex = db and #db + 1 or 1
            E:StaticPopup_Show("WINDTOOLS_TALENT_MANAGER_NEW_SET", nil, nil, nextIndex)
        end
    )
    ES:HandleButton(newButton)

    -- 天赋设定按钮
    frame.setButtons = {}
    for i = 1, 15 do
        local button = CreateFrame("Button", "WTTalentManagerSetButton" .. i, frame, "UIPanelButtonTemplate")
        button:Size(140, 20)

        if i == 1 then
            button:Point("TOP", frame, "TOP", 0, -50)
        else
            button:Point("TOP", frame.setButtons[i - 1], "BOTTOM", 0, -5)
        end

        button:SetText("")
        button:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        ES:HandleButton(button)
        S:CreateShadow(button.backdrop, nil, 1, 1, 1, true)
        if button.backdrop.shadow then
            button.backdrop.shadow:Hide()
        end

        button:SetScript(
            "OnClick",
            function(self, mouseButton)
                if mouseButton == "LeftButton" then
                    TM:SetTalent(self.talentString, self.pvpTalentTable)
                elseif mouseButton == "RightButton" then
                    TM:ShowContextText(self)
                end
            end
        )

        button:SetScript(
            "OnEnter",
            function(self)
                TM:SetButtonTooltip(self)
                self.backdrop.shadow:Show()
            end
        )

        button:SetScript(
            "OnLeave",
            function(self)
                GameTooltip:Hide()
                self.backdrop.shadow:Hide()
            end
        )

        button:Hide()
        frame.setButtons[i] = button
    end

    if not _G.PlayerTalentFrameTalents:IsShown() then
        frame:Hide()
        self.itemButtonsAnchor:Hide()
    end

    self:SecureHook(
        "PlayerTalentFrame_ShowTalentTab",
        function()
            if not self.db.forceHide then
                frame:Show()
            else
                frame:Hide()
            end
            self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateItemButtons")
            self:RegisterEvent("PLAYER_LEVEL_UP", "UpdateItemButtons")
            self:RegisterEvent("UNIT_AURA", "UpdateStatus")
            self:RegisterEvent("ZONE_CHANGED", "UpdateStatus")
            self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateStatus")
            self.itemButtonsAnchor:Show()
            self:UpdateStatus(nil, "player")
            self:UpdateItemButtons()
        end
    )

    self:SecureHook(
        "PlayerTalentFrame_HideTalentTab",
        function()
            frame:Hide()
            self:UnregisterEvent("BAG_UPDATE_DELAYED")
            self:UnregisterEvent("PLAYER_LEVEL_UP")
            self:UnregisterEvent("UNIT_AURA")
            self:UnregisterEvent("ZONE_CHANGED")
            self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
            self.itemButtonsAnchor:Hide()
        end
    )

    self:SecureHook(
        _G.PlayerTalentFrame,
        "Hide",
        function()
            frame:Hide()
            self:UnregisterEvent("BAG_UPDATE_DELAYED")
            self:UnregisterEvent("PLAYER_LEVEL_UP")
            self:UnregisterEvent("UNIT_AURA")
            self:UnregisterEvent("ZONE_CHANGED")
            self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
            self.itemButtonsAnchor:Hide()
        end
    )

    -- 移动模块兼容
    if E.private.WT.misc.moveBlizzardFrames then
        local MF = W:GetModule("MoveFrames")
        MF:HandleFrame(frame:GetName(), "PlayerTalentFrame")
    end

    -- 开关按钮
    local toggleButton =
        CreateFrame("Button", "WTTalentManagerToggleButton", _G.PlayerTalentFrameTalents, "UIPanelButtonTemplate")
    toggleButton:Point("BOTTOMRIGHT", _G.PlayerTalentFrameTalents, "BOTTOMRIGHT", -5, -15)
    toggleButton:SetText(L["Toggle Talent Manager"])
    toggleButton:SetWidth(toggleButton.Text:GetStringWidth() + 20)
    toggleButton:SetHeight(25)
    toggleButton:SetScript(
        "OnClick",
        function()
            if frame:IsShown() then
                TM.db.forceHide = true
                frame:Hide()
            else
                TM.db.forceHide = nil
                frame:Show()
            end
        end
    )
    ES:HandleButton(toggleButton)

    self.frame = frame
    self:UpdateSetButtons()
end

function TM:Enviroment()
    -- 新增设定的窗口
    E.PopupDialogs.WINDTOOLS_TALENT_MANAGER_NEW_SET = {
        text = L["Talent Manager"] .. " - " .. L["New Set"],
        button1 = ACCEPT,
        button2 = CANCEL,
        hasEditBox = 1,
        OnShow = function(self, setNumber)
            self.editBox:SetAutoFocus(false)
            self.editBox.width = self.editBox:GetWidth()
            self.editBox:Width(280)
            self.editBox:AddHistoryLine("text")
            self.editBox:SetText(L["New Set"] .. " #" .. setNumber)
            self.editBox:HighlightText()
            self.editBox:SetJustifyH("CENTER")
        end,
        OnHide = function(self)
            self.editBox:Width(self.editBox.width or 50)
            self.editBox.width = nil
        end,
        EditBoxOnEnterPressed = function(self)
            local setName = self:GetText()
            if setName then
                TM:SaveSet(setName)
            end
            self:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
        OnAccept = function(self)
            local setName = self.editBox:GetText()
            if setName then
                TM:SaveSet(setName)
            end
        end,
        hideOnEscape = 1
    }

    -- 重命名的窗口
    E.PopupDialogs.WINDTOOLS_TALENT_MANAGER_RENAME_SET = {
        text = L["Talent Manager"] .. " - " .. L["Rename Set"],
        button1 = ACCEPT,
        button2 = CANCEL,
        hasEditBox = 1,
        OnShow = function(self, data)
            self.editBox:SetAutoFocus(false)
            self.editBox.width = self.editBox:GetWidth()
            self.editBox:Width(280)
            self.editBox:AddHistoryLine("text")
            self.editBox:SetText(data.setName)
            self.editBox:HighlightText()
            self.editBox:SetJustifyH("CENTER")
        end,
        OnHide = function(self)
            self.editBox:Width(self.editBox.width or 50)
            self.editBox.width = nil
        end,
        EditBoxOnEnterPressed = function(self, data)
            local newName = self:GetText()
            if newName then
                TM:RenameSet(data.specID, data.setName, newName)
            end
            self:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
        OnAccept = function(self, data)
            local newName = self.editBox:GetText()
            if newName then
                TM:RenameSet(data.specID, data.setName, newName)
            end
        end,
        hideOnEscape = 1
    }

    -- 按钮右键菜单
    self.contextMenuFrame = CreateFrame("Frame", "WTTalentManagerContextMenu", E.UIParent, "UIDropDownMenuTemplate")
end

function TM:CreateItemButton(parent, itemID, width, height)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate, BackdropTemplate")
    button:Size(width, height or width)
    button:SetTemplate("Default")
    button:SetClampedToScreen(true)
    button:SetAttribute("type", "item")
    button:SetAttribute("item", "item:" .. itemID)
    button.itemID = itemID
    button:EnableMouse(true)
    button:RegisterForClicks("AnyUp")

    local tex = button:CreateTexture(nil, "OVERLAY", nil)
    tex:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
    tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    tex:SetTexCoord(unpack(E.TexCoords))
    tex:SetTexture(GetItemIcon(itemID))

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetTextColor(1, 1, 1, 1)
    count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    count:SetJustifyH("RIGHT")
    count:FontTemplate()

    local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    E:RegisterCooldown(cooldown)

    button.tex = tex
    button.count = count
    button.cooldown = button.cooldown

    button:StyleButton()

    button:SetScript(
        "OnEnter",
        function(self)
            if self.SetBackdropBorderColor then
                self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
            end
            GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetItemByID(itemID)
            GameTooltip:Show()
        end
    )

    button:SetScript(
        "OnLeave",
        function(self)
            if self.SetBackdropBorderColor then
                self:SetBackdropBorderColor(unpack(E.media.bordercolor))
            end
            GameTooltip:Hide()
        end
    )

    button:SetScript(
        "OnUpdate",
        function()
            local start, duration, enable = GetItemCooldown(itemID)
            CooldownFrame_Set(cooldown, start, duration, enable)
        end
    )

    return button
end

function TM:BuildItemButtons()
    if not self.db or self.itemButtonsAnchor then
        return
    end

    local frame = CreateFrame("Frame", nil, _G.PlayerTalentFrame)
    frame:Size(500, 40)
    frame:Point("TOPLEFT", 0, -31)
    self.itemButtonsAnchor = frame

    if self.db.statusIcon then
        local status = frame:CreateTexture(nil, "ARTWORK")
        status:SetTexture(W.Media.Textures.exchange)
        status:Size(32, 32)
        status:Point("LEFT", 20, 0)
        frame.status = status
    end

    if self.db.itemButtons then
        self.itemButtons = {
            tome = {},
            codex = {}
        }

        for _, data in ipairs(itemList.tome) do
            local button = self:CreateItemButton(frame, data[1], 36)
            if button then
                button.min = data[2]
                button.max = data[3]
                tinsert(self.itemButtons.tome, button)
            end
        end

        for _, data in ipairs(itemList.codex) do
            local button = self:CreateItemButton(frame, data[1], 36)
            if button then
                button.min = data[2]
                button.max = data[3]
                tinsert(self.itemButtons.codex, button)
            end
        end
    end

    self:UpdateItemButtons()
end

function TM:UpdateStatus(event, unit)
    if event == "UNIT_AURA" and not unit == "player" then
        return
    end

    if self.db.statusIcon and self.itemButtonsAnchor.status then
        if self:IsPlayerCanChangeTalent() then
            self.itemButtonsAnchor.status:SetVertexColor(unpack(E.media.rgbvaluecolor))
            self.itemButtonsAnchor.status:SetAlpha(1)
        else
            self.itemButtonsAnchor.status:SetVertexColor(1, 1, 1)
            self.itemButtonsAnchor.status:SetAlpha(0.3)
        end
    end
end

function TM:UpdateItemButtons()
    local frame = _G.PlayerTalentFrameTalents
    if not frame or not frame:IsShown() then
        return
    end

    if not self.itemButtons then
        return
    end

    if self.db and self.db.itemButtons then
        -- Update layout
        local lastButton
        for _, button in pairs(self.itemButtons.tome) do
            local level = UnitLevel("player")
            local allow = level and level >= button.min and level <= button.max
            local count = allow and GetItemCount(button.itemID, nil, true)
            if count and count > 0 then
                button.count:SetText(count)
                button:ClearAllPoints()
                if lastButton then
                    button:Point("LEFT", lastButton, "RIGHT", 3, 0)
                else
                    button:Point("LEFT", 79, 0)
                end
                lastButton = button
                button:Show()
            else
                button:Hide()
            end
        end

        for _, button in pairs(self.itemButtons.codex) do
            local level = UnitLevel("player")
            local allow = level and level >= button.min and level <= button.max
            local count = allow and GetItemCount(button.itemID, nil, true)
            if count and count > 0 then
                button.count:SetText(count)
                button:ClearAllPoints()
                if lastButton then
                    button:Point("LEFT", lastButton, "RIGHT", 13, 0)
                else
                    button:Point("LEFT", 79, 0)
                end
                lastButton = button
                button:Show()
            else
                button:Hide()
            end
        end
        self.itemButtonsAnchor:Show()
    else
        self.itemButtonsAnchor:Hide()
    end
end

function TM:PLAYER_SPECIALIZATION_CHANGED(_, unit)
    if unit == "player" then
        self:UpdatePlayerInfo()
        self:UpdateSetButtons()
    end
end

function TM:PLAYER_ENTERING_WORLD()
    self:UpdatePlayerInfo()
    self:UpdateSetButtons()
end

function TM:Initialize()
    self.db = E.private.WT.combat.talentManager
    if not self.db.enable then
        return
    end

    self:Enviroment()
    self:UpdatePlayerInfo()
    self:BuildFrame()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

W:RegisterModule(TM:GetName())
