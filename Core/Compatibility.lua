local W, F, E, L, V, P, G = unpack(select(2, ...))
local MF = W.Modules.MoveFrames
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

function W:ConstructCompatibiltyFrame()
    local frame = CreateFrame("Frame", "WTCompatibiltyFrame", E.UIParent)
    frame:Size(550, 500)
    frame:Point("CENTER")
    frame:CreateBackdrop("Transparent")
    S:CreateShadow(frame)
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

    local scrollFrameParent =
        CreateFrame("ScrollFrame", "WTCompatibiltyFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
    scrollFrameParent:CreateBackdrop("Transparent")
    scrollFrameParent:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    scrollFrameParent:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -32, 30)
    ES:HandleScrollBar(scrollFrameParent.ScrollBar)
    local scrollFrame = CreateFrame("Frame", "WTCompatibiltyFrameScrollFrame", scrollFrameParent)
    scrollFrame:SetSize(scrollFrameParent:GetSize())

    scrollFrameParent:SetScrollChild(scrollFrame)
    frame.scrollFrameParent = scrollFrameParent
    frame.scrollFrame = scrollFrame

    local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
    bottomDesc:FontTemplate()
    bottomDesc:SetJustifyH("LEFT")
    bottomDesc:Width(530)
    F.SetFontOutline(bottomDesc, nil, "-1")
    bottomDesc:SetText(
        E.NewSign .. L["If you find the WindTools module conflicts with another addon, alert me via Discord."]
    )
    --bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
    bottomDesc:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

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
        function()
            data.func1()
            frame.configChanged = true
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
        function()
            data.func2()
            frame.configChanged = true
        end
    )
end

function W:CheckCompatibilityMerathilisUI(WTModuleName, MUIModuleName, Functions)
    if not IsAddOnLoaded("ElvUI_MerathilisUI") then
        return
    end

    if Functions.check and Functions.check() then
        self:AddButtonToCompatibiltyFrame(
            {
                module1 = WTModuleName,
                plugin1 = L["WindTools"],
                func1 = Functions.disableMUIModule,
                module2 = MUIModuleName,
                plugin2 = L["MerathilisUI"],
                func2 = Functions.disableWTModule
            }
        )
    end
end

function W:CheckCompatibility()
    self:ConstructCompatibiltyFrame()
    self:CheckCompatibilityMerathilisUI(
        L["Extra Items Bar"],
        L["AutoButtons"],
        {
            check = function()
                if E.db.WT.item.extraItemsBar.enable and E.db.mui.autoButtons.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.item.extraItemsBar.enable = true
                E.db.mui.autoButtons.enable = false
            end,
            disableWTModule = function()
                E.db.WT.item.extraItemsBar.enable = false
                E.db.mui.autoButtons.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Game Bar"],
        L["Micro Bar"],
        {
            check = function()
                if E.db.WT.misc.gameBar.enable and E.db.mui.microBar.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.misc.gameBar.enable = true
                E.db.mui.microBar.enable = false
            end,
            disableWTModule = function()
                E.db.WT.misc.gameBar.enable = false
                E.db.mui.microBar.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Contacts"],
        L["Mail"],
        {
            check = function()
                if E.db.WT.item.contacts.enable and E.db.mui.mail.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.item.contacts.enable = true
                E.db.mui.mail.enable = false
            end,
            disableWTModule = function()
                E.db.WT.item.contacts.enable = false
                E.db.mui.mail.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        format("%s-%s", L["Tooltip"], L["Add Icon"]),
        L["Tooltip Icons"],
        {
            check = function()
                if E.private.WT.tooltips.icon and E.db.mui.tooltip.tooltipIcon then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.private.WT.tooltips.icon = true
                E.db.mui.tooltip.tooltipIcon = false
            end,
            disableWTModule = function()
                E.private.WT.tooltips.icon = false
                E.db.mui.tooltip.tooltipIcon = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Group Info"],
        L["LFG Info"],
        {
            check = function()
                if E.db.WT.tooltips.groupInfo.enable and E.db.mui.misc.lfgInfo.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.tooltips.groupInfo.enable = true
                E.db.mui.misc.lfgInfo.enable = false
            end,
            disableWTModule = function()
                E.db.WT.tooltips.groupInfo.enable = false
                E.db.mui.misc.lfgInfo.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Paragon Reputation"],
        L["Paragon Reputation"],
        {
            check = function()
                if E.db.WT.quest.paragonReputation.enable and E.db.mui.misc.paragon.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.quest.paragonReputation.enable = true
                E.db.mui.misc.paragon.enable = false
            end,
            disableWTModule = function()
                E.db.WT.quest.paragonReputation.enable = false
                E.db.mui.misc.paragon.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Role Icon"],
        L["Role Icon"],
        {
            check = function()
                if E.private.WT.unitFrames.roleIcon.enable and E.db.mui.unitframes.roleIcons then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.private.WT.unitFrames.roleIcon.enable = true
                E.db.mui.unitframes.roleIcons = false
            end,
            disableWTModule = function()
                E.private.WT.unitFrames.roleIcon.enable = false
                E.db.mui.unitframes.roleIcons = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Combat Alert"],
        L["Combat Alert"],
        {
            check = function()
                if E.db.WT.combat.combatAlert.enable and E.db.mui.CombatAlert.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.combat.combatAlert.enable = true
                E.db.mui.CombatAlert.enable = false
            end,
            disableWTModule = function()
                E.db.WT.combat.combatAlert.enable = false
                E.db.mui.CombatAlert.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Who Clicked Minimap"],
        L["Minimap Ping"],
        {
            check = function()
                if E.db.WT.maps.whoClicked.enable and E.db.mui.maps.minimap.ping.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.maps.whoClicked.enable = true
                E.db.mui.maps.minimap.ping.enable = false
            end,
            disableWTModule = function()
                E.db.WT.maps.whoClicked.enable = false
                E.db.mui.maps.minimap.ping.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Minimap Buttons"],
        L["Minimap Buttons"],
        {
            check = function()
                if E.private.WT.maps.minimapButtons.enable and E.db.mui.smb.enable then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.private.WT.maps.minimapButtons.enable = true
                E.db.mui.smb.enable = false
            end,
            disableWTModule = function()
                E.private.WT.maps.minimapButtons.enable = false
                E.db.mui.smb.enable = true
            end
        }
    )

    self:CheckCompatibilityMerathilisUI(
        L["Rectangle Minimap"],
        L["Rectangle Minimap"],
        {
            check = function()
                if E.db.WT.maps.rectangleMinimap.enable and E.db.mui.maps.minimap.rectangle then
                    return true
                end
                return false
            end,
            disableMUIModule = function()
                E.db.WT.maps.rectangleMinimap.enable = true
                E.db.mui.maps.minimap.rectangle = false
            end,
            disableWTModule = function()
                E.db.WT.maps.rectangleMinimap.enable = false
                E.db.mui.maps.minimap.rectangle = true
            end
        }
    )

    if self.CompatibiltyFrame.numModules > 0 then
        self.CompatibiltyFrame:Show()
    end
end
