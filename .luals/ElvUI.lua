---@diagnostic disable: duplicate-doc-field
---@meta

---@class ElvUI
---@field db ElvUIProfileDB
---@field private ElvUIPrivateDB
---@field global ElvUIGlobalDB
---@field TexCoords number[]
local E = {}

---@class ElvUIProfileDB
---@field WT ProfileDB
---@field general {font: string}

---@class ElvUIPrivateDB
---@field WT PrivateDB

---@class ElvUIGlobalDB
---@field WT GlobalDB

-- ============================================================================
-- ELVUI CORE API FUNCTIONS
-- ============================================================================

---@class ClassColor
---@field r number Red component (0-1)
---@field g number Green component (0-1)
---@field b number Blue component (0-1)
---@field colorStr string Hex color string

---@class SpecInfo
---@field id number Specialization ID
---@field index number Specialization index
---@field classFile string Class file name
---@field className string Class name
---@field classMale string Male class name
---@field classFemale string Female class name
---@field englishName string English specialization name
---@field name string Localized specialization name
---@field desc string Specialization description
---@field icon number Specialization icon ID
---@field role string Specialization role (TANK, HEALER, DAMAGER)

---@class TooltipData
---@field name string Tooltip name
---@field lines table Tooltip lines data

---@class WatchedFactionInfo
---@field name string Faction name
---@field reaction number Current reaction level
---@field currentReactionThreshold number Current reaction threshold
---@field nextReactionThreshold number Next reaction threshold
---@field currentStanding number Current standing
---@field factionID number Faction ID

---@class AuraData
---@field name string Aura name
---@field icon number Aura icon
---@field count number Aura stack count
---@field debuffType string Debuff type
---@field duration number Aura duration
---@field expirationTime number Aura expiration time
---@field source string Aura source
---@field isStealable boolean Is aura stealable
---@field nameplateShowPersonal boolean Show on nameplate
---@field spellId number Spell ID

-- ============================================================================
-- CORE UTILITY FUNCTIONS
-- ============================================================================

---Registers clicks for frames with retail/classic compatibility
---@param frame Frame Frame to register clicks for
function E:RegisterClicks(frame) end

---Gets currency ID from a currency link
---@param link string Currency link
---@return number|nil currencyID Currency ID or nil
function E:GetCurrencyIDFromLink(link) end

---Gets date/time information
---@param localTime? boolean If true, use local time instead of realm time
---@param unix? boolean If true, return unix timestamp
---@return table|number dateTable Date table or unix timestamp
function E:GetDateTime(localTime, unix) end

---Gets class color information
---@param class string Class name
---@param usePriestColor? boolean If true, use priest color for priests
---@return ClassColor|nil color Class color table or nil
function E:ClassColor(class, usePriestColor) end

---Gets quality color information
---@param quality number Item quality level
---@return table color Quality color table
function E:GetQualityColor(quality) end

---Gets item quality color RGB values
---@param quality number Item quality level
---@return number r Red component
---@return number g Green component
---@return number b Blue component
function E:GetItemQualityColor(quality) end

---Gets inverse class color
---@param class string Class name
---@param usePriestColor? boolean If true, use priest color for priests
---@param forceCap? boolean If true, force color capping
---@return ClassColor color Inverse class color table
function E:InverseClassColor(class, usePriestColor, forceCap) end

---Gets class information by class file or class ID
---@param value string|number Class file name or class ID
---@return table|nil classInfo Class information table or nil
function E:GetClassInfo(value) end

---Gets unlocalized class name
---@param className string Localized class name
---@return string|nil classFile Unlocalized class file name or nil
function E:UnlocalizedClassName(className) end

---Gets localized class name
---@param className string Class file name
---@param unit? string|number Unit or gender number
---@return string localizedName Localized class name
function E:LocalizedClassName(className, unit) end

-- ============================================================================
-- ADDITIONAL ELVUI UTILITY METHODS
-- ============================================================================

---Checks if frame has restricted point access (8.2+)
---@param frame Frame|Region Frame to check
---@return boolean isRestricted True if frame has restricted point access
function E:SetPointsRestricted(frame) end

---Safely gets point information from a frame
---@param frame Frame|Region Frame to get point from
---@return AnchorPoint|string|nil point The anchor point or nil
---@return Frame|Region|string|nil relativeTo The relative frame or nil
---@return AnchorPoint|string|nil relativePoint The relative anchor point or nil
---@return number|nil xOfs X offset or nil
---@return number|nil yOfs Y offset or nil
function E:SafeGetPoint(frame) end

-- ============================================================================
-- SPECIALIZATION FUNCTIONS
-- ============================================================================

---Gets unit specialization information
---@param unit string Unit to check
---@return SpecInfo|nil specInfo Specialization information or nil
function E:GetUnitSpecInfo(unit) end

---Populates specialization information tables
function E:PopulateSpecInfo() end

---Scans tooltip for textures (gems and essences)
---@return table gems Gem textures table
---@return table essences Essence textures table
function E:ScanTooltipTextures() end

-- ============================================================================
-- MOUSE AND FOCUS FUNCTIONS
-- ============================================================================

---Gets mouse focus with backwards compatibility
---@return Frame|nil frame Mouse focus frame or nil
function E:GetMouseFocus() end

-- ============================================================================
-- SPELL FUNCTIONS
-- ============================================================================

---Gets spell information
---@param spellID number Spell ID
---@return string|nil name Spell name
---@return number|nil rank Spell rank
---@return number|nil icon Spell icon
---@return number|nil castTime Cast time
---@return number|nil minRange Minimum range
---@return number|nil maxRange Maximum range
---@return number|nil spellID Spell ID
---@return number|nil originalIconID Original icon ID
function E:GetSpellInfo(spellID) end

---Gets spell charges information
---@param spellID number Spell ID
---@return number|nil currentCharges Current charges
---@return number|nil maxCharges Maximum charges
---@return number|nil cooldownStartTime Cooldown start time
---@return number|nil cooldownDuration Cooldown duration
---@return number|nil chargeModRate Charge modification rate
function E:GetSpellCharges(spellID) end

---Gets spell cooldown information
---@param spellID number Spell ID
---@return number|nil startTime Cooldown start time
---@return number|nil duration Cooldown duration
---@return boolean|nil isEnabled Is cooldown enabled
---@return number|nil modRate Modification rate
function E:GetSpellCooldown(spellID) end

---Gets spell rename from BigWigs
---@param spellID number Spell ID
---@return string|nil renamedName Renamed spell name or nil
function E:GetSpellRename(spellID) end

---Sets spell rename in BigWigs
---@param spellID number Spell ID
---@param text string New spell name
function E:SetSpellRename(spellID, text) end

-- ============================================================================
-- AURA FUNCTIONS
-- ============================================================================

---Gets aura data for a unit
---@param unitToken string Unit token
---@param index number Aura index
---@param filter string Aura filter
---@return AuraData|nil auraData Aura data or nil
function E:GetAuraData(unitToken, index, filter) end

---Gets aura by spell ID
---@param unit string Unit to check
---@param spellID number Spell ID to find
---@param filter? string Aura filter
---@return AuraData|nil auraData Aura data or nil
function E:GetAuraByID(unit, spellID, filter) end

---Gets aura by name
---@param unit string Unit to check
---@param name string Aura name to find
---@param filter? string Aura filter
---@return AuraData|nil auraData Aura data or nil
function E:GetAuraByName(unit, name, filter) end

-- ============================================================================
-- THREAT AND ROLE FUNCTIONS
-- ============================================================================

---Gets threat status color
---@param status number Threat status
---@param nothreat? boolean If true, return no threat color
---@return number r Red component
---@return number g Green component
---@return number b Blue component
---@return number a Alpha component
function E:GetThreatStatusColor(status, nothreat) end

---Gets player role
---@return string role Player role (TANK, HEALER, DAMAGER, NONE)
function E:GetPlayerRole() end

---Checks and updates player role
function E:CheckRole() end

---Checks if debuff type is dispellable by player
---@param debuffType string Debuff type
---@return boolean isDispellable True if dispellable
function E:IsDispellableByMe(debuffType) end

---Updates dispel color for a debuff type
---@param debuffType string Debuff type
---@param r number Red component
---@param g number Green component
---@param b number Blue component
function E:UpdateDispelColor(debuffType, r, g, b) end

---Updates all dispel colors
function E:UpdateDispelColors() end

-- ============================================================================
-- CUSTOM CLASS COLOR FUNCTIONS
-- ============================================================================

---Triggers custom class color update callbacks
function E:CustomClassColorUpdate() end

---Registers a custom class color callback
---@param func function Callback function
function E:CustomClassColorRegister(func) end

---Unregisters a custom class color callback
---@param func function Callback function
function E:CustomClassColorUnregister(func) end

---Notifies of custom class color changes
function E:CustomClassColorNotify() end

---Gets class token from localized class name
---@param className string Localized class name
---@return string|nil classToken Class token or nil
function E:CustomClassColorClassToken(className) end

---Sets up custom class colors
---@return table customColors Custom class colors table
function E:SetupCustomClassColors() end

---Updates custom class color for a class
---@param classTag string Class tag
---@param r number Red component
---@param g number Green component
---@param b number Blue component
function E:UpdateCustomClassColor(classTag, r, g, b) end

---Updates all custom class colors
---@return boolean changed True if any colors were changed
function E:UpdateCustomClassColors() end

-- ============================================================================
-- COMMAND BAR FUNCTIONS
-- ============================================================================

---Handles Order Hall command bar settings
function E:HandleCommandBar() end

-- ============================================================================
-- MASQUE INTEGRATION FUNCTIONS
-- ============================================================================

---Masque callback for group state changes
---@param Group string Masque group name
---@param SkinID string Skin ID
---@param SkinTable table Skin table
---@param SkinName string Skin name
---@param SkinOptions table Skin options
---@param Disabled boolean Is disabled
function E:MasqueCallback(Group, SkinID, SkinTable, SkinName, SkinOptions, Disabled) end

-- ============================================================================
-- DEBUG FUNCTIONS
-- ============================================================================

---Dumps object for debugging
---@param object any Object to dump
---@param inspect? boolean If true, use table inspector
function E:Dump(object, inspect) end

-- ============================================================================
-- PET BATTLE FRAME FUNCTIONS
-- ============================================================================

---Adds non-pet battle frames back to UIParent
function E:AddNonPetBattleFrames() end

---Removes non-pet battle frames from UIParent
function E:RemoveNonPetBattleFrames() end

---Registers frame to be hidden during pet battles
---@param object Frame|string Frame object or name
---@param originalParent Frame Original parent frame
---@param originalStrata? string Original frame strata
function E:RegisterPetBattleHideFrames(object, originalParent, originalStrata) end

---Unregisters frame from pet battle hiding
---@param object Frame|string Frame object or name
function E:UnregisterPetBattleHideFrames(object) end

-- ============================================================================
-- VEHICLE LOCK FUNCTIONS
-- ============================================================================

---Registers object for vehicle lock
---@param object Frame|string Frame object or name
---@param originalParent Frame Original parent frame
function E:RegisterObjectForVehicleLock(object, originalParent) end

---Unregisters object from vehicle lock
---@param object Frame|string Frame object or name
function E:UnregisterObjectForVehicleLock(object) end

---Hides frames when entering vehicle
---@param event string Event name
---@param unit string Unit that entered vehicle
function E:EnterVehicleHideFrames(event, unit) end

---Shows frames when exiting vehicle
---@param event string Event name
---@param unit string Unit that exited vehicle
function E:ExitVehicleShowFrames(event, unit) end

-- ============================================================================
-- BATTLEGROUND FUNCTIONS
-- ============================================================================

---Requests battlefield score data
function E:RequestBGInfo() end

---Gets watched faction information
---@return WatchedFactionInfo|table factionInfo Faction information
function E:GetWatchedFactionInfo() end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

---Handles PLAYER_ENTERING_WORLD event
---@param event string Event name
---@param initLogin boolean Is initial login
---@param isReload boolean Is reload
function E:PLAYER_ENTERING_WORLD(event, initLogin, isReload) end

---Handles PLAYER_REGEN_ENABLED event
function E:PLAYER_REGEN_ENABLED() end

---Handles PLAYER_REGEN_DISABLED event
function E:PLAYER_REGEN_DISABLED() end

---Alerts if in combat
---@return boolean inCombat True if in combat
function E:AlertCombat() end

---Checks if trial account is at max level
---@return boolean isTrialMax True if trial at max level
function E:XPIsTrialMax() end

---Checks if player is at max level
---@return boolean isLevelMax True if at max level
function E:XPIsLevelMax() end

---Gets group unit for a unit
---@param unit string Unit to check
---@return string|nil groupUnit Group unit or nil
function E:GetGroupUnit(unit) end

---Gets unit battlefield faction
---@param unit string Unit to check
---@return string englishFaction English faction name
---@return string localizedFaction Localized faction name
function E:GetUnitBattlefieldFaction(unit) end

---Handles NEUTRAL_FACTION_SELECT_RESULT event
function E:NEUTRAL_FACTION_SELECT_RESULT() end

---Handles PLAYER_LEVEL_UP event
---@param event string Event name
---@param level number New level
function E:PLAYER_LEVEL_UP(event, level) end

-- ============================================================================
-- GAME MENU FUNCTIONS
-- ============================================================================

---Positions game menu button
function E:PositionGameMenuButton() end

---Handles game menu button click
function E:ClickGameMenu() end

---Scales game menu
function E:ScaleGameMenu() end

---Sets up game menu
function E:SetupGameMenu() end

-- ============================================================================
-- TOOLTIP FUNCTIONS
-- ============================================================================

---Makes tooltip compatible with GetTooltipData
---@param tt GameTooltip Tooltip to make compatible
function E:CompatibleTooltip(tt) end

---Gets class icon coordinates
---@param classFile string Class file name
---@param crop? boolean|number If true or number, crop coordinates
---@param get? boolean If true, return raw coordinates
---@return number left Left coordinate
---@return number right Right coordinate
---@return number top Top coordinate
---@return number bottom Bottom coordinate
function E:GetClassCoords(classFile, crop, get) end

---Crops texture coordinates based on ratio
---@param width number Texture width
---@param height number Texture height
---@param mult? number Crop multiplier (default 0.5)
---@return number left Left coordinate
---@return number right Right coordinate
---@return number top Top coordinate
---@return number bottom Bottom coordinate
function E:CropRatio(width, height, mult) end

---Scans tooltip for unit information
---@param unit string Unit to scan
---@return TooltipData|nil tooltipData Tooltip data or nil
function E:ScanTooltip_UnitInfo(unit) end

---Scans tooltip for inventory item information
---@param unit string Unit to scan
---@param slot number Inventory slot
---@return TooltipData|nil tooltipData Tooltip data or nil
function E:ScanTooltip_InventoryInfo(unit, slot) end

---Scans tooltip for hyperlink information
---@param link string Hyperlink to scan
---@return TooltipData|nil tooltipData Tooltip data or nil
function E:ScanTooltip_HyperlinkInfo(link) end

---Creates a complicated menu with backwards compatibility
---@param menuList table Menu list data
---@param menuFrame Frame Menu frame
---@param anchor Frame|string Anchor frame or point
---@param x? number X offset
---@param y? number Y offset
---@param displayMode? string Display mode
---@param autoHideDelay? number Auto hide delay
function E:ComplicatedMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay) end

---Loads the API module
function E:LoadAPI() end

-- ============================================================================
-- PIXEL SNAP AND DISPLAY METHODS
-- ============================================================================

---Disables pixel snapping for a frame
---@param frame Frame|Region Frame to disable pixel snapping for
function E:DisablePixelSnap(frame) end

---Watches pixel snap changes for a frame
---@param frame Frame|Region Frame to watch
---@param snap boolean Whether to enable pixel snapping
function E:WatchPixelSnap(frame, snap) end

---Sets backdrop frame level
---@param frame Frame|Region Frame to set level for
---@param level number Frame level
function E:BackdropFrameLevel(frame, level) end

---Lowers backdrop frame level relative to parent
---@param backdrop Frame|Region Backdrop frame
---@param parent Frame|Region Parent frame
function E:BackdropFrameLower(backdrop, parent) end

---Gets template colors and settings
---@generic T : string
---@param template T Template name
---@param isUnitFrameElement boolean Whether this is a unit frame element
---@return T
function E:GetTemplate(template, isUnitFrameElement) end

return E