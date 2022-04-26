local W, F, E, L = unpack(select(2, ...))
local EMP = W:NewModule("ExtendMerchantPages", "AceHook-3.0")
local ES = E:GetModule("Skins")

-- Modified from Extended Vendor UI & NDui_Plus
local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

local BLIZZARD_MERCHANT_ITEMS_PER_PAGE = 10

-- copy from ElvUI/Mainline/Modules/Skins/Merchant.lua
function EMP:SkinButton(i)
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.merchant) then
        return
    end

    local item = _G["MerchantItem" .. i]
    item:Size(155, 45)
    item:StripTextures(true)
    item:CreateBackdrop("Transparent")
    item.backdrop:Point("TOPLEFT", -3, 2)
    item.backdrop:Point("BOTTOMRIGHT", 2, -3)

    local slot = _G["MerchantItem" .. i .. "SlotTexture"]
    item.Name:Point("LEFT", slot, "RIGHT", -5, 5)
    -- item.Name:Size(110, 30)

    local button = _G["MerchantItem" .. i .. "ItemButton"]
    button:StripTextures()
    button:StyleButton()
    button:SetTemplate(nil, true)
    button:Point("TOPLEFT", item, "TOPLEFT", 4, -4)

    local icon = button.icon
    icon:SetTexCoord(unpack(E.TexCoords))
    icon:ClearAllPoints()
    icon:Point("TOPLEFT", 1, -1)
    icon:Point("BOTTOMRIGHT", -1, 1)

    ES:HandleIconBorder(button.IconBorder)
end

function EMP:UpdateMerchantPositions()
    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        local button = _G["MerchantItem" .. i]
        button:Show()
        button:ClearAllPoints()

        if (i % BLIZZARD_MERCHANT_ITEMS_PER_PAGE) == 1 then
            if (i == 1) then
                button:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 24, -70)
            else
                button:SetPoint(
                    "TOPLEFT",
                    _G["MerchantItem" .. (i - (BLIZZARD_MERCHANT_ITEMS_PER_PAGE - 1))],
                    "TOPRIGHT",
                    12,
                    0
                )
            end
        else
            if (i % 2) == 1 then
                button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 2)], "BOTTOMLEFT", 0, -16)
            else
                button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 12, 0)
            end
        end
    end
end

function EMP:UpdateBuybackPositions()
    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        local button = _G["MerchantItem" .. i]
        button:ClearAllPoints()

        local contentWidth = 3 * _G["MerchantItem1"]:GetWidth() + 2 * 50
        local firstButtonOffsetX = (_G.MerchantFrame:GetWidth() - contentWidth) / 2

        if i > _G.BUYBACK_ITEMS_PER_PAGE then
            button:Hide()
        else
            if i == 1 then
                button:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", firstButtonOffsetX, -105)
            else
                if ((i % 3) == 1) then
                    button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 3)], "BOTTOMLEFT", 0, -30)
                else
                    button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 50, 0)
                end
            end
        end
    end
end

function EMP:Initialize()
    if not E.private.WT.item.extendMerchantPages.enable then
        return
    end

    self.db = E.private.WT.item.extendMerchantPages

    if IsAddOnLoaded("ExtVendor") then
        self.StopRunning = "ExtVendor"
        return
    end

    if IsAddOnLoaded("ExtVendor") then
        self.StopRunning = "ExtVendor"
        return
    end

    _G.MERCHANT_ITEMS_PER_PAGE = self.db.numberOfPages * 10
    _G.MerchantFrame:SetWidth(30 + self.db.numberOfPages * 330)

    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        if not _G["MerchantItem" .. i] then
            CreateFrame("Frame", "MerchantItem" .. i, _G.MerchantFrame, "MerchantItemTemplate")
            self:SkinButton(i)
        end
    end

    _G.MerchantBuyBackItem:ClearAllPoints()
    _G.MerchantBuyBackItem:SetPoint("TOPLEFT", _G.MerchantItem10, "BOTTOMLEFT", -14, -20)
    _G.MerchantPrevPageButton:ClearAllPoints()
    _G.MerchantPrevPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 30, 55)
    _G.MerchantPageText:ClearAllPoints()
    _G.MerchantPageText:SetPoint("BOTTOM", _G.MerchantFrame, "BOTTOM", 160, 50)
    _G.MerchantNextPageButton:ClearAllPoints()
    _G.MerchantNextPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 290, 55)

    self:SecureHook("MerchantFrame_UpdateMerchantInfo", "UpdateMerchantPositions")
    self:SecureHook("MerchantFrame_UpdateBuybackInfo", "UpdateBuybackPositions")
end

W:RegisterModule(EMP:GetName())
