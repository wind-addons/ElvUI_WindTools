local W, F, E, L = unpack(select(2, ...))
local QK = W:NewModule("QuickKeystone", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemID = GetContainerItemID
local UseContainerItem = UseContainerItem

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local keystones = {
    [138019] = true,
    [158923] = true,
    [180653] = true,
    [151086] = true
}

function QK:PutKeystone()
    for bagIndex = 0, NUM_BAG_SLOTS do
        for slotIndex = 1, GetContainerNumSlots(bagIndex) do
            local itemID = GetContainerItemID(bagIndex, slotIndex)
            if itemID and keystones[itemID] then
                UseContainerItem(bagIndex, slotIndex)
                return
            end
        end
    end
end

function QK:UpdateHook(event, addon)
    if event then
        if addon == "Blizzard_ChallengesUI" then
            self:UnregisterEvent("ADDON_LOADED")
        else
            return 
        end
    end

    local frame = _G.ChallengesKeystoneFrame
    if not frame then
        return
    end

    if self.db.enable then
        if not self:IsHooked(frame, "OnShow") then
            self:SecureHookScript(frame, "OnShow", "PutKeystone")
        end
    else
        if self:IsHooked(frame, "OnShow") then
            self:Unhook(frame, "OnShow")
        end
    end
end

function QK:ProfileUpdate()
	self.db = E.db.WT.combat.quickKeystone

    if IsAddOnLoaded("Blizzard_ChallengesUI") then
        self:UpdateHook()
    else
        self:RegisterEvent("ADDON_LOADED", "UpdateHook")
    end
end

QK.Initialize = QK.ProfileUpdate

W:RegisterModule(QK:GetName())
