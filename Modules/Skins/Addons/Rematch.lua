local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local LibStub = _G.LibStub

function S:Rematch()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
        return
    end

    local frame = _G.RematchJournal
    if not frame then return end

    ES:HandleBlizzardRegions(frame, nil, true)
    frame:CreateBackdrop()
    self:CreateShadow(frame)
    
    frame.NineSlice:Kill()
    frame.portrait:Kill()
    frame.TitleBg:Kill()
    frame.Bg:Kill()
    frame.TopTileStreaks:Kill()
    
    ES:HandleCloseButton(frame.CloseButton)
    F.SetFontOutline(frame.TitleText)

    for _, tab in pairs{frame.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point('TOPLEFT', 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point('BOTTOMRIGHT', -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadowAfterElvUISkins(tab)
    end
end

S:AddCallbackForAddon("Rematch")