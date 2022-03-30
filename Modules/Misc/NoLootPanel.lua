local W, F, E, L = unpack(select(2, ...))
local NLP = W:NewModule("NoLootPanel", "AceHook-3.0")

local _G = _G

function NLP:ProfileUpdate()
    if E.db.WT.misc.noLootPanel then
        _G.BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
    else
        _G.BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
    end
end

function NLP:PLAYER_LOGIN()
    self:ProfileUpdate()
    self:UnregisterEvent("PLAYER_LOGIN")
end

function NLP:Initialize()
    self:RegisterEvent("PLAYER_LOGIN")
end

W:RegisterModule(NLP:GetName())
