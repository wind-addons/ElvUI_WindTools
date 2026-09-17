local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local DT = W:NewModule("DestroyTotem", "AceEvent-3.0")

local format = format

local CreateFrame = CreateFrame
local SetOverrideBindingClick = SetOverrideBindingClick

local MAX_TOTEMS = MAX_TOTEMS

DT.Buttons = {}

---Create a invisible button for destroying totems.
---@param slot number
---@return Button
local function CreateTotemButton(slot)
	local name = "WTDestroyTotemButton" .. slot

	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate")
	button:SetSize(1, 1)
	button:Hide()
	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")
	button:SetAttribute("type", "destroytotem")
	button:SetAttribute("totem-slot", slot)

	return button
end

function DT:SetupKeyBindings()
	for slot = 1, MAX_TOTEMS do
		local key = self.db.keys and self.db.keys[slot]
		if key and key ~= "" and key ~= "NONE" then
			SetOverrideBindingClick(DT.Buttons[slot], true, key, DT.Buttons[slot]:GetName())
		end
	end
end

---Get the macro text for destroying totems.
---@param slot number The totem slot (1 to MAX_TOTEMS)
---@return string? The macro text for the specified totem slot
function DT:GetMacroText(slot)
	local button = DT.Buttons[slot]
	if button then
		return format("/click %s LeftButton 1", button:GetName())
	end
end

function DT:Initialize()
	self.db = E.private.WT.combat.destroyTotem
	if not self.db or not self.db.enable then
		return
	end

	for slot = 1, MAX_TOTEMS do
		DT.Buttons[slot] = CreateTotemButton(slot)
	end

	F.TaskManager:OutOfCombat(self.SetupKeyBindings, self)
end

W:RegisterModule(DT:GetName())
