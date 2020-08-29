local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local MM = E:GetModule("Minimap")

local _G = _G
local InCombatLockdown = InCombatLockdown
local Minimap = _G.Minimap

function RM:ChangeShape()
    if not self.db or not self.db.enable then
        return
    end

    if InCombatLockdown() then
        return
    end

    local MMHolder = _G.MMHolder

    local oldWidth, oldHeight = Minimap:GetSize()
    local oldHolderWidth, oldHolderHeight = MMHolder:GetSize()

    local newWidth = self.db.widthPercentage * E.db.general.minimap.size
    local newHeight = self.db.heightPercentage * E.db.general.minimap.size

    local newHolderWidth = oldHolderWidth - oldWidth + newWidth
    local newHolderHeight = oldHolderHeight - oldHeight + newHeight

    Minimap:Size(newWidth, newHeight)
    MMHolder:Size(newHolderWidth, newHolderHeight)
end

function RM:SetUpdateHook()
    if not self.Initialized then
        self:SecureHook(MM, "SetGetMinimapShape", "ChangeShape")
        self:SecureHook(MM, "UpdateSettings", "ChangeShape")
        self:SecureHook(MM, "Initialize", "ChangeShape")
        self:SecureHook(E, "UpdateAll", "ChangeShape")
    end
    self:ChangeShape()
end

function RM:PLAYER_ENTERING_WORLD()
self:SetUpdateHook()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function RM:Initialize()
    self.db = E.db.WT.maps.rectangleMinimap
    if not self.db or not self.db.enable then
        return
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function RM:ProfileUpdate()
    print(1)
    self.db = E.db.WT.maps.rectangleMinimap
    if not self.db then return end
    if self.db.enable then
        self:SetUpdateHook()
    end
end

W:RegisterModule(RM:GetName())
