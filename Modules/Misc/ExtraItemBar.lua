local W, F, E, L = unpack(select(2, ...))
local EB = W:NewModule("ExtraItemsBar", "AceEvent-3.0", "AceHook-3.0")
local ES = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local strmatch = strmatch
local tinsert = tinsert
local wipe = wipe
local tonumber = tonumber
local InCombatLockdown = InCombatLockdown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local CreateFrame = CreateFrame
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local GameTooltip = _G.GameTooltip

local questItemList = {}

local function GetWorldQuestItemList()
    local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
end

function EB:UpdateQuestItemList()
    wipe(questItemList)
    for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
        local link = GetQuestLogSpecialItemInfo(questLogIndex)
        if link then
            local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
            tinsert(questItemList, itemID)
        end
    end
end

function EB:Test()
    self:UpdateQuestItemList()
    F.Developer.Print(questItemList)
    self:CreateBar(1)
    self:UpdateBar(1)
end

function EB:UpdateButton(name, barDB)
    local button = _G[name]
    if not button then
        button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
        button:Size(barDB.size)
        button:SetTemplate("Default")
        button:StyleButton()
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

        local bind = button:CreateFontString(nil, "OVERLAY")
        bind:SetTextColor(0.6, 0.6, 0.6)
        bind:Point("BOTTOM", button, "BOTTOM", 0, -5)
        bind:SetJustifyH("CENTER")

        local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
        cooldown:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
        cooldown:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        cooldown:SetSwipeColor(0, 0, 0, 0)
        cooldown:SetDrawBling(false)

        button.tex = tex
        button.count = count
        button.bind = bind
        button.cooldown = cooldown
    end

    F.SetFontWithDB(button.count, barDB.countFont)
    F.SetFontWithDB(button.bind, barDB.bindFont)
    button:Size(barDB.size)

    return button
end

function EB:SetUpButton(button, itemID)
    if itemID then
        local name = GetItemInfo(itemID)
        local count = GetItemCount(itemID, nil, true)
        local icon = GetItemIcon(itemID)
        button.tex:SetTexture(icon)
        button.itemName = name
        button.itemID = itemID
        button.spellName = IsUsableItem(itemID)
        button.slotID = nil
    end

    button:Show()

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
    anchor:Point("BOTTOMLEFT", _G.RightChatPanel or _G.LeftChatPanel, "TOPLEFT", 0, (id - 1) * 40)
    anchor:Size(200, 40)
    E:CreateMover(
        anchor,
        "WTExtraItemsBarMover",
        L["Extra Items Bar" .. " " .. id],
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
        bar.buttons[i] = self:UpdateButton(bar:GetName() .. "Button" .. i, barDB)

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

    local barDB = self.db["bar" .. id]

    local buttonID = 1

    -- 更新任务物品
    for _, itemID in pairs(questItemList) do
        self:SetUpButton(self.bars[id].buttons[buttonID], itemID)
        buttonID = buttonID + 1
        if buttonID > 12 then
            return
        end
    end

    if buttonID <= 12 then
        for hideButtonID = buttonID, 12 do
            self.bars[id].buttons[hideButtonID]:Hide()
        end
    end
end

function EB:Initialize()
    self.db = E.db.WT.misc.extraItemsBar
    if not self.db or not self.db.enable then
        return
    end

    self.bars = {}
    --self:CreateBar(1)
end

W:RegisterModule(EB:GetName())
