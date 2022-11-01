local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local next = next
local pairs = pairs
local select = select
local tinsert = tinsert
local unpack = unpack

function S:Blizzard_EncounterJournal()
    if not self:CheckDB("encounterjournal", "encounterJournal") then
        return
    end

    self:CreateShadow(_G.EncounterJournal)

    -- Bottom tabs
    local tabs = {
        _G.EncounterJournalSuggestTab,
        _G.EncounterJournalDungeonTab,
        _G.EncounterJournalRaidTab,
        _G.EncounterJournalLootJournalTab
    }

    for _, tab in pairs(tabs) do
        self:ReskinTab(tab)
    end

    for _, name in next, {"overviewTab", "modelTab", "bossTab", "lootTab"} do
        local tab = _G.EncounterJournal.encounter.info[name]
        self:CreateBackdropShadow(tab)
        local point, relativeTo, relativePoint, x, y = tab:GetPoint(1)
        if name == "overviewTab" then
            tab:SetPoint(point, relativeTo, relativePoint, 16, -55)
        else
            tab:SetPoint(point, relativeTo, relativePoint, 0, -4)
        end
        tab.SetPoint = E.noop
    end
end

S:AddCallbackForAddon("Blizzard_EncounterJournal")
