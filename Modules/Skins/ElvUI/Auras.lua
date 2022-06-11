local W, F, E, L = unpack(select(2, ...))
local A = E:GetModule("Auras")
local S = W.Modules.Skins

local _G = _G

local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemQualityColor = GetItemQualityColor

function S:ElvUI_Auras_CreateIcon(_, button)
    self:CreateLowerShadow(button)
end

function S:ElvUI_Auras_UpdateAura(_, button)
    self:CreateLowerShadow(button)

    local r, g, b

    if button.debuffType and (not button.debuffTypeWT or button.debuffTypeWT ~= button.debuffType) then
        local color = button.filter == "HARMFUL" and A.db.colorDebuffs and _G.DebuffTypeColor[button.debuffType]
        button.debuffTypeWT = button.debuffType

        if color then
            r, g, b = color.r, color.g, color.b
        end
    end

    self:UpdateShadowColor(button.shadow, r, g, b)
end

function S:ElvUI_Auras_UpdateTempEnchant(_, button, index, expiration)
    self:CreateLowerShadow(button)

    local r, g, b

    if expiration then
        local quality = A.db.colorEnchants and GetInventoryItemQuality("player", index)

        if quality and quality > 1 then
            r, g, b = GetItemQualityColor(quality)
        end
    end

    self:UpdateShadowColor(button.shadow, r, g, b)
end

function S:ElvUI_Auras()
    if not E.private.auras.enable then
        return
    end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.auras) then
        return
    end

    self:SecureHook(A, "CreateIcon", "ElvUI_Auras_CreateIcon")
    self:SecureHook(A, "UpdateAura", "ElvUI_Auras_UpdateAura")
    self:SecureHook(A, "UpdateTempEnchant", "ElvUI_Auras_UpdateTempEnchant")
end

S:AddCallback("ElvUI_Auras")
