local W ---@class WindTools
local F ---@type Functions
local E, L ---@type table, table
W, F, E, L = unpack((select(2, ...)))

local C = W.Utilities.Color ---@type ColorUtility

local tinsert = tinsert
local tconcat = table.concat

-- Add ElvUI move category
tinsert(E.ConfigModeLayouts, "WINDTOOLS")
E.ConfigModeLocalizedStrings["WINDTOOLS"] = W.Title

E.PopupDialogs.WINDTOOLS_EDITBOX = {
	text = W.Title,
	button1 = _G.OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.EditBox:SetAutoFocus(false)
		self.EditBox.width = self.EditBox:GetWidth()
		self.EditBox:Width(280)
		self.EditBox:AddHistoryLine("text")
		self.EditBox.temptxt = data
		self.EditBox:SetText(data)
		self.EditBox:HighlightText()
		self.EditBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.EditBox:Width(self.EditBox.width or 50)
		self.EditBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

local qqGroupNumbers = tconcat({
	format("%s (%d): %s (%s)", L["QQ Group"], 1, "336069019", C.StringByTemplate(L["Almost full"], "rose-500")),
	format("%s (%d): %s (%s)", L["QQ Group"], 2, "948518444", C.StringByTemplate(L["Almost full"], "rose-500")),
	format("%s (%d): %s (%s)", L["QQ Group"], 3, "687772809", C.StringByTemplate(L["Recommended"], "green-500")),
}, "\n")

local qqGroupDescription = tconcat({
	L["This the QQ group for Wind Addons users."],
	C.StringByTemplate(L["!! No talking about specific UI sets !!"], "rose-500"),
	format(L["Click [%s] to show the QQ groups."], C.StringByTemplate(L["I got it!"], "green-500")),
}, "\n")

E.PopupDialogs.WINDTOOLS_QQ_GROUP_DIALOG = {
	text = qqGroupDescription,
	button1 = L["I got it!"],
	button2 = _G.CANCEL,
	OnAccept = function(self)
		self:Hide()
		E:StaticPopup_Show("WINDTOOLS_QQ_GROUP_NUMBER_DIALOG")
	end,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

E.PopupDialogs.WINDTOOLS_QQ_GROUP_NUMBER_DIALOG = {
	text = qqGroupNumbers,
	button1 = _G.OKAY,
	OnAccept = E.noop,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}
