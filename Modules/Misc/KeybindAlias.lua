local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table, PrivateDB, ProfileDB, GlobalDB
local M = W.Modules.Misc ---@class Misc
local AB = E.ActionBars

local pairs = pairs

local setHistory = {}

local function updateHistoty(button, before, after)
	if not button then
		return
	end

	if after and before ~= after then
		if not setHistory[button] then
			setHistory[button] = {}
		end

		setHistory[button].before = before
		setHistory[button].after = after
	else
		setHistory[button] = nil
	end
end

local function getBeforeText(button, currentText)
	if setHistory[button] then
		if setHistory[button].before == currentText or setHistory[button].after == currentText then
			return setHistory[button].before
		end
	end
	return currentText
end

function M:ElvUI_AB_FixKeybindText(_, button)
	local currentText = button.HotKey:GetText()
	local before = getBeforeText(button, currentText)
	local after

	if E.db.WT and E.db.WT.misc.keybindAlias.enable then
		if E.db.WT.misc.keybindAlias.list and E.db.WT.misc.keybindAlias.list[before] then
			after = E.db.WT.misc.keybindAlias.list[before]
			button.HotKey:SetText(after)
		end
	end

	if not after then
		button.HotKey:SetText(before)
		self.hooks[AB].FixKeybindText(nil, button)
		after = button.HotKey:GetText()
	end

	updateHistoty(button, before, after)
end

function M:UpdateAllKeybindText()
	for button in pairs(setHistory) do
		self:ElvUI_AB_FixKeybindText(nil, button)
	end
end

M:RawHook(AB, "FixKeybindText", "ElvUI_AB_FixKeybindText")
M:AddCallback("UpdateAllKeybindText")
M:AddCallbackForUpdate("UpdateAllKeybindText")
