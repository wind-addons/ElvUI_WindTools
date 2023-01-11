local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local M = E:GetModule("Minimap")

local _G = _G
local abs = abs
local ceil = ceil
local floor = floor
local format = format
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local sqrt = sqrt

local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded

function RM:HereBeDragons_Pins_AddMinimapIconMap(_, _, icon)
    if icon.SetPoint then
        hooksecurefunc(
            icon,
            "SetPoint",
            function(pin, arg1, arg2, arg3, arg4, arg5)
                if self.db and self.db.enable and self.effectiveHeight and self.effectiveHeight > 0 then
                    if arg1 and arg1 == "CENTER" and arg3 and arg3 == "CENTER" then
                        if arg5 and abs(arg5) > self.effectiveHeight / 2 then
                            pin:SetAlpha(0)
                        else
                            pin:SetAlpha(1)
                        end
                    end
                end
            end
        )
    end
end

function RM:HandyNotesFix()
    local lib = _G.LibStub("HereBeDragons-Pins-2.0", true)
    if not lib then
        return
    end

    self.HereBeDragonsPinLib = lib

    self:SecureHook(lib, "AddMinimapIconMap", "HereBeDragons_Pins_AddMinimapIconMap")
end

function RM:ChangeShape()
    if not self.db then
        return
    end

    if InCombatLockdown() then
        return
    end

    local Minimap = _G.Minimap
    local MinimapPanel = _G.MinimapPanel
    local MinimapBackdrop = _G.MinimapBackdrop

    local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
    local texturePath = format("Interface\\AddOns\\ElvUI_WindTools\\Media\\Textures\\MinimapMasks\\%d.tga", fileID)
    local heightPct = fileID / 128
    local newHeight = E.MinimapSize * heightPct
    local diff = E.MinimapSize - newHeight
    local halfDiff = ceil(diff / 2)

    Minimap:SetClampedToScreen(true)
    Minimap:SetMaskTexture(texturePath)
    Minimap:Size(E.MinimapSize, E.MinimapSize)
    Minimap:SetHitRectInsets(0, 0, halfDiff * E.mult, halfDiff * E.mult)
    Minimap:SetClampRectInsets(0, 0, 0, 0)
    _G.MinimapMover:SetClampRectInsets(0, 0, halfDiff * E.mult, -halfDiff * E.mult)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPLEFT", M.MapHolder, "TOPLEFT", E.Border, -E.Border + halfDiff)
    Minimap.backdrop:SetOutside(Minimap, 1, -halfDiff + 1)
    MinimapBackdrop:SetOutside(Minimap.backdrop)

    if _G.HybridMinimap then
        local mapCanvas = _G.HybridMinimap.MapCanvas
        local rectangleMask = _G.HybridMinimap:CreateMaskTexture()
        rectangleMask:SetTexture(texturePath)
        rectangleMask:SetAllPoints(_G.HybridMinimap)
        _G.HybridMinimap.RectangleMask = rectangleMask
        mapCanvas:SetMaskTexture(rectangleMask)
        mapCanvas:SetUseMaskTexture(true)
    end

    if Minimap.location then
        Minimap.location:ClearAllPoints()
        Minimap.location:SetPoint("TOP", M.MapHolder, "TOP", 0, -5)
    end

    if MinimapPanel:IsShown() then
        MinimapPanel:ClearAllPoints()
        MinimapPanel:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -E.Border, (E.PixelMode and 0 or -3) + halfDiff)
        MinimapPanel:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", E.Border, -23 + halfDiff)
    end

    self:Minimap_Holder_Size()
    self.effectiveHeight = newHeight
end

do
    local isRunning
    function RM:Minimap_Holder_Size()
        if isRunning then
            return
        end

        isRunning = true

        local MinimapPanel = _G.MinimapPanel

        local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
        local newHeight = E.MinimapSize * fileID / 128

        local borderWidth, borderHeight = E.PixelMode and 2 or 6, E.PixelMode and 2 or 8
        local panelSize, joinPanel =
            (MinimapPanel:IsShown() and MinimapPanel:GetHeight()) or (E.PixelMode and 1 or -1),
            1
        local holderHeight = newHeight + (panelSize - joinPanel)

        M.MapHolder:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
        _G.MinimapMover:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
        isRunning = false
    end
end

function RM:SetUpdateHook()
    if not self.initialized then
        self:SecureHook(M, "SetGetMinimapShape", "ChangeShape")
        self:SecureHook(M, "UpdateSettings", "ChangeShape")
        self:SecureHook(M, "Initialize", "ChangeShape")
        self:SecureHook(M.MapHolder, "Size", "Minimap_Holder_Size")
        self.initialized = true
    end
    self:ChangeShape()
    E:Delay(1, self.ChangeShape, self)
end

function RM:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    if self.initialized then
        E:Delay(1, self.ChangeShape, self)
    else
        self:SetUpdateHook()
    end
end

function RM:Initialize()
    self.db = E.db.WT.maps.rectangleMinimap
    if not self.db or not self.db.enable or not M.Initialized then
        return
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ADDON_LOADED")

    if IsAddOnLoaded("HandyNotes") then
        self:HandyNotesFix()
    end
end

function RM:ADDON_LOADED(_, addon)
    if addon == "Blizzard_HybridMinimap" then
        self:ChangeShape()
        self:UnregisterEvent("ADDON_LOADED")
    end
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
