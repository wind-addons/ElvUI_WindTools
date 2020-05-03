local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')
local UF = E:GetModule('UnitFrames')

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ElvUI_UnitFrames()
    if not E.private.unitframe.enable then return end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.unitFrames) then return end

    -- 低频度更新单位框体外围阴影
    hooksecurefunc(UF, "UpdateNameSettings", function(_, f) if f then S:CreateShadow(f) end end)

    -- 在 oUF 更新仇恨值阴影时判断是否隐藏美化阴影
    hooksecurefunc(UF, "Configure_Threat", function(_, f)
        local threat = f.ThreatIndicator
        if not threat then return end
        threat.PostUpdate = function(self, unit, status, r, g, b)
            UF.UpdateThreat(self, unit, status, r, g, b)
            local parent = self:GetParent()
            if not unit or parent.unit ~= unit then return end
            if parent.db and parent.db.threatStyle == 'GLOW' and parent.shadow then
                parent.shadow:SetShown(not threat.MainGlow:IsShown())
            end
        end
    end)

    -- 为分离的能量条提供阴影
    hooksecurefunc(UF, "Configure_Power",
                   function(_, f) if f.USE_POWERBAR and f.POWERBAR_DETACHED then S:CreateShadow(f.Power) end end)

    -- 为单位框体光环提供边缘美化
    hooksecurefunc(UF, "UpdateAuraSettings", function(_, _, a) if a then S:CreateShadow(a) end end)
end

S:AddCallback('ElvUI_UnitFrames')
