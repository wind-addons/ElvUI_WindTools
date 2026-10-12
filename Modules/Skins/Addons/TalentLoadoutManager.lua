local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local pairs = pairs

S:AddCallbackForAddon("TalentLoadoutManager", nil, S:CreateAddonCheck("talentLoadoutManager"))

---@param sideBar TLM_SideBar
local function SkinSideBarFrame(sideBar)
	if not sideBar or sideBar.__windSkin then
		return
	end

	if sideBar.Background then
		sideBar.Background:SetAlpha(0)
	end

	sideBar:SetTemplate("Transparent")
	S:CreateShadow(sideBar)

	if sideBar.Title then
		F.SetFont(sideBar.Title, E.db.general.font, E.db.general.fontSize)
	end

	if sideBar.Warning then
		F.SetFont(sideBar.Warning, E.db.general.font, E.db.general.fontSize)
	end

	for _, button in pairs({ sideBar.CreateButton, sideBar.ImportButton, sideBar.SaveButton, sideBar.ConfigButton }) do
		if button then
			S:Proxy("HandleButton", button)
		end
	end

	if sideBar.ScrollBoxContainer and sideBar.ScrollBoxContainer.ScrollBar then
		S:Proxy("HandleTrimScrollBar", sideBar.ScrollBoxContainer.ScrollBar)
	end

	sideBar.__windSkin = true
end

---Same condition as SideBarMixin:SetCollapsed, using SideBarMixin.Enum.AnchorLocation.
---@param module TLM_SideBarMixin
---@return boolean pointingRight
local function IsToggleArrowPointingRight(module)
	local anchor = module:GetAnchorLocation()
	local collapsed = module:GetCollapsed()
	local Anchor = module.Enum.AnchorLocation
	return (not collapsed and (anchor == Anchor.LeftOuter or anchor == Anchor.RightInner))
		or (collapsed and (anchor == Anchor.RightOuter or anchor == Anchor.LeftInner))
end

---@param module TLM_SideBarMixin
local function UpdateToggleArrow(module)
	local button = module.SideBar and module.SideBar.ToggleSideBarButton
	if not button or not button.windArrow then
		return
	end

	local rotation = IsToggleArrowPointingRight(module) and ES.ArrowRotation.right or ES.ArrowRotation.left
	button.windArrow:SetRotation(rotation)
end

---@param module TLM_SideBarMixin
local function SkinToggleButton(module)
	local button = module.SideBar and module.SideBar.ToggleSideBarButton
	if not button or button.__windSkin then
		return
	end

	S:Proxy("HandleButton", button)

	button.windArrow = button:CreateTexture(nil, "OVERLAY")
	button.windArrow:SetTexture(E.Media.Textures.ArrowUp)
	button.windArrow:Point("CENTER")
	button.windArrow:Size(14)

	UpdateToggleArrow(module)

	button.__windSkin = true
end

---@param frame TLM_ElementFrame
local function SkinListRow(frame)
	if not frame or frame.__windSkin then
		return
	end

	if frame.Text then
		F.SetFont(frame.Text, E.db.general.font, E.db.general.fontSize)
	end

	frame.__windSkin = true
end

---@param dialog TLM_SideBar
local function SkinImportDialog(dialog)
	if not dialog or dialog.__windSkin then
		return
	end

	dialog:StripTextures()
	dialog:CreateBackdrop("Transparent")
	S:CreateShadow(dialog)

	if dialog.AcceptButton then
		S:Proxy("HandleButton", dialog.AcceptButton)
	end
	if dialog.CancelButton then
		S:Proxy("HandleButton", dialog.CancelButton)
	end

	local importControl = dialog.ImportControl
	if importControl and importControl.InputContainer then
		importControl.InputContainer:StripTextures()
		importControl.InputContainer:CreateBackdrop("Transparent")
	end

	local nameControl = dialog.NameControl
	if nameControl and nameControl.EditBox then
		S:Proxy("HandleEditBox", nameControl.EditBox)
	end

	if dialog.AutoApplyCheckbox then
		S:Proxy("HandleCheckBox", dialog.AutoApplyCheckbox)
	end
	if dialog.ImportIntoCurrentLoadoutCheckbox then
		S:Proxy("HandleCheckBox", dialog.ImportIntoCurrentLoadoutCheckbox)
	end

	dialog.__windSkin = true
end

---@param module TLM_SideBarMixin
local function SkinSideBarModule(module)
	if not module or not module.SideBar then
		return
	end

	SkinSideBarFrame(module.SideBar)
	SkinToggleButton(module)
	SkinImportDialog(module.importDialog)

	local scrollBox = module.SideBar.ScrollBoxContainer and module.SideBar.ScrollBoxContainer.ScrollBox
	if scrollBox then
		for _, frame in scrollBox:EnumerateFrames() do
			SkinListRow(frame)
		end
	end

	if module.__windSkinHooks then
		return
	end

	module.__windSkinHooks = true
	S:SecureHook(module, "SetCollapsed", UpdateToggleArrow)
	S:SecureHook(module, "OnListElementInitialized", function(_, frame)
		SkinListRow(frame)
	end)
end

function S:TalentLoadoutManager()
	local TLM = _G.TalentLoadoutManager
	if not TLM or not TLM.RegisterCallback or not TLM.Event or not TLM.Event.SideBarLoaded or not TLM.GetSideBar then
		return
	end

	-- CallbackRegistryMixin calls func(owner, ...), and SideBarLoaded's payload is sideBarName, sideBar.
	TLM:RegisterCallback(TLM.Event.SideBarLoaded, function(_, _, sideBar)
		SkinSideBarModule(sideBar)
	end, S)

	-- SideBarLoaded does not replay. sideBars is filled in OnInitialize, before the frame exists.
	if TLM.sideBars then
		for sideBarName in pairs(TLM.sideBars) do
			SkinSideBarModule(TLM:GetSideBar(sideBarName))
		end
	end
end
