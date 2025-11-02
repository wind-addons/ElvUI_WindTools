local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@type Skins
local WS = S.Widgets
local ES = E.Skins

local type = type

function WS:HandleAce3CheckBox(check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(check, "HandleAce3CheckBox")
		return
	end

	local db = E.private.WT.skins.widgets.checkBox

	if not check or not db or not db.enable then
		return
	end

	if not check.windWidgetSkinned then
		check:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		F.InternalizeMethod(check, "SetTexture", true)
		check.windWidgetSkinned = true
	end

	if self.IsUglyYellow(check:GetVertexColor()) then
		F.SetVertexColorWithDB(check, db.classColor and E.myClassColor or db.color)
	end
end

do
	ES.Ace3_CheckBoxSetDesaturated_ = ES.Ace3_CheckBoxSetDesaturated
	function ES.Ace3_CheckBoxSetDesaturated(check, value)
		ES.Ace3_CheckBoxSetDesaturated_(check, value)
		WS:HandleAce3CheckBox(check)
	end
end

function WS:CheckBoxCheckedTexture_SetTexture(tex, texPath)
	if not texPath then
		return
	end

	texPath = texPath == "" and ""
		or LSM:Fetch("statusbar", E.private.WT.skins.widgets.checkBox.texture)
		or E.media.normTex

	self.hooks[tex].SetTexture(tex, texPath)
end

function WS:CheckBoxCheckedTexture_SetVertexColor(tex, ...)
	local isDefaultColor = self.IsUglyYellow(...)
	local SetVertexColor = self.hooks[tex].SetVertexColor

	-- Let skin use its own logic to colorize the check texture
	if tex.__windColorOverride and type(tex.__windColorOverride) == "function" then
		local color = tex.__windColorOverride(...)
		if type(color) == "table" and color.r and color.g and color.b then
			return SetVertexColor(tex, color.r, color.g, color.b, color.a)
		elseif type(color) == "string" and color == "DEFAULT" then
			isDefaultColor = true
		end
	end

	if isDefaultColor then
		local color = E.private.WT.skins.widgets.checkBox.classColor and E.myClassColor
			or E.private.WT.skins.widgets.checkBox.color
		return SetVertexColor(tex, color.r, color.g, color.b, color.a)
	end

	return SetVertexColor(tex, ...)
end

function WS:OverrideUpdateCheckBoxTexture(checkBox)
	local db = E.private.WT
		and E.private.WT.skins
		and E.private.WT.skins.widgets
		and E.private.WT.skins.widgets.checkBox

	if not checkBox or not db or not db.enable then
		return
	end

	local checked = checkBox.GetCheckedTexture and checkBox:GetCheckedTexture()
	if checked then
		if not self:IsHooked(checked, "SetVertexColor") then
			F.SetVertexColorWithDB(checked, db.classColor and E.myClassColor or db.color)
			self:RawHook(checked, "SetVertexColor", "CheckBoxCheckedTexture_SetVertexColor", true)
			F.InternalizeMethod(checked, "SetTexture", true)
		end
		F.CallMethod(checked, "SetTexture", LSM:Fetch("statusbar", db.texture) or E.media.normTex)
	end

	local disabled = checkBox.GetDisabledTexture and checkBox:GetDisabledTexture()
	if disabled and not self:IsHooked(disabled, "SetTexture") then
		self:RawHook(disabled, "SetTexture", "CheckBoxCheckedTexture_SetTexture", true)
	end
end

function WS:HandleCheckBox(_, checkBox)
	if not E.private.skins.checkBoxSkin then
		return
	end

	local db = E.private.WT
		and E.private.WT.skins
		and E.private.WT.skins.widgets
		and E.private.WT.skins.widgets.checkBox

	if not checkBox or not db or not db.enable then
		return
	end

	if self:IsHooked(checkBox, "SetCheckedTexture") then
		return
	end

	self:SecureHook(checkBox, "SetCheckedTexture", "OverrideUpdateCheckBoxTexture")
	self:OverrideUpdateCheckBoxTexture(checkBox)
end

WS:SecureHook(ES, "HandleCheckBox")
