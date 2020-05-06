local W, F, E, L = unpack(select(2, ...))
local C = W:NewModule('CombatAlert', 'AceEvent-3.0')

function C:CreateAnimationFrame()
end

function C:CreateTextFrame()
end

function C:ShowAlert()
end

function C:QueueAlert()
end

function C:CheckNextAlert()
end

function C:PLAYER_REGEN_DISABLED()
end

function C:PLAYER_REGEN_ENABLED()
end

function C:Initialize()
    if not E.db.WT.combat.combatAlert.enable then return end
    self.db = E.db.WT.combat.combatAlert
    
    C:CreateAnimationFrame()
    C:CreateTextFrame()

    self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

    self.initialized = true
end

function C:ProfileUpdate()
    if E.db.WT.combat.combatAlert.enable then
        self:Initialize()
    else
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    end
end

W:RegisterModule(C:GetName())
