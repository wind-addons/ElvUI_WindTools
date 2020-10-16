local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local MM = E:GetModule("Minimap")

local _G = _G
local floor = floor
local format = format
local pairs = pairs
local sqrt = sqrt

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
    local MinimapBackdrop = _G.MinimapBackdrop

    local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
    local texturePath = format("Interface\\AddOns\\ElvUI_WindTools\\Media\\Textures\\MinimapMasks\\%d.tga", fileID)
    local heightPct = fileID / 128
    local newHeight = E.MinimapSize * heightPct
    local diff = E.MinimapSize - newHeight

    Minimap:SetMaskTexture(texturePath)
    Minimap:Size(E.MinimapSize, E.MinimapSize)
    Minimap:SetHitRectInsets(0, 0, (diff / 2) * E.mult, (diff / 2) * E.mult)
    Minimap:SetClampRectInsets(0, 0, 0, 0)
    Minimap:ClearAllPoints()
    Minimap:Point("TOPLEFT", MMHolder, "TOPLEFT", E.Border, -E.Border + diff / 2)
    Minimap.backdrop:SetOutside(Minimap, 1, -(diff / 2) + 1)
    MinimapBackdrop:SetOutside(Minimap.backdrop)

    if Minimap.location then
        Minimap.location:ClearAllPoints()
        Minimap.location:Point("TOP", MMHolder, "TOP", 0, -5)
    end

    self:MMHolder_Size()
end

do
    local isRunning
    function RM:MMHolder_Size()
        if isRunning then
            return
        end

        isRunning = true

        local MinimapPanel = _G.MinimapPanel
        local MMHolder = _G.MMHolder

        local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
        local newHeight = E.MinimapSize * fileID / 128

        local borderWidth, borderHeight = E.PixelMode and 2 or 6, E.PixelMode and 2 or 8
        local panelSize, joinPanel =
            (MinimapPanel:IsShown() and MinimapPanel:GetHeight()) or (E.PixelMode and 1 or -1),
            1
        local holderHeight = newHeight + (panelSize - joinPanel)

        MMHolder:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
        _G.MinimapMover:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
        isRunning = false
    end
end

function RM:SetUpdateHook()
    if not self.Initialized then
        self:SecureHook(MM, "SetGetMinimapShape", "ChangeShape")
        self:SecureHook(MM, "UpdateSettings", "ChangeShape")
        self:SecureHook(MM, "Initialize", "ChangeShape")
        self:SecureHook(E, "UpdateAll", "ChangeShape")
        self:SecureHook(_G.MMHolder, "Size", "MMHolder_Size")
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
