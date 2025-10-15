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

local function Tex_SetTexture(tex, texPath)
	if not texPath then
		return
	end

	if texPath == "" then
		F.CallMethod(tex, "SetTexture", "")
	else
		F.CallMethod(
			tex,
			"SetTexture",
			LSM:Fetch("statusbar", E.private.WT.skins.widgets.checkBox.texture) or E.media.normTex
		)
	end
end

local function Tex_SetVertexColor(tex, ...)
	local isDefaultColor = WS.IsUglyYellow(...)

	-- Let skin use its own logic to colorize the check texture
	if tex.__windColorOverride and type(tex.__windColorOverride) == "function" then
		local color = tex.__windColorOverride(...)
		if type(color) == "table" and color.r and color.g and color.b then
			return F.CallMethod(tex, "SetVertexColor", color.r, color.g, color.b, color.a)
		elseif type(color) == "string" and color == "DEFAULT" then
			isDefaultColor = true
		end
	end

	if isDefaultColor then
		local color = E.private.WT.skins.widgets.checkBox.classColor and E.myClassColor
			or E.private.WT.skins.widgets.checkBox.color
		return F.CallMethod(tex, "SetVertexColor", color.r, color.g, color.b, color.a)
	end

	return F.CallMethod(tex, "SetVertexColor", ...)
end

function WS:HandleCheckBox(_, check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	local db = E.private.WT
		and E.private.WT.skins
		and E.private.WT.skins.widgets
		and E.private.WT.skins.widgets.checkBox
	if not check or not db or not db.enable then
		return
	end

	if not check.windWidgetSkinned then
		if check.GetCheckedTexture then
			local texture = check:GetCheckedTexture()
			if texture then
				texture:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
				F.InternalizeMethod(texture, "SetTexture", true)
				F.SetVertexColorWithDB(texture, db.classColor and E.myClassColor or db.color)
				F.InternalizeMethod(texture, "SetVertexColor")
				texture.SetVertexColor = Tex_SetVertexColor
			end
		end

		if check.GetDisabledTexture then
			local texture = check:GetDisabledTexture()
			if texture then
				F.InternalizeMethod(texture, "SetTexture")
				texture.SetTexture = Tex_SetTexture
			end
		end

		check.windWidgetSkinned = true
	end
end

WS:SecureHook(ES, "HandleCheckBox")
