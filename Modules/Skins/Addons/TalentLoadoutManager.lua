local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

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

---@param button Button
local function SkinToggleButton(button)
	if not button or button.__windSkin then
		return
	end

	S:Proxy("HandleButton", button, nil, nil, nil, nil, nil, nil, true)

	local normalTexture = button:GetNormalTexture()
	local highlightTexture = button:GetHighlightTexture()
	if normalTexture then
		normalTexture:SetAlpha(0)
	end
	if highlightTexture then
		highlightTexture:SetAlpha(0)
	end

	button.windArrow = button:CreateTexture(nil, "OVERLAY")
	button.windArrow:SetTexture(E.Media.Textures.ArrowUp)
	button.windArrow:Point("CENTER")
	button.windArrow:Size(14)

	if normalTexture then
		hooksecurefunc(normalTexture, "SetTexCoord", function(_, ...)
			if F.IsAlmost({ 0.15625, 0.5, 0.84375, 0.5, 0.15625, 0, 0.84375, 0 }, { ... }) then
				button.windArrow:SetRotation(ES.ArrowRotation.right)
			elseif F.IsAlmost({ 0.15625, 0, 0.84375, 0, 0.15625, 0.5, 0.84375, 0.5 }, { ... }) then
				button.windArrow:SetRotation(ES.ArrowRotation.left)
			end
		end)
	end

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

---@param scrollBox any WowScrollBoxList
local function SkinScrollBox(scrollBox)
	if not scrollBox or scrollBox.__windSkinHooked then
		return
	end

	for _, frame in scrollBox:EnumerateFrames() do
		SkinListRow(frame)
	end

	hooksecurefunc(scrollBox, "Update", function(box)
		box:ForEachFrame(SkinListRow)
	end)

	scrollBox.__windSkinHooked = true
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
	if not module then
		return
	end

	if module.SideBar then
		SkinSideBarFrame(module.SideBar)
		SkinToggleButton(module.SideBar.ToggleSideBarButton)

		local scrollBox = module.SideBar.ScrollBoxContainer and module.SideBar.ScrollBoxContainer.ScrollBox
		SkinScrollBox(scrollBox)
	end

	if module.importDialog then
		SkinImportDialog(module.importDialog)
	end
end

function S:TalentLoadoutManager()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.talentLoadoutManager then
		return
	end

	local addon = _G.LibStub("AceAddon-3.0"):GetAddon("TalentLoadoutManager", true)
	if not addon then
		return
	end

	for _, moduleName in pairs({ "SideBar", "TTVSideBar" }) do
		local module = addon:GetModule(moduleName, true)
		if module then
			SkinSideBarModule(module)
			self:SecureHook(module, "SetupHook", SkinSideBarModule)
		end
	end
end

S:AddCallbackForAddon("TalentLoadoutManager")
