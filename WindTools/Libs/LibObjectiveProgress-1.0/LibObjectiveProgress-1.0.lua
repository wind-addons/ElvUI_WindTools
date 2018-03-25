--[[
LibObjectiveProgress: Core API
Developed by: Simca@Malfurion (MMOSimca)
]]--

-- Set major/minor version
local MAJOR, MINOR = "LibObjectiveProgress-1.0", 27
assert(LibStub, MAJOR .. " requires LibStub")

-- Initialize library
local LOP, oldversion = LibStub:NewLibrary(MAJOR, MINOR)
if not LOP then return end

-- Localized function references
local GetNumQuestLogEntries = _G.GetNumQuestLogEntries
local GetQuestLogTitle = _G.GetQuestLogTitle


function LOP:GetNPCWeightByMap(mapID, npcID, isTeeming, isUpperKarazhan)
    -- Load map-based weight data if needed
    if not LOP.MapBasedWeights then LOP:LoadWeightDataByMap() end

    -- Ensure that specified map/NPC is valid
    local tableIndex = 1
    if isTeeming then tableIndex = 2 end
    if isUpperKarazhan then tableIndex = tableIndex + 2 end -- Nasty hack for Upper Return to Karazhan (since it shares a mapID with Lower Return to Karazhan)
    if not LOP.MapBasedWeights[mapID] or not LOP.MapBasedWeights[mapID][tableIndex] or not LOP.MapBasedWeights[mapID][tableIndex][npcID] then return nil end

    -- Get map-based weight data for specified NPC
    return LOP.MapBasedWeights[mapID][tableIndex][npcID]
end


function LOP:GetNPCWeightByQuest(questID, npcID)
    -- Load map-based weight data if needed
    if not LOP.QuestBasedWeights then LOP:LoadWeightDataByQuest() end

    -- Ensure that specified map / NPC is valid
    if not LOP.QuestBasedWeights[questID] or not LOP.QuestBasedWeights[questID][npcID] then return nil end

    -- Get map-based weight data for specified NPC
    return LOP.QuestBasedWeights[questID][npcID]
end


function LOP:GetNPCWeightByCurrentQuests(npcID)
    -- Table variable declared here
    local questTable = nil
    
    -- Get NPC weight for all quests in log
    local numEntries = GetNumQuestLogEntries()
    for questLogIndex = 1, numEntries do
        local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questLogIndex)

        -- If this row isn't a header, has a valid questID, and has a valid weight, then initialize the table and record the questID/weight pair
        if not isHeader and questID ~= 0 then
            local weight = LOP:GetNPCWeightByQuest(questID, npcID)
            if weight then
                questTable = questTable or {}
                questTable[questID] = weight
            end
        end
    end
    
    -- Return completed table (or nil if no quests reference the NPC in question)
    return questTable
end
