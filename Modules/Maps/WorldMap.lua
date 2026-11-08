local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local WM = W:NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local ceil = ceil
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local mod = mod
local pairs = pairs
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber
local wipe = wipe

local EventRegistry = EventRegistry
local Pool_HideAndClearAnchors = Pool_HideAndClearAnchors

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_MapExplorationInfo_GetExploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures
local C_Map_GetMapArtID = C_Map.GetMapArtID
local C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
local C_Map_GetMapInfo = C_Map.GetMapInfo

-- STRUCTURE:
-- UiMapArtID = {
--     ["TextureWidth:TextureHeight:offsetX:offsetY"] = WorldMapOverlayTileFileDataID
--     ...
-- }

-- Fog data
-- Raw Table: [WorldMapOverlay, WorldMapOverlayTile]
-- Tool: https://github.com/fang2hou/WindToolsScripts/tree/master/MapOverlay
-- Because our code is based on Leatrix Maps, we also need to use the same data format to make maintaining easier.
-- Retail rows are WorldMapReveal_Retail.lua. WoW Forever rows are WorldMapReveal_Forever.lua.
local RevealDatabase = W.WorldMapRevealDatabase or {}

local function resetCache(cache)
	for _, tex in pairs(cache.overlayTextures) do
		tex:SetVertexColor(1, 1, 1, 1)
	end

	wipe(cache.overlayTextures)
end

local worldMapCache = { overlayTextures = {}, RemoveAllData = resetCache }
local battleFieldMapCache = { overlayTextures = {}, RemoveAllData = resetCache }

-- Interface\AddOns\Blizzard_SharedMapDataProviders\MapExplorationDataProvider.lua
-- MapExplorationPinMixin:RefreshOverlays(fullUpdate)
-- Some tricky code from Leatrix_Maps
function WM:MapExplorationPin_RefreshOverlays(pin, fullUpdate, cache)
	local wasWaitingForLoad = pin.isWaitingForLoad
	cache:RemoveAllData()
	if fullUpdate or wasWaitingForLoad then
		pin.isWaitingForLoad = true
		pin:SetAlpha(0)
	end

	local drawLayer = pin.dataProvider:GetDrawLayer()

	if not self.db or not self.db.reveal.enable then
		return
	end

	local mapCanvas = pin:GetMap()
	local mapID = pin:GetMap():GetMapID()
	local uiMapArtID = C_Map_GetMapArtID(mapID)
	local db = uiMapArtID and RevealDatabase[uiMapArtID]
	if not db then
		return
	end

	local exploredMapTextures = C_MapExplorationInfo_GetExploredMapTextures(mapID)
	if exploredMapTextures then
		for _, info in pairs(exploredMapTextures) do
			local key = info.textureWidth .. ":" .. info.textureHeight .. ":" .. info.offsetX .. ":" .. info.offsetY
			db[key] = nil
		end
	end

	pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
	local layers = C_Map_GetMapArtLayers(mapID)
	local layerInfo = layers and layers[pin.layerIndex]
	if not layerInfo then
		return
	end
	local TILE_SIZE_WIDTH = layerInfo.tileWidth
	local TILE_SIZE_HEIGHT = layerInfo.tileHeight

	-- Get the map type (needed to make sure only zone maps are tinted)
	local mapType = C_Map_GetMapInfo(mapID).mapType or 0

	for key, files in pairs(db) do
		local textureWidthStr, textureHeightStr, offsetXStr, offsetYStr = strsplit(":", key)
		local textureWidth = tonumber(textureWidthStr)
		local textureHeight = tonumber(textureHeightStr)
		local offsetX = tonumber(offsetXStr)
		local offsetY = tonumber(offsetYStr)

		if not (textureWidth and textureHeight and offsetX and offsetY) then
			return
		end

		local fileDataIDs = { strsplit(",", files) }
		local numTexturesWide = ceil(textureWidth / TILE_SIZE_WIDTH)
		local numTexturesTall = ceil(textureHeight / TILE_SIZE_HEIGHT)
		local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
		for j = 1, numTexturesTall do
			if j < numTexturesTall then
				texturePixelHeight = TILE_SIZE_HEIGHT
				textureFileHeight = TILE_SIZE_HEIGHT
			else
				texturePixelHeight = mod(textureHeight, TILE_SIZE_HEIGHT)
				if texturePixelHeight == 0 then
					texturePixelHeight = TILE_SIZE_HEIGHT
				end
				textureFileHeight = 16
				while textureFileHeight < texturePixelHeight do
					textureFileHeight = textureFileHeight * 2
				end
			end
			for k = 1, numTexturesWide do
				local texture = pin.overlayTexturePool:Acquire()
				mapCanvas:AddMaskableTexture(texture)
				tinsert(cache.overlayTextures, texture)
				if k < numTexturesWide then
					texturePixelWidth = TILE_SIZE_WIDTH
					textureFileWidth = TILE_SIZE_WIDTH
				else
					texturePixelWidth = mod(textureWidth, TILE_SIZE_WIDTH)
					if texturePixelWidth == 0 then
						texturePixelWidth = TILE_SIZE_WIDTH
					end
					textureFileWidth = 16
					while textureFileWidth < texturePixelWidth do
						textureFileWidth = textureFileWidth * 2
					end
				end
				texture:Width(texturePixelWidth)
				texture:Height(texturePixelHeight)
				texture:SetTexCoord(0, texturePixelWidth / textureFileWidth, 0, texturePixelHeight / textureFileHeight)
				texture:Point(
					"TOPLEFT",
					offsetX + (TILE_SIZE_WIDTH * (k - 1)),
					-(offsetY + (TILE_SIZE_HEIGHT * (j - 1)))
				)
				texture:SetTexture(fileDataIDs[((j - 1) * numTexturesWide) + k], nil, nil, "TRILINEAR")

				if self.db and self.db.reveal.useColor and mapType == 3 then
					texture:SetVertexColor(
						WM.db.reveal.color.r,
						WM.db.reveal.color.g,
						WM.db.reveal.color.b,
						WM.db.reveal.color.a
					)
				end
				texture:SetDrawLayer(drawLayer, -1)
				texture:Show()

				if fullUpdate then
					pin.textureLoadGroup:AddTexture(texture)
				end
			end
		end
	end
end

local function overlayTexturePoolResetter(pool, texture)
	texture:SetVertexColor(1, 1, 1)
	texture:SetAlpha(1)
	return Pool_HideAndClearAnchors(pool, texture)
end

-- Reveal features are modified based on Leatrix_Maps
function WM:Reveal()
	if not self.db.reveal.enable then
		return
	end

	if E.myfaction == "Alliance" then
		local allianceOverlayTextures = RevealDatabase[556]
		local allianceTexture = allianceOverlayTextures and allianceOverlayTextures["223:279:194:0"]
		if allianceTexture then
			allianceOverlayTextures["223:279:194:0"] = gsub(allianceTexture, "1037663", "")
		end
	elseif E.myfaction == "Horde" then
		local hordeOverlayTextures = RevealDatabase[542]
		local hordeTexture = hordeOverlayTextures and hordeOverlayTextures["267:257:336:327"]
		if hordeTexture then
			hordeOverlayTextures["267:257:336:327"] = gsub(hordeTexture, "1003342", "")
		end
	end

	for pin in _G.WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		hooksecurefunc(pin, "RefreshOverlays", function(_pin, fullUpdate)
			WM:MapExplorationPin_RefreshOverlays(_pin, fullUpdate, worldMapCache)
		end)
		hooksecurefunc(pin, "OnReleased", function(_pin)
			pin.isWaitingForLoad = nil
		end)
		pin.overlayTexturePool.resetterFunc = overlayTexturePoolResetter
	end

	if C_AddOns_IsAddOnLoaded("Blizzard_BattlefieldMap") then
		self:RevealBattleFieldMap()
	else
		self:RegisterEvent("ADDON_LOADED")
	end
end

function WM:RevealBattleFieldMap()
	for pin in _G.BattlefieldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		hooksecurefunc(pin, "RefreshOverlays", function(_pin, fullUpdate)
			WM:MapExplorationPin_RefreshOverlays(_pin, fullUpdate, battleFieldMapCache)
		end)
		pin.overlayTexturePool.resetterFunc = overlayTexturePoolResetter
	end
end

function WM:Scale()
	if not self.db.scale.enable then
		return
	end

	_G.WorldMapFrame:SetClampedToScreen(true)
	_G.WorldMapFrame:SetScale(self.db.scale.size)

	EventRegistry:RegisterCallback("WorldMapMinimized", _G.WorldMapFrame.SetScale, _G.WorldMapFrame, self.db.scale.size)
	EventRegistry:RegisterCallback("WorldMapMaximized", _G.WorldMapFrame.SetScale, _G.WorldMapFrame, 1)
end

function WM:ADDON_LOADED(event, addonName)
	if addonName == "Blizzard_BattlefieldMap" then
		self:UnregisterEvent(event)
		self:RevealBattleFieldMap()
	end
end

function WM:Initialize()
	if C_AddOns_IsAddOnLoaded("Mapster") then
		self.StopRunning = "Mapster"
		return
	end

	self.db = E.private.WT.maps.worldMap

	if not self.db or not self.db.enable then
		return
	end

	self:Scale()
	self:Reveal()
end

W:RegisterModule(WM:GetName())
