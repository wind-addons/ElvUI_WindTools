local W, F, E, L = unpack(select(2, ...))
local TM = W:NewModule("TalentManager", "AceEvent-3.0", "AceHook-3.0")
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G

local format = format
local gsub = gsub
local pairs = pairs
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local unpack = unpack

local CreateFrame = CreateFrame
local EasyMenu = EasyMenu
local GameTooltip = _G.GameTooltip
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTalentInfo = GetTalentInfo
local GetTalentTierInfo = GetTalentTierInfo
local IsAddOnLoaded = IsAddOnLoaded
local LearnTalents = LearnTalents

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL
local MAX_TALENT_TIERS = _G.MAX_TALENT_TIERS

function TM:ADDON_LOADED(_, addon)
    if addon == "Blizzard_TalentUI" then
        self:UnregisterEvent("ADDON_LOADED")
        self:BuildFrame()
    end
end

function TM:SaveSet(setName)
    local talentString = self:GetTalentString()

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
                talentString = talentString
            }
        )
        self:UpdateSetButtons()
    end
end

function TM:UpdateSet(setName)
    local talentString = self:GetTalentString()
    for key, data in pairs(self.db.sets[self.specID]) do
        if data.setName == setName then
            data.talentString = talentString
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

function TM:SetTalent(talentString)
    if not talentString or talentString == "" then
        return
    end

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

function TM:GetTalentString()
    local talentString = ""
    for tier = 1, MAX_TALENT_TIERS do
        local isAvilable, column = GetTalentTierInfo(tier, 1)
        talentString = talentString .. (isAvilable and column or 0)
    end
    return talentString
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
                    TM:SetTalent(self.talentString)
                elseif mouseButton == "RightButton" then
                    TM:ShowContextText(self)
                end
            end
        )

        button:SetScript(
            "OnEnter",
            function(self)
                TM:SetButtonTooltip(self)
                if self.backdrop.shadow then
                    self.backdrop.shadow:Show()
                end
            end
        )

        button:SetScript(
            "OnLeave",
            function(self)
                GameTooltip:Hide()
                if self.backdrop.shadow then
                    self.backdrop.shadow:Hide()
                end
            end
        )

        button:Hide()
        frame.setButtons[i] = button
    end

    if not _G.PlayerTalentFrameTalents:IsShown() then
        frame:Hide()
    end

    self:SecureHook(
        "PlayerTalentFrame_ShowTalentTab",
        function()
            if not self.db.forceHide then
                frame:Show()
            else
                frame:Hide()
            end
        end
    )

    self:SecureHook(
        "PlayerTalentFrame_HideTalentTab",
        function()
            frame:Hide()
        end
    )

    self:SecureHook(
        _G.PlayerTalentFrame,
        "Hide",
        function()
            frame:Hide()
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

function TM:PLAYER_SPECIALIZATION_CHANGED(_, unit)
    if unit == "player" then
        self:UpdatePlayerInfo()
        self:UpdateSetButtons()
    end
end

function TM:Initialize()
    self.db = E.private.WT.combat.talentManager
    if not self.db.enable then
        return
    end

    self:Enviroment()
    self:UpdatePlayerInfo()
    self:BuildFrame()

    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

W:RegisterModule(TM:GetName())
