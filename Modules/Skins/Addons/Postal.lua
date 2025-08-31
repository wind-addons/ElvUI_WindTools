local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local CT = W:GetModule("Contacts")

local _G = _G
local floor = floor
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local tinsert = tinsert
local unpack = unpack

local function reskinArrowButton(button)
	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local highlightTexture = button:GetHighlightTexture()

	highlightTexture:SetTexture(nil)

	normalTexture:SetTexture(E.Media.Textures.ArrowUp)
	normalTexture:SetRotation(E.Skins.ArrowRotation.down)
	normalTexture:SetInside(button, 2, 2)
	normalTexture:SetVertexColor(1, 1, 1)

	pushedTexture:SetTexture(E.Media.Textures.ArrowUp)
	pushedTexture:SetRotation(E.Skins.ArrowRotation.down)
	pushedTexture:SetInside(button, 2, 2)
	pushedTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
end

local function reskinQuickAttachButton(button)
	button:SetTemplate("Transparent")
	button:GetNormalTexture():SetTexture(nil)
	button:GetPushedTexture():SetTexture(nil)
	button:GetHighlightTexture():SetTexture(nil)
	button.Border:Kill()
	button:StyleButton(false, false)
	button.icon:SetTexCoord(unpack(E.TexCoords))
end

local function postalMain()
	if not _G.Postal_ModuleMenuButton then
		return false
	end

	if not _G.Postal_ModuleMenuButton.__windSkin then
		_G.Postal_ModuleMenuButton:StripTextures()

		reskinArrowButton(_G.Postal_ModuleMenuButton)

		_G.Postal_ModuleMenuButton:SetSize(20, 20)
		_G.Postal_ModuleMenuButton:ClearAllPoints()
		_G.Postal_ModuleMenuButton:SetPoint("TOPRIGHT", _G.MailFrame, "TOPRIGHT", -22, -1)

		_G.Postal_ModuleMenuButton.__windSkin = true
	end

	return true
end

local function postalSelect()
	if not _G.PostalSelectOpenButton or not _G.PostalSelectReturnButton then
		return false
	end

	S:Proxy("HandleButton", _G.PostalSelectOpenButton)
	S:Proxy("HandleButton", _G.PostalSelectReturnButton)

	for i = 1, 7 do
		local checkBox = _G["PostalInboxCB" .. i]
		S:Proxy("HandleCheckBox", checkBox)
	end

	return true
end

local function postalOpenAll()
	if not _G.PostalOpenAllButton or not _G.Postal_OpenAllMenuButton then
		return false
	end

	S:Proxy("HandleButton", _G.PostalOpenAllButton)
	if not _G.Postal_OpenAllMenuButton.__windSkin then
		S:Proxy("HandleButton", _G.Postal_OpenAllMenuButton)
		reskinArrowButton(_G.Postal_OpenAllMenuButton)
		local height = _G.PostalOpenAllButton:GetHeight()
		_G.Postal_OpenAllMenuButton:SetSize(height, height)

		_G.Postal_OpenAllMenuButton:ClearAllPoints()
		_G.Postal_OpenAllMenuButton:SetPoint("LEFT", _G.PostalOpenAllButton, "RIGHT", 2, 0)
		_G.Postal_OpenAllMenuButton.__windSkin = true
	end

	return true
end

local function postalBlackBook()
	if not _G.Postal_BlackBookButton then
		return false
	end
	if not _G.Postal_BlackBookButton.__windSkin then
		S:Proxy("HandleButton", _G.Postal_BlackBookButton)

		reskinArrowButton(_G.Postal_BlackBookButton)
		_G.Postal_BlackBookButton:SetSize(18, 18)
		_G.Postal_BlackBookButton:ClearAllPoints()
		_G.Postal_BlackBookButton:SetPoint("LEFT", _G.SendMailNameEditBox, "RIGHT", 2, 0)
		_G.Postal_BlackBookButton.__windSkin = true
	end

	return true
end

local function postalQuickAttach()
	local cachedButtons = {}
	for i = 1, 13 do
		local button = _G["Postal_QuickAttachButton" .. i]
		if not button then
			return false
		end
		tinsert(cachedButtons, button)
	end

	local mailFrameHeight = _G.MailFrame:GetHeight()
	local height = (mailFrameHeight - 2 * 12) / 13

	for i, button in ipairs(cachedButtons) do
		if not button.__windSkin then
			button:SetScale(1)
			reskinQuickAttachButton(button)
			S:CreateShadow(button)
			button:SetSize(height, height)
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", _G.MailFrame, "TOPRIGHT", 2, floor(-(i - 1) * (height + 2)))
			button.__windSkin = true
		end
	end

	CT:RepositionWithPostal()

	return true
end

local function postalForward()
	if not _G.OpenMailForwardButton then
		return false
	end

	S:Proxy("HandleButton", _G.OpenMailForwardButton)
	return true
end

function S:Postal()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.postal then
		return
	end

	self:DisableAddOnSkin("Postal")

	local Postal = _G.LibStub("AceAddon-3.0"):GetAddon("Postal")
	local Select = Postal:GetModule("Select")
	local OpenAll = Postal:GetModule("OpenAll")
	local BlackBook = Postal:GetModule("BlackBook")
	local QuickAttach = Postal:GetModule("QuickAttach")
	local Forward = Postal:GetModule("Forward")

	if not Postal or not Select or not OpenAll or not BlackBook or not QuickAttach then
		return
	end

	if not postalMain() and Postal.OnInitialize then
		hooksecurefunc(Postal, "OnInitialize", postalMain)
	end

	if not postalSelect() and Select.OnEnable then
		hooksecurefunc(Select, "OnEnable", postalSelect)
	end

	if not postalOpenAll() and OpenAll.OnEnable then
		hooksecurefunc(OpenAll, "OnEnable", postalOpenAll)
	end

	if not postalBlackBook() and BlackBook.OnEnable then
		hooksecurefunc(BlackBook, "OnEnable", postalBlackBook)
	end

	if not postalQuickAttach() and QuickAttach.OnEnable then
		hooksecurefunc(QuickAttach, "OnEnable", postalQuickAttach)
	end

	if not postalForward() and Forward.OnEnable then
		hooksecurefunc(Forward, "OnEnable", postalForward)
	end
end

S:AddCallbackForAddon("Postal")
