local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")
local MF = W:GetModule("MoveFrames")

local _G = _G
local pairs = pairs
local unpack = unpack

local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI

function S:Rematch()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
        return
    end

    local frame = _G.RematchJournal
    if not frame then
        return
    end

    -- 背景
    ES:HandleBlizzardRegions(frame, nil, true)
    frame.NineSlice:Kill()
    frame.portrait:Kill()
    frame.Bg:Kill()
    frame.TopTileStreaks:Kill()
    frame:CreateBackdrop()
    self:CreateShadow(frame)

    ES:HandleCloseButton(frame.CloseButton)

    -- 标题
    frame.TitleBg:StripTextures()
    F.SetFontOutline(frame.TitleText)

    -- 宠物数目
    local childName = {
        "BorderBottomLeft",
        "BorderBottomMiddle",
        "BorderBottomRight",
        "BorderLeftMiddle",
        "BorderRightMiddle",
        "BorderTopLeft",
        "BorderTopMiddle",
        "BorderTopRight",
        "Bg"
    }

    local PetCount = _G.RematchToolbar.PetCount

    if PetCount then
        for _, name in pairs(childName) do
            PetCount[name]:Hide()
        end
        PetCount:SetHighlightTexture(nil)
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

    -- 左半边
    for _, region in pairs {_G.RematchPetPanel.Top:GetRegions()} do
        region:Hide()
    end
    ES:HandleEditBox(_G.RematchPetPanel.Top.SearchBox)
    _G.RematchPetPanel.Top.SearchBox:ClearAllPoints()
    _G.RematchPetPanel.Top.SearchBox:Point("LEFT", _G.RematchPetPanel.Top.Toggle, "RIGHT", 2, 0)
    _G.RematchPetPanel.Top.SearchBox:Point("RIGHT", _G.RematchPetPanel.Top.Filter, "LEFT", -2, 0)

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
                self.Texture:SetRotation(ES.ArrowRotation["up"])
            else
                self.Texture:SetRotation(ES.ArrowRotation["down"])
            end
        end
    )

    ES:HandleButton(_G.RematchPetPanel.Top.Filter)

    _G.RematchPetPanel.Top.Filter.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchPetPanel.Top.Filter.Arrow:SetRotation(ES.ArrowRotation.right)

    -- 中间
    ES:HandleButton(_G.RematchLoadoutPanel.Target.TargetButton)
    ES:HandleButton(_G.RematchLoadoutPanel.TargetPanel.Top.BackButton)

    -- 右边
    ES:HandleButton(_G.RematchTeamPanel.Top.Teams)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetRotation(ES.ArrowRotation.right)

    -- 右侧队伍标签页
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

    -- 右下角标签页
    for _, tab in pairs {frame.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadowAfterElvUISkins(tab)
    end

    -- 下方按钮
    ES:HandleButton(_G.RematchBottomPanel.SummonButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveAsButton)
    ES:HandleButton(_G.RematchBottomPanel.FindBattleButton)

    -- 移动支持
    if MF and MF.db and MF.db.moveBlizzardFrames then
        if not _G.CollectionsJournal then
            CollectionsJournal_LoadUI()
        end
        MF:HandleFrame(frame, _G.CollectionsJournal)
        MF:HandleFrame(frame.backdrop, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchBottomPanel, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchToolbar, _G.CollectionsJournal)
    end
end

S:AddCallbackForAddon("Rematch")
