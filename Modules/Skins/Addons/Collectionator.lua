local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local hooksecurefunc = hooksecurefunc

local function reskinWarningDialog(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	if frame.editBox then
		S:Proxy("HandleEditBox", frame.editBox)
		frame.editBox:SetTextInsets(0, 0, 0, 0)
	end

	for _, buttonName in pairs({ "ContinueButton" }) do
		local button = frame[buttonName]
		if button and button:IsObjectType("Button") then
			S:Proxy("HandleButton", button)
		end
	end
end

local function reskinView(frame)
	if frame.ResultsListingInset then
		frame.ResultsListingInset:Kill()
	end

	if frame.BuyCheapest then
		S:Proxy("HandleButton", frame.BuyCheapest.SkipButton)
		S:Proxy("HandleButton", frame.BuyCheapest.BuyButton)
		F.Move(frame.BuyCheapest.BuyButton, -4, 0)
	end

	if frame.TextFilter then
		S:Proxy("HandleEditBox", frame.TextFilter)
	end

	if frame.RefreshButton then
		S:Proxy("HandleButton", frame.RefreshButton)
	end

	local function reskinResetButton(f, anchor, x, y)
		S:Proxy("HandleButton", f)
		f:Size(20, 20)
		f:ClearAllPoints()
		f:SetPoint("LEFT", anchor, "RIGHT", x, y)
	end

	for _, filter in pairs({
		frame.ArmorFilter,
		frame.WeaponFilter,
		frame.QualityFilter,
		frame.SlotFilter,
		frame.TypeFilter,
		frame.ProfessionFilter,
	}) do
		if filter then
			S:Proxy("HandleButton", filter, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
			filter.Icon:Kill()
			reskinResetButton(filter.ResetButton, filter, 2, 0)
		end
	end
end

local function replicateTabFrame(frame)
	frame.windskin = true

	reskinWarningDialog(frame.WarningDialog)

	for _, view in pairs({ frame.TMogView, frame.PetView, frame.ToyView, frame.MountView, frame.RecipeView }) do
		if view then
			reskinView(view)
		end
	end

	for _, button in pairs({
		frame.MountButton,
		frame.PetButton,
		frame.RecipeButton,
		frame.TMogButton,
		frame.ToyButton,
	}) do
		if button and button:IsObjectType("Button") then
			S:Proxy("HandleButton", button)
			F.Move(button, 4, 0)
		end
	end

	for _, button in pairs({
		frame.FullScanButton,
		frame.OptionsButton,
	}) do
		if button and button:IsObjectType("Button") then
			S:Proxy("HandleButton", button)
			F.Move(button, -4, 0)
		end
	end
end

local function reskinOption(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child and child:IsObjectType("Button") then
			S:Proxy("HandleButton", child)
		elseif child and child.CheckBox then
			S:Proxy("HandleCheckBox", child.CheckBox)
			child.CheckBox:Size(24)
		end
	end
end

function S:Collectionator()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.collectionator then
		return
	end

	local LibAHTab = _G.LibStub("LibAHTab-1-0", true)
	if not LibAHTab then
		return
	end

	hooksecurefunc(LibAHTab, "CreateTab", function(self, _, ref, label)
		if label ~= _G.COLLECTIONATOR_L_TAB_REPLICATE and label ~= _G.COLLECTIONATOR_L_TAB_SUMMARY then
			return
		end

		replicateTabFrame(ref)
	end)

	reskinOption(_G.CollectionatorConfigBasicOptionsFrame)
end

S:AddCallbackForAddon("Collectionator")
