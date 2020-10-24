local W, F, E, L = unpack(select(2, ...))
local IL = W:NewModule("Inspect", "AceEvent-3.0")
-- Special lite version of TinyInspect

local _G = _G
local testDB = {
    enable = true
}

function FL:Initialize()
    self.db = testDB

    if not self.db.enable then
        return
    end

	self:RegisterEvent("LOOT_READY")
end

W:RegisterModule(IL:GetName())
