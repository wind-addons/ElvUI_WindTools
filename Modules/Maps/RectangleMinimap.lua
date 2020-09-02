local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local MM = E:GetModule("Minimap")

local _G = _G
local InCombatLockdown = InCombatLockdown

function RM:ChangeShape()
    if not self.db then
        return
    end

    if InCombatLockdown() then
        return
    end

    local Minimap = _G.Minimap
    local MMHolder = _G.MMHolder
    local MinimapPanel = _G.MinimapPanel

    local widthPct = self.db.enable and self.db.widthPercentage or 1
    local heightPct = self.db.enable and self.db.heightPercentage or 1
    local newWidth = widthPct * E.MinimapSize
    local newHeight = heightPct * E.MinimapSize

    local borderWidth, borderHeight = E.PixelMode and 2 or 6, E.PixelMode and 2 or 8
    local panelSize, joinPanel = (MinimapPanel:IsShown() and MinimapPanel:GetHeight()) or (E.PixelMode and 1 or -1), 1
    local holderHeight = newHeight + (panelSize - joinPanel)

    Minimap:Size(newWidth, newHeight)
    MMHolder:Size(newWidth + borderWidth, holderHeight + borderHeight)
    _G.MinimapMover:Size(newWidth + borderWidth, holderHeight + borderHeight)
end

function RM:SetUpdateHook()
    if not self.Initialized then
        self:SecureHook(MM, "SetGetMinimapShape", "ChangeShape")
        self:SecureHook(MM, "UpdateSettings", "ChangeShape")
        self:SecureHook(MM, "Initialize", "ChangeShape")
        self:SecureHook(E, "UpdateAll", "ChangeShape")
        self.Initialized = true
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
    self.db = E.db.WT.maps.rectangleMinimap

    if not self.db then
        return
    end

    if self.db.enable then
        self:SetUpdateHook()
    else
        self:ChangeShape()
    end
end

W:RegisterModule(RM:GetName())
