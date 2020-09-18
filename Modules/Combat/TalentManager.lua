local W, F, E, L = unpack(select(2, ...))
local TM = W:NewModule("TalentManager", "AceEvent-3.0")
local S = W:GetModule("Skins")

local gsub = gsub
local tinsert = tinsert
local unpack = unpack
local LearnTalents = LearnTalents
local GetTalentInfo = GetTalentInfo
local GetTalentTierInfo = GetTalentTierInfo

local MAX_TALENT_TIERS = MAX_TALENT_TIERS

function TM:SetTalent(talentString)
    local talentTable = {}
    gsub(
        talentString,
        "[0-9]",
        function(char)
            tinsert(talentTable, char)
        end
    )

    if #talentTable < MAX_TALENT_TIERS then
        F.DebugMessage(TM, L["Talent string is not valid."])
    end

    local talentIDs = {}
    for tier = 1, MAX_TALENT_TIERS do
        local isAvilable, column = GetTalentTierInfo(tier, 1)
        if isAvilable and talentTable[tier] ~= 0 and talentTable[i] ~= column then
            local talentID = GetTalentInfo(tier, talentTable[tier], 1)
            tinsert(talentIDs, talentID)
        end
    end

    if #talentIDs > 1 then
        LearnTalents(unpack(talentIDs))
    end
end

function TM:GetTalentString()
    local talentString = ""
    for tier = 1, MAX_TALENT_TIERS do
        local isAvilable, column = GetTalentTierInfo(tier, 1)
        talentString = talentString .. (isAvilable and column or 0)
    end
    return talentString
end

function TM:Initialize()
    self.db = E.private.WT.combat.talentManager
    if not self.db.enable then
        return
    end
end

W:RegisterModule(TM:GetName())
