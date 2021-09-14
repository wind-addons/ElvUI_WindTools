local W, F, E, L, V, P, G = unpack(select(2, ...))
local MF = W.Modules.MoveFrames
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local strlen = strlen
local strsplit = strsplit
local type = type

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

function W:ConstructCompatibiltyFrame()
    local frame = CreateFrame("Frame", "WTCompatibiltyFrame", E.UIParent)
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

    MF:HandleFrame(frame)

    local close = CreateFrame("Button", "WTCompatibiltyFrameCloseButton", frame, "UIPanelCloseButton, BackdropTemplate")
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
    title:SetText(L["WindTools"] .. " - " .. L["Compatibility Check"])
    title:Point("TOP", frame, "TOP", 0, -10)

    local desc = frame:CreateFontString(nil, "ARTWORK")
    desc:FontTemplate()
    desc:SetJustifyH("LEFT")
    desc:Width(420)
    F.SetFontOutline(desc, nil, "-1")
    desc:SetText(
        format(
            "%s\n%s\n%s",
            L[
                "There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."
            ],
            L["Choose the module you would like to |cff00ff00use|r."],
            format(L["Have a good time with %s!"], L["WindTools"])
        )
    )
    desc:Point("TOPLEFT", frame, "TOPLEFT", 10, -40)

    local tex = frame:CreateTexture("WTCompatibiltyFrameIllustration", "ARTWORK")
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
            format(L["If you find the %s module conflicts with another addon, alert me via Discord."], L["WindTools"])
    )
    --bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
    bottomDesc:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

    local completeButton =
        CreateFrame("Button", "WTCompatibiltyFrameCompleteButton", frame, "OptionsButtonTemplate, BackdropTemplate")
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
        CreateFrame("ScrollFrame", "WTCompatibiltyFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
    scrollFrameParent:CreateBackdrop("Transparent")
    scrollFrameParent:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    scrollFrameParent:Point("RIGHT", frame, "RIGHT", -32, 0)
    scrollFrameParent:Point("BOTTOM", completeButton, "TOP", 0, 10)
    ES:HandleScrollBar(scrollFrameParent.ScrollBar)
    local scrollFrame = CreateFrame("Frame", "WTCompatibiltyFrameScrollFrame", scrollFrameParent)
    scrollFrame:SetSize(scrollFrameParent:GetSize())

    scrollFrameParent:SetScrollChild(scrollFrame)
    frame.scrollFrameParent = scrollFrameParent
    frame.scrollFrame = scrollFrame

    W.CompatibiltyFrame = frame
end

function W:AddButtonToCompatibiltyFrame(data)
    local frame = self.CompatibiltyFrame
    frame.numModules = frame.numModules + 1

    local leftButton =
        CreateFrame(
        "Button",
        "WTCompatibiltyFrameLeftButton" .. frame.numModules,
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
        frame.scrollFrame:CreateTexture("WTCompatibiltyFrameMiddleTexture" .. frame.numModules, "ARTWORK")
    middleTexture:Point("CENTER")
    middleTexture:Size(20)
    middleTexture:SetTexture(W.Media.Icons.convert)
    middleTexture:SetVertexColor(1, 1, 1)
    middleTexture:Point("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

    local rightButton =
        CreateFrame(
        "Button",
        "WTCompatibiltyFrameRightButton" .. frame.numModules,
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

function W:CheckCompatibilityMerathilisUI(WTModuleName, MUIModuleName, WTDB, MUIDB)
    if not IsAddOnLoaded("ElvUI_MerathilisUI") then
        return
    end

    if not (WTDB and MUIDB and type(WTDB) == "string" and type(MUIDB) == "string") then
        return
    end

    local realWTDB = E
    local lastWTTable, lastWTKey
    for _, key in ipairs {strsplit(".", WTDB)} do
        if key and strlen(key) > 0 then
            if realWTDB[key] ~= nil then
                if type(realWTDB[key]) == "boolean" then
                    lastWTTable = realWTDB
                    lastWTKey = key
                end
                realWTDB = realWTDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. WTDB)
                return
            end
        end
    end

    local realMUIDB = E
    local lastMUITable, lastMUIKey
    for _, key in ipairs {strsplit(".", MUIDB)} do
        if key and strlen(key) > 0 then
            if realMUIDB[key] ~= nil then
                if type(realMUIDB[key]) == "boolean" then
                    lastMUITable = realMUIDB
                    lastMUIKey = key
                end
                realMUIDB = realMUIDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. MUIDB)
                return
            end
        end
    end

    if realMUIDB == true and realWTDB == true then
        self:AddButtonToCompatibiltyFrame(
            {
                module1 = WTModuleName,
                plugin1 = L["WindTools"],
                func1 = function()
                    lastMUITable[lastMUIKey] = false
                    lastWTTable[lastWTKey] = true
                end,
                module2 = MUIModuleName,
                plugin2 = L["MerathilisUI"],
                func2 = function()
                    lastMUITable[lastMUIKey] = true
                    lastWTTable[lastWTKey] = false
                end
            }
        )
    end
end

function W:CheckCompatibilityShadowAndLight(WTModuleName, SLModuleName, WTDB, SLDB)
    if not IsAddOnLoaded("ElvUI_SLE") then
        return
    end

    if not (WTDB and SLDB and type(WTDB) == "string" and type(SLDB) == "string") then
        return
    end

    local realWTDB = E
    local lastWTTable, lastWTKey
    for _, key in ipairs {strsplit(".", WTDB)} do
        if key and strlen(key) > 0 then
            if realWTDB[key] ~= nil then
                if type(realWTDB[key]) == "boolean" then
                    lastWTTable = realWTDB
                    lastWTKey = key
                end
                realWTDB = realWTDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. WTDB)
                return
            end
        end
    end

    local realSLDB = E
    local lastSLTable, lastSLKey
    for _, key in ipairs {strsplit(".", SLDB)} do
        if key and strlen(key) > 0 then
            if realSLDB[key] ~= nil then
                if type(realSLDB[key]) == "boolean" then
                    lastSLTable = realSLDB
                    lastSLKey = key
                end
                realSLDB = realSLDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. SLDB)
                return
            end
        end
    end

    if realSLDB == true and realWTDB == true then
        self:AddButtonToCompatibiltyFrame(
            {
                module1 = WTModuleName,
                plugin1 = L["WindTools"],
                func1 = function()
                    lastSLTable[lastSLKey] = false
                    lastWTTable[lastWTKey] = true
                end,
                module2 = SLModuleName,
                plugin2 = L["Shadow & Light"],
                func2 = function()
                    lastSLTable[lastSLKey] = true
                    lastWTTable[lastWTKey] = false
                end
            }
        )
    end
end

function W:CheckCompatibilitymMediaTag(WTModuleName, MTModuleName, WTDB, MTDB)
    if not IsAddOnLoaded("ElvUI_mMediaTag") then
        return
    end

    if not (WTDB and MTDB and type(WTDB) == "string" and type(MTDB) == "string") then
        return
    end

    local realWTDB = E
    local lastWTTable, lastWTKey
    for _, key in ipairs {strsplit(".", WTDB)} do
        if key and strlen(key) > 0 then
            if realWTDB[key] ~= nil then
                if type(realWTDB[key]) == "boolean" then
                    lastWTTable = realWTDB
                    lastWTKey = key
                end
                realWTDB = realWTDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. WTDB)
                return
            end
        end
    end

    local realMTDB = E
    local lastMTTable, lastMTKey
    for _, key in ipairs {strsplit(".", MTDB)} do
        if key and strlen(key) > 0 then
            if realMTDB[key] ~= nil then
                if type(realMTDB[key]) == "boolean" then
                    lastMTTable = realMTDB
                    lastMTKey = key
                end
                realMTDB = realMTDB[key]
            else
                F.DebugMessage("Compatibility", "DB Error: " .. MTDB)
                return
            end
        end
    end

    if realMTDB == true and realWTDB == true then
        self:AddButtonToCompatibiltyFrame(
            {
                module1 = WTModuleName,
                plugin1 = L["WindTools"],
                func1 = function()
                    lastMTTable[lastMTKey] = false
                    lastWTTable[lastWTKey] = true
                end,
                module2 = MTModuleName,
                plugin2 = L["mMediaTag"],
                func2 = function()
                    lastMTTable[lastMTKey] = true
                    lastWTTable[lastWTKey] = false
                end
            }
        )
    end
end

function W:CheckCompatibility()
    self:ConstructCompatibiltyFrame()

    -- Merathilis UI
    self:CheckCompatibilityMerathilisUI(
        L["Extra Items Bar"],
        L["AutoButtons"],
        "db.WT.item.extraItemsBar.enable",
        "db.mui.autoButtons.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Game Bar"],
        L["Micro Bar"],
        "db.WT.misc.gameBar.enable",
        "db.mui.microBar.enable"
    )

    self:CheckCompatibilityMerathilisUI(L["Contacts"], L["Mail"], "db.WT.item.contacts.enable", "db.mui.mail.enable")

    self:CheckCompatibilityMerathilisUI(
        format("%s-%s", L["Tooltip"], L["Add Icon"]),
        format("%s-%s", L["Tooltip"], L["Tooltip Icons"]),
        "private.WT.tooltips.icon",
        "db.mui.tooltip.tooltipIcon"
    )

    self:CheckCompatibilityMerathilisUI(
        format("%s-%s", L["Tooltip"], L["Domination Rank"]),
        format("%s-%s", L["Tooltip"], L["Domination Rank"]),
        "private.WT.tooltips.dominationRank",
        "db.mui.tooltip.dominationRank"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Group Info"],
        L["LFG Info"],
        "db.WT.tooltips.groupInfo.enable",
        "db.mui.misc.lfgInfo.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Paragon Reputation"],
        L["Paragon Reputation"],
        "db.WT.quest.paragonReputation.enable",
        "db.mui.misc.paragon.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Role Icon"],
        L["Role Icon"],
        "private.WT.unitFrames.roleIcon.enable",
        "db.mui.unitframes.roleIcons"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Combat Alert"],
        L["Combat Alert"],
        "db.WT.combat.combatAlert.enable",
        "db.mui.CombatAlert.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Who Clicked Minimap"],
        L["Minimap Ping"],
        "db.WT.maps.whoClicked.enable",
        "db.mui.maps.minimap.ping.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Minimap Buttons"],
        L["Minimap Buttons"],
        "private.WT.maps.minimapButtons.enable",
        "db.mui.smb.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Rectangle Minimap"],
        L["Rectangle Minimap"],
        "db.WT.maps.rectangleMinimap.enable",
        "db.mui.maps.minimap.rectangleMinimap.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Chat Bar"],
        L["Chat Bar"],
        "db.WT.social.chatBar.enable",
        "db.mui.chat.chatBar.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Chat Link"],
        L["Chat Link"],
        "db.WT.social.chatLink.enable",
        "db.mui.chat.chatLink.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Raid Markers"],
        L["Raid Markers"],
        "db.WT.combat.raidMarkers.enable",
        "db.mui.raidmarkers.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        format("%s-%s", L["Chat Text"], L["Remove Brackets"]),
        L["Hide Player Brackets"],
        "db.WT.social.chatText.removeBrackets",
        "db.mui.chat.hidePlayerBrackets"
    )

    self:CheckCompatibilityMerathilisUI(
        format("%s-%s", L["Talent Manager"], L["Item Buttons"]),
        L["Codex Buttons"],
        "private.WT.combat.talentManager.itemButtons",
        "db.mui.misc.respec"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Super Tracker"],
        L["Super Tracker"],
        "private.WT.maps.superTracker.enable",
        "db.mui.maps.superTracker.enable"
    )

    self:CheckCompatibilityMerathilisUI(
        L["Instance Difficulty"],
        L["Raid Difficulty"],
        "private.WT.maps.instanceDifficulty.enable",
        "db.mui.maps.minimap.instanceDifficulty.enable"
    )

    -- S&L
    self:CheckCompatibilityShadowAndLight(
        L["Move Frames"],
        L["Move Blizzard frames"],
        "private.WT.misc.moveBlizzardFrames",
        "private.sle.module.blizzmove.enable"
    )

    self:CheckCompatibilityShadowAndLight(
        L["Rectangle Minimap"],
        L["Rectangle Minimap"],
        "db.WT.maps.rectangleMinimap.enable",
        "private.sle.minimap.rectangle"
    )

    self:CheckCompatibilityShadowAndLight(
        L["Raid Markers"],
        L["Raid Markers"],
        "db.WT.combat.raidMarkers.enable",
        "db.sle.raidmarkers.enable"
    )

    self:CheckCompatibilityShadowAndLight(
        format("%s-%s", L["Skins"], L["Scenario"]),
        format("%s-%s", L["Skins"], _G.OBJECTIVES_TRACKER_LABEL),
        "private.WT.skins.blizzard.scenario",
        "private.sle.skins.objectiveTracker.enable"
    )

    -- mMediaTag
    self:CheckCompatibilitymMediaTag(
        format("%s-%s", L["Tooltips"], L["Icon"]),
        L["Tooltip Icons"],
        "private.WT.tooltips.icon",
        "db.mMediaTag.mTIcon"
    )

    self:CheckCompatibilitymMediaTag(
        L["Objective Tracker"],
        L["ObjectiveTracker Skin"],
        "private.WT.quest.objectiveTracker.enable",
        "db.mMediaTag.mObjectiveTracker.enable"
    )

    if self.CompatibiltyFrame.numModules > 0 then
        self.CompatibiltyFrame:Show()
    end
end
