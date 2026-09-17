local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local T = W:NewModule("Trade", "AceEvent-3.0")

local _G = _G
local GetUnitName = GetUnitName
local SendChatMessage = SendChatMessage

function T:CreateThanksButton()
	self.ThanksButton = F.Widgets.New("Button", _G.TradeFrame, L["Thanks"], 80, 20, function(_)
		if self.ThanksButton.targetName then
			SendChatMessage(T.db.thanksText, "WHISPER", nil, self.ThanksButton.targetName)
		end
	end)

	self.ThanksButton:Point("BOTTOMLEFT", _G.TradeFrame, "BOTTOMLEFT", 5, 5)
end

function T:TRADE_SHOW()
	local targetName = GetUnitName("NPC", true)
	if self.ThanksButton then
		self.ThanksButton.targetName = targetName
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
		if self.ThanksButton then
			self.ThanksButton:Show()
		else
			self:CreateThanksButton()
		end
		self:RegisterEvent("TRADE_SHOW")
	else
		if self.ThanksButton then
			self.ThanksButton:Hide()
		end
		self:UnregisterEvent("TRADE_SHOW")
	end
end

W:RegisterModule(T:GetName())
