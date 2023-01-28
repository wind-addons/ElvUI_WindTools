local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local TT = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local floor = floor
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

function S:RareScanner()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rareScanner then
        return
    end

    local scannerButton = _G["scanner_button"]
    if not scannerButton or not scannerButton.ModelView then
        return
    end

    scannerButton:SetScript("OnEnter", nil)
    scannerButton:SetScript("OnLeave", nil)

    self:ESProxy("HandleButton", scannerButton)

    if scannerButton.CloseButton then
        self:ESProxy("HandleCloseButton", scannerButton.CloseButton)
        scannerButton.CloseButton:ClearAllPoints()
        scannerButton.CloseButton:SetSize(20, 20)
        scannerButton.CloseButton:SetPoint("TOPRIGHT", -3, -3)
    end

    if scannerButton.FilterEntityButton then
        self:ESProxy("HandleButton", scannerButton.FilterEntityButton)
        scannerButton.FilterEntityButton:SetNormalTexture(W.Media.Icons.buttonMinus, true)
        scannerButton.FilterEntityButton:SetPushedTexture(W.Media.Icons.buttonMinus, true)
        scannerButton.FilterEntityButton:ClearAllPoints()
        scannerButton.FilterEntityButton:SetSize(16, 16)
        scannerButton.FilterEntityButton:SetPoint("TOPLEFT", scannerButton, "TOPLEFT", 3, -3)
    end

    if scannerButton.Title then
        F.SetFontOutline(scannerButton.Title)
    end

    if scannerButton.Description_text then
        F.SetFontOutline(scannerButton.Description_text)
    end

    scannerButton:SetTemplate("Transparent")
    self:CreateShadow(scannerButton)

    if scannerButton.Center then
        scannerButton.Center:Show()
    end

    for _, region in pairs({scannerButton:GetRegions()}) do
        if region:GetObjectType() == "Texture" then
            if region:GetTexture() == 235408 then -- title background
                region:SetTexture(nil)
            end
        end
    end

    if scannerButton.LootBar then
        if scannerButton.LootBar.LootBarToolTip then
            hooksecurefunc(
                scannerButton.LootBar.LootBarToolTip,
                "Show",
                function(self)
                    TT:SetStyle(_G.LootBarToolTip)

                    if scannerButton.LootBar.LootBarToolTipComp1 and scannerButton.LootBar.LootBarToolTipComp1.Show then
                        TT:SetStyle(scannerButton.LootBar.LootBarToolTipComp1)
                    end

                    if scannerButton.LootBar.LootBarToolTipComp2 and scannerButton.LootBar.LootBarToolTipComp2.Show then
                        TT:SetStyle(scannerButton.LootBar.LootBarToolTipComp2)
                    end
                end
            )
        end

        T:AddIconTooltip("LootBarToolTip")
        T:AddIconTooltip("LootBarToolTipComp1")
        T:AddIconTooltip("LootBarToolTipComp2")

        hooksecurefunc(
            scannerButton.LootBar.itemFramesPool,
            "Acquire",
            function(pool)
                for button in pool:EnumerateActive() do
                    if not button.__windSkin then
                        if button.Icon and button.Icon:GetObjectType() == "Texture" then
                            button.Icon:SetTexCoord(unpack(E.TexCoords))
                        end

                        local size = button.Icon:GetWidth() - 2
                        button.Icon:SetSize(size, size)

                        button:CreateBackdrop()
                        button.backdrop:SetOutside(button.Icon)
                        self:CreateShadow(button.backdrop)
                        button.__windSkin = true
                    end
                end
            end
        )
    end

    for _, child in pairs({_G.WorldMapFrame:GetChildren()}) do
        if child:GetObjectType() == "Frame" and child.EditBox and child.relativeFrame then
            for _, region in pairs({child.EditBox:GetRegions()}) do
                if region:GetObjectType() == "Texture" then
                    if region:GetTexture() then
                        region:SetTexture(nil)
                    end
                end
            end

            child.EditBox:SetTemplate("Transparent")
            self:CreateShadow(child.EditBox)

            child.EditBox:ClearAllPoints()
            child.EditBox:SetAllPoints(child)

            local w, h = child:GetSize()
            child:SetSize(w, floor(h * 0.62))

            child:ClearAllPoints()
            child:SetPoint("TOP", _G.WorldMapFrame.ScrollContainer, "TOP", 0, -5)
            break
        end
    end
end

S:AddCallbackForAddon("RareScanner")
