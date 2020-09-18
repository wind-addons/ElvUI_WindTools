local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local LibStub = _G.LibStub

function S:BugSack_Open()
    local BugSackFrame = _G.BugSackFrame

    if BugSackFrame.windStyle then
        return
    end

    -- 背景
    BugSackFrame:StripTextures()
    BugSackFrame:CreateBackdrop("Transparent")
    S:CreateShadow(BugSackFrame.backdrop)

    -- 关闭按钮
    for _, child in pairs {_G.BugSackFrame:GetChildren()} do
        local numRegions = child:GetNumRegions()

        if numRegions == 1 then
            local text = child:GetRegions()
            if text and text.SetText then
                F.SetFontOutline(text)
                text.windStyle = true
            end
        elseif numRegions == 4 then
            ES:HandleCloseButton(child)
            child.windStyle = true
        end
    end

    -- 滚动条
    ES:HandleScrollBar(_G.BugSackScrollScrollBar)

    -- 滚动文字
    for _, region in pairs {_G.BugSackScrollText:GetRegions()} do
        if region and region.SetText then
            F.SetFontOutline(region)
        end
    end

    -- 下方 3 按钮
    ES:HandleButton(_G.BugSackNextButton)
    ES:HandleButton(_G.BugSackPrevButton)
    ES:HandleButton(_G.BugSackSendButton)

    -- 下方标签页
    local tabs = {
        _G.BugSackTabAll,
        _G.BugSackTabLast,
        _G.BugSackTabSession
    }

    for _, tab in pairs(tabs) do
        ES:HandleTab(tab)
        tab.backdrop:SetTemplate("Transparent")
        S:CreateShadow(tab.backdrop)

        local point, relativeTo, relativePoint, xOffset, yOffset = tab:GetPoint(1)
        tab:ClearAllPoints()
        if yOffset ~= 0 then
            yOffset = -1
        end
        tab:Point(point, relativeTo, relativePoint, xOffset, yOffset)

        local text = _G[tab:GetName() .. "Text"]
        if text then
            F.SetFontOutline(text)
        end
    end

    BugSackFrame.windStyle = true
end

function S:BugSack()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bugSack then
        return
    end

    self:SecureHook(_G.BugSack, "OpenSack", "BugSack_Open")
end

S:AddCallbackForAddon("BugSack")
