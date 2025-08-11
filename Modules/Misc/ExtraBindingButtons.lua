local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local CreateFrame = CreateFrame

local C_PartyInfo_LeaveParty = C_PartyInfo.LeaveParty

local function createInvisibleButton(name, buttonType, content)
	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate")

	if buttonType == "onclick" then
		button:SetScript("OnClick", content)
	elseif buttonType == "macro" then
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", content)
	end

	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")

	return button
end

function M:ExtraBindingButtons()
	self.ExtraBindingButtons = {}

	self.ExtraBindingButtons.Logout = createInvisibleButton("WTExtraBindingButtonLogout", "macro", "/logout")

	self.ExtraBindingButtons.LeaveParty = createInvisibleButton("WTExtraBindingButtonLeaveGroup", "onclick", function()
		C_PartyInfo_LeaveParty()
	end)
	self.ExtraBindingButtons.LeaveDelve =
		createInvisibleButton("WTExtraBindingButtonLeaveDelve", "macro", "/run C_PartyInfo.DelveTeleportOut()")
end

M:AddCallback("ExtraBindingButtons")
