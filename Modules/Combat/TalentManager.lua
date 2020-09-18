local W, F, E, L = unpack(select(2, ...))
local TM = W:NewModule("TalentManager", "AceEvent-3.0")
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local gsub = gsub
local tinsert = tinsert
local unpack = unpack
local LearnTalents = LearnTalents
local GetTalentInfo = GetTalentInfo
local GetTalentTierInfo = GetTalentTierInfo

local MAX_TALENT_TIERS = MAX_TALENT_TIERS

-- 新增设定的窗口
E.PopupDialogs.WINDTOOLS_TALENT_MANAGER_NEW_SET = {
    text = L["Talent Manager"],
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

function TM:SaveSet(setName)
    print(setName)
end

function TM:ADDON_LOADED(_, addon)
    if addon == "Blizzard_TalentUI" then
        self:UnregisterEvent("ADDON_LOADED")
        self:BuildFrame()
    end
end

function TM:BuildFrame()
    if not IsAddOnLoaded("Blizzard_TalentUI") then
        self:RegisterEvent("ADDON_LOADED")
        return
    end

    -- 在天赋页右边加上
    local frame = CreateFrame("Frame", "WTTalentManager", E.UIParent)
    frame:Point("TOPLEFT", _G.PlayerTalentFrame, "TOPRIGHT", 3, -1)
    frame:Point("BOTTOMRIGHT", _G.PlayerTalentFrame, "BOTTOMRIGHT", 153, 1)
    frame:CreateBackdrop("Transparent")

    if E.private.WT.skins.enable and E.private.WT.skins.windtools then
        S:CreateShadow(frame.backdrop)
    end

    -- 新增按钮
    local newButton = CreateFrame("Button", "WTTalentManagerNewButton", frame, "UIPanelButtonTemplate")
    newButton:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
    newButton:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
    newButton:SetHeight(20)
    newButton:SetText(L["New Set"])
    newButton:SetScript(
        "OnClick",
        function()
            E:StaticPopup_Show("WINDTOOLS_TALENT_MANAGER_NEW_SET", nil, nil, 10)
        end
    )
    ES:HandleButton(newButton)

    self.frame = frame
end

function TM:SetTalent(talentString)
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
        if isAvilable and talentTable[tier] ~= 0 and talentTable[i] ~= column then
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

function TM:Initialize()
    self.db = E.private.WT.combat.talentManager
    if not self.db.enable then
        return
    end
end

W:RegisterModule(TM:GetName())
