local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local MF = W:GetModule("MoveFrames")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
local CreateFrame = CreateFrame

function S:Rematch_Top()
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
    local function HandleIconButton(frame)
        frame:StyleButton(nil, true)
        if frame.IconBorder then
            frame.IconBorder:Hide()
        end
        if frame.Icon then
            frame.Icon:CreateBackdrop()
        end
    end

    HandleIconButton(_G.RematchHealButton)
    HandleIconButton(_G.RematchBandageButton)
    HandleIconButton(_G.RematchToolbar.SafariHat)
    HandleIconButton(_G.RematchLesserPetTreatButton)
    HandleIconButton(_G.RematchPetTreatButton)
    HandleIconButton(_G.RematchToolbar.SummonRandom)
end

function S:Rematch_Bottom()
    -- Tabs
    for _, tab in pairs {_G.RematchJournal.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadowAfterElvUISkins(tab)
    end

    -- Buttons
    ES:HandleButton(_G.RematchBottomPanel.SummonButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveAsButton)
    ES:HandleButton(_G.RematchBottomPanel.FindBattleButton)
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

function S:Rematch_TopLeft()
    for _, region in pairs {_G.RematchPetPanel.Top:GetRegions()} do
        region:Hide()
    end

    if _G.RematchPetPanel.Top.SearchBox then
        local searchBox = _G.RematchPetPanel.Top.SearchBox
        ES:HandleEditBox(searchBox)
        searchBox.backdrop:SetOutside(0, 0)
        searchBox:ClearAllPoints()
        searchBox:Point("TOPLEFT", _G.RematchPetPanel.Top.Toggle, "TOPRIGHT", 2, 0)
        searchBox:Point("BOTTOMRIGHT", _G.RematchPetPanel.Top.Filter, "BOTTOMLEFT", -2, 0)
    end

    ES:HandleButton(_G.RematchPetPanel.Top.Toggle)
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

    ES:HandleButton(_G.RematchPetPanel.Top.Filter)

    _G.RematchPetPanel.Top.Filter.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchPetPanel.Top.Filter.Arrow:SetRotation(ES.ArrowRotation.right)
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
    self:CreateShadow(_G.RematchJournal.backdrop)
    ES:HandleCloseButton(_G.RematchJournal.CloseButton)

    -- Right tabs
    self:SecureHook(
        _G.RematchTeamTabs,
        "Update",
        function()
            if _G.RematchTeamTabs and _G.RematchTeamTabs.Layout then
                for _, tab in pairs {_G.RematchTeamTabs.Layout:GetChildren()} do
                    if not tab.windStyle then
                        tab:StripTextures()
                        tab.Icon:CreateBackdrop()
                        self:CreateShadow(tab.Icon.backdrop)
                        tab:StyleButton(nil, true)
                        tab.hover:ClearAllPoints()
                        tab.hover:SetAllPoints(tab.Icon)
                        tab.windStyle = true
                    end
                end
            end
        end
    )

    -- New Group
    _G.RematchDialog:StripTextures()
    _G.RematchDialog:CreateBackdrop("Transparent")
    self:CreateShadow(_G.RematchDialog)
    ES:HandleCloseButton(_G.RematchDialog.CloseButton)
    ES:HandleButton(_G.RematchDialog.Accept)
    ES:HandleButton(_G.RematchDialog.Cancel)

    self:Rematch_Top()
    self:Rematch_TopLeft()
    self:Rematch_Bottom()

    -- 中间
    ES:HandleButton(_G.RematchLoadoutPanel.Target.TargetButton)
    ES:HandleButton(_G.RematchLoadoutPanel.TargetPanel.Top.BackButton)

    -- 右边
    ES:HandleButton(_G.RematchTeamPanel.Top.Teams)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetRotation(ES.ArrowRotation.right)

    -- Compatible with Move Frames module
    if MF and MF.db and MF.db.moveBlizzardFrames then
        if not _G.CollectionsJournal then
            CollectionsJournal_LoadUI()
        end
        _G.RematchJournal.moveHandler = CreateFrame("Frame", nil, _G.RematchJournal)
        _G.RematchJournal.moveHandler:SetAllPoints(_G.RematchJournal.TitleBg)
        MF:HandleFrame(_G.RematchJournal.moveHandler, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchJournal, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchToolbar, _G.CollectionsJournal)
    end
end

S:AddCallbackForAddon("Rematch")
