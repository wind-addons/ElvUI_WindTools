local W, F, E, L = unpack((select(2, ...)))
local T = W:NewModule("Trade", "AceEvent-3.0")

local _G = _G
local GetUnitName = GetUnitName
local SendChatMessage = SendChatMessage

function T:CreateThanksButton()
	self.thanksButton = F.Widgets.New("Button", _G.TradeFrame, L["Thanks"], 80, 20, function(self)
		if self.targetName then
			SendChatMessage(T.db.thanksText, "WHISPER", nil, self.targetName)
		end
	end)

	self.thanksButton:SetPoint("BOTTOMLEFT", _G.TradeFrame, "BOTTOMLEFT", 5, 5)
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
