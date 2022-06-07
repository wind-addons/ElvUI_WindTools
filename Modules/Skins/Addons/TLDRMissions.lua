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
    ES:HandleCheckBox(frame)
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
    ES:HandleButton(button)

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
    ES:HandleTab(gui.MainTabButton, nil, "Transparent")
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

    ES:HandleButton(gui.CalculateButton)
    ES:HandleButton(gui.AbortButton)
    ES:HandleButton(gui.SkipCalculationButton)
    ES:HandleButton(gui.StartMissionButton)
    ES:HandleButton(gui.SkipMissionButton)
    ES:HandleButton(gui.CompleteMissionsButton)
end

local function reskinAdvancedPanel(gui)
    ES:HandleTab(gui.AdvancedTabButton, nil, "Transparent")
    S:ReskinTab(gui.AdvancedTabButton)

    ES:HandleRadioButton(gui.HardestRadioButton)
    ES:HandleRadioButton(gui.EasiestRadioButton)
    ES:HandleRadioButton(gui.FewestRadioButton)
    ES:HandleRadioButton(gui.MostRadioButton)
    ES:HandleRadioButton(gui.LowestRadioButton)
    ES:HandleRadioButton(gui.HighestRadioButton)
    ES:HandleSliderFrame(gui.MinimumTroopsSlider)

    reskinCheckButton("FollowerXPSpecialTreatment")
    reskinDropdownButton("FollowerXPSpecialTreatment")
    reskinDropdownButton("FollowerXPSpecialTreatmentAlgorithm")

    ES:HandleSliderFrame(gui.LowerBoundLevelRestrictionSlider)
    ES:HandleSliderFrame(gui.AnimaCostLimitSlider)
    ES:HandleSliderFrame(gui.SimulationsPerFrameSlider)
    ES:HandleEditBox(gui.MaxSimulationsEditBox)
    ES:HandleSliderFrame(gui.DurationLowerSlider)
    ES:HandleSliderFrame(gui.DurationHigherSlider)

    reskinCheckButton("AutoShowButton")
    reskinCheckButton("AllowProcessingAnywhereButton")
    reskinCheckButton("AutoStartButton")
end

local function reskinProfilePanel(gui)
    ES:HandleTab(gui.ProfileTabButton, nil, "Transparent")
    S:ReskinTab(gui.ProfileTabButton)
end

function S:TLDRMissions()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tldrMissions then
        return
    end

    -- Toggle button in Mission Table
    if _G.TLDRMissionsToggleButton then
        ES:HandleButton(_G.TLDRMissionsToggleButton)
    end

    -- Main GUI
    if _G.TLDRMissionsFrame then
        local gui = _G.TLDRMissionsFrame
        ES:HandleCloseButton(gui.CloseButton)
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
