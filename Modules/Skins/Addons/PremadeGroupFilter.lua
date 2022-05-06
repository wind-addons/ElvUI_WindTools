local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local strmatch = strmatch

function S:PremadeGroupsFilter_SetPoint(frame, point, relativeFrame, relativePoint, x, y)
    if point == "TOPLEFT" and relativePoint == "TOPRIGHT" then
        if (not x and not y) or (x == 0 and y == 0) then
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", relativeFrame, "TOPRIGHT", 5, 0)
        end
    end
end

function S:PremadeGroupsFilter()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.premadeGroupsFilter then
        return
    end

    S:DisableAddOnSkin("PremadeGroupsFilter")

    local frame = _G.PremadeGroupsFilterDialog
    ES:HandlePortraitFrame(frame, true)

    -- Extend 1 pixel looks as same height as PVEFrame
    frame.backdrop:SetTemplate("Transparent")
    frame.backdrop:ClearAllPoints()
    frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -1, 0)
    frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

    self:CreateBackdropShadow(frame, true)
    self:MerathilisUISkin(frame)

    -- Because we added shadow, moving the frame a little bit right looks better
    self:SecureHook(frame, "SetPoint", "PremadeGroupsFilter_SetPoint")

    for i = 1, frame:GetNumPoints() do
        S:PremadeGroupsFilter_SetPoint(frame, frame:GetPoint())
    end

    if frame.Advanced then
        for _, region in pairs {frame.Advanced:GetRegions()} do
            local name = region.GetName and region:GetName()
            if name and (strmatch(name, "Corner") or strmatch(name, "Border")) then
                region:StripTextures()
            end
        end
    end

    if frame.Expression then
        ES:HandleEditBox(frame.Expression)
    end

    if frame.ResetButton then
        ES:HandleButton(frame.ResetButton)
    end

    if frame.RefreshButton then
        ES:HandleButton(frame.RefreshButton)
    end

    if frame.MinimizeButton then
        ES:HandleNextPrevButton(frame.MinimizeButton, "up", nil, true)
        frame.MinimizeButton:ClearAllPoints()
        frame.MinimizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
    end

    if frame.MaximizeButton then
        ES:HandleNextPrevButton(frame.MaximizeButton, "down", nil, true)
        frame.MaximizeButton:ClearAllPoints()
        frame.MaximizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
    end

    if frame.MoveableToggle then
        frame.MoveableToggle:Size(16)
        frame.MoveableToggle:ClearAllPoints()
        frame.MoveableToggle:Point("TOPLEFT", frame, "TOPLEFT", 4, -4)
        for _, region in pairs {frame.MoveableToggle:GetRegions()} do
            if region.GetTexture and strmatch(region:GetTexture(), "Locked") then
                region:SetTexture(W.Media.Icons.buttonLock)
            else
                region:SetTexture(W.Media.Icons.buttonUnlock)
            end
            region:Size(16)
            region:ClearAllPoints()
            region:SetAllPoints(frame.MoveableToggle)
        end
    end

    local lines = {
        "Difficulty",
        "Ilvl",
        "Noilvl",
        "Defeated",
        "Members",
        "Tanks",
        "Heals",
        "Dps"
    }

    for _, line in pairs(lines) do
        if frame[line] then
            if frame[line].Act then
                ES:HandleCheckBox(frame[line].Act)
                frame[line].Act:Size(24)
                frame[line].Act:ClearAllPoints()
                frame[line].Act:Point("LEFT", frame[line], "LEFT", 3, -3)
            end

            if line == "Defeated" and frame[line].Title then
                frame[line].Title:SetHeight(18)
            end

            if frame[line].DropDown then
                ES:HandleDropDownBox(frame[line].DropDown)
            end

            if frame[line].Min then
                ES:HandleEditBox(frame[line].Min)
                frame[line].Min.backdrop:ClearAllPoints()
                frame[line].Min.backdrop:SetOutside(frame[line].Min, 0, 0)
            end

            if frame[line].Max then
                ES:HandleEditBox(frame[line].Max)
                frame[line].Max.backdrop:ClearAllPoints()
                frame[line].Max.backdrop:SetOutside(frame[line].Max, 0, 0)
            end
        end
    end

    if _G.UsePFGButton then
        ES:HandleCheckBox(_G.UsePFGButton)
        _G.UsePFGButton:ClearAllPoints()
        _G.UsePFGButton:Point("RIGHT", _G.LFGListFrame.SearchPanel.RefreshButton, "LEFT", -50, 0)
    end
end

S:AddCallbackForAddon("PremadeGroupsFilter")
