local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local MM = E:GetModule("Minimap")

local _G = _G
local sqrt = sqrt

local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown

local function Wind_Minimap_OnClick(map)
    local heightPercentage
    if not RM or not RM.db or not RM.db.enable then
        heightPercentage = 1
    else
        heightPercentage = RM.db.heightPercentage or 1
    end

    local x, y = GetCursorPosition()
    x = x / map:GetEffectiveScale()
    y = y / map:GetEffectiveScale()

    local cx, cy = map:GetCenter()
    cy = cy + 0.5 * (1 - heightPercentage) * E.MinimapSize

    x = x - cx
    y = y - cy
    x = x * heightPercentage

    if (sqrt(x * x + y * y) < (E.MinimapSize / 2)) then
        _G.Minimap:PingLocation(x, y)
    end
end

_G.Minimap_OnClick = Wind_Minimap_OnClick

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

    local heightPct = self.db.enable and self.db.heightPercentage or 1
    local newHeight = heightPct * E.MinimapSize

    local borderWidth, borderHeight = E.PixelMode and 2 or 6, E.PixelMode and 2 or 8
    local panelSize, joinPanel = (MinimapPanel:IsShown() and MinimapPanel:GetHeight()) or (E.PixelMode and 1 or -1), 1
    local holderHeight = newHeight + (panelSize - joinPanel)

    Minimap:Size(E.MinimapSize, newHeight)
    MMHolder:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
    _G.MinimapMover:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
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
