local W, F, E, L = unpack(select(2, ...))
local T = W:NewModule("Trade", "AceEvent-3.0")
local ES = E.Skins

local _G = _G
local CreateFrame = CreateFrame
local GetUnitName = GetUnitName
local SendChatMessage = SendChatMessage

function T:CreateThanksButton()
    local frame = _G.TradeFrame
    local button = CreateFrame("Button", "WTTradeThanksButton", frame, "UIPanelButtonTemplate")
    button:Size(80, 20)
    button:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
    button:SetText(L["Thanks"])
    button:SetScript(
        "OnClick",
        function(self)
            if self.targetName then
                SendChatMessage(T.db.thanksText, "WHISPER", nil, self.targetName)
            end
        end
    )
    ES:HandleButton(button)
    self.thanksButton = button
end

function T:TRADE_SHOW()
    local targetName = GetUnitName("NPC", true)
    if self.thanksButton then
        self.thanksButton.targetName = targetName
    end
end

function T:Initialize()
    self.db = E.db.WT.item.trade
    if not self.db or not self.db.enable then
        return
    end

    if self.db.thanksButton then
        self:CreateThanksButton()
        self:RegisterEvent("TRADE_SHOW")
    end
end

function T:ProfileUpdate()
    self.db = E.db.WT.item.trade
    if not self.db then
        return
    end

    if self.db.enable and self.db.thanksButton then
        if self.thanksButton then
            self.thanksButton:Show()
        else
            self:CreateThanksButton()
        end
        self:RegisterEvent("TRADE_SHOW")
    else
        if self.thanksButton then
            self.thanksButton:Hide()
        end
        self:UnregisterEvent("TRADE_SHOW")
    end
end

W:RegisterModule(T:GetName())
