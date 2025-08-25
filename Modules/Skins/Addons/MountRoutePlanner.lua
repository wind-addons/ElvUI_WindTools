local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local abs = abs
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

local TEX_PREFIX = "Interface\\AddOns\\MountRoutePlanner\\Assets\\"

local function trySkin(func)
	return function(button)
		if button.__wind then
			return
		end

		if func(button) ~= false then
			button.__wind = true
		end
	end
end
local function reskinTextButton(button)
	if not button.Text then
		return false
	end

	S:Proxy("HandleButton", button)

	if W.ChineseLocale then
		button:SetWidth(80)
	end
end

local function reskinIconButton(button, icon, size)
	button:StripTextures()
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:Size(size, size)
	button.Icon:Point("CENTER")

	button:HookScript("OnEnter", function(self)
		self.Icon:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
	end)
	button:HookScript("OnLeave", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
	end)
end

local function closeButton(button)
	if not S:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Close.tga") then
		return false
	end

	S:Proxy("HandleCloseButton", button)
end

local function settingButton(button)
	if not S:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Settings.tga") then
		return false
	end

	reskinIconButton(button, W.Media.Icons.buttonSetting, 14)
end

local function resetButton(button)
	if not S:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Reset.tga") then
		return false
	end

	reskinIconButton(button, W.Media.Icons.buttonGoStart, 18)
end

local function discordButton(button)
	if not S:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Discord.tga") then
		return false
	end

	reskinIconButton(button, W.Media.Icons.buttonDiscord, 15)
end

local function mountButton(button)
	local width, height = button:GetSize()
	if not width or not height or abs(width - 32) > 0.01 or abs(height - 32) > 0.01 then
		return false
	end

	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	button:CreateBackdrop()
end

local function actionButton(button)
	local width, height = button:GetSize()
	if not width or not height or abs(width - 40) > 0.01 or abs(height - 40) > 0.01 then
		return false
	end

	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	button:SetTemplate()
end

function S:MountRoutePlanner()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.mountRoutePlanner then
		return
	end

	local frame = _G.MRPFrame
	if not frame then
		return
	end

	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	frame.progressBar:SetTexture(E.media.normTex)
	frame.progressBar:SetVertexColor(W.Utilities.Color.RGBFromTemplate("success"))
	frame.progressBarBG:Kill()
	frame.progressBar:CreateBackdrop()
	frame.progressBar.backdrop:SetOutside(frame.progressBarBG)

	for _, region in pairs({ frame:GetRegions() }) do
		if region.GetObjectType and region:GetObjectType() == "FontString" then
			F.SetFontOutline(region)
		end
	end

	for _, child in pairs({ frame:GetChildren() }) do
		local objectType = child.GetObjectType and child:GetObjectType()
		if objectType == "Button" then
			trySkin(discordButton)(child)
			trySkin(resetButton)(child)
			trySkin(settingButton)(child)
			trySkin(closeButton)(child)
			trySkin(reskinTextButton)(child)
			trySkin(actionButton)(child)
		elseif objectType == "CheckButton" then
			self:Proxy("HandleCheckBox", child)
			child:Size(24, 24)
		end
	end

	local waitForUpdate = false

	hooksecurefunc(frame.stepText, "SetText", function()
		if frame.rewardIcons then
			for _, button in pairs(frame.rewardIcons) do
				trySkin(mountButton)(button)
			end
		end
	end)
end

S:AddCallbackForAddon("MountRoutePlanner")
