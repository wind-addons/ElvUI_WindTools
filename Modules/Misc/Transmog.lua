local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local _G = _G
local mixin = _G.WardrobeOutfitDropDownMixin

local TRANSMOG_SLOTS = TRANSMOG_SLOTS
local NO_TRANSMOG_SOURCE_ID = NO_TRANSMOG_SOURCE_ID
local LE_TRANSMOG_TYPE_APPEARANCE = LE_TRANSMOG_TYPE_APPEARANCE
local LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_ILLUSION

local GetInventorySlotInfo = GetInventorySlotInfo
local C_TransmogCollection_PlayerCanCollectSource = C_TransmogCollection.PlayerCanCollectSource
local C_TransmogCollection_PlayerKnowsSource = C_TransmogCollection.PlayerKnowsSource
local C_TransmogCollection_GetOutfitSources = C_TransmogCollection.GetOutfitSources

local function CheckOutfitForSave(self, name)
    local sources = {}
    local mainHandEnchant, offHandEnchant
    local pendingSources = {}

    for i = 1, #TRANSMOG_SLOTS do
        local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, TRANSMOG_SLOTS[i].transmogType)
        if (sourceID ~= NO_TRANSMOG_SOURCE_ID) then
            if (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE) then
                local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot)
                local isValidSource = C_TransmogCollection_PlayerKnowsSource(sourceID)
                if (not isValidSource) then
                    local isInfoReady, canCollect = C_TransmogCollection_PlayerCanCollectSource(sourceID)
                    if (isInfoReady) then
                        if (canCollect) then
                            isValidSource = true
                        end
                    else
                        -- saving the "slot" for the sourceID
                        pendingSources[sourceID] = slotID
                    end
                end
                if (isValidSource) then
                    sources[slotID] = sourceID
                end
            elseif (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_ILLUSION) then
                if (TRANSMOG_SLOTS[i].slot == "MAINHANDSLOT") then
                    mainHandEnchant = sourceID
                else
                    offHandEnchant = sourceID
                end
            end
        end
    end

    -- store the state for this save
    WardrobeOutfitFrame.sources = sources
    WardrobeOutfitFrame.mainHandEnchant = mainHandEnchant
    WardrobeOutfitFrame.offHandEnchant = offHandEnchant
    WardrobeOutfitFrame.pendingSources = pendingSources
    WardrobeOutfitFrame.hadInvalidSources = false
    WardrobeOutfitFrame.name = name
    -- save the dropdown
    WardrobeOutfitFrame.popupDropDown = self

    WardrobeOutfitFrame:EvaluateSaveState()
end

local function IsOutfitDressed(self)
    if (not self.selectedOutfitID) then
        return true
    end
    local appearanceSources, mainHandEnchant, offHandEnchant =
        C_TransmogCollection_GetOutfitSources(self.selectedOutfitID)
    if (not appearanceSources) then
        return true
    end

    for i = 1, #TRANSMOG_SLOTS do
        if (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE) then
            local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, LE_TRANSMOG_TYPE_APPEARANCE)
            local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot)
            if (sourceID ~= NO_TRANSMOG_SOURCE_ID and sourceID ~= appearanceSources[slotID]) then
                if (appearanceSources[slotID] ~= NO_TRANSMOG_SOURCE_ID) then
                    return false
                end
            end
        end
    end
    local mainHandSourceID = self:GetSlotSourceID("MAINHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION)
    if (mainHandSourceID ~= mainHandEnchant) then
        return false
    end
    local offHandSourceID = self:GetSlotSourceID("SECONDARYHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION)
    if (offHandSourceID ~= offHandEnchant) then
        return false
    end
    return true
end

function M:SaveArtifact()
    if E.private.WT.misc.saveArtifact then
        mixin.CheckOutfitForSave = CheckOutfitForSave
        mixin.IsOutfitDressed = IsOutfitDressed
    end
end

M:AddCallback("SaveArtifact")
