local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local strfind = strfind

local CreateFrame = CreateFrame

function S:AAP_SkinOrderList()
    local frame = _G.AAPQOrderList
    if not frame then
        return
    end

    frame:CreateBackdrop("Transparent")
    frame.backdrop:ClearAllPoints()
    frame.backdrop:SetOutside(frame, 5, 5)
    frame.texture:Kill()
    self:CreateBackdropShadow(frame)

    if _G.AAP_SBXOZ then
        local close = CreateFrame("Button", "WTAAP_SBXOZ", frame, "UIPanelCloseButton, BackdropTemplate")
        close:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT")
        close:SetScript("OnClick", _G.AAP_SBXOZ:GetScript("OnClick"))
        self:ESProxy("HandleCloseButton", close)
        _G.AAP_SBXOZ:Hide()
        _G.AAP_SBXOZ = close
    end

    if _G.AAP_ZoneQuestOrder_ZoneName then
        _G.AAP_ZoneQuestOrder_ZoneName.texture:Hide()
        _G.AAP_ZoneQuestOrder_ZoneName:CreateBackdrop()
        _G.AAP_ZoneQuestOrder_ZoneName.backdrop:ClearAllPoints()
        _G.AAP_ZoneQuestOrder_ZoneName.backdrop:SetOutside(_G.AAP_ZoneQuestOrder_ZoneName, 5, 5)
        self:CreateBackdropShadow(_G.AAP_ZoneQuestOrder_ZoneName, true)
        F.SetFontOutline(_G.AAP_ZoneQuestOrder_ZoneName.FS, E.db.general.font)
    end
end

function S:AAP_SkinQuestList()
    local frame = _G.AAP.QuestList
    if not frame then
        return
    end

    frame.Greetings:CreateBackdrop("Transparent")
    frame.Greetings.texture:Kill()
    self:CreateBackdropShadow(frame.Greetings)
    F.SetFontOutline(frame.Greetings2FS1, E.db.general.font)
    F.SetFontOutline(frame.Greetings2FS221, E.db.general.font)
    F.SetFontOutline(frame.Greetings2FS2, E.db.general.font)
    self:ESProxy("HandleEditBox", frame.Greetings2EB1)
    F.SetFontOutline(frame.Greetings2FS3, E.db.general.font)
    self:ESProxy("HandleEditBox", frame.Greetings2EB2)
    self:ESProxy("HandleButton", frame.GreetingsHideB)

    local progressFrame = frame.QuestFrames.MyProgress
    if progressFrame then
        progressFrame:CreateBackdrop("Transparent")
        progressFrame.texture:Kill()
        self:CreateShadow(progressFrame)
        F.SetFontOutline(frame.QuestFrames.MyProgressFS, E.db.general.font)
    end

    for i = 1, 20 do
        local CLQListFrame = _G["CLQListF" .. i]
        if CLQListFrame then
            CLQListFrame:CreateBackdrop("Transparent")
            CLQListFrame.texture:Kill()
            self:CreateShadow(CLQListFrame)
        end
    end
end

function S:AAP_SkinOptionsFrame()
    local frame = _G.AAP.OptionsFrame
    if not frame then
        return
    end

    frame.MainFrame:CreateBackdrop("Transparent")
    frame.MainFrame.texture:Kill()
    self:CreateBackdropShadow(frame.MainFrame)
    self:ESProxy("HandleButton", frame.ShowStuffs)
    self:ESProxy("HandleButton", frame.ShowStuffs2)
    frame.ShowStuffs:Point("BOTTOMLEFT", frame.MainFrame, "BOTTOMLEFT", 0, 0)
    frame.ShowStuffs2:Point("BOTTOMLEFT", frame.ShowStuffs, "TOPLEFT", 0, 5)
    self:ESProxy("HandleButton", frame.Button1)
    self:ESProxy("HandleButton", frame.Button2)
    self:ESProxy("HandleButton", frame.Button3)

    local optionFrames = {
        frame.MainFrame.OptionsQuests,
        frame.MainFrame.OptionsArrow,
        frame.MainFrame.OptionsGeneral
    }

    for _, optionFrame in pairs(optionFrames) do
        if optionFrame then
            optionFrame.texture:StripTextures()
            for _, child in pairs {optionFrame:GetChildren()} do
                local objectType = child:GetObjectType()
                if objectType == "Button" then
                    self:ESProxy("HandleButton", child)
                elseif objectType == "CheckButton" then
                    self:ESProxy("HandleCheckBox", child)
                elseif objectType == "Slider" then
                    self:ESProxy("HandleSliderFrame", child)
                end
            end
        end
    end
end

function S:AAP_SkinLoadInFrame()
    local frame = _G.AAP.LoadInOptionFrame
    if not frame then
        return
    end

    frame:CreateBackdrop("Transparent")
    self:CreateBackdropShadow(frame)
    frame.texture:Kill()

    F.SetFontOutline(frame.FS, E.db.general.font)
    self:ESProxy("HandleButton", frame.B1)
    self:ESProxy("HandleButton", frame.B2)
    self:ESProxy("HandleButton", frame.B3)

    self:AAP_SkinRoutePlanFrame()
end

function S:AAP_SkinRoutePlanFrame()
    local frame = _G.AAP.RoutePlan.FG1
    if not frame then
        return
    end

    if frame.CloseButton then
        local close = F.Widgets.New("CloseButton", frame, nil, frame.CloseButton:GetScript("OnMouseUp"))
        close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
        frame.CloseButton:Hide()
        frame.CloseButton = close
    end
end

S["AAP-Core"] = function(self)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.azerothAutoPilot then
        return
    end

    self:AAP_SkinOrderList()
    self:AAP_SkinQuestList()
    self:SecureHook(_G.AAP, "LoadOptionsFrame", "AAP_SkinOptionsFrame")
    self:SecureHook(_G.AAP, "RoutePlanLoadIn", "AAP_SkinLoadInFrame")
end

S:AddCallbackForAddon("AAP-Core")
