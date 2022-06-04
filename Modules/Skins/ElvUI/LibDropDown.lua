local W, F, E, L = unpack(select(2, ...))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ES_SkinLibDropDownMenu(_, prefix)
    if _G[prefix .. "_UIDropDownMenu_CreateFrames"] then
        local bd = _G[prefix .. "_DropDownList1Backdrop"]
        local mbd = _G[prefix .. "_DropDownList1MenuBackdrop"]
        if bd and bd.template then
            self:CreateShadow(bd)
        end
        if mbd and mbd.template then
            self:CreateShadow(bd)
        end

        S[prefix .. "_UIDropDownMenuSkinned"] = true
        hooksecurefunc(
            prefix .. "_UIDropDownMenu_CreateFrames",
            function()
                local lvls = _G[(prefix == "Lib" and "LIB" or prefix) .. "_UIDROPDOWNMENU_MAXLEVELS"]
                local ddbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "Backdrop"]
                local ddmbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "MenuBackdrop"]
                if ddbd and ddbd.template then
                    self:CreateShadow(bd)
                end
                if ddmbd and ddmbd.template then
                    self:CreateShadow(bd)
                end
            end
        )
    end
end

S:SecureHook(ES, "SkinLibDropDownMenu", "ES_SkinLibDropDownMenu")
