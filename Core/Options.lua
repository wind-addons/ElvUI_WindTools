local W, F, E, L, V, P, G = unpack((select(2, ...)))
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

local function green(str)
	return "|cff00d1b2" .. str .. "|r"
end

local function red(str)
	return "|cffff3860" .. str .. "|r"
end

local function grey(str)
	return "|cffbbbbbb" .. str .. "|r"
end

local qqGroupNumbers = tconcat({
	format("%s (%d): %s (%s)", L["QQ Group"], 1, "336069019", grey(L["Almost full"])),
	format("%s (%d): %s (%s)", L["QQ Group"], 2, "948518444", grey(L["Almost full"])),
	format("%s (%d): %s (%s)", L["QQ Group"], 3, "687772809", green(L["Recommended"])),
}, "\n")

local qqGroupDescription = tconcat({
	L["This the QQ group for Wind Addons users."],
	red(L["!! No talking about specific UI sets !!"]),
	"",
	L["Click [%s] to show the QQ groups."]:format(green(L["I got it!"])),
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
