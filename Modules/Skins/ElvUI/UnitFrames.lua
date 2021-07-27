local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local UF = E:GetModule("UnitFrames")

local _G = _G

function S:ElvUI_UnitFrames_UpdateNameSettings(_, f)
    if not E.private.WT.skins.enable or not E.private.WT.skins.shadow then
        return
    end

    if f.Health.backdrop and not f.Health.backdrop.shadow then
        self:CreateBackdropShadow(f.Health, true)
        f.Health.backdrop.shadow:ClearAllPoints()
        f.Health.backdrop.shadow:SetAllPoints(f.TargetGlow)
    end
end

function S:ElvUI_UnitFrames_Configure_Threat(_, f)
    local threat = f.ThreatIndicator
    if not threat then
        return
    end
    threat.PostUpdate = function(self, unit, status, r, g, b)
        UF.UpdateThreat(self, unit, status, r, g, b)
        local parent = self:GetParent()
        if not unit or parent.unit ~= unit then
            return
        end
        if parent.db and parent.db.threatStyle == "GLOW" then
            if parent.Health and parent.Health.backdrop and parent.Health.backdrop.shadow then
                parent.Health.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
            end
            if parent.Power and parent.Power.backdrop and parent.Power.backdrop.shadow and parent.USE_POWERBAR_OFFSET then
                parent.Power.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
            end
        end
    end
end

function S:ElvUI_UnitFrames_Configure_Power(_, f)
    if f.USE_POWERBAR then
        local shadow = f.Power.backdrop.shadow
        if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
            if not shadow then
                self:CreateBackdropShadow(f.Power, true)
            else
                shadow:Show()
            end
        else
            if shadow then
                shadow:Hide()
            end
        end
    end
end

function S:ElvUI_UnitFrames_UpdateAuraSettings(_, _, a)
    self:CreateShadow(a)
end

function S:ElvUI_UnitFrames()
    if not E.private.unitframe.enable then
        return
    end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.unitFrames) then
        return
    end

    -- 低频度更新单位框体外围阴影
    self:SecureHook(UF, "UpdateNameSettings", "ElvUI_UnitFrames_UpdateNameSettings")

    -- 在 oUF 更新仇恨值阴影时判断是否隐藏美化阴影
    self:SecureHook(UF, "Configure_Threat", "ElvUI_UnitFrames_Configure_Threat")

    -- 为分离的能量条提供阴影
    self:SecureHook(UF, "Configure_Power", "ElvUI_UnitFrames_Configure_Power")

    -- 为单位框体光环提供边缘美化
    self:SecureHook(UF, "UpdateAuraSettings", "ElvUI_UnitFrames_UpdateAuraSettings")
end

S:AddCallback("ElvUI_UnitFrames")
