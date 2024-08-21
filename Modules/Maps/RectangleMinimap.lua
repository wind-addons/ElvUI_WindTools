local W, F, E, L = unpack((select(2, ...)))
local RM = W:NewModule("RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
local M = E:GetModule("Minimap")

local _G = _G
local abs = abs
local ceil = ceil
local floor = floor
local format = format
local hooksecurefunc = hooksecurefunc
local tinsert = tinsert
local tremove = tremove

local InCombatLockdown = InCombatLockdown

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function RM:HereBeDragons_Pins_AddMinimapIconMap(_, _, icon)
	if icon.SetPoint then
		hooksecurefunc(icon, "SetPoint", function(pin, arg1, arg2, arg3, arg4, arg5)
			if self.db and self.db.enable and self.effectiveHeight and self.effectiveHeight > 0 then
				if arg1 and arg1 == "CENTER" and arg3 and arg3 == "CENTER" then
					if arg5 and abs(arg5) > self.effectiveHeight / 2 then
						pin:SetAlpha(0)
					else
						pin:SetAlpha(1)
					end
				end
			end
		end)
	end
end

function RM:HandyNotesFix()
	local lib = _G.LibStub("HereBeDragons-Pins-2.0", true)
	if not lib then
		return
	end

	self.HereBeDragonsPinLib = lib

	-- self:SecureHook(lib, "AddMinimapIconMap", "HereBeDragons_Pins_AddMinimapIconMap")
end

function RM:ChangeShape()
	if not self.db or InCombatLockdown() then
		return
	end

	local Minimap = _G.Minimap
	local holder = M.MapHolder
	local panel = _G.MinimapPanel

	local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
	local texturePath = format([[Interface\AddOns\ElvUI_WindTools\Media\Textures\MinimapMasks\%d.tga]], fileID)
	local heightPct = fileID / 128
	local newHeight = E.MinimapSize * heightPct
	local diff = E.MinimapSize - newHeight
	local halfDiff = ceil(diff / 2)

	local mmOffset = E.PixelMode and 1 or 3
	local mmScale = E.db.general.minimap.scale

	-- First, update the size and position of the ElvUI Minimap holder and mover
	self.effectiveHeight = newHeight
	self:UpdateMiniMapHolderAndMover()

	-- Update the size and position of the panel
	if panel:IsShown() then
		panel:ClearAllPoints()
		panel:Point("TOPLEFT", Minimap, "BOTTOMLEFT", -E.Border, (E.PixelMode and 0 or -3) + halfDiff * mmScale)
		panel:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", E.Border, -23 + halfDiff * mmScale)
	end

	-- Do not allow the Minimap to be dragged off screen because the canvas cannot go off screen
	Minimap:SetClampedToScreen(true)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:ClearAllPoints()
	Minimap:Point("TOPRIGHT", holder, -mmOffset / mmScale, -mmOffset / mmScale + halfDiff)

	-- Update mask
	Minimap:SetMaskTexture(texturePath)
	Minimap:SetHitRectInsets(0, 0, halfDiff, halfDiff)

	-- Update the size and position of the Minimap
	Minimap.backdrop:ClearAllPoints()
	Minimap.backdrop:SetOutside(Minimap, mmOffset, -halfDiff * mmScale + mmOffset)

	-- Update the size and position of the Minimap location text
	if Minimap.location then
		Minimap.location:ClearAllPoints()
		Minimap.location:Point("TOP", Minimap, 0, -4 - halfDiff * mmScale)
	end

	-- HybridMinimap support
	if _G.HybridMinimap then
		local mapCanvas = _G.HybridMinimap.MapCanvas
		local rectangleMask = _G.HybridMinimap:CreateMaskTexture()
		rectangleMask:SetTexture(texturePath)
		rectangleMask:SetAllPoints(_G.HybridMinimap)
		_G.HybridMinimap.RectangleMask = rectangleMask
		mapCanvas:SetMaskTexture(rectangleMask)
		mapCanvas:SetUseMaskTexture(true)
	end
end

function RM:UpdateMiniMapHolderAndMover()
	local panel = _G.MinimapPanel
	local holder = M.MapHolder
	local mover = _G.MinimapMover
	local scale = E.db.general.minimap.scale

	local mWidth, mHeight = _G.Minimap:GetWidth(), self.effectiveHeight
	local bWidth, bHeight = E:Scale(E.PixelMode and 2 or 6), E:Scale(E.PixelMode and 2 or 8)
	local panelSize, joinPanel = (panel:IsShown() and panel:GetHeight()) or E:Scale(E.PixelMode and 1 or -1), E:Scale(1)
	local HEIGHT, WIDTH = (mHeight * scale) + (panelSize - joinPanel), mWidth * scale

	holder:SetSize(WIDTH + bWidth, HEIGHT + bHeight)
	mover:SetSize(WIDTH + bWidth, HEIGHT + bHeight)
end

function RM:SetUpdateHook()
	if not self.initialized and M.Initialized then
		self:SecureHook(M, "SetGetMinimapShape", "ChangeShape")
		self:SecureHook(M, "UpdateSettings", "ChangeShape")
		self.initialized = true
	end

	self:ChangeShape()
end

function RM:Blizzard_Minimap_Loaded()
	self:SetUpdateHook()
end

function RM:Blizzard_HybridMinimap_Loaded()
	self:SetUpdateHook()
end

function RM:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetUpdateHook()
end

function RM:Initialize()
	self.db = E.db.WT.maps.rectangleMinimap
	if not self.db or not self.db.enable or not M.Initialized then
		return
	end

	if C_AddOns_IsAddOnLoaded("HandyNotes") then
		self:HandyNotesFix()
	end

	self.addonLoadedCallbacks = {}
	if not C_AddOns_IsAddOnLoaded("Blizzard_Minimap") then
		tinsert(self.addonLoadedCallbacks, { "Blizzard_Minimap", self.Blizzard_Minimap_Loaded })
	end

	if not C_AddOns_IsAddOnLoaded("Blizzard_HybridMinimap") then
		tinsert(self.addonLoadedCallbacks, { "Blizzard_HybridMinimap", self.Blizzard_HybridMinimap_Loaded })
	end

	if #self.addonLoadedCallbacks > 0 then
		self:RegisterEvent("ADDON_LOADED")
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function RM:ADDON_LOADED(_, addon)
	for i = 1, #self.addonLoadedCallbacks do
		local callback = self.addonLoadedCallbacks[i]
		if callback[1] == addon then
			callback[2](self)
			tremove(self.addonLoadedCallbacks, i)
			break
		end
	end

	if #self.addonLoadedCallbacks == 0 then
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
	elseif self.initialized then
		self:ChangeShape()
	end
end

W:RegisterModule(RM:GetName())
