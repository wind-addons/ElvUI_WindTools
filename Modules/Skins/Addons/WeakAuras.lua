local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local format = format
local unpack = unpack

local WeakAuras = _G.WeakAuras

---Create backdrop and shadow for a frame with common settings
---@param frame Frame The frame to apply backdrop and shadow to
local function CreateBackdropAndShadow(frame)
	if not frame or frame.__windBackdrop then
		return
	end

	frame.customBackdropAlpha = 0
	frame:CreateBackdrop("Transparent")

	if E.private.WT.skins.weakAurasShadow then
		S:CreateBackdropShadow(frame, true)
	end

	frame.__windBackdrop = true
end

---Handle complex texture coordinate calculations for icons
---@param icon Texture The icon texture to handle
local function HandleComplexTexCoords(icon)
	if not icon then
		return
	end

	F.InternalizeMethod(icon, "SetTexCoord")
	icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		local cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
		if URx and URy and LRx and LRy then
			cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
		end

		local left, right, top, down = unpack(E.TexCoords)
		if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
			local width, height = cRight - cLeft, cDown - cTop
			if width == height then
				F.CallMethod(self, "SetTexCoord", left, right, top, down)
			elseif width > height then
				F.CallMethod(
					self,
					"SetTexCoord",
					left,
					right,
					top + cTop * (right - left),
					top + cDown * (right - left)
				)
			else
				F.CallMethod(self, "SetTexCoord", left + cLeft * (down - top), left + cRight * (down - top), top, down)
			end
		else
			F.CallMethod(self, "SetTexCoord", cLeft, cRight, cTop, cDown)
		end
	end

	icon:SetTexCoord(icon:GetTexCoord())
end

---Sync backdrop alpha with icon alpha
---@param frame Frame The frame containing the backdrop
---@param icon Texture The icon to sync with
local function SyncBackdropAlpha(frame, icon)
	if not frame.backdrop or not icon then
		return
	end

	frame.backdrop.icon = icon
	frame.backdrop:HookScript("OnUpdate", function(self)
		local alpha = self.icon:GetAlpha()
		self:SetAlpha(alpha)
		if self.shadow then
			self.shadow:SetAlpha(alpha)
		end
	end)
end

---Skin an icon region
---@param frame Frame The icon frame to skin
local function SkinIconRegion(frame)
	if frame.icon then
		HandleComplexTexCoords(frame.icon)
		SyncBackdropAlpha(frame, frame.icon)
	end
end

---Skin an aurabar region
---@param frame Frame The aurabar frame to skin
local function SkinAurabarRegion(frame)
	if frame.icon then
		F.InternalizeMethod(frame.icon, "SetTexCoord", true)
		F.CallMethod(frame.icon, "SetTexCoord", unpack(E.TexCoords))
	end

	if frame.iconFrame then
		frame.iconFrame:SetAllPoints(frame.icon)
		frame.iconFrame:CreateBackdrop()

		-- Sync icon frame backdrop visibility with icon
		hooksecurefunc(frame.icon, "Hide", function()
			frame.iconFrame.backdrop:SetShown(false)
		end)

		hooksecurefunc(frame.icon, "Show", function()
			frame.iconFrame.backdrop:SetShown(true)
		end)
	end
end

---Main function to skin WeakAuras regions
---@param frame Frame The frame to skin
---@param regionType string The type of region ("icon", "aurabar", etc.)
local function SkinWeakAuras(frame, regionType)
	if not frame or frame.__windSkin then
		return
	end

	if regionType == "icon" then
		CreateBackdropAndShadow(frame)
		SkinIconRegion(frame)
	elseif regionType == "aurabar" then
		CreateBackdropAndShadow(frame)
		SkinAurabarRegion(frame)
	end

	frame.__windSkin = true
end

function S:WeakAuras()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
		return
	end

	if not WeakAuras or not WeakAuras.Private then
		local alertMessage = format(
			"%s %s %s",
			L["You are using Official WeakAuras, the skin of WeakAuras will not be loaded due to the limitation."],
			L["If you want to use WeakAuras skin, please install |cffff0000WeakAurasPatched|r (https://wow-ui.net/wap)."],
			L["You can disable this alert via disabling WeakAuras Skin in Skins - Addons."]
		)
		E:Delay(10, F.Print, alertMessage)
		return
	end

	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				SkinWeakAuras(region, region.regionType)
			end
		end)
	end
end

S:AddCallbackForAddon("WeakAuras")
