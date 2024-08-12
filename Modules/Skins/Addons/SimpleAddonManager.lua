local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function ReskinScrollFrameItems(frame, template)
    if template == "SimpleAddonManagerAddonItem" or template == "SimpleAddonManagerCategoryItem" then
        for _, btn in pairs(frame.buttons) do
            if not btn.__windSkin then
                F.SetFontOutline(btn.Name)
                S:ESProxy("HandleCheckBox", btn.EnabledButton)
                if btn.ExpandOrCollapseButton then
                    S:ESProxy("HandleCollapseTexture", btn.ExpandOrCollapseButton)
                end
                btn.__windSkin = true
            end
        end
    end
end

local function ReskinModules(frame)
    -- MainFrame
    S:ESProxy("HandleButton", frame.OkButton)
    S:ESProxy("HandleButton", frame.CancelButton)
    S:ESProxy("HandleButton", frame.EnableAllButton)
    S:ESProxy("HandleButton", frame.DisableAllButton)
    S:ESProxy("HandleDropDownBox", frame.CharacterDropDown, nil, nil, true)

    frame.OkButton:ClearAllPoints()
    frame.OkButton:SetPoint("RIGHT", frame.CancelButton, "LEFT", -2, 0)
    frame.DisableAllButton:ClearAllPoints()
    frame.DisableAllButton:SetPoint("LEFT", frame.EnableAllButton, "RIGHT", 2, 0)

    -- SearchBox
    S:ESProxy("HandleEditBox", frame.SearchBox)

    -- AddonListFrame
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)

    -- CategoryFrame
    S:ESProxy("HandleButton", frame.CategoryFrame.NewButton)
    S:ESProxy("HandleButton", frame.CategoryFrame.SelectAllButton)
    S:ESProxy("HandleButton", frame.CategoryFrame.ClearSelectionButton)
    S:ESProxy("HandleButton", frame.CategoryButton)
    S:ESProxy("HandleScrollBar", frame.CategoryFrame.ScrollFrame.ScrollBar)

    frame.CategoryFrame.NewButton:ClearAllPoints()
    frame.CategoryFrame.NewButton:SetHeight(20)
    frame.CategoryFrame.NewButton:SetPoint("BOTTOMLEFT", frame.CategoryFrame.SelectAllButton, "TOPLEFT", 0, 2)
    frame.CategoryFrame.NewButton:SetPoint("BOTTOMRIGHT", frame.CategoryFrame.ClearSelectionButton, "TOPRIGHT", 0, 2)

    -- Profile
    S:ESProxy("HandleButton", frame.SetsButton)
    S:ESProxy("HandleButton", frame.ConfigButton)

    -- Misc
    hooksecurefunc("HybridScrollFrame_CreateButtons", ReskinScrollFrameItems)
    ReskinScrollFrameItems(frame.ScrollFrame, "SimpleAddonManagerAddonItem")
    ReskinScrollFrameItems(frame.CategoryFrame.ScrollFrame, "SimpleAddonManagerCategoryItem")
end

function S:SimpleAddonManager()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.simpleAddonManager then
        return
    end

    if not _G.SimpleAddonManager then
        return
    end

    hooksecurefunc(_G.SimpleAddonManager, "Initialize", ReskinModules)

    _G.SimpleAddonManager:StripTextures(true)
    _G.SimpleAddonManager:SetTemplate("Transparent")
    self:CreateShadow(_G.SimpleAddonManager)
    self:ESProxy("HandleCloseButton", _G.SimpleAddonManager.CloseButton)

    local edd = _G.LibStub("ElioteDropDownMenu-1.0", true)
    if edd then
        hooksecurefunc(
            edd,
            "UIDropDownMenu_CreateFrames",
            function(level)
                if _G["ElioteDDM_DropDownList" .. level] and not _G["ElioteDDM_DropDownList" .. level].__windSkin then
                    _G["ElioteDDM_DropDownList" .. level .. "Backdrop"]:SetTemplate("Transparent")
                    _G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"]:SetTemplate("Transparent")
                    self:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "Backdrop"])
                    self:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"])
                    _G["ElioteDDM_DropDownList" .. level].__windSkin = true
                end
            end
        )
    end
end

S:AddCallbackForAddon("SimpleAddonManager")
