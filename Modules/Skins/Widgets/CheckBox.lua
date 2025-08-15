local W, F, E, L = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
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
		check.SetTexture = E.noop
		check.windWidgetSkinned = true
	end

	if self.IsUglyYellow(check:GetVertexColor()) then
		F.SetVertexColorWithDB(check, db.classColor and W.ClassColor or db.color)
	end
end

do
	ES.Ace3_CheckBoxSetDesaturated_ = ES.Ace3_CheckBoxSetDesaturated
	function ES.Ace3_CheckBoxSetDesaturated(check, value)
		ES.Ace3_CheckBoxSetDesaturated_(check, value)
		WS:HandleAce3CheckBox(check)
	end
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
				texture.SetTexture = E.noop
				F.SetVertexColorWithDB(texture, db.classColor and W.ClassColor or db.color)
				texture.SetVertexColor_ = texture.SetVertexColor
				texture.SetVertexColor = function(tex, ...)
					local isDefaultColor = self.IsUglyYellow(...)

					-- Let skin use its own logic to colorize the check texture
					if tex.__windColorOverride and type(tex.__windColorOverride) == "function" then
						local color = tex.__windColorOverride(...)
						if type(color) == "table" and color.r and color.g and color.b then
							tex:SetVertexColor_(color.r, color.g, color.b, color.a)
							return
						elseif type(color) == "string" and color == "DEFAULT" then
							isDefaultColor = true
						end
					end

					if isDefaultColor then
						local color = db.classColor and W.ClassColor or db.color
						tex:SetVertexColor_(color.r, color.g, color.b, color.a)
					else
						tex:SetVertexColor_(...)
					end
				end
			end
		end

		if check.GetDisabledTexture then
			local texture = check:GetDisabledTexture()
			if texture then
				texture.SetTexture_ = texture.SetTexture
				texture.SetTexture = function(tex, texPath)
					if not texPath then
						return
					end

					if texPath == "" then
						tex:SetTexture_("")
					else
						tex:SetTexture_(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
					end
				end
			end
		end

		check.windWidgetSkinned = true
	end
end

WS:SecureHook(ES, "HandleCheckBox")
