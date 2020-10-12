local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local LibStub = _G.LibStub

local DeleteRegions = {
    "Center",
    "BottomEdge",
    "LeftEdge",
    "RightEdge",
    "TopEdge",
    "BottomLeftCorner",
    "BottomRightCorner",
    "TopLeftCorner",
    "TopRightCorner"
}

function S:TinyInspect_SkinPanel(unit, parent, ilevel, maxLevel)
    if not parent or not parent.inspectFrame then
        return
    end

    local frame = parent.inspectFrame
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 5, 0)

    if frame.windStyle then
        parent.inspectFrameHolder:Show()
        return
    end

    for _, regionKey in pairs(DeleteRegions) do
        if frame[regionKey] then
            frame[regionKey]:Kill()
        end
    end

    frame.closeButton:ClearAllPoints()
    frame.closeButton:SetPoint("BOTTOMLEFT", 3, 3)

    inspectFrameHolder = CreateFrame("Frame", nil, parent)
    inspectFrameHolder:Point("TOPLEFT", frame, "TOPLEFT", 0, -1)
    inspectFrameHolder:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 1)
    inspectFrameHolder:CreateBackdrop("Transparent")
    inspectFrameHolder.backdrop:SetFrameLevel(frame:GetFrameLevel())
    inspectFrameHolder.backdrop:SetFrameStrata(frame:GetFrameStrata())
    S:CreateShadow(inspectFrameHolder, 5)

    self:SecureHookScript(
        frame.closeButton,
        "OnClick",
        function()
            inspectFrameHolder:Hide()
        end
    )

    self:SecureHookScript(
        parent,
        "OnHide",
        function()
            inspectFrameHolder:Hide()
        end
    )

    inspectFrameHolder:Show()
    parent.inspectFrameHolder = inspectFrameHolder

    frame.windStyle = true
end

function S:TinyInspect()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tinyInspect then
        return
    end

    if _G.ShowInspectItemListFrame then
        self:SecureHook("ShowInspectItemListFrame", "TinyInspect_SkinPanel")
    end
end

S:AddCallbackForAddon("TinyInspect")
