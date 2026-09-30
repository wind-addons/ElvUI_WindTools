local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G

local pairs = pairs
local unpack = unpack

local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor

local data = S:AddCallbackForAddon("TomCats", nil, S:CreateAddonCheck("tomCats"))

local atlasToQuality = {
	["auctionhouse-itemicon-border-gray"] = 0,
	["auctionhouse-itemicon-border-white"] = 1,
	["auctionhouse-itemicon-border-green"] = 2,
	["auctionhouse-itemicon-border-blue"] = 3,
	["auctionhouse-itemicon-border-purple"] = 4,
	["auctionhouse-itemicon-border-orange"] = 5,
	["auctionhouse-itemicon-border-artifact"] = 6,
	["auctionhouse-itemicon-border-account"] = 8,
}

function data:HandleTomCatsIcon(icon)
	if not icon or not icon:IsShown() then
		return
	end

	if not icon.__windSkin then
		local maskNum = icon.Icon:GetNumMaskTextures()
		for i = 1, maskNum do
			icon.Icon:RemoveMaskTexture(icon.Icon:GetMaskTexture(i))
		end

		S:Proxy("HandleIcon", icon.Icon, true)
		icon.IconBorder:SetAlpha(0)
		icon.__windSkin = true
	end

	local atlas = icon.IconBorder:IsShown() and icon.IconBorder:GetAtlas()
	local quality = atlas and atlasToQuality[atlas]

	if quality then
		local r, g, b = C_Item_GetItemQualityColor(quality)
		icon.Icon.backdrop:SetBackdropBorderColor(r, g, b)
	else
		icon.Icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	if icon.CategoryIcon then
		icon.CategoryIcon:SetFrameLevel(icon:GetFrameLevel() + 2)
		data:HandleTomCatsIcon(icon.CategoryIcon)
	end
end

function data:SkinTooltipItems() -- self is TomCatsVignetteTooltip, not data
	local tt = self
	for _, item in pairs(tt.Loot) do
		data:HandleTomCatsIcon(item)
	end
end

function data:HeaderCollapseButton_SetNormalAtlas(atlas) -- self is the vignettes section header button, not data
	local button = self
	if atlas == "Campaign_HeaderIcon_Closed" then
		return button:SetNormalTexture(E.Media.Textures.PlusButton)
	elseif atlas == "Campaign_HeaderIcon_Open" then
		return button:SetNormalTexture(E.Media.Textures.MinusButton)
	end

	S.hooks[button].SetNormalAtlas(button, atlas)
end

function data:HeaderCollapseButton_SetPushedAtlas(atlas) -- self is the vignettes section header button, not data
	local button = self
	if atlas == "Campaign_HeaderIcon_ClosedPressed" then
		return button:SetPushedTexture(E.Media.Textures.PlusButton)
	elseif atlas == "Campaign_HeaderIcon_OpenPressed" then
		return button:SetPushedTexture(E.Media.Textures.MinusButton)
	end

	S.hooks[button].SetPushedAtlas(button, atlas)
end

function S:TomCats()
	TT:SetStyle(_G.TomCatsVignetteTooltip)
	self:SecureHook(_G.TomCatsVignetteTooltip, "SetOwner", data.SkinTooltipItems)
	if _G.TomCatsVignettesSection and _G.TomCatsVignettesSection.Header then
		local header = _G.TomCatsVignettesSection.Header
		self:RawHook(header, "SetNormalAtlas", data.HeaderCollapseButton_SetNormalAtlas, true)
		self:RawHook(header, "SetPushedAtlas", data.HeaderCollapseButton_SetPushedAtlas, true)
		header:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		F.InternalizeMethod(header, "SetHighlightTexture", true)
		header:Size(16)
		header.topPadding = 16
		F.SetFont(header.text)
	end

	E:Delay(1, function()
		for _, frame in pairs({ _G.UIParent:GetChildren() }) do
			if frame and frame.title and frame.icon and frame.headerBar and frame.footerBar then
				if frame.icon.Background then
					frame.icon.Background:SetAlpha(0)
				end

				if frame.icon.Border then
					frame.icon.Border:SetAlpha(0)
				end

				if frame.icon.logo then
					frame.icon.logo:ClearAllPoints()
					frame.icon.logo:Point("CENTER", frame, "BOTTOM", 5, -3)
				end

				frame.headerBar:SetAlpha(0)
				frame.footerBar:SetAlpha(0)
				F.SetFont(frame.title)

				frame:SetTemplate("Transparent")
				self:CreateShadow(frame)
			end
		end
	end)
end
