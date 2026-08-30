local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local A = E:GetModule("Auras")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs

local UNITFRAME_AURA_KEYS = { "Buffs", "Debuffs", "Auras", "AuraBars" }

local function ShouldSkinAuraContainer(container)
	if not container then
		return false
	end

	local privateWT = E.private and E.private.WT
	local skins = privateWT and privateWT.skins
	if not skins or not skins.enable then
		return false
	end

	local elvuiSkins = skins.elvui
	if not elvuiSkins or not elvuiSkins.enable then
		return false
	end

	if container.isTopAura then
		return elvuiSkins.auras
	end
	if container.isUnitframe or container.isAuraBar then
		return elvuiSkins.unitFrames
	end
	if container.isNameplate then
		return elvuiSkins.nameplates
	end

	return false
end

local function BindAuraButtonShadowColor(button)
	local shadow = button.shadow
	local borderTexture = button.dispelBorder or button.border
	if not shadow or not shadow.__wind or not borderTexture or not borderTexture.SetVertexColor then
		return
	end

	hooksecurefunc(borderTexture, "SetVertexColor", function(_, r, g, b)
		if E:IsSecretValue(r) or E:IsSecretValue(g) or E:IsSecretValue(b) or not r or not g or not b then
			return
		end

		if r == E.db.general.bordercolor.r and g == E.db.general.bordercolor.g and b == E.db.general.bordercolor.b then
			S:UpdateShadowColor(shadow)
		else
			S:UpdateShadowColor(shadow, r, g, b)
		end
	end)
end

function S:ElvUI_Auras_SkinAuraButton(_, container, button)
	button = button or container
	if not button or button.__windSkin then
		return
	end

	if button.IsForbidden and button:IsForbidden() then
		return
	end

	container = (button ~= container and container) or button.container or button:GetParent()
	if not ShouldSkinAuraContainer(container) then
		return
	end

	self:CreateShadow(button)
	BindAuraButtonShadowColor(button)
	button.__windSkin = true
end

local function SkinAuraButtonsOnContainer(container)
	if not container or not container.buttons then
		return
	end

	for button in next, container.buttons do
		S:ElvUI_Auras_SkinAuraButton(nil, container, button)
	end
end

local function SkinAuraButtonsOnUnitFrame(frame)
	if not frame then
		return
	end

	for index = 1, #UNITFRAME_AURA_KEYS do
		SkinAuraButtonsOnContainer(frame[UNITFRAME_AURA_KEYS[index]])
	end
end

function S:ElvUI_Auras_SkinExistingButtons()
	if E.AuraPreviewFrames then
		for container in next, E.AuraPreviewFrames do
			SkinAuraButtonsOnContainer(container)
		end
	end

	SkinAuraButtonsOnContainer(A.BuffFrame)
	SkinAuraButtonsOnContainer(A.DebuffFrame)

	for _, frame in pairs(UF.units) do
		SkinAuraButtonsOnUnitFrame(frame)
	end

	for unit in pairs(UF.groupunits) do
		SkinAuraButtonsOnUnitFrame(UF[unit])
	end

	for groupName in pairs(UF.headers) do
		local group = UF[groupName]
		if group and group.GetNumChildren then
			for _, child in next, { group:GetChildren() } do
				if child.Health then
					SkinAuraButtonsOnUnitFrame(child)
				elseif child.GetChildren then
					for _, nested in next, { child:GetChildren() } do
						if nested.Health then
							SkinAuraButtonsOnUnitFrame(nested)
						end
					end
				end
			end
		end
	end
end

function S:ElvUI_Auras_Hook()
	if not self:IsHooked(E, "Auras_UpdateButton") then
		self:SecureHook(E, "Auras_UpdateButton", "ElvUI_Auras_SkinAuraButton")
	end
end

function S:ElvUI_Auras()
	if not E.private.WT.skins.elvui.enable then
		return
	end

	local elvuiSkins = E.private.WT.skins.elvui
	if not (elvuiSkins.auras or elvuiSkins.unitFrames or elvuiSkins.nameplates) then
		return
	end

	self:ElvUI_Auras_Hook()
	self:ElvUI_Auras_SkinExistingButtons()
end

S:AddCallback("ElvUI_Auras")
