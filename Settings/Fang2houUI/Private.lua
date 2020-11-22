local W, F, E, L, V, P, G = unpack(select(2, ...))

local IsAddOnLoaded = IsAddOnLoaded

function W:Fang2houUIPrivate()
    if W.Locale == "zhTW" then
        E.private["general"]["namefont"] = "預設"
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["name"] = "預設"
    elseif W.Locale == "zhCN" then
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["name"] = "默认"
        E.private["general"]["namefont"] = "默认"
    elseif W.Locale == "koKR" then
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["name"] = "기본 글꼴"
        E.private["general"]["namefont"] = "기본 글꼴"
    end

    if W.Locale == "zhTW" then
        E.private["general"]["dmgfont"] = "傷害數字"
    elseif W.Locale == "zhCN" then
        E.private["general"]["dmgfont"] = "伤害数字"
    elseif W.Locale == "koKR" then
        E.private["general"]["dmgfont"] = "데미지 글꼴"
    end
    
    E.private["WT"]["maps"]["instanceDifficulty"]["font"]["size"] = 15
    E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 0
    E.private["WT"]["maps"]["minimapButtons"]["buttonSize"] = 29
    E.private["WT"]["maps"]["minimapButtons"]["buttonsPerRow"] = 7
    E.private["WT"]["maps"]["minimapButtons"]["calendar"] = true
    E.private["WT"]["maps"]["minimapButtons"]["inverseDirection"] = true
    E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 3
    E.private["WT"]["maps"]["superTracker"]["distanceText"]["name"] = F.GetCompatibleFont("Montserrat")
    E.private["WT"]["maps"]["superTracker"]["distanceText"]["onlyNumber"] = true
    E.private["WT"]["maps"]["superTracker"]["noLimit"] = true
    E.private["WT"]["maps"]["instanceDifficulty"]["enable"] = true
    E.private["WT"]["maps"]["worldMap"]["scale"]["size"] = 1.2
    E.private["WT"]["misc"]["autoScreenshot"] = true
    E.private["WT"]["misc"]["moveSpeed"] = true
    E.private["WT"]["misc"]["mute"]["enable"] = true
    E.private["WT"]["misc"]["mute"]["mount"][63796] = true
    E.private["WT"]["misc"]["mute"]["mount"][229385] = true
    E.private["WT"]["misc"]["skipCutScene"] = false
    E.private["general"]["chatBubbleFont"] = "聊天"
    E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
    E.private["general"]["chatBubbles"] = "nobackdrop"
    E.private["general"]["glossTex"] = "WindTools Flat"
    E.private["general"]["minimap"]["hideClassHallReport"] = true
    E.private["general"]["normTex"] = "WindTools Glow"
    E.private["install_complete"] = 12
    E.private["skins"]["parchmentRemoverEnable"] = true
    E.private["theme"] = "default"

    if IsAddOnLoaded("Plater") or IsAddOnLoaded("Kui_Nameplates") then
        E.private["nameplates"]["enable"] = false
    end

    E:StaticPopup_Show("PRIVATE_RL")
end
