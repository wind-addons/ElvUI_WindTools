local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")
local MF = W:GetModule("MoveFrames")

local _G = _G
local LibStub = _G.LibStub

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
