local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function reskin(func)
    return function(frame, ...)
        if frame.__windSkin then
            return
        end

        func(frame, ...)

        frame.__windSkin = true
    end
end

local function bottomTabButtons(frame)
    for _, details in ipairs(_G.Auctionator.Tabs.State.knownTabs) do
        local tabButtonFrameName = "AuctionatorTabs_" .. details.name
        local tabButton = _G[tabButtonFrameName]

        if tabButton and not tabButton.__windSkin then
            S:ESProxy("HandleTab", tabButton, nil, "Transparent")
            S:ReskinTab(tabButton)
            tabButton.Text:SetWidth(tabButton:GetWidth())
            if details.tabOrder > 1 then
                local pointData = {tabButton:GetPoint(1)}
                pointData[4] = -5
                tabButton:ClearAllPoints()
                tabButton:SetPoint(unpack(pointData))
            end

            tabButton.__windSkin = true
        end
    end
end

local function splashFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleCloseButton", frame.Close)
    S:ESProxy("HandleCheckBox", frame.HideCheckbox.CheckBox)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)

    if E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning then
        W.Modules.MoveFrames:HandleFrame(frame)
    end
end

local function exportTextFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Close)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function listExportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.SelectAll)
    S:ESProxy("HandleButton", frame.UnselectAll)
    S:ESProxy("HandleButton", frame.Export)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function listImportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Import)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function scrollListShoppingList(frame)
    frame.Inset:StripTextures()
    frame.Inset:SetTemplate("Transparent")

    S:ESProxy("HandleScrollBar", frame.ScrollBar)
end

local function scrollListRecents(frame)
    frame.Inset:StripTextures()
    frame.Inset:SetTemplate("Transparent")

    S:ESProxy("HandleScrollBar", frame.ScrollBar)
end

local function configTab(frame)
    frame.Bg:SetTexture(nil)
    frame.NineSlice:SetTemplate("Transparent")

    S:ESProxy("HandleButton", frame.OptionsButton)
    S:ESProxy("HandleButton", frame.ScanButton)

    S:ESProxy("HandleEditBox", frame.DiscordLink.InputBox)
    S:ESProxy("HandleEditBox", frame.BugReportLink.InputBox)
end

local function shoppingTab(frame)
    if frame.OneItemSearch then
        S:ESProxy("HandleEditBox", frame.OneItemSearch.SearchBox)
        S:ESProxy("HandleButton", frame.OneItemSearch.SearchButton)
        S:ESProxy("HandleButton", frame.OneItemSearch.ExtendedButton)
    end

    S:ESProxy("HandleDropDownBox", frame.ListDropdown)


    S:ESProxy("HandleButton", frame.AddItem)
    S:ESProxy("HandleButton", frame.ManualSearch)
    S:ESProxy("HandleButton", frame.SortItems)
    S:ESProxy("HandleButton", frame.Import)
    S:ESProxy("HandleButton", frame.Export)
    S:ESProxy("HandleButton", frame.ExportCSV)
end

function S:Auctionator()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.auctionator then
        return
    end

    hooksecurefunc(_G.AuctionatorSplashScreenMixin, "OnLoad", reskin(splashFrame))
    hooksecurefunc(_G.AuctionatorExportTextFrameMixin, "OnLoad", reskin(exportTextFrame))
    hooksecurefunc(_G.AuctionatorListExportFrameMixin, "OnLoad", reskin(listExportFrame))
    hooksecurefunc(_G.AuctionatorListImportFrameMixin, "OnLoad", reskin(listImportFrame))
    hooksecurefunc(_G.AuctionatorTabContainerMixin, "OnLoad", reskin(bottomTabButtons))
    hooksecurefunc(_G.AuctionatorShoppingTabMixin, "OnLoad", reskin(shoppingTab))
    hooksecurefunc(_G.AuctionatorScrollListShoppingListMixin, "OnLoad", reskin(scrollListShoppingList))
    hooksecurefunc(_G.AuctionatorScrollListRecentsMixin, "OnLoad", reskin(scrollListRecents))
    hooksecurefunc(_G.AuctionatorConfigTabMixin, "OnLoad", reskin(configTab))
end

S:AddCallbackForAddon("Auctionator")
