local W, F, E, L = unpack(select(2, ...))
local CH = W:NewModule("CovenantHelper", "AceHook-3.0", "AceEvent-3.0")
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local tinsert = tinsert
local ipairs = ipairs

local CreateFrame = CreateFrame

local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Soulbinds_ActivateSoulbind = C_Soulbinds.ActivateSoulbind
local C_Soulbinds_CanActivateSoulbind = C_Soulbinds.CanActivateSoulbind
local C_Soulbinds_GetActiveSoulbindID = C_Soulbinds.GetActiveSoulbindID
local C_Soulbinds_GetSoulbindData = C_Soulbinds.GetSoulbindData

local function tryActivateSoulbind(soulbindID)
    if not soulbindID then
        return false
    end

    local result, errorDescription = C_Soulbinds_CanActivateSoulbind(soulbindID)
    if not result and errorDescription then
        F.Print(L["Failed to auto-activate soulbind."])
        F.Print(L["The reason is:"] .. " " .. errorDescription)
        return false
    end

    C_Soulbinds_ActivateSoulbind(soulbindID)
    return true
end

function CH:UpdateCovenantCache()
    local soulbinds = {
        {7, 13, 18},
        {3, 8, 9},
        {1, 2, 6},
        {4, 5, 10}
    }

    self.covenantCache = {}

    for covenantID, soulbindIDs in ipairs(soulbinds) do
        local covenantData = C_Covenants_GetCovenantData(covenantID)
        local cache = {
            name = covenantData.name,
            soulbinds = {}
        }

        for _, soulbindID in ipairs(soulbindIDs) do
            local soulbindData = C_Soulbinds_GetSoulbindData(soulbindID)
            if soulbindData then
                tinsert(
                    cache.soulbinds,
                    {
                        id = soulbindData.ID,
                        name = soulbindData.name,
                        modelID = soulbindData.modelSceneData.creatureDisplayInfoID
                    }
                )
            end
        end

        tinsert(self.covenantCache, cache)
    end
end

function CH:BuildAlert()
    local reminder = CreateFrame("Frame", nil, E.UIParent)
    reminder:SetPoint("TOP", 0, -400)
    reminder:SetSize(500, 200)
    reminder:SetTemplate("Transparent")
    if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
        S:CreateShadow(reminder)
    end

    reminder.title = reminder:CreateFontString(nil, "OVERLAY")
    reminder.title:SetFont(E.media.normFont, 12, "OUTLINE")
    reminder.title:SetText(F.GetWindStyleText(L["Covenant Helper"]))
    reminder.title:SetPoint("TOP", 0, -12)

    reminder.remindText = reminder:CreateFontString(nil, "OVERLAY")

    reminder.closeButton = F.Widgets.New("CloseButton", reminder)
    reminder.closeButton:SetPoint("TOPRIGHT")

    reminder.configButton =
        F.Widgets.New(
        "TextureButton",
        reminder,
        W.Media.Icons.barOptions,
        nil,
        nil,
        14,
        14,
        function()
            return E:ToggleOptionsUI("WindTools,combat,covenantHelper")
        end
    )

    F.Widgets.AddTooltip(reminder.configButton, L["Open Configuation"], "ANCHOR_RIGHT")

    reminder.configButton:SetPoint("TOPLEFT", 10, -10)

    reminder.soulbindButtons = {}

    for i = 1, 3 do
        local soulbindButton =
            F.Widgets.New(
            "Button",
            reminder,
            "",
            150,
            35,
            function(self)
                if self.soulbindID then
                    if tryActivateSoulbind(self.soulbindID) then
                        reminder:Hide()
                    end
                end
            end
        )

        S:CreateShadow(soulbindButton, 4, 0, 1, 1, true)

        local activeText = soulbindButton:CreateFontString(nil, "OVERLAY")
        activeText:SetFont(E.media.normFont, 12, "OUTLINE")
        activeText:SetPoint("BOTTOM", 0, -6)
        activeText:SetText("|cff00ff00" .. L["Active"] .. "|r")
        soulbindButton.activeText = activeText

        local model = CreateFrame("PlayerModel", nil, soulbindButton)
        model:SetFrameLevel(soulbindButton:GetFrameLevel())
        model:SetInside(soulbindButton, 1, 1)
        model:SetDisplayInfo(384)
        model:SetCamDistanceScale(1)
        model:SetAlpha(0.3)
        model:SetPosition(0, 0, -0.2)
        model:Show()

        soulbindButton.model = model

        soulbindButton:HookScript(
            "OnEnter",
            function(self)
                local alpha = self.model:GetAlpha()
                E:UIFrameFadeIn(model, 0.3 * (1 - alpha), alpha, 1)
            end
        )

        soulbindButton:HookScript(
            "OnLeave",
            function(self)
                local alpha = self.model:GetAlpha()
                E:UIFrameFadeIn(model, 0.3 * (alpha - 0.3), alpha, 0.3)
            end
        )

        tinsert(reminder.soulbindButtons, soulbindButton)
    end

    reminder.soulbindButtons[1]:SetPoint("BOTTOM", -160, 15)
    reminder.soulbindButtons[2]:SetPoint("BOTTOM", 0, 15)
    reminder.soulbindButtons[3]:SetPoint("BOTTOM", 160, 15)

    reminder:Hide()

    self.reminder = reminder

    E:CreateMover(
        self.reminder,
        "WTCovenantHelperAlertFrame",
        L["Covenant Helper"],
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return E.db.WT.combat.covenantHelper.enable
        end,
        "WindTools,combat,covenantHelper"
    )
end

function CH:ShowReminder(message)
    if not self.reminder then
        return
    end

    local text = self.reminder.remindText

    F.SetFontWithDB(text, self.db.soulbind.remindText)
    text:SetText(message)
    text:ClearAllPoints()
    text:SetPoint("CENTER", self.db.soulbind.remindText.xOffset, self.db.soulbind.remindText.yOffset + 10)

    local covenantID = C_Covenants_GetActiveCovenantID()
    local activeSoulbindID = C_Soulbinds_GetActiveSoulbindID()

    local buttons = self.reminder.soulbindButtons

    for index, soulbindData in ipairs(self.covenantCache[covenantID].soulbinds) do
        buttons[index].soulbindID = soulbindData.id
        buttons[index].soulbindName = soulbindData.name
        buttons[index]:SetText(soulbindData.name)
        buttons[index].model:SetDisplayInfo(soulbindData.modelID)

        if activeSoulbindID == soulbindData.id then
            buttons[index].activeText:Show()
            buttons[index].shadow:Show()
        else
            buttons[index].activeText:Hide()
            buttons[index].shadow:Hide()
        end
    end

    self.reminder:Show()
end

function CH:AutoActivateSoulbind()
    if not self.db.soulbind.autoActivate then
        return
    end

    local covenantID = C_Covenants_GetActiveCovenantID()
    local soulbindIndex =
        self.soulbindRules["characters"][E.myname] and self.soulbindRules["characters"][E.myname][covenantID]

    if soulbindIndex then
        return tryActivateSoulbind(self.covenantCache[covenantID].soulbinds[soulbindIndex].id)
    end
end

function CH:GetSoulbindData(covenantID)
    return self.covenantCache[covenantID].soulbinds
end

function CH:SOULBIND_ACTIVATED(_, soulbindID)
    if soulbindID ~= 0 then
        self:UnregisterEvent("SOULBIND_ACTIVATED")
        if not self:AutoActivateSoulbind() then
            if self.db.soulbind.showReminder then
                self:ShowReminder(L["Confirm your choice of the soulbind"])
            end
        end
    end
end

function CH:COVENANT_CHOSEN()
    self:RegisterEvent("SOULBIND_ACTIVATED")
    E:Delay(
        3,
        function()
            self:UnregisterEvent("SOULBIND_ACTIVATED")
        end
    )
end

function CH:Initialize()
    self.db = E.db.WT.combat.covenantHelper
    self.soulbindRules = E.global.WT.combat.covenantHelper.soulbindRules

    if not self.initialized then
        self:BuildAlert()
        self:UpdateCovenantCache()
        self.initialized = true
    end

    if self.db.enable then
        self:RegisterEvent("COVENANT_CHOSEN")
    else
        self:UnregisterEvent("COVENANT_CHOSEN")
    end
end

CH.ProfileUpdate = CH.Initialize

W:RegisterModule(CH:GetName())
