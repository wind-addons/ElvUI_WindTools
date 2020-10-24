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
    desc:Width(530)
    F.SetFontOutline(desc, nil, "-1")
    desc:SetText(
        format(
            "%s\n%s\n%s",
            L[
                "There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."
            ],
            L["Choose the module you preferred to use in-game."],
            format(L["Have a good time with %s!"], L["WindTools"])
        )
    )
    desc:Point("TOPLEFT", frame, "TOPLEFT", 10, -40)

    local scrollFrame = CreateFrame("Frame", "WTCompatibiltyFrameScrollFrame", frame, "BackdropTemplate")
    scrollFrame:CreateBackdrop("Transparent")
    scrollFrame:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    scrollFrame:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
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
    leftButton:Point("TOPLEFT", frame.scrollFrame, "TOPLEFT", 15, -frame.numModules * 50 + 40)
    ES:HandleButton(leftButton)
    leftButton:SetScript(
        "OnClick",
        function()
            data.func1()
            frame.configChanged = true
        end
    )

    local middleTexture = frame:CreateTexture("WTCompatibiltyFrameMiddleTexture" .. frame.numModules, "ARTWORK")
    middleTexture:Point("CENTER")
    middleTexture:Size(24)
    middleTexture:SetTexture(W.Media.Icons.convert)
    middleTexture:SetVertexColor(1, 1, 1)
    middleTexture:Point("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 20)

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
    rightButton:Point("TOPRIGHT", frame.scrollFrame, "TOPRIGHT", -15, -frame.numModules * 50 + 40)
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
                E.db.mui.autoButtons.enable = false
            end,
            disableWTModule = function()
                E.db.WT.item.extraItemsBar.enable = false
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
                E.db.mui.microBar.enable = false
            end,
            disableWTModule = function()
                E.db.WT.misc.gameBar.enable = false
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
                E.db.mui.mail.enable = false
            end,
            disableWTModule = function()
                E.db.WT.item.contacts.enable = false
            end
        }
    )

    if self.CompatibiltyFrame.numModules > 0 then
        self.CompatibiltyFrame:Show()
    end
end
