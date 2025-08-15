local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local format = format
local pairs = pairs
local print = print
local unpack = unpack

local WeakAuras = _G.WeakAuras

function S:WeakAuras_PrintProfile()
	local frame = _G.WADebugEditBox.Background

	if frame and not frame.__windSkin then
		self:Proxy("HandleScrollBar", _G.WADebugEditBoxScrollFrameScrollBar)

		frame:StripTextures()
		frame:SetTemplate("Transparent")
		self:CreateShadow(frame)

		for _, child in pairs({ frame:GetChildren() }) do
			if child:GetNumRegions() == 3 then
				child:StripTextures()
				local subChild = child:GetChildren()
				subChild:ClearAllPoints()
				subChild:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
				self:Proxy("HandleCloseButton", subChild)
			end
		end

		frame.__windSkin = true
	end
end

function S:ProfilingWindow_UpdateButtons(frame)
	-- 下方 4 个按钮
	for _, button in pairs({ frame.statsFrame:GetChildren() }) do
		self:Proxy("HandleButton", button)
	end

	-- 顶部 2 个按钮
	for _, button in pairs({ frame.titleFrame:GetChildren() }) do
		if not button.__windSkin and button.GetNormalTexture then
			local normalTextureID = button:GetNormalTexture():GetTexture()
			if normalTextureID == 252125 then
				button:StripTextures()
				button.SetNormalTexture = E.noop
				button.SetPushedTexture = E.noop
				button.SetHighlightTexture = E.noop

				button.Texture = button:CreateTexture(nil, "OVERLAY")
				button.Texture:SetPoint("CENTER")
				button.Texture:SetTexture(E.Media.Textures.ArrowUp)
				button.Texture:SetSize(14, 14)

				button:HookScript("OnEnter", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					end
				end)

				button:HookScript("OnLeave", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(1, 1, 1)
					end
				end)

				button:HookScript("OnClick", function(self)
					self.Texture:Show("")
					if self:GetParent():GetParent().minimized then
						button.Texture:SetRotation(ES.ArrowRotation["down"])
					else
						button.Texture:SetRotation(ES.ArrowRotation["up"])
					end
				end)

				button:SetHitRectInsets(6, 6, 7, 7)
				button:SetPoint("TOPRIGHT", frame.titleFrame, "TOPRIGHT", -19, 3)
			else
				self:Proxy("HandleCloseButton", button)
				button:ClearAllPoints()
				button:SetPoint("TOPRIGHT", frame.titleFrame, "TOPRIGHT", 3, 1)
			end

			button.__windSkin = true
		end
	end
end

local function Skin_WeakAuras(f, fType)
	if fType == "icon" then
		if not f.__windSkin then
			f.icon.SetTexCoordOld = f.icon.SetTexCoord
			f.icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
				local cLeft, cRight, cTop, cDown
				if URx and URy and LRx and LRy then
					cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
				else
					cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
				end

				local left, right, top, down = unpack(E.TexCoords)
				if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
					local width, height = cRight - cLeft, cDown - cTop
					if width == height then
						self:SetTexCoordOld(left, right, top, down)
					elseif width > height then
						self:SetTexCoordOld(left, right, top + cTop * (right - left), top + cDown * (right - left))
					else
						self:SetTexCoordOld(left + cLeft * (down - top), left + cRight * (down - top), top, down)
					end
				else
					self:SetTexCoordOld(cLeft, cRight, cTop, cDown)
				end
			end
			f.icon:SetTexCoord(f.icon:GetTexCoord())
			f:CreateBackdrop()
			if E.private.WT.skins.weakAurasShadow then
				S:CreateBackdropShadow(f, true)
			end
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			hooksecurefunc(f, "SetFrameStrata", function()
				f.backdrop:SetFrameLevel(0)
			end)
			f.backdrop.icon = f.icon
			f.backdrop:HookScript("OnUpdate", function(self)
				self:SetAlpha(self.icon:GetAlpha())
				if self.shadow then
					self.shadow:SetAlpha(self.icon:GetAlpha())
				end
			end)

			f.__windSkin = true
		end
	elseif fType == "aurabar" then
		if not f.__windSkin then
			f:CreateBackdrop()
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			hooksecurefunc(f, "SetFrameStrata", function()
				f.backdrop:SetFrameLevel(0)
			end)
			if E.private.WT.skins.weakAurasShadow then
				S:CreateBackdropShadow(f, true)
			end
			f.icon:SetTexCoord(unpack(E.TexCoords))
			f.icon.SetTexCoord = E.noop
			f.iconFrame:SetAllPoints(f.icon)
			f.iconFrame:CreateBackdrop()
			hooksecurefunc(f.icon, "Hide", function()
				f.iconFrame.backdrop:SetShown(false)
			end)

			hooksecurefunc(f.icon, "Show", function()
				f.iconFrame.backdrop:SetShown(true)
			end)

			f.__windSkin = true
		end
	end
end

function S:WeakAuras()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
		return
	end

	-- Only works for WeakAurasPatched
	if not WeakAuras or not WeakAuras.Private then
		local alertMessage = format(
			"%s: %s %s %s",
			W.Title,
			L["You are using Official WeakAuras, the skin of WeakAuras will not be loaded due to the limitation."],
			L["If you want to use WeakAuras skin, please install |cffff0000WeakAurasPatched|r (https://wow-ui.net/wap)."],
			L["You can disable this alert via disabling WeakAuras Skin in Skins - Addons."]
		)
		E:Delay(10, print, alertMessage)
		return
	end

	-- Handle the options region type registration
	if WeakAuras.Private.RegisterRegionOptions then
		self:RawHook(WeakAuras.Private, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
	end

	-- from 雨夜独行客@NGA
	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				Skin_WeakAuras(region, region.regionType)
			end
		end)
	end

	-- Real Time Profiling Window
	local profilingWindow = WeakAuras.RealTimeProfilingWindow
	if profilingWindow then
		self:CreateShadow(profilingWindow)
		if profilingWindow.UpdateButtons then
			self:SecureHook(profilingWindow, "UpdateButtons", "ProfilingWindow_UpdateButtons")
		end
		if WeakAuras.PrintProfile then
			self:SecureHook(WeakAuras, "PrintProfile", "WeakAuras_PrintProfile")
		end
	end
end

S:AddCallbackForAddon("WeakAuras")
