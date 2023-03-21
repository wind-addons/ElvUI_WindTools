local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local LibStub = _G.LibStub

local pairs = pairs
local floor = floor

function S:Myslot()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.myslot then
        return
    end

    local frame = LibStub("Myslot-5.0").MainFrame
    if not frame then
        return
    end

    frame:StripTextures()
    frame:SetTemplate("Transparent")
    self:CreateShadow(frame)

    for _, child in pairs {frame:GetChildren()} do
        local objType = child:GetObjectType()
        if objType == "Button" then
            self:ESProxy("HandleButton", child)
        elseif objType == "CheckButton" then
            self:ESProxy("HandleCheckBox", child)
            child:Size(23)
        elseif objType == "Frame" then
            if floor(child:GetWidth() - 600) == 0 and floor(child:GetHeight() - 400) == 0 then
                child:SetBackdrop(nil)
                child:CreateBackdrop()
                child.backdrop:SetInside(child, 2, 4)
                for _, subChild in pairs {child:GetChildren()} do
                    if subChild:GetObjectType() == "ScrollFrame" then
                        self:ESProxy("HandleScrollBar", subChild.ScrollBar)
                        break
                    end
                end
            elseif child.initialize and child.Icon then
                self:ESProxy("HandleDropDownBox", child, 220)
                child:ClearAllPoints()
                child:SetPoint("TOPLEFT", frame, 7, -45)
            end
        end
    end
end

S:AddCallbackForAddon("Myslot")
