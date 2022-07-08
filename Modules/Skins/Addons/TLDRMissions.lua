local W, F, E, L = unpack(select(2, ...))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G

local function reskinCheckButton(name)
    local gui = _G.TLDRMissionsFrame
    if not gui then
        return
    end

    local frame = gui[name .. "CheckButton"] or gui[name] or _G[name]
    if not frame then
        return
    end

    frame:SetSize(22, 22)
    S:ESProxy("HandleCheckBox", frame)
end

local function reskinDropdownButton(name)
    local gui = _G.TLDRMissionsFrame
    if not gui then
        return
    end

    local dropDown = gui[name .. "DropDown"] or _G[name]
    if not dropDown then
        return
    end

    dropDown:StripTextures()
    local button = dropDown.Button
    S:ESProxy("HandleButton", button)

    local buttonWidth = button:GetWidth() or 24
    button:SetSize(buttonWidth - 4, buttonWidth - 4)

    local normalTexture = button:GetNormalTexture()
    local pushedTexture = button:GetPushedTexture()

    normalTexture:SetTexture(E.Media.Textures.ArrowUp)
    normalTexture:SetRotation(ES.ArrowRotation.down)
    normalTexture:SetInside(button, 2, 2)

    pushedTexture:SetTexture(E.Media.Textures.ArrowUp)
    pushedTexture:SetRotation(ES.ArrowRotation.down)
    pushedTexture:SetInside(button, 2, 2)
end

local function reskinMainPanel(gui)
    S:ESProxy("HandleTab", gui.MainTabButton, nil, "Transparent")
    S:ReskinTab(gui.MainTabButton)
    gui.MainTabButton:ClearAllPoints()
    gui.MainTabButton:SetPoint("TOPLEFT", gui, "BOTTOMLEFT", 0, -1)

    local function handleOptionLine(name)
        reskinCheckButton(name)
        reskinDropdownButton(name)
        reskinDropdownButton(name .. "AnimaCost")
    end

    handleOptionLine("Gold")
    handleOptionLine("Anima")
    handleOptionLine("FollowerXPItems")
    handleOptionLine("PetCharms")
    handleOptionLine("AugmentRunes")
    handleOptionLine("Reputation")
    handleOptionLine("FollowerXP")
    handleOptionLine("CraftingCache")
    handleOptionLine("Runecarver")
    handleOptionLine("Campaign")
    handleOptionLine("Gear")
    handleOptionLine("SanctumFeature")
    handleOptionLine("Sacrifice")

    S:ESProxy("HandleButton", gui.CalculateButton)
    S:ESProxy("HandleButton", gui.AbortButton)
    S:ESProxy("HandleButton", gui.SkipCalculationButton)
    S:ESProxy("HandleButton", gui.StartMissionButton)
    S:ESProxy("HandleButton", gui.SkipMissionButton)
    S:ESProxy("HandleButton", gui.CompleteMissionsButton)
end

local function reskinAdvancedPanel(gui)
    S:ESProxy("HandleTab", gui.AdvancedTabButton, nil, "Transparent")
    S:ReskinTab(gui.AdvancedTabButton)

    S:ESProxy("HandleRadioButton", gui.HardestRadioButton)
    S:ESProxy("HandleRadioButton", gui.EasiestRadioButton)
    S:ESProxy("HandleRadioButton", gui.FewestRadioButton)
    S:ESProxy("HandleRadioButton", gui.MostRadioButton)
    S:ESProxy("HandleRadioButton", gui.LowestRadioButton)
    S:ESProxy("HandleRadioButton", gui.HighestRadioButton)
    S:ESProxy("HandleSliderFrame", gui.MinimumTroopsSlider)

    reskinCheckButton("FollowerXPSpecialTreatment")
    reskinDropdownButton("FollowerXPSpecialTreatment")
    reskinDropdownButton("FollowerXPSpecialTreatmentAlgorithm")

    S:ESProxy("HandleSliderFrame", gui.LowerBoundLevelRestrictionSlider)
    S:ESProxy("HandleSliderFrame", gui.AnimaCostLimitSlider)
    S:ESProxy("HandleSliderFrame", gui.SimulationsPerFrameSlider)
    S:ESProxy("HandleEditBox", gui.MaxSimulationsEditBox)
    S:ESProxy("HandleSliderFrame", gui.DurationLowerSlider)
    S:ESProxy("HandleSliderFrame", gui.DurationHigherSlider)

    reskinCheckButton("AutoShowButton")
    reskinCheckButton("AllowProcessingAnywhereButton")
    reskinCheckButton("AutoStartButton")
end

local function reskinProfilePanel(gui)
    S:ESProxy("HandleTab", gui.ProfileTabButton, nil, "Transparent")
    S:ReskinTab(gui.ProfileTabButton)
end

function S:TLDRMissions()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tldrMissions then
        return
    end

    self:ESProxy("HandleButton", _G.TLDRMissionsToggleButton)

    -- Main GUI
    if _G.TLDRMissionsFrame then
        local gui = _G.TLDRMissionsFrame
        self:ESProxy("HandleButton", gui.shortcutButton)
        self:ESProxy("HandleCloseButton", gui.CloseButton)
        gui:StripTextures()
        gui:SetTemplate("Transparent")
        self:CreateShadow(gui)

        -- Main
        reskinMainPanel(gui)

        -- Advanced
        reskinAdvancedPanel(gui)

        -- Profile
        reskinProfilePanel(gui)
    end
end

S:AddCallbackForAddon("TLDRMissions")

-- Completely replace the 'AceGUI:Create' in TLDRMissions standalone libs
if _G.TLDRMissions then
    local aceGUIStandalone = _G.TLDRMissions.LibStub("AceGUI-3.0", true)
    local aceGUIGlobel = _G.LibStub("AceGUI-3.0", true)
    if aceGUIStandalone and aceGUIGlobel then
        aceGUIStandalone.Create = function(_, ...)
            return aceGUIGlobel:Create(...)
        end
    end
end
