local W, F, E, L, V, P, G = unpack(select(2, ...))
local MF = W.Modules.MoveFrames
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local strlen = strlen
local strsplit = strsplit
local type = type

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

function W:ConstructCompatibilityFrame()
    local frame = CreateFrame("Frame", "WTCompatibilityFrame", E.UIParent)
    frame:Size(550, 500)
    frame:Point("CENTER")
    frame:CreateBackdrop("Transparent")
    S:CreateShadowModule(frame.backdrop)
    S:MerathilisUISkin(frame.backdrop)
    frame.numModules = 0
    frame:Hide()
    frame:SetScript(
        "OnHide",
        function()
            if frame.configChanged then
                E:StaticPopup_Show("PRIVATE_RL")
            end
        end
    )

    frame:SetFrameStrata("TOOLTIP")
    frame:SetFrameLevel(9000)

    MF:HandleFrame(frame)

    local close =
        CreateFrame("Button", "WTCompatibilityFrameCloseButton", frame, "UIPanelCloseButton, BackdropTemplate")
    close:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT")
    ES:HandleCloseButton(close)
    close:SetScript(
        "OnClick",
        function()
            frame:Hide()
        end
    )

    local title = frame:CreateFontString(nil, "ARTWORK")
    title:FontTemplate()
    F.SetFontOutline(title, nil, "2")
    title:SetText(L["WindTools"] .. " " .. L["Compatibility Check"])
    title:Point("TOP", frame, "TOP", 0, -10)

    local desc = frame:CreateFontString(nil, "ARTWORK")
    desc:FontTemplate()
    desc:SetJustifyH("LEFT")
    desc:Width(420)
    F.SetFontOutline(desc, nil, "-1")
    desc:SetText(
        L[
            "There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."
        ] ..
            " " .. format(L["Have a good time with %s!"], L["WindTools"])
    )
    desc:Point("TOPLEFT", frame, "TOPLEFT", 10, -40)

    local largeTip = frame:CreateFontString(nil, "ARTWORK")
    largeTip:FontTemplate()
    largeTip:SetJustifyH("CENTER")
    largeTip:Width(500)
    F.SetFontOutline(largeTip, nil, "7")
    largeTip:SetText(
        format(
            "%s %s %s",
            F.CreateColorString("[", E.db.general.valuecolor),
            L["Choose the module you would like to |cff00ff00use|r."],
            F.CreateColorString("]", E.db.general.valuecolor)
        )
    )
    largeTip:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)

    local tex = frame:CreateTexture("WTCompatibilityFrameIllustration", "ARTWORK")
    tex:Size(64)
    tex:SetTexture(W.Media.Textures.illMurloc1)
    tex:Point("TOPRIGHT", frame, "TOPRIGHT", -20, -25)

    local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
    bottomDesc:FontTemplate()
    bottomDesc:SetJustifyH("LEFT")
    bottomDesc:Width(530)
    F.SetFontOutline(bottomDesc, nil, "-1")
    bottomDesc:SetText(
        E.NewSign ..
            format(L["If you find the %s module conflicts with another addon, alert me via Discord."], L["WindTools"]) ..
                "\n" ..
                    L[
                        "You can disable/enable compatibility check via the option in the bottom of [WindTools]-[Information]-[Help]."
                    ]
    )
    --bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
    bottomDesc:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

    local completeButton =
        CreateFrame("Button", "WTCompatibilityFrameCompleteButton", frame, "OptionsButtonTemplate, BackdropTemplate")
    completeButton.Text:SetText(L["Complete"])
    completeButton.Text:SetJustifyH("CENTER")
    completeButton.Text:SetJustifyV("CENTER")
    F.SetFontOutline(completeButton.Text, E.db.general.font, "4")
    completeButton:Size(350, 35)
    completeButton:Point("BOTTOM", bottomDesc, "TOP", 0, 10)
    ES:HandleButton(completeButton)
    completeButton:SetScript(
        "OnClick",
        function()
            frame:Hide()
        end
    )

    local scrollFrameParent =
        CreateFrame("ScrollFrame", "WTCompatibilityFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
    scrollFrameParent:CreateBackdrop("Transparent")
    scrollFrameParent:Point("TOPLEFT", largeTip, "BOTTOMLEFT", 0, -10)
    scrollFrameParent:Point("RIGHT", frame, "RIGHT", -32, 0)
    scrollFrameParent:Point("BOTTOM", completeButton, "TOP", 0, 10)
    ES:HandleScrollBar(scrollFrameParent.ScrollBar)
    local scrollFrame = CreateFrame("Frame", "WTCompatibilityFrameScrollFrame", scrollFrameParent)
    scrollFrame:SetSize(scrollFrameParent:GetSize())

    scrollFrameParent:SetScrollChild(scrollFrame)
    frame.scrollFrameParent = scrollFrameParent
    frame.scrollFrame = scrollFrame

    W.CompatibilityFrame = frame
end

local function AddButtonToCompatibilityFrame(data)
    local frame = W.CompatibilityFrame
    frame.numModules = frame.numModules + 1

    local leftButton =
        CreateFrame(
        "Button",
        "WTCompatibilityFrameLeftButton" .. frame.numModules,
        frame.scrollFrame,
        "OptionsButtonTemplate, BackdropTemplate"
    )
    leftButton.Text:SetText(format("%s\n%s", data.module1, data.plugin1))
    leftButton.Text:SetJustifyH("CENTER")
    leftButton.Text:SetJustifyV("CENTER")
    F.SetFontOutline(leftButton.Text, E.db.general.font)
    leftButton:Size(220, 40)
    leftButton:Point("TOPLEFT", frame.scrollFrame, "TOPLEFT", 5, -frame.numModules * 50 + 45)
    ES:HandleButton(leftButton)
    leftButton:SetScript(
        "OnClick",
        function(self)
            data.func1()
            frame.configChanged = true
            local name = gsub(self:GetName(), "LeftButton", "MiddleTexture")
            if _G[name] then
                _G[name]:SetTexture(E.Media.Textures.ArrowUp)
                _G[name]:SetRotation(ES.ArrowRotation.left)
            end
        end
    )

    local middleTexture =
        frame.scrollFrame:CreateTexture("WTCompatibilityFrameMiddleTexture" .. frame.numModules, "ARTWORK")
    middleTexture:Point("CENTER")
    middleTexture:Size(20)
    middleTexture:SetTexture(W.Media.Icons.convert)
    middleTexture:SetVertexColor(1, 1, 1)
    middleTexture:Point("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

    local rightButton =
        CreateFrame(
        "Button",
        "WTCompatibilityFrameRightButton" .. frame.numModules,
        frame.scrollFrame,
        "OptionsButtonTemplate, BackdropTemplate"
    )
    rightButton.Text:SetText(format("%s\n%s", data.module2, data.plugin2))
    rightButton.Text:SetJustifyH("CENTER")
    rightButton.Text:SetJustifyV("CENTER")
    F.SetFontOutline(rightButton.Text, E.db.general.font)
    rightButton:Size(220, 40)
    rightButton:Point("TOPRIGHT", frame.scrollFrame, "TOPRIGHT", -5, -frame.numModules * 50 + 45)
    ES:HandleButton(rightButton)
    rightButton:SetScript(
        "OnClick",
        function(self)
            data.func2()
            frame.configChanged = true
            local name = gsub(self:GetName(), "RightButton", "MiddleTexture")
            if _G[name] then
                _G[name]:SetTexture(E.Media.Textures.ArrowUp)
                _G[name]:SetRotation(ES.ArrowRotation.right)
            end
        end
    )
end

local function GetDatabaseRealValue(path)
    local accessTable, accessKey, accessValue = nil, nil, E

    for _, key in ipairs {strsplit(".", path)} do
        if key and strlen(key) > 0 then
            if accessValue and accessValue[key] ~= nil then
                if type(accessValue[key]) == "boolean" then
                    accessTable = accessValue
                    accessKey = key
                end
                accessValue = accessValue[key]
            else
                F.DebugMessage("Compatibility", "DB Path Error: " .. path)
                return
            end
        end
    end

    return accessTable, accessKey, accessValue
end

local function GetCheckCompatibilityFunction(targetAddonName, targetAddonLocales)
    if not IsAddOnLoaded(targetAddonName) then
        return E.noop
    end

    return function(myModuleName, targetAddonModuleName, myDB, targetAddonDB)
        if not (myDB and targetAddonDB and type(myDB) == "string" and type(targetAddonDB) == "string") then
            return
        end

        local myTable, myKey, myValue = GetDatabaseRealValue(myDB)
        local targetTable, targetKey, targetValue = GetDatabaseRealValue(targetAddonDB)

        if myValue == true and targetValue == true then
            AddButtonToCompatibilityFrame(
                {
                    module1 = myModuleName,
                    plugin1 = L["WindTools"],
                    func1 = function()
                        myTable[myKey] = true
                        targetTable[targetKey] = false
                    end,
                    module2 = targetAddonModuleName,
                    plugin2 = targetAddonLocales,
                    func2 = function()
                        myTable[myKey] = false
                        targetTable[targetKey] = true
                    end
                }
            )
        end
    end
end

local CheckMerathilisUI = GetCheckCompatibilityFunction("ElvUI_MerathilisUI", L["MerathilisUI"])
local CheckShadowAndLight = GetCheckCompatibilityFunction("ElvUI_SLE", L["Shadow & Light"])
local CheckmMediaTag = GetCheckCompatibilityFunction("ElvUI_mMediaTag", L["mMediaTag"])
local CheckElvUIEnhanced = GetCheckCompatibilityFunction("ElvUI_Enhanced", L["ElvUI Enhanced Again"])

function W:CheckCompatibility()
    if not E.private.WT.core.compatibilityCheck then
        return
    end

    self:ConstructCompatibilityFrame()

    -- Merathilis UI
    CheckMerathilisUI(
        L["Extra Items Bar"],
        L["AutoButtons"],
        "db.WT.item.extraItemsBar.enable",
        "db.mui.autoButtons.enable"
    )

    CheckMerathilisUI(L["Game Bar"], L["Micro Bar"], "db.WT.misc.gameBar.enable", "db.mui.microBar.enable")

    CheckMerathilisUI(L["Contacts"], L["Mail"], "db.WT.item.contacts.enable", "db.mui.mail.enable")

    CheckMerathilisUI(
        format("%s-%s", L["Tooltip"], L["Add Icon"]),
        format("%s-%s", L["Tooltip"], L["Tooltip Icons"]),
        "private.WT.tooltips.icon",
        "db.mui.tooltip.tooltipIcon"
    )

    CheckMerathilisUI(
        format("%s-%s", L["Tooltip"], L["Domination Rank"]),
        format("%s-%s", L["Tooltip"], L["Domination Rank"]),
        "private.WT.tooltips.dominationRank",
        "db.mui.tooltip.dominationRank"
    )

    CheckMerathilisUI(L["Group Info"], L["LFG Info"], "db.WT.tooltips.groupInfo.enable", "db.mui.misc.lfgInfo.enable")

    CheckMerathilisUI(
        L["Paragon Reputation"],
        L["Paragon Reputation"],
        "db.WT.quest.paragonReputation.enable",
        "db.mui.misc.paragon.enable"
    )

    CheckMerathilisUI(
        L["Role Icon"],
        L["Role Icon"],
        "private.WT.unitFrames.roleIcon.enable",
        "db.mui.unitframes.roleIcons"
    )

    CheckMerathilisUI(
        L["Combat Alert"],
        L["Combat Alert"],
        "db.WT.combat.combatAlert.enable",
        "db.mui.CombatAlert.enable"
    )

    CheckMerathilisUI(
        L["Who Clicked Minimap"],
        L["Minimap Ping"],
        "db.WT.maps.whoClicked.enable",
        "db.mui.maps.minimap.ping.enable"
    )

    CheckMerathilisUI(
        L["Minimap Buttons"],
        L["Minimap Buttons"],
        "private.WT.maps.minimapButtons.enable",
        "db.mui.smb.enable"
    )

    CheckMerathilisUI(
        L["Rectangle Minimap"],
        L["Rectangle Minimap"],
        "db.WT.maps.rectangleMinimap.enable",
        "db.mui.maps.minimap.rectangleMinimap.enable"
    )

    CheckMerathilisUI(L["Chat Bar"], L["Chat Bar"], "db.WT.social.chatBar.enable", "db.mui.chat.chatBar.enable")

    CheckMerathilisUI(L["Chat Link"], L["Chat Link"], "db.WT.social.chatLink.enable", "db.mui.chat.chatLink.enable")

    CheckMerathilisUI(
        L["Raid Markers"],
        L["Raid Markers"],
        "db.WT.combat.raidMarkers.enable",
        "db.mui.raidmarkers.enable"
    )

    CheckMerathilisUI(
        format("%s-%s", L["Chat Text"], L["Remove Brackets"]),
        L["Hide Player Brackets"],
        "db.WT.social.chatText.removeBrackets",
        "db.mui.chat.hidePlayerBrackets"
    )

    CheckMerathilisUI(
        format("%s-%s", L["Talent Manager"], L["Item Buttons"]),
        L["Codex Buttons"],
        "private.WT.combat.talentManager.itemButtons",
        "db.mui.misc.respec"
    )

    CheckMerathilisUI(
        L["Super Tracker"],
        L["Super Tracker"],
        "private.WT.maps.superTracker.enable",
        "db.mui.maps.superTracker.enable"
    )

    CheckMerathilisUI(
        L["Instance Difficulty"],
        L["Raid Difficulty"],
        "private.WT.maps.instanceDifficulty.enable",
        "db.mui.maps.minimap.instanceDifficulty.enable"
    )

    CheckMerathilisUI(
        format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
        L["Merchant"],
        "private.WT.item.extendMerchantPages.enable",
        "db.mui.merchant.enable"
    )

    CheckMerathilisUI(
        L["Absorb"],
        L["Heal Prediction"],
        "db.WT.unitFrames.absorb.enable",
        "db.mui.unitframes.healPrediction.enable"
    )

    CheckMerathilisUI(
        L["Objective Tracker"],
        L["Objective Tracker"],
        "private.WT.quest.objectiveTracker.enable",
        "db.mui.blizzard.objectiveTracker.enable"
    )

    -- S&L
    CheckShadowAndLight(
        L["Move Frames"],
        L["Move Blizzard frames"],
        "private.WT.misc.moveFrames.enable",
        "private.sle.module.blizzmove.enable"
    )

    CheckShadowAndLight(
        format("%s-%s", L["Skins"], L["Shadow"]),
        L["Enhanced Shadow"],
        "private.WT.skins.shadow",
        "private.sle.module.shadows.enable"
    )

    CheckShadowAndLight(
        format("%s-%s", L["Tooltip"], L["Progression"]),
        format("%s-%s", L["Tooltip"], L["Raid Progression"]),
        "private.WT.tooltips.progression.enable",
        "db.sle.tooltip.RaidProg.enable"
    )

    CheckShadowAndLight(
        L["Rectangle Minimap"],
        L["Rectangle Minimap"],
        "db.WT.maps.rectangleMinimap.enable",
        "private.sle.minimap.rectangle"
    )

    CheckShadowAndLight(
        L["Raid Markers"],
        L["Raid Markers"],
        "db.WT.combat.raidMarkers.enable",
        "db.sle.raidmarkers.enable"
    )

    CheckShadowAndLight(
        format("%s-%s", L["Skins"], L["Scenario"]),
        format("%s-%s", L["Skins"], _G.OBJECTIVES_TRACKER_LABEL),
        "private.WT.skins.blizzard.scenario",
        "private.sle.skins.objectiveTracker.enable"
    )

    CheckShadowAndLight(
        format("%s-%s", L["Item"], L["Fast Loot"]),
        L["Loot"],
        "db.WT.item.fastLoot.enable",
        "db.sle.loot.enable"
    )

    CheckShadowAndLight(
        format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
        L["Merchant"],
        "private.WT.item.extendMerchantPages.enable",
        "private.sle.skins.merchant.enable"
    )

    -- mMediaTag
    CheckmMediaTag(
        format("%s-%s", L["Tooltips"], L["Icon"]),
        L["Tooltip Icons"],
        "private.WT.tooltips.icon",
        "db.mMediaTag.mTIcon"
    )

    CheckmMediaTag(
        L["Objective Tracker"],
        L["ObjectiveTracker Skin"],
        "private.WT.quest.objectiveTracker.enable",
        "db.mMediaTag.mObjectiveTracker.enable"
    )

    CheckmMediaTag(
        L["Role Icon"],
        L["Role Symbols"],
        "private.WT.unitFrames.roleIcon.enable",
        "db.mMediaTag.mRoleSymbols.enable"
    )

    -- Enhanced Again
    CheckElvUIEnhanced(
        L["Raid Markers"],
        L["Raid Markers"],
        "db.WT.combat.raidMarkers.enable",
        "db.eel.raidmarkerbar.enable"
    )

    CheckElvUIEnhanced(
        format("%s-%s", L["Tooltip"], L["Progression"]),
        format("%s-%s", L["Tooltip"], L["Progression"]),
        "private.WT.tooltips.progression.enable",
        "db.eel.progression.enable"
    )

    CheckElvUIEnhanced(
        L["Minimap Buttons"],
        L["Minimap Button Bar"],
        "private.WT.maps.minimapButtons.enable",
        "db.eel.minimap.minimapbar.enable"
    )

    if self.CompatibilityFrame.numModules > 0 then
        self.CompatibilityFrame:Show()
    end
end
