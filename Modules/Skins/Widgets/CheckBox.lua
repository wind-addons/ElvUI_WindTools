local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local WS = S.Widgets
local ES = E.Skins

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

    local db = E.private.WT and E.private.WT.skins and E.private.WT.skins.widgets and E.private.WT.skins.widgets.checkBox
    if not check or not db or not db.enable then
        return
    end

    if not check.windWidgetSkinned then
        if check.GetCheckedTexture then
            local tex = check:GetCheckedTexture()
            if tex then
                tex:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
                tex.SetTexture = E.noop
                F.SetVertexColorWithDB(tex, db.classColor and W.ClassColor or db.color)
                tex.SetVertexColor_ = tex.SetVertexColor
                tex.SetVertexColor = function(tex, ...)
                    if self.IsUglyYellow(...) then
                        local color = db.classColor and W.ClassColor or db.color
                        tex:SetVertexColor_(color.r, color.g, color.b, color.a)
                    else
                        tex:SetVertexColor_(...)
                    end
                end
            end
        end

        if check.GetDisabledTexture then
            local tex = check:GetDisabledTexture()
            if tex then
                tex.SetTexture_ = tex.SetTexture
                tex.SetTexture = function(tex, texPath)
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
