local W, F, E, L, V, P, G = unpack(select(2, ...))

local IsAddOnLoaded = IsAddOnLoaded

function W:Fang2houUIPrivate()
    if W.Locale == "zhTW" then
        E.private["general"]["namefont"] = "預設"
    elseif W.Locale == "zhCN" then
        E.private["general"]["namefont"] = "默认"
    elseif W.Locale == "koKR" then
        E.private["general"]["namefont"] = "기본 글꼴"
    end

    if W.Locale == "zhTW" then
        E.private["general"]["dmgfont"] = "傷害數字"
    elseif W.Locale == "zhCN" then
        E.private["general"]["dmgfont"] = "伤害数字"
    elseif W.Locale == "koKR" then
        E.private["general"]["dmgfont"] = "데미지 글꼴"
    end

    E.private["general"]["normTex"] = "WindTools Glow"
    E.private["general"]["glossTex"] = "WindTools Flat"
    E.private["general"]["chatBubbles"] = "disabled"
    E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
    E.private["general"]["minimap"]["hideCalendar"] = false
    E.private["WT"]["misc"]["mute"]["enable"] = true
    E.private["WT"]["misc"]["mute"]["mount"][63796] = true
    E.private["WT"]["misc"]["mute"]["mount"][229385] = true
    E.private["WT"]["misc"]["noKanjiMath"] = true
    E.private["WT"]["skins"]["elvui"]["chatPanels"] = false
    E.private["WT"]["maps"]["worldMap"]["scale"]["size"] = 1.2
    E.private["WT"]["maps"]["minimapButtons"]["mouseOver"] = true
    E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 3
    E.private["WT"]["maps"]["minimapButtons"]["calendar"] = true
    E.private["WT"]["maps"]["minimapButtons"]["buttonsPerRow"] = 7
    E.private["WT"]["maps"]["minimapButtons"]["inverseDirection"] = true
    E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 0
    E.private["WT"]["maps"]["minimapButtons"]["buttonSize"] = 29
    E.private["skins"]["parchmentRemoverEnable"] = true
    E.private["theme"] = "default"

    if IsAddOnLoaded("Plater") or IsAddOnLoaded("Kui_Nameplates") then
        E.private["nameplates"]["enable"] = false
    end

    E:StaticPopup_Show("PRIVATE_RL")
end
