local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local ipairs = ipairs
local pairs = pairs
local sort = sort

local optionCheckBoxes = {
	"alerts",
	"bags",
	"bags_unbound",
	"byComparison",
	"currentClass",
	"dressed",
	"dressed_ensemble",
	"encounterjournal",
	"loot",
	"merchant",
	"mousescroll",
	"notifyKnown",
	"setjournal",
	"spin",
	"tokens",
	"uncover",
	"zoomHeld",
	"zoomMasked",
	"zoomWorn",
}

local optionDropDowns = {
	"anchor",
	"modifier",
}

local function IterateDemoButtons(callback)
	local optionsPanel = _G.AppearanceTooltipOptionsCheckdressed and _G.AppearanceTooltipOptionsCheckdressed:GetParent()
	if not optionsPanel then
		return false
	end

	local found = false

	for _, child in pairs({ optionsPanel:GetChildren() }) do
		for _, button in pairs({ child:GetChildren() }) do
			if button:GetObjectType() == "Button" and button.GetItemID then
				found = true
				callback(button, child)
			end
		end
	end

	return found
end

local function ReskinDemoButton(button)
	if button.__windSkin then
		return
	end

	local name = button:GetName()
	local iconOverlay = button.IconOverlay
	local icon = button.icon
		or button.Icon
		or button.IconTexture
		or button.iconTexture
		or (name and (_G[name .. "IconTexture"] or _G[name .. "Icon"]))
	local iconTexture = icon and icon.GetTexture and icon:GetTexture()
	local iconOverlayAtlas = iconOverlay and iconOverlay.GetAtlas and iconOverlay:GetAtlas()
	local iconOverlayTexture = iconOverlay and iconOverlay.GetTexture and iconOverlay:GetTexture()
	local iconOverlayShown = iconOverlay and iconOverlay.IsShown and iconOverlay:IsShown()

	S:Proxy("HandleItemButton", button, true)

	if icon then
		icon:SetTexCoords()
		icon:ClearAllPoints()
		icon:Point("TOPLEFT", 1, -1)
		icon:Point("BOTTOMRIGHT", -1, 1)
		icon:SetAlpha(1)
		icon:Show()
		if iconTexture then
			icon:SetTexture(iconTexture)
		end
	end

	if button.IconBorder then
		S:Proxy("HandleIconBorder", button.IconBorder, button.backdrop)
	end

	if iconOverlay then
		if iconOverlayAtlas then
			iconOverlay:SetAtlas(iconOverlayAtlas, true)
		elseif iconOverlayTexture then
			iconOverlay:SetTexture(iconOverlayTexture)
		end
		iconOverlay:SetParent(button)
		iconOverlay:ClearAllPoints()
		if icon then
			iconOverlay:SetAllPoints(icon)
		else
			iconOverlay:SetInside(button, 1, 1)
		end
		iconOverlay:SetDrawLayer("OVERLAY", 7)
		iconOverlay:SetAlpha(1)
		if iconOverlayShown then
			iconOverlay:Show()
		else
			iconOverlay:Hide()
		end
	end

	if button.appearancetooltipoverlay then
		button.appearancetooltipoverlay:SetFrameLevel(button:GetFrameLevel() + 6)
	end

	local highlight = button:GetHighlightTexture()
	if highlight then
		highlight:SetTexture(E.media.blankTex)
		highlight:SetVertexColor(1, 1, 1, 0.2)
		highlight:SetInside(button, 1, 1)
	end

	local pushed = button:GetPushedTexture()
	if pushed then
		pushed:SetTexture(E.media.blankTex)
		pushed:SetVertexColor(0, 0, 0, 0.25)
		pushed:SetInside(button, 1, 1)
	end

	button.__windSkin = true
end

local function ReskinDemoIcons()
	local demoFrame
	local buttons = {}

	IterateDemoButtons(function(button, parent)
		demoFrame = demoFrame or parent
		buttons[#buttons + 1] = button
		ReskinDemoButton(button)
	end)

	if #buttons == 0 or not demoFrame then
		return
	end

	sort(buttons, function(a, b)
		return a:GetTop() > b:GetTop()
	end)

	for index, button in ipairs(buttons) do
		button:ClearAllPoints()
		if index == 1 then
			button:Point("TOPRIGHT", demoFrame)
		else
			button:Point("TOPRIGHT", buttons[index - 1], "BOTTOMRIGHT", 0, -2)
		end
	end
end

local function ReskinOptions()
	for _, key in pairs(optionCheckBoxes) do
		local checkBox = _G["AppearanceTooltipOptionsCheck" .. key]
		if checkBox and not checkBox.__windSkin then
			checkBox:Size(22)
			S:Proxy("HandleCheckBox", checkBox)
			checkBox.__windSkin = true
		end
	end

	for _, key in pairs(optionDropDowns) do
		local dropDown = _G["AppearanceTooltipOptions" .. key .. "Dropdown"]
		if dropDown and not dropDown.__windSkin then
			dropDown:Height(25)
			F.InternalizeMethod(dropDown, "SetHeight", true)
			S:Proxy("HandleDropDownBox", dropDown, 140)
			dropDown.__windSkin = true
		end
	end

	ReskinDemoIcons()
	F.WaitFor(function()
		return IterateDemoButtons(function() end)
	end, ReskinDemoIcons, 0.05, 5)

	local optionsPanel = _G.AppearanceTooltipOptionsCheckdressed and _G.AppearanceTooltipOptionsCheckdressed:GetParent()
	if optionsPanel and not optionsPanel.__windDemoHooked then
		optionsPanel:HookScript("OnShow", function()
			F.WaitFor(function()
				return IterateDemoButtons(function() end)
			end, ReskinDemoIcons, 0.05, 5)
		end)
		optionsPanel.__windDemoHooked = true
	end
end

function S:AppearanceTooltip()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.appearanceTooltip then
		return
	end

	local tooltip = _G.AppearanceTooltipTooltip
	if tooltip then
		TT:SetStyle(tooltip)
	end

	F.WaitFor(function()
		return _G.AppearanceTooltipOptionsCheckdressed and _G.AppearanceTooltipOptionsmodifierDropdown
	end, ReskinOptions)
end

S:AddCallbackForAddon("AppearanceTooltip")
