local W, F, E, L = unpack(select(2, ...))
local EB = W:NewModule("ExtraItemsBar", "AceEvent-3.0", "AceHook-3.0")
local S = W:GetModule("Skins")

local _G = _G
local unpack = unpack
local strmatch = strmatch
local tinsert = tinsert
local wipe = wipe
local tonumber = tonumber
local InCombatLockdown = InCombatLockdown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local CreateFrame = CreateFrame
local GetInventoryItemID = GetInventoryItemID
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local GameTooltip = _G.GameTooltip
local IsUsableItem = IsUsableItem
local GetItemIcon = GetItemIcon
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo

local questItemList = {}
local equipmentList = {}

local function UpdateQuestItemList()
    wipe(questItemList)
    for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
        local link = GetQuestLogSpecialItemInfo(questLogIndex)
        if link then
            local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
            local data = {
                questLogIndex = questLogIndex,
                itemID = itemID
            }
            tinsert(questItemList, data)
        end
    end
end

local function UpdateEquipmentList()
    wipe(equipmentList)
    for slotID = 1, 18 do
        local itemID = GetInventoryItemID("player", slotID)
        if itemID and IsUsableItem(itemID) then
            tinsert(equipmentList, slotID)
        end
    end
end

function EB:Test()
    UpdateQuestItemList()
    UpdateEquipmentList()
    self:CreateBar(1)
    self:UpdateBar(1)
end

function EB:CreateButton(name, barDB)
    local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
    button:Size(barDB.size)
    button:SetTemplate("Default")
    button:SetClampedToScreen(true)
    button:SetAttribute("type", "item")
    button:EnableMouse(false)
    button:RegisterForClicks("AnyUp")

    local tex = button:CreateTexture(nil, "OVERLAY", nil)
    tex:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
    tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    tex:SetTexCoord(unpack(E.TexCoords))

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetTextColor(1, 1, 1, 1)
    count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0.5, 0)
    count:SetJustifyH("CENTER")
    F.SetFontWithDB(count, barDB.countFont)

    local bind = button:CreateFontString(nil, "OVERLAY")
    bind:SetTextColor(0.6, 0.6, 0.6)
    bind:Point("BOTTOM", button, "BOTTOM", 0, -5)
    bind:SetJustifyH("CENTER")
    F.SetFontWithDB(bind, barDB.bindFont)

    local cooldown = CreateFrame("Cooldown", name .. "Cooldown", button, "CooldownFrameTemplate")
    E:RegisterCooldown(cooldown)

    button.tex = tex
    button.count = count
    button.bind = bind
    button.cooldown = cooldown

    button:StyleButton()

    if E.private.WT.skins.enable and E.private.WT.skins.windtools then
        S:CreateShadow(button)
    end

    return button
end

function EB:SetUpButton(button, questItemData, slotID)
    button.itemName = nil
    button.itemID = nil
    button.spellName = nil
    button.slotID = nil
    button.countText = nil

    if questItemData then
        button.itemID = questItemData.itemID
        button.itemName = GetItemInfo(questItemData.itemID)
        button.spellName = IsUsableItem(questItemData.itemID)
        button.countText = GetItemCount(questItemData.itemID, nil, true)
        button.tex:SetTexture(GetItemIcon(questItemData.itemID))
        button.questLogIndex = questItemData.questLogIndex

        button:SetBackdropBorderColor(1, 1, 1)
    elseif slotID then
        local itemID = GetInventoryItemID("player", slotID)
        local name, _, rarity = GetItemInfo(itemID)

        button.slotID = slotID
        button.itemName = GetItemInfo(itemID)
        button.spellName = IsUsableItem(itemID)
        button.tex:SetTexture(GetItemIcon(itemID))

        if rarity and rarity > 1 then
            local r, g, b = GetItemQualityColor(rarity)
            button:SetBackdropBorderColor(r, g, b)
        end
    end

    -- 更新对叠数
    if button.countText and button.countText > 1 then
        button.count:SetText(countText)
    else
        button.count:SetText()
    end

    -- 更新 OnUpdate 函数
    local OnUpdateFunction

    if button.itemID then
        OnUpdateFunction = function(self)
            local start, duration, enable
            if self.questLogIndex > 0 then
                start, duration, enable = GetQuestLogSpecialItemCooldown(self.questLogIndex)
            else
                start, duration, enable = GetItemCooldown(self.itemID)
            end
            CooldownFrame_Set(self.cooldown, start, duration, enable)
            if (duration and duration > 0 and enable and enable == 0) then
                self.tex:SetVertexColor(0.4, 0.4, 0.4)
            elseif IsItemInRange(self.itemID, "target") == false then
                self.tex:SetVertexColor(1, 0, 0)
            else
                self.tex:SetVertexColor(1, 1, 1)
            end
        end
    elseif button.slotID then
        OnUpdateFunction = function(self)
            local start, duration, enable = GetInventoryItemCooldown("player", self.slotID)
            CooldownFrame_Set(self.cooldown, start, duration, enable)
        end
    end

    button:SetScript("OnUpdate", OnUpdateFunction)

    -- 浮动提示
    button:SetScript(
        "OnEnter",
        function(self)
            if InCombatLockdown() then
                return
            end

            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
            GameTooltip:ClearLines()

            if self.slotID then
                GameTooltip:SetInventoryItem("player", self.slotID)
            else
                GameTooltip:SetItemByID(self.itemID)
            end

            GameTooltip:Show()
        end
    )

    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )

    -- 更新按钮功能
    if not InCombatLockdown() then
        button:EnableMouse(true)
        button:Show()
        if button.slotID then
            button:SetAttribute("type", "macro")
            button:SetAttribute("macrotext", "/use " .. button.slotID)
        elseif button.itemName then
            button:SetAttribute("type", "item")
            button:SetAttribute("item", button.itemName)
        end
    else
        button:RegisterEvent("PLAYER_REGEN_ENABLED")
        button:SetScript(
            "OnEvent",
            function(self, event)
                if event == "PLAYER_REGEN_ENABLED" then
                    self:EnableMouse(true)
                    if self.slotID then
                        self:SetAttribute("type", "macro")
                        self:SetAttribute("macrotext", "/use " .. self.slotID)
                    elseif self.itemName then
                        self:SetAttribute("type", "item")
                        self:SetAttribute("item", self.itemName)
                    end
                    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
                    button:Show()
                end
            end
        )
    end
end

function EB:CreateBar(id)
    if not self.db or not self.db["bar" .. id] then
        return
    end

    local barDB = self.db["bar" .. id]

    -- 建立条移动锚点
    local anchor = CreateFrame("Frame", "WTExtraItemsBar" .. id .. "Anchor", E.UIParent)
    anchor:SetClampedToScreen(true)
    anchor:Point("BOTTOMLEFT", _G.RightChatPanel or _G.LeftChatPanel, "TOPLEFT", 0, (id - 1) * 45)
    anchor:Size(200, 40)
    E:CreateMover(
        anchor,
        "WTExtraItemsBar" .. id .. "Mover",
        L["Extra Items Bar"] .. " " .. id,
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return EB.db.enable and barDB.enable
        end
    )

    -- 建立条
    local bar = CreateFrame("Frame", "WTExtraItemsBar" .. id, E.UIParent, "SecureHandlerStateTemplate")
    bar.id = id
    bar:ClearAllPoints()
    bar:SetParent(anchor)
    bar:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    bar:Size(200, 40)
    bar:CreateBackdrop("Transparent")
    bar:SetFrameStrata("LOW")

    -- 建立按钮
    bar.buttons = {}
    for i = 1, 12 do
        bar.buttons[i] = self:CreateButton(bar:GetName() .. "Button" .. i, barDB)
        bar.buttons[i]:SetParent(bar)
        if i == 1 then
            bar.buttons[i]:Point("LEFT", bar, "LEFT", 5, 0)
        else
            bar.buttons[i]:Point("LEFT", bar.buttons[i - 1], "RIGHT", 5, 0)
        end
    end

    self.bars[id] = bar
end

function EB:UpdateBar(id)
    if not self.db or not self.db["bar" .. id] then
        return
    end

    local bar = self.bars[id]
    local barDB = self.db["bar" .. id]

    local buttonID = 1

    for _, module in ipairs {strsplit("[, ]", barDB.include)} do
        if module == "QUEST" then -- 更新任务物品
            for _, data in pairs(questItemList) do
                self:SetUpButton(bar.buttons[buttonID], data)
                buttonID = buttonID + 1
                if buttonID > 12 then
                    return
                end
            end
        elseif module == "EQUIP" then -- 更新装备物品
            for _, slotID in pairs(equipmentList) do
                self:SetUpButton(bar.buttons[buttonID], nil, slotID)
                buttonID = buttonID + 1
                if buttonID > 12 then
                    return
                end
            end
        end
    end

    -- 隐藏其余按钮
    if buttonID == 1 then
        bar:Hide()
        return
    elseif buttonID <= 12 then
        for hideButtonID = buttonID, 12 do
            bar.buttons[hideButtonID]:Hide()
        end
    end

    bar:Show()

    -- 切换阴影
    if E.private.WT.skins.enable and E.private.WT.skins.windtools then
        if barDB.backdrop then
            bar.backdrop:Show()
            for i = 1, 12 do
                if bar.buttons[i].shadow then
                    bar.buttons[i].shadow:Hide()
                end
            end
        else
            bar.backdrop:Hide()
            for i = 1, 12 do
                if bar.buttons[i].shadow then
                    bar.buttons[i].shadow:Show()
                end
            end
        end
    end
end

function EB:UpdateAll()
    UpdateQuestItemList()
    UpdateEquipmentList()

    for i = 1, 3 do
        self:UpdateBar(i)
    end
end

function EB:CreateAll()
    self.bars = {}

    for i = 1, 3 do
        self:CreateBar(i)
        if E.private.WT.skins.enable and E.private.WT.skins.windtools then
            S:CreateShadow(self.bars[i].backdrop)
        end
    end
end

function EB:Initialize()
    self.db = E.db.WT.misc.extraItemsBar
    if not self.db or not self.db.enable then
        return
    end

    self:CreateAll()
end

W:RegisterModule(EB:GetName())
