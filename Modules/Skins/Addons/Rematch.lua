local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local MF = W:GetModule("MoveFrames")
local Rematch = Rematch

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select
local unpack = unpack

local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
local CreateFrame = CreateFrame

local function ReskinIconButton(button)
    if button and not button.windStyle then
        button:StyleButton(nil, true)

        if button.Status then
            button.Status:SetTexture(E.media.blankTex)
            button.Status:SetVertexColor(1, 0, 0, 0.3)
        end

        if button.Texture then
            button.Texture:SetTexCoord(unpack(E.TexCoords))
        end

        if button.Icon then
            button.Icon:CreateBackdrop()
        end

        if button.IconBorder then
            button.IconBorder:Hide()
        end

        if button.Selected then
            button.Selected:SetTexture(E.media.blankTex)
            button.Selected:SetVertexColor(1, 1, 1, 0.3)
        end

        if button.hover and button.Icon then
            button.hover:ClearAllPoints()
            button.hover:SetAllPoints(button.Icon)
        end

        button.windStyle = true
    end
end

local function ReskinCloseButton(button)
    if not button then
        return
    end
    ES:HandleCloseButton(button)
    button.Icon = E.noop
    button.SetNormalTexture = E.noop
    button.SetPushedTexture = E.noop
    button.SetHighlightTexture = E.noop
end

local function ClearTextureButton(button, icon)
    if not button then
        return
    end
    if icon then
        icon = button.Icon:GetTexture()
    else
        button.Icon = E.noop
    end

    button:StripTextures()
    button.SetNormalTexture = E.noop
    button.SetPushedTexture = E.noop
    button.SetHighlightTexture = E.noop
    button.Icon:SetTexture(icon)
end

local function ReskinButton(button)
    for _, region in pairs {button:GetRegions()} do
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
            region.OldSetTexture = region.SetTexture
            region.SetTexture = E.noop
        end
    end
    ES:HandleButton(button, true)
end

local function ReskinFilterButton(button)
    if not button then
        return
    end
    ReskinButton(button)
    button.Arrow:OldSetTexture(E.Media.Textures.ArrowUp)
    button.Arrow:SetRotation(ES.ArrowRotation.right)
end

local function ReskinEditBox(editBox)
    local searchIconTex
    if editBox.SearchIcon and editBox.SearchIcon.GetTexture then
        searchIconTex = editBox.SearchIcon:GetTexture()
    end
    editBox:StripTextures()
    if searchIconTex then
        editBox.SearchIcon:SetTexture(searchIconTex)
    end

    ES:HandleEditBox(editBox)
    editBox.backdrop:SetOutside(0, 0)
end

local function ReskinDropdown(dropdown) -- modified from NDui
    dropdown:SetBackdrop(nil)
    dropdown:StripTextures()
    dropdown:CreateBackdrop()
    dropdown.backdrop:SetInside(dropdown, 2, 2)
    if dropdown.Icon then
        dropdown.Icon:SetAlpha(1)
        dropdown.Icon:CreateBackdrop()
    end
    local arrow = dropdown:GetChildren()
    ES:HandleNextPrevButton(arrow, "down")
end

local function ReskinScrollBar(scrollBar)
    ES:HandleScrollBar(scrollBar)
    scrollBar.Thumb.backdrop:ClearAllPoints()
    scrollBar.Thumb.backdrop:Point("TOPLEFT", scrollBar.Thumb, "TOPLEFT", 3, -3)
    scrollBar.Thumb.backdrop:Point("BOTTOMRIGHT", scrollBar.Thumb, "BOTTOMRIGHT", -1, 3)

    ReskinButton(scrollBar.BottomButton)
    local tex = scrollBar.BottomButton:GetNormalTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0)

    tex = scrollBar.BottomButton:GetPushedTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0.3)

    ReskinButton(scrollBar.TopButton)
    tex = scrollBar.TopButton:GetNormalTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0)

    tex = scrollBar.TopButton:GetPushedTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0.3)
end

local function ReskinXPBar(bar)
    if not bar then
        return
    end
    local iconTex = bar.Icon and bar.Icon:GetTexture()
    bar:StripTextures()
    if iconTex then
        bar.Icon:SetTexture(iconTex)
    end
    bar:SetStatusBarTexture(E.media.normTex)
    bar:CreateBackdrop("Transparent")
end

local function ReskinCard(card) -- modified from NDui
    if not card then
        return
    end

    card:SetBackdrop(nil)
    card:CreateBackdrop("Transparent")
    S:CreateBackdropShadow(card)

    if card.Source then
        card.Source:StripTextures()
    end

    card.Middle:StripTextures()

    if card.Middle.XP then
        ReskinXPBar(card.Middle.XP)
        card.Middle.XP:Height(15)
    end

    if card.Middle.Lore then
        F.SetFontOutline(card.Middle.Lore, E.db.general.font)
        card.Middle.Lore:SetTextColor(1, 1, 1, 1)
    end

    if card.Bottom.AbilitiesBG then
        card.Bottom.AbilitiesBG:Hide()
    end

    if card.Bottom.BottomBG then
        card.Bottom.BottomBG:Hide()
    end
end

local function ReskinInset(frame)
    if not frame or frame.windStyle then
        return
    end

    frame:StripTextures()
    frame:CreateBackdrop()
    frame.backdrop:SetInside(frame, 2, 2)
    frame.backdrop.Center:SetVertexColor(1, 1, 1, 0.3)
    frame.windStyle = true
end

local function ReskinTooltip(tooltip)
    if not tooltip then
        return
    end

    tooltip:StripTextures()
    tooltip:CreateBackdrop("Transparent")
    S:CreateBackdropShadow(tooltip)
end

local function ReskinPetList(list) -- modified from NDui
    local buttons = list.ScrollFrame.Buttons
    if not buttons then
        return
    end
    for i = 1, #buttons do
        local button = buttons[i]
        if not button.windStyle then
            if button.Pet then
                button.Pet:CreateBackdrop()

                if button.Status then
                    button.Status:SetTexture(E.media.blankTex)
                    button.Status:SetVertexColor(1, 0, 0, 0.3)
                end

                if button.Rarity then
                    button.Pet.backdrop:SetBackdropBorderColor(button.Rarity:GetVertexColor())
                    button.Rarity:SetTexture(nil)
                end
                if button.LevelBack then
                    button.LevelBack:SetTexture(nil)
                end
                button.LevelText:SetTextColor(1, 1, 1)
                button.LevelText:FontTemplate()
                parent = button.Pet
            end

            if button.Back then
                button.Back:SetTexture(nil)
            end

            for _, child in pairs {button:GetChildren()} do
                if child:GetNumChildren() == 0 and child:GetNumRegions() == 8 then
                    child:StripTextures()
                    child.tex = child:CreateTexture(nil)
                    child.tex:SetInside(child, 1, 1)
                    child.tex:SetTexture(E.media.blankTex)
                    child.tex:SetVertexColor(1, 1, 1, 0.3)
                    break
                end
            end

            ES:HandleButton(button)
            if not button.Pet then
                button.backdrop:SetInside(button, 1, 1)
            else
                button.backdrop:SetInside(button, 1, 0)
            end

            if button.Back then
                button.Back:SetTexture(nil)
            end

            if not button.Back:IsShown() then
                button.backdrop:Hide()
            end

            button.windStyle = true
        else
            if button.Back:IsShown() then
                button.backdrop:Show()
            else
                button.backdrop:Hide()
            end
        end
    end
end

local function ReskinOptions(list)
    local buttons = list.ScrollFrame.Buttons
    if not buttons then
        return
    end
    for i = 1, #buttons do
        local button = buttons[i]
        if not button.windStyle then
            ES:HandleButton(button)
            button.backdrop:SetInside(button, 1, 1)
            button.HeaderBack:StripTextures()
            button.HeaderBack = button.backdrop
            button.windStyle = true
        end
    end
end

local function ReskinTeamList(panel)
    if panel then
        for i = 1, 3 do
            local loadout = panel.Loadouts[i]
            if loadout and not loadout.windStyle then
                loadout:StripTextures()
                ES:HandleButton(loadout)
                loadout.backdrop:SetInside(loadout, 2, 2)
                ReskinIconButton(loadout.Pet.Pet)
                if loadout.Pet.Pet.Level then
                    loadout.Pet.Pet.Level.Text:SetTextColor(1, 1, 1)
                    loadout.Pet.Pet.Level.Text:FontTemplate()
                    loadout.Pet.Pet.Level.BG:SetTexture(nil)
                end
                ReskinXPBar(loadout.HP)
                ReskinXPBar(loadout.XP)
                loadout.XP:SetSize(255, 7)
                loadout.HP.MiniHP:SetText("HP")
                for j = 1, 3 do
                    ReskinIconButton(loadout.Abilities[j])
                end

                loadout.windStyle = true
            end
        end
    end
end

local function ReskinFlyout(frame)
    if not frame or frame.windStyle then
        return
    end

    frame:SetBackdrop(nil)
    frame:CreateBackdrop()
    frame.backdrop:SetInside(frame, 2, 2)
    S:CreateBackdropShadow(frame)
    hooksecurefunc(
        frame,
        "Show",
        function(self)
            local abilities = self.Abilities
            if abilities then
                for i = 1, #abilities do
                    local ability = abilities[i]
                    ReskinIconButton(ability)
                end
            end
        end
    )
    frame.windStyle = true
end

function S:Rematch_Header()
    -- 标题
    _G.RematchJournal.TitleBg:StripTextures()
    F.SetFontOutline(_G.RematchJournal.TitleText)

    -- 宠物数目
    if _G.RematchToolbar.PetCount then
        local PetCount = _G.RematchToolbar.PetCount
        PetCount.SetHighlightTexture = E.noop
        PetCount:StripTextures()
        PetCount:CreateBackdrop()
        PetCount.backdrop:Point("TOPLEFT", 0, -3)
        F.SetFontOutline(PetCount.Total)
        F.SetFontOutline(PetCount.TotalLabel)
        F.SetFontOutline(PetCount.Unique)
        F.SetFontOutline(PetCount.UniqueLabel)
    end

    -- 右上按钮
    ReskinIconButton(_G.RematchHealButton)
    ReskinIconButton(_G.RematchBandageButton)
    ReskinIconButton(_G.RematchToolbar.SafariHat)
    ReskinIconButton(_G.RematchLesserPetTreatButton)
    ReskinIconButton(_G.RematchPetTreatButton)
    ReskinIconButton(_G.RematchToolbar.SummonRandom)
    ReskinIconButton(_G.RematchToolbar.FindBattle)
end

function S:Rematch_LeftTop()
    for _, region in pairs {_G.RematchPetPanel.Top:GetRegions()} do
        region:Hide()
    end

    if _G.RematchPetPanel.Top.SearchBox then
        local searchBox = _G.RematchPetPanel.Top.SearchBox
        ReskinEditBox(searchBox)
        searchBox:ClearAllPoints()
        searchBox:Point("TOPLEFT", _G.RematchPetPanel.Top.Toggle, "TOPRIGHT", 2, 0)
        searchBox:Point("BOTTOMRIGHT", _G.RematchPetPanel.Top.Filter, "BOTTOMLEFT", -2, 0)
    end

    ReskinButton(_G.RematchPetPanel.Top.Toggle)
    _G.RematchPetPanel.Top.Toggle:StripTextures()

    _G.RematchPetPanel.Top.Toggle.Texture = _G.RematchPetPanel.Top.Toggle:CreateTexture(nil, "OVERLAY")
    _G.RematchPetPanel.Top.Toggle.Texture:Point("CENTER")
    _G.RematchPetPanel.Top.Toggle.Texture:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchPetPanel.Top.Toggle.Texture:Size(14, 14)

    self:SecureHook(
        _G.Rematch,
        "SetTopToggleButton",
        function()
            if _G.RematchPetPanel.Top.Toggle.up then
                _G.RematchPetPanel.Top.Toggle.Texture:SetRotation(ES.ArrowRotation["up"])
            else
                _G.RematchPetPanel.Top.Toggle.Texture:SetRotation(ES.ArrowRotation["down"])
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnEnter",
        function(self)
            if self.Texture then
                self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnLeave",
        function(self)
            if self.Texture then
                self.Texture:SetVertexColor(1, 1, 1)
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnClick",
        function(self)
            self:SetNormalTexture("")
            self:SetPushedTexture("")
            if self.up then
                self.Texture:SetRotation(ES.ArrowRotation.up)
            else
                self.Texture:SetRotation(ES.ArrowRotation.down)
            end
        end
    )
    ReskinFilterButton(_G.RematchPetPanel.Top.Filter)
end

function S:Rematch_LeftBottom()
    if not _G.RematchPetPanel.List then
        return
    end

    local list = _G.RematchPetPanel.List

    list.Background:Kill()
    list:CreateBackdrop()
    list.backdrop:SetInside(list, 1, 2)
    ReskinScrollBar(list.ScrollFrame.ScrollBar)

    hooksecurefunc(_G.RematchPetPanel.List, "Update", ReskinPetList)
    hooksecurefunc(_G.RematchQueuePanel.List, "Update", ReskinPetList)
end

function S:Rematch_Middle() -- Modified from NDui
    local panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.Target
    if panel then
        panel:StripTextures()
        panel:CreateBackdrop()
        ReskinButton(panel.TargetButton)
        panel.ModelBorder:SetBackdrop(nil)
        panel.ModelBorder:DisableDrawLayer("BACKGROUND")
        panel.ModelBorder:CreateBackdrop("Transparent")
        panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
        ReskinButton(panel.LoadSaveButton)
        for i = 1, 3 do
            local button = panel["Pet" .. i]
            if button then
                button:StripTextures()
                ReskinIconButton(button)
            end
        end
    end

    ReskinTeamList(_G.RematchLoadoutPanel)
    ReskinFlyout(_G.RematchLoadoutPanel.Flyout)
    hooksecurefunc(_G.RematchLoadoutPanel, "UpdateLoadouts", ReskinTeamList)

    -- Target Panel
    panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.TargetPanel
    if panel then
        panel.Top:StripTextures()
        ReskinButton(panel.Top.BackButton)
        ReskinEditBox(panel.Top.SearchBox)
        panel.Top.SearchBox:ClearAllPoints()
        panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
        panel.Top.SearchBox:Point("RIGHT", panel.Top.BackButton, "LEFT", -2, 0)
        panel.List.Background:Kill()
        panel.List:CreateBackdrop()
        panel.List.backdrop:SetInside(panel.List, 2, 2)
        ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
        hooksecurefunc(panel.List, "Update", ReskinPetList)
    end
end

function S:Rematch_Right() -- Modified from NDui
    -- Team Panel
    local panel = _G.RematchTeamPanel
    if panel then
        panel.Top:StripTextures()
        ReskinEditBox(panel.Top.SearchBox)
        panel.Top.SearchBox:ClearAllPoints()
        panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
        panel.Top.SearchBox:Point("RIGHT", panel.Top.Teams, "LEFT", -2, 0)
        ReskinFilterButton(panel.Top.Teams)
        panel.List.Background:Kill()
        panel.List:CreateBackdrop()
        panel.List.backdrop:SetInside(panel.List, 0, 2)
        ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
        hooksecurefunc(panel.List, "Update", ReskinPetList)
    end

    -- Queue Panel
    panel = _G.RematchQueuePanel
    if panel then
        panel.Top:StripTextures()
        ReskinFilterButton(panel.Top.QueueButton)
        panel.List.Background:Kill()
        panel.List:CreateBackdrop()
        panel.List.backdrop:SetInside(panel.List, 2, 2)
        ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
        hooksecurefunc(panel.List, "Update", ReskinPetList)
    end

    -- Option Panel
    panel = _G.RematchOptionPanel
    if panel then
        panel.Top:StripTextures()
        ReskinEditBox(panel.Top.SearchBox)
        for i = 1, 4 do
            ReskinIconButton(panel.Growth.Corners[i])
        end
        panel.List.Background:Kill()
        panel.List:CreateBackdrop()
        panel.List.backdrop:SetInside(panel.List, 2, 2)
        ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
        hooksecurefunc(panel.List, "Update", ReskinOptions)
    end
end

function S:Rematch_Footer()
    -- Tabs
    for _, tab in pairs {_G.RematchJournal.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadow(tab)
    end

    -- Buttons
    ReskinButton(_G.RematchBottomPanel.SummonButton)
    ReskinButton(_G.RematchBottomPanel.SaveButton)
    ReskinButton(_G.RematchBottomPanel.SaveAsButton)
    ReskinButton(_G.RematchBottomPanel.FindBattleButton)
    ES:HandleCheckBox(_G.RematchBottomPanel.UseDefault)

    hooksecurefunc(
        _G.RematchJournal,
        "SetupUseRematchButton",
        function()
            if _G.UseRematchButton then
                ES:HandleCheckBox(_G.UseRematchButton)
            end
        end
    )
end

function S:Rematch_Dialog() -- Modified from NDui
    if not _G.RematchDialog then
        return
    end

    -- Background
    local dialog = _G.RematchDialog
    dialog:StripTextures()
    dialog.Prompt:StripTextures()
    dialog:CreateBackdrop("Transparent")
    self:CreateBackdropShadow(dialog)

    -- Buttons
    ReskinCloseButton(dialog.CloseButton)
    ReskinButton(dialog.Accept)
    ReskinButton(dialog.Cancel)

    -- Icon selector
    ReskinIconButton(dialog.Slot)
    ReskinEditBox(dialog.EditBox)
    dialog.TeamTabIconPicker:StripTextures()
    dialog.TeamTabIconPicker:CreateBackdrop()
    ES:HandleScrollBar(dialog.TeamTabIconPicker.ScrollFrame.ScrollBar)
    hooksecurefunc(
        _G.RematchTeamTabs,
        "UpdateTabIconPickerList",
        function()
            -- modified from NDui
            local buttons = dialog.TeamTabIconPicker.ScrollFrame.buttons
            for i = 1, #buttons do
                local line = buttons[i]
                for j = 1, 10 do
                    local button = line.Icons[j]
                    if button and not button.windStyle then
                        button:Size(26, 26)
                        button.Icon = button.Texture
                        ReskinIconButton(button)
                        button.windStyle = true
                    end
                end
            end
        end
    )

    -- Checkbox
    ES:HandleCheckBox(dialog.CheckButton)

    -- Dropdown
    ReskinDropdown(dialog.SaveAs.Target)
    ReskinDropdown(dialog.TabPicker)

    -- Save as [team]
    hooksecurefunc(
        _G.Rematch,
        "UpdateSaveAsDialog",
        function()
            for i = 1, 3 do
                local button = _G.RematchDialog.SaveAs.Team.Pets[i]
                ReskinIconButton(button)
                button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
                local abilities = button.Abilities
                if abilities then
                    for j = 1, #abilities do
                        ReskinIconButton(abilities[j])
                    end
                end
            end
        end
    )

    -- Collection
    local collection = dialog.CollectionReport
    hooksecurefunc(
        Rematch,
        "ShowCollectionReport",
        function()
            for i = 1, 4 do
                local bar = collection.RarityBar[i]
                bar:SetTexture(E.media.normTex)
            end
            if not collection.RarityBarBorder.backdrop then
                collection.RarityBarBorder:StripTextures()
                collection.RarityBarBorder:CreateBackdrop("Transparent")
                collection.RarityBarBorder.backdrop:SetInside(collection.RarityBarBorder, 6, 5)
            end
        end
    )

    hooksecurefunc(
        collection,
        "UpdateChart",
        function()
            for i = 1, 10 do
                local col = collection.Chart.Columns[i]
                col.Bar:SetTexture(E.media.blankTex)
                col.IconBorder:Hide()
            end
        end
    )
    ReskinDropdown(collection.ChartTypeComboBox)
    collection.Chart:StripTextures()
    collection.Chart:CreateBackdrop("Transparent")
    collection.Chart.backdrop:SetInside(collection.Chart, 2, 2)
    ES:HandleRadioButton(collection.ChartTypesRadioButton)
    ES:HandleRadioButton(collection.ChartSourcesRadioButton)
end

function S:Rematch_AbilityCard()
    if not _G.RematchAbilityCard then
        return
    end

    local card = _G.RematchAbilityCard
    card:SetBackdrop(nil)
    card.TitleBG:SetAlpha(0)
    card.Hints.HintsBG:SetAlpha(0)
    card:CreateBackdrop("Transparent")
    self:CreateBackdropShadow(card)
end

function S:Rematch_PetCard()
    if not _G.RematchPetCard then
        return
    end

    local card = _G.RematchPetCard
    card:StripTextures()
    card.Title:StripTextures()
    card:CreateBackdrop("Transparent")
    self:CreateBackdropShadow(card)
    ReskinCloseButton(card.CloseButton)
    ES:HandleNextPrevButton(card.PinButton, "up")
    card.PinButton:ClearAllPoints()
    card.PinButton:Point("TOPLEFT", 3, -3)
    ReskinCard(card.Front)
    ReskinCard(card.Back)

    for i = 1, 6 do
        local button = card.Front.Bottom.Abilities[i]
        button.IconBorder:Kill()
        select(8, button:GetRegions()):SetTexture(nil)
        ReskinIconButton(button.Icon)
    end
end

function S:Rematch_RightTabs()
    hooksecurefunc(
        _G.RematchTeamTabs,
        "Update",
        function(tabs)
            for _, tab in next, tabs.Tabs do
                if tab and not tab.windStyle then
                    tab.Background:Kill()
                    ReskinIconButton(tab)
                    self:CreateBackdropShadow(tab.Icon)
                    tab:Size(40, 40)
                    tab.windStyle = true
                end
            end
        end
    )
end

function S:Rematch_Standalone()
    if not _G.RematchFrame then
        return
    end

    local frame = _G.RematchFrame
    frame:StripTextures()
    frame:CreateBackdrop()
    self:CreateBackdropShadow(frame)

    frame.TitleBar:StripTextures()
    ReskinCloseButton(frame.TitleBar.CloseButton)
    ClearTextureButton(frame.TitleBar.MinimizeButton, true)
    ClearTextureButton(frame.TitleBar.SinglePanelButton, true)
    ClearTextureButton(frame.TitleBar.LockButton, true)

    for _, tab in pairs {frame.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadow(tab)
    end

    -- Mini Panel
    local mini = _G.RematchMiniPanel
    if mini then
        ReskinFlyout(mini.Flyout)
        hooksecurefunc(
            mini,
            "Update",
            function(panel)
                panel.Background:Kill()
                local pets = panel.Pets
                for i = 1, 3 do
                    local button = panel.Pets[i]
                    ReskinIconButton(button)
                    button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
                    local abilities = button.Abilities
                    if abilities then
                        for j = 1, #abilities do
                            ReskinIconButton(abilities[j])
                        end
                    end
                    ReskinXPBar(button.HP)
                    ReskinXPBar(button.XP)
                end
            end
        )
    end
end

function S:Rematch_SkinLoad()
    if _G.RematchJournal.skinLoaded then
        return
    end

    S:Rematch_Middle()

    -- Mini frame target
    if _G.RematchMiniPanel.Target then
        local panel = _G.RematchMiniPanel.Target
        local greenCheckTex = panel.GreenCheck and panel.GreenCheck:GetTexture()
        panel:StripTextures()
        if greenCheckTex then
            panel.GreenCheck:SetTexture(greenCheckTex)
        end
        panel:CreateBackdrop()
        panel.ModelBorder:SetBackdrop(nil)
        panel.ModelBorder:DisableDrawLayer("BACKGROUND")
        panel.ModelBorder:CreateBackdrop("Transparent")
        panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
        ReskinButton(panel.LoadButton)
        for i = 1, 3 do
            local button = panel.Pets[i]
            if button then
                ReskinIconButton(button)
            end
        end
    end

    -- Tooltip
    ReskinTooltip(_G.RematchTooltip)
    ReskinTooltip(_G.RematchTableTooltip)
    ReskinTooltip(_G.FloatingPetBattleAbilityTooltip)
    for i = 1, 3 do
        local menu = _G.Rematch:GetMenuFrame(i, UIParent)
        menu:StripTextures()
        menu:CreateBackdrop("Transparent")
        S:CreateBackdropShadow(menu)
        menu.Title:StripTextures()
        menu.Title:CreateBackdrop()
        menu.Title.backdrop:SetBackdropColor(1, 0.8, 0, 0.25)
    end

    -- Compatible with Move Frames module
    if MF and MF.db and MF.db.moveBlizzardFrames then
        if not _G.CollectionsJournal then
            CollectionsJournal_LoadUI()
        end
        MF:HandleFrame(_G.RematchJournal, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchToolbar, _G.CollectionsJournal)
    end

    RematchJournal.skinLoaded = true
end

function S:Rematch()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
        return
    end

    if not _G.RematchJournal then
        return
    end

    -- Background
    _G.RematchJournal:StripTextures()
    _G.RematchJournal.portrait:Hide()
    _G.RematchJournal:CreateBackdrop()
    self:CreateBackdropShadow(_G.RematchJournal, true)
    ES:HandleCloseButton(_G.RematchJournal.CloseButton)

    -- Main
    self:Rematch_Header()
    self:Rematch_LeftTop()
    self:Rematch_LeftBottom()
    self:Rematch_Right()
    self:Rematch_Footer()

    -- Misc
    self:Rematch_Dialog()
    self:Rematch_AbilityCard()
    self:Rematch_PetCard()
    self:Rematch_RightTabs()
    self:Rematch_Standalone()
    ReskinInset(_G.RematchLoadedTeamPanel)
    hooksecurefunc(_G.RematchJournal, "ConfigureJournal", self.Rematch_SkinLoad)
    hooksecurefunc(_G.RematchFrame, "ConfigureFrame", self.Rematch_SkinLoad)
end

S:AddCallbackForAddon("Rematch")
