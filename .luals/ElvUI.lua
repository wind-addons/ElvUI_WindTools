---@diagnostic disable: duplicate-doc-field
---@meta

---@class ElvUI
---@field db ElvUIProfileDB
---@field private ElvUIPrivateDB
---@field global ElvUIGlobalDB
---@field TexCoords number[]
---@field DF table Defaults table
---@field privateVars table Private variables table
---@field Options table Options configuration
---@field callbacks table Callback handler
---@field wowpatch string WoW patch version
---@field wowbuild string WoW build version
---@field wowdate string WoW date
---@field wowtoc string WoW TOC version
---@field locale string Game locale
---@field oUF table oUF reference
---@field Libs table Libraries table
---@field LibsMinor table Library minor versions
---@field FPS table FPS tracking data
---@field OtherAddons table Other addon states
---@field InfoColor string Info color string
---@field InfoColor2 string Secondary info color
---@field twoPixelsPlease boolean Two pixels mode
---@field TBC boolean The Burning Crusade Classic
---@field Cata boolean Cataclysm Classic
---@field Wrath boolean Wrath Classic
---@field Mists boolean Mists Classic
---@field Retail boolean Retail WoW
---@field Classic boolean Classic WoW
---@field ClassicHC boolean Classic Hardcore
---@field ClassicSOD boolean Season of Discovery
---@field ClassicAnniv boolean Classic Anniversary
---@field ClassicAnnivHC boolean Classic Anniversary Hardcore
---@field IsHardcoreActive boolean Is hardcore active
---@field IsEngravingEnabled boolean Is engraving enabled
---@field QualityColors table Item quality colors
---@field myClassColor ClassColor Player's class color
---@field loadedtime number Load time
---@field serverID number Server ID
---@field myguid string Player GUID
---@field PixelMode boolean Pixel perfect mode
---@field Border number Border size
---@field Spacing number Spacing size
---@field SpellBookTooltip GameTooltip Spell book tooltip
---@field ConfigTooltip GameTooltip Config tooltip
---@field ScanTooltip GameTooltip Scan tooltip
---@field EasyMenu Frame Easy menu frame
---@field myname string Player name
---@field mynameRealm string Player name with realm
---@field myclass string Player class
---@field myrace string Player race
---@field myfaction string Player faction
---@field mylevel number Player level
---@field myrealm string Player realm
---@field ActionBars ActionBarsModule Action bars module
---@field AFK AFKModule AFK module
---@field Auras AurasModule Auras module
---@field Bags BagsModule Bags module
---@field Blizzard BlizzardModule Blizzard module
---@field Chat ChatModule Chat module
---@field DataBars DataBarsModule Data bars module
---@field DataTexts DataTextsModule Data texts module
---@field DebugTools DebugToolsModule Debug tools module
---@field Distributor DistributorModule Distributor module
---@field EditorMode EditorModeModule Editor mode module
---@field Layout LayoutModule Layout module
---@field Minimap MinimapModule Minimap module
---@field Misc MiscModule Misc module
---@field ModuleCopy ModuleCopyModule Module copy module
---@field NamePlates NamePlatesModule Name plates module
---@field PluginInstaller PluginInstallerModule Plugin installer module
---@field PrivateAuras PrivateAurasModule Private auras module
---@field RaidUtility RaidUtilityModule Raid utility module
---@field Skins SkinsModule Skins module
---@field Tooltip TooltipModule Tooltip module
---@field TotemTracker TotemTrackerModule Totem tracker module
---@field UnitFrames UnitFramesModule Unit frames module
---@field WorldMap WorldMapModule World map module
---@field Masque table Masque library reference
local E = {}

---@class ElvUIProfileDB
---@field WT ProfileDB
---@field gridSize number Grid size
---@field layoutSetting string Layout setting
---@field hideTutorial boolean Hide tutorial
---@field dbConverted any Database converted flag
---@field general ElvUIGeneralProfile
---@field databars ElvUIDataBarsProfile
---@field bags ElvUIBagsProfile
---@field nameplates ElvUINamePlatesProfile
---@field auras ElvUIAurasProfile
---@field chat ElvUIChatProfile
---@field datatexts ElvUIDataTextsProfile
---@field tooltip ElvUITooltipProfile
---@field unitframe ElvUIUnitFrameProfile
---@field cooldown ElvUICooldownProfile
---@field actionbar ElvUIActionBarProfile
---@field cdmanager ElvUICDManagerProfile
---@field WeakAuras ElvUIWeakAurasProfile

---@class ElvUIPrivateDB
---@field WT PrivateDB
---@field general ElvUIGeneralPrivate
---@field bags ElvUIBagsPrivate
---@field nameplates ElvUINamePlatesPrivate
---@field auras ElvUIAurasPrivate
---@field chat ElvUIChatPrivate
---@field skins ElvUISkinsPrivate
---@field tooltip ElvUITooltipPrivate
---@field unitframe ElvUIUnitFramePrivate
---@field actionbar ElvUIActionBarPrivate

---@class ElvUIGlobalDB
---@field WT GlobalDB
---@field general ElvUIGeneralGlobal
---@field classtimer table Class timer settings
---@field chat ElvUIChatGlobal
---@field bags ElvUIBagsGlobal
---@field datatexts ElvUIDataTextsGlobal
---@field nameplates table Name plates global settings
---@field unitframe ElvUIUnitFrameGlobal
---@field profileCopy ElvUIProfileCopyGlobal

-- ============================================================================
-- ELVUI MODULE DEFINITIONS
-- ============================================================================

---@class ElvUIModule
---@field db table Module database
---@field private table Module private data

---@class ActionBarsModule : ElvUIModule
---@field db table Action bars database

---@class AFKModule : ElvUIModule
---@field db table AFK database

---@class AurasModule : ElvUIModule
---@field db table Auras database

---@class BagsModule : ElvUIModule
---@field db table Bags database

---@class BlizzardModule : ElvUIModule
---@field db table Blizzard database

---@class ChatModule : ElvUIModule
---@field db table Chat database

---@class DataBarsModule : ElvUIModule
---@field db table Data bars database

---@class DataTextsModule : ElvUIModule
---@field db table Data texts database

---@class DebugToolsModule : ElvUIModule
---@field db table Debug tools database

---@class DistributorModule : ElvUIModule
---@field db table Distributor database

---@class EditorModeModule : ElvUIModule
---@field db table Editor mode database

---@class LayoutModule : ElvUIModule
---@field db table Layout database

---@class MinimapModule : ElvUIModule
---@field db table Minimap database

---@class MiscModule : ElvUIModule
---@field db table Misc database

---@class ModuleCopyModule : ElvUIModule
---@field db table Module copy database

---@class NamePlatesModule : ElvUIModule
---@field db table Name plates database

---@class PluginInstallerModule : ElvUIModule
---@field db table Plugin installer database

---@class PrivateAurasModule : ElvUIModule
---@field db table Private auras database

---@class RaidUtilityModule : ElvUIModule
---@field db table Raid utility database

---@class SkinsModule : ElvUIModule
---@field db table Skins database

---@class TooltipModule : ElvUIModule
---@field db table Tooltip database

---@class TotemTrackerModule : ElvUIModule
---@field db table Totem tracker database

---@class UnitFramesModule : ElvUIModule
---@field db table Unit frames database
---@field LSM table LibSharedMedia reference

---@class WorldMapModule : ElvUIModule
---@field db table World map database

-- ============================================================================
-- ELVUI GLOBAL SETTINGS CLASSES
-- ============================================================================

---@class ElvUIGeneralGlobal
---@field UIScale number UI scale
---@field locale string Locale setting
---@field eyefinity boolean Eyefinity support
---@field ultrawide boolean Ultrawide support
---@field smallerWorldMap boolean Smaller world map
---@field allowDistributor boolean Allow distributor
---@field smallerWorldMapScale number Smaller world map scale
---@field fadeMapWhenMoving boolean Fade map when moving
---@field mapAlphaWhenMoving number Map alpha when moving
---@field fadeMapDuration number Fade map duration
---@field WorldMapCoordinates ElvUIWorldMapCoordinates World map coordinates settings
---@field AceGUI ElvUIAceGUISettings AceGUI settings
---@field disableTutorialButtons boolean Disable tutorial buttons
---@field commandBarSetting string Command bar setting

---@class ElvUIWorldMapCoordinates
---@field enable boolean Enable coordinates
---@field position string Position
---@field xOffset number X offset
---@field yOffset number Y offset

---@class ElvUIAceGUISettings
---@field width number Width
---@field height number Height

---@class ElvUIChatGlobal
---@field classColorMentionExcludedNames string[] Excluded names for class color mentions

---@class ElvUIBagsGlobal
---@field ignoredItems string[] Ignored items

---@class ElvUIDataTextsGlobal
---@field customPanels table Custom panels
---@field customCurrencies table Custom currencies
---@field settings ElvUIDataTextSettings Data text settings
---@field newPanelInfo ElvUINewPanelInfo New panel info

---@class ElvUIDataTextSettings
---@field Agility ElvUIDataTextSetting Agility settings
---@field Armor ElvUIDataTextSetting Armor settings
---@field ['Attack Power'] ElvUIDataTextSetting Attack power settings
---@field Avoidance ElvUIDataTextSetting Avoidance settings
---@field Bags ElvUIBagsDataTextSetting Bags settings
---@field CallToArms ElvUIDataTextSetting Call to arms settings
---@field Combat ElvUICombatDataTextSetting Combat settings
---@field CombatIndicator ElvUICombatIndicatorSetting Combat indicator settings
---@field Currencies ElvUICurrenciesDataTextSetting Currencies settings
---@field Crit ElvUIDataTextSetting Crit settings
---@field Durability ElvUIDurabilityDataTextSetting Durability settings
---@field DualSpecialization ElvUIDataTextSetting Dual specialization settings
---@field ElvUI ElvUIDataTextSetting ElvUI settings
---@field ['Equipment Sets'] ElvUIEquipmentSetsSetting Equipment sets settings
---@field Experience ElvUIExperienceDataTextSetting Experience settings
---@field Friends ElvUIFriendsDataTextSetting Friends settings
---@field Gold ElvUIGoldDataTextSetting Gold settings
---@field Guild ElvUIGuildDataTextSetting Guild settings
---@field Haste ElvUIDataTextSetting Haste settings
---@field Hit ElvUIDataTextSetting Hit settings
---@field Intellect ElvUIDataTextSetting Intellect settings
---@field ['Item Level'] ElvUIItemLevelDataTextSetting Item level settings
---@field Leech ElvUIDataTextSetting Leech settings
---@field Location ElvUILocationDataTextSetting Location settings
---@field Mastery ElvUIDataTextSetting Mastery settings
---@field MovementSpeed ElvUIDataTextSetting Movement speed settings
---@field QuickJoin ElvUIDataTextSetting Quick join settings
---@field Reputation ElvUIExperienceDataTextSetting Reputation settings
---@field ['Talent/Loot Specialization'] ElvUITalentSpecializationSetting Talent specialization settings
---@field SpellPower ElvUISpellPowerSetting Spell power settings
---@field ['Spell Crit Chance'] ElvUISpellPowerSetting Spell crit chance settings
---@field Speed ElvUIDataTextSetting Speed settings
---@field Stamina ElvUIDataTextSetting Stamina settings
---@field Strength ElvUIDataTextSetting Strength settings
---@field System ElvUISystemDataTextSetting System settings
---@field Time ElvUITimeDataTextSetting Time settings
---@field Versatility ElvUIDataTextSetting Versatility settings
---@field Dodge ElvUIDataTextSetting Dodge settings
---@field Parry ElvUIDataTextSetting Parry settings
---@field Block ElvUIDataTextSetting Block settings
---@field ['Mana Regen'] ElvUIDataTextSetting Mana regen settings
---@field HealPower ElvUIDataTextSetting Heal power settings
---@field ['Spell Hit'] ElvUIDataTextSetting Spell hit settings

---@class ElvUIDataTextSetting
---@field Label string Label
---@field NoLabel boolean No label
---@field decimalLength? number Decimal length

---@class ElvUIBagsDataTextSetting : ElvUIDataTextSetting
---@field textFormat string Text format
---@field includeReagents boolean Include reagents

---@class ElvUICombatDataTextSetting
---@field TimeFull boolean Time full
---@field NoLabel boolean No label

---@class ElvUICombatIndicatorSetting
---@field OutOfCombat string Out of combat text
---@field InCombat string In combat text
---@field OutOfCombatColor table Out of combat color
---@field InCombatColor table In combat color

---@class ElvUICurrenciesDataTextSetting
---@field goldFormat string Gold format
---@field goldCoins boolean Gold coins
---@field displayedCurrency string Displayed currency
---@field displayStyle string Display style
---@field tooltipData table Tooltip data
---@field idEnable table ID enable
---@field headers boolean Headers
---@field maxCurrency boolean Max currency

---@class ElvUIDurabilityDataTextSetting : ElvUIDataTextSetting
---@field percThreshold number Percentage threshold
---@field goldFormat string Gold format
---@field goldCoins boolean Gold coins

---@class ElvUIEquipmentSetsSetting : ElvUIDataTextSetting
---@field NoIcon boolean No icon

---@class ElvUIExperienceDataTextSetting
---@field textFormat string Text format

---@class ElvUIFriendsDataTextSetting : ElvUIDataTextSetting
---@field hideAFK boolean Hide AFK
---@field hideDND boolean Hide DND
---@field hideWoW boolean Hide WoW
---@field hideD3 boolean Hide D3
---@field hideVIPR boolean Hide VIPR
---@field hideWTCG boolean Hide WTCG
---@field hideHero boolean Hide Hero
---@field hidePro boolean Hide Pro
---@field hideS1 boolean Hide S1
---@field hideS2 boolean Hide S2
---@field hideBSAp boolean Hide BSAP
---@field hideApp boolean Hide App

---@class ElvUIGoldDataTextSetting
---@field goldFormat string Gold format
---@field maxLimit number Max limit
---@field goldCoins boolean Gold coins

---@class ElvUIGuildDataTextSetting : ElvUIDataTextSetting
---@field maxLimit number Max limit

---@class ElvUIItemLevelDataTextSetting : ElvUIDataTextSetting
---@field onlyEquipped boolean Only equipped
---@field rarityColor boolean Rarity color

---@class ElvUILocationDataTextSetting
---@field showZone boolean Show zone
---@field showSubZone boolean Show sub zone
---@field showContinent boolean Show continent
---@field color string Color
---@field customColor table Custom color

---@class ElvUITalentSpecializationSetting
---@field displayStyle string Display style
---@field showBoth boolean Show both
---@field iconSize number Icon size
---@field iconOnly boolean Icon only

---@class ElvUISpellPowerSetting
---@field school number School

---@class ElvUISystemDataTextSetting
---@field NoLabel boolean No label
---@field ShowOthers boolean Show others
---@field latency string Latency
---@field showTooltip boolean Show tooltip

---@class ElvUITimeDataTextSetting
---@field time24 boolean 24 hour time
---@field localTime boolean Local time
---@field flashInvite boolean Flash invite
---@field savedInstances boolean Saved instances

---@class ElvUINewPanelInfo
---@field growth string Growth direction
---@field width number Width
---@field height number Height
---@field frameStrata string Frame strata
---@field numPoints number Number of points
---@field frameLevel number Frame level
---@field backdrop boolean Backdrop
---@field panelTransparency boolean Panel transparency
---@field mouseover boolean Mouseover
---@field border boolean Border
---@field textJustify string Text justify
---@field visibility string Visibility
---@field tooltipAnchor string Tooltip anchor
---@field tooltipXOffset number Tooltip X offset
---@field tooltipYOffset number Tooltip Y offset
---@field fonts ElvUIPanelFonts Panel fonts

---@class ElvUIPanelFonts
---@field enable boolean Enable custom fonts
---@field font string Font
---@field fontSize number Font size
---@field fontOutline string Font outline

---@class ElvUIUnitFrameGlobal
---@field aurawatch table Aura watch settings
---@field aurafilters table Aura filters
---@field raidDebuffIndicator ElvUIRaidDebuffIndicator Raid debuff indicator
---@field newCustomText ElvUINewCustomText New custom text
---@field rangeCheck ElvUIRangeCheck Range check settings

---@class ElvUIRaidDebuffIndicator
---@field instanceFilter string Instance filter
---@field otherFilter string Other filter

---@class ElvUINewCustomText
---@field text_format string Text format
---@field size number Size
---@field font string Font
---@field fontOutline string Font outline
---@field xOffset number X offset
---@field yOffset number Y offset
---@field justifyH string Justify horizontal
---@field attachTextTo string Attach text to

---@class ElvUIRangeCheck
---@field FRIENDLY ElvUIRangeCheckFaction Friendly range check
---@field ENEMY ElvUIRangeCheckFaction Enemy range check
---@field RESURRECT ElvUIRangeCheckFaction Resurrect range check
---@field PET ElvUIRangeCheckFaction Pet range check

---@class ElvUIRangeCheckFaction
---@field DEATHKNIGHT table Death knight spells
---@field DEMONHUNTER table Demon hunter spells
---@field DRUID table Druid spells
---@field EVOKER table Evoker spells
---@field HUNTER table Hunter spells
---@field MAGE table Mage spells
---@field MONK table Monk spells
---@field PALADIN table Paladin spells
---@field PRIEST table Priest spells
---@field ROGUE table Rogue spells
---@field SHAMAN table Shaman spells
---@field WARLOCK table Warlock spells
---@field WARRIOR table Warrior spells

---@class ElvUIProfileCopyGlobal
---@field selected string Selected profile

-- ============================================================================
-- ELVUI PRIVATE SETTINGS CLASSES
-- ============================================================================

---@class ElvUIGeneralPrivate
---@field loot boolean Enable loot
---@field lootRoll boolean Enable loot roll
---@field normTex string Normal texture
---@field glossTex string Gloss texture
---@field dmgfont string Damage font
---@field namefont string Name font
---@field chatBubbles string Chat bubbles style
---@field chatBubbleFont string Chat bubble font
---@field chatBubbleFontSize number Chat bubble font size
---@field chatBubbleFontOutline string Chat bubble font outline
---@field chatBubbleName boolean Chat bubble name
---@field nameplateFont string Nameplate font
---@field nameplateFontSize number Nameplate font size
---@field nameplateFontOutline string Nameplate font outline
---@field nameplateLargeFont string Nameplate large font
---@field nameplateLargeFontSize number Nameplate large font size
---@field nameplateLargeFontOutline string Nameplate large font outline
---@field pixelPerfect boolean Pixel perfect mode
---@field replaceNameFont boolean Replace name font
---@field replaceCombatFont boolean Replace combat font
---@field replaceCombatText boolean Replace combat text
---@field replaceBubbleFont boolean Replace bubble font
---@field replaceNameplateFont boolean Replace nameplate font
---@field replaceBlizzFonts boolean Replace Blizzard fonts
---@field blizzardFontSize boolean Blizzard font size
---@field noFontScale boolean No font scale
---@field totemTracker boolean Totem tracker
---@field classColors boolean Class colors
---@field queueStatus boolean Queue status
---@field minimap ElvUIMinimapPrivate Minimap settings
---@field classColorMentionsSpeech boolean Class color mentions speech
---@field raidUtility boolean Raid utility
---@field voiceOverlay boolean Voice overlay
---@field worldMap boolean World map

---@class ElvUIMinimapPrivate
---@field enable boolean Enable minimap
---@field hideClassHallReport boolean Hide class hall report
---@field hideCalendar boolean Hide calendar
---@field hideTracking boolean Hide tracking

---@class ElvUIBagsPrivate
---@field enable boolean Enable bags
---@field bagBar boolean Enable bag bar

---@class ElvUINamePlatesPrivate
---@field enable boolean Enable nameplates

---@class ElvUIAurasPrivate
---@field enable boolean Enable auras
---@field disableBlizzard boolean Disable Blizzard auras
---@field buffsHeader boolean Buffs header
---@field debuffsHeader boolean Debuffs header
---@field masque ElvUIAurasMasquePrivate Masque settings

---@class ElvUIAurasMasquePrivate
---@field buffs boolean Buffs masque
---@field debuffs boolean Debuffs masque

---@class ElvUIChatPrivate
---@field enable boolean Enable chat

---@class ElvUISkinsPrivate
---@field ace3Enable boolean Ace3 enable
---@field libDropdown boolean Lib dropdown
---@field checkBoxSkin boolean Checkbox skin
---@field parchmentRemoverEnable boolean Parchment remover enable
---@field blizzard ElvUIBlizzardSkinsPrivate Blizzard skins

---@class ElvUIBlizzardSkinsPrivate
---@field enable boolean Enable Blizzard skins
---@field achievement boolean Achievement skin
---@field addonManager boolean Addon manager skin
---@field adventureMap boolean Adventure map skin
---@field alertframes boolean Alert frames skin
---@field alliedRaces boolean Allied races skin
---@field animaDiversion boolean Anima diversion skin
---@field archaeology boolean Archaeology skin
---@field arena boolean Arena skin
---@field arenaRegistrar boolean Arena registrar skin
---@field artifact boolean Artifact skin
---@field auctionhouse boolean Auction house skin
---@field azerite boolean Azerite skin
---@field azeriteEssence boolean Azerite essence skin
---@field azeriteRespec boolean Azerite respec skin
---@field bags boolean Bags skin
---@field barber boolean Barber skin
---@field battlefield boolean Battlefield skin
---@field bgmap boolean BG map skin
---@field bgscore boolean BG score skin
---@field binding boolean Binding skin
---@field blizzardOptions boolean Blizzard options skin
---@field bmah boolean Black market skin
---@field calendar boolean Calendar skin
---@field channels boolean Channels skin
---@field character boolean Character skin
---@field chromieTime boolean Chromie time skin
---@field cooldownManager boolean Cooldown manager skin
---@field collections boolean Collections skin
---@field communities boolean Communities skin
---@field contribution boolean Contribution skin
---@field covenantPreview boolean Covenant preview skin
---@field covenantRenown boolean Covenant renown skin
---@field covenantSanctum boolean Covenant sanctum skin
---@field craft boolean Craft skin
---@field deathRecap boolean Death recap skin
---@field debug boolean Debug skin
---@field dressingroom boolean Dressing room skin
---@field encounterjournal boolean Encounter journal skin
---@field engraving boolean Engraving skin
---@field eventLog boolean Event log skin
---@field friends boolean Friends skin
---@field garrison boolean Garrison skin
---@field gbank boolean Guild bank skin
---@field gmChat boolean GM chat skin
---@field gossip boolean Gossip skin
---@field greeting boolean Greeting skin
---@field guide boolean Guide skin
---@field guild boolean Guild skin
---@field guildBank boolean Guild bank skin
---@field guildcontrol boolean Guild control skin
---@field guildregistrar boolean Guild registrar skin
---@field help boolean Help skin
---@field inspect boolean Inspect skin
---@field islandQueue boolean Island queue skin
---@field islandsPartyPose boolean Islands party pose skin
---@field itemInteraction boolean Item interaction skin
---@field itemUpgrade boolean Item upgrade skin
---@field lfg boolean LFG skin
---@field lfguild boolean LFGuild skin
---@field loot boolean Loot skin
---@field losscontrol boolean Loss control skin
---@field macro boolean Macro skin
---@field mail boolean Mail skin
---@field merchant boolean Merchant skin
---@field mirrorTimers boolean Mirror timers skin
---@field misc boolean Misc skin
---@field nonraid boolean Non-raid skin
---@field objectiveTracker boolean Objective tracker skin
---@field obliterum boolean Obliterum skin
---@field orderhall boolean Order hall skin
---@field perks boolean Perks skin
---@field petbattleui boolean Pet battle UI skin
---@field petition boolean Petition skin
---@field playerChoice boolean Player choice skin
---@field pvp boolean PvP skin
---@field quest boolean Quest skin
---@field questChoice boolean Quest choice skin
---@field questTimers boolean Quest timers skin
---@field raid boolean Raid skin
---@field reforge boolean Reforge skin
---@field runeforge boolean Runeforge skin
---@field scrapping boolean Scrapping skin
---@field socket boolean Socket skin
---@field soulbinds boolean Soulbinds skin
---@field spellbook boolean Spellbook skin
---@field stable boolean Stable skin
---@field subscriptionInterstitial boolean Subscription interstitial skin
---@field tabard boolean Tabard skin
---@field talent boolean Talent skin
---@field talkinghead boolean Talking head skin
---@field taxi boolean Taxi skin
---@field timemanager boolean Time manager skin
---@field tooltip boolean Tooltip skin
---@field torghastLevelPicker boolean Torghast level picker skin
---@field trade boolean Trade skin
---@field tradeskill boolean Tradeskill skin
---@field trainer boolean Trainer skin
---@field transmogrify boolean Transmogrify skin
---@field tutorials boolean Tutorials skin
---@field weeklyRewards boolean Weekly rewards skin
---@field worldmap boolean World map skin
---@field expansionLanding boolean Expansion landing skin
---@field majorFactions boolean Major factions skin
---@field genericTrait boolean Generic trait skin
---@field editor boolean Editor skin
---@field campsites boolean Campsites skin

---@class ElvUITooltipPrivate
---@field enable boolean Enable tooltip

---@class ElvUIUnitFramePrivate
---@field enable boolean Enable unit frames
---@field disabledBlizzardFrames ElvUIDisabledBlizzardFrames Disabled Blizzard frames

---@class ElvUIDisabledBlizzardFrames
---@field castbar boolean Disable castbar
---@field player boolean Disable player frame
---@field target boolean Disable target frame
---@field focus boolean Disable focus frame
---@field boss boolean Disable boss frames
---@field arena boolean Disable arena frames
---@field party boolean Disable party frames
---@field raid boolean Disable raid frames

---@class ElvUIActionBarPrivate
---@field enable boolean Enable action bars
---@field hideCooldownBling boolean Hide cooldown bling
---@field masque ElvUIActionBarMasquePrivate Masque settings

---@class ElvUIActionBarMasquePrivate
---@field actionbars boolean Action bars masque
---@field petBar boolean Pet bar masque
---@field stanceBar boolean Stance bar masque

-- ============================================================================
-- ELVUI PROFILE SETTINGS CLASSES
-- ============================================================================

---@class ElvUIGeneralProfile
---@field messageRedirect string Message redirect
---@field smoothingAmount number Smoothing amount
---@field stickyFrames boolean Sticky frames
---@field loginmessage boolean Login message
---@field interruptAnnounce string Interrupt announce
---@field autoRepair string Auto repair
---@field autoTrackReputation boolean Auto track reputation
---@field autoAcceptInvite boolean Auto accept invite
---@field hideErrorFrame boolean Hide error frame
---@field hideZoneText boolean Hide zone text
---@field enhancedPvpMessages boolean Enhanced PvP messages
---@field objectiveFrameHeight number Objective frame height
---@field objectiveFrameAutoHide boolean Objective frame auto hide
---@field objectiveFrameAutoHideInKeystone boolean Objective frame auto hide in keystone
---@field bonusObjectivePosition string Bonus objective position
---@field talkingHeadFrameScale number Talking head frame scale
---@field talkingHeadFrameBackdrop boolean Talking head frame backdrop
---@field vehicleSeatIndicatorSize number Vehicle seat indicator size
---@field resurrectSound boolean Resurrect sound
---@field questRewardMostValueIcon boolean Quest reward most value icon
---@field questXPPercent boolean Quest XP percent
---@field durabilityScale number Durability scale
---@field gameMenuScale number Game menu scale
---@field lockCameraDistanceMax boolean Lock camera distance max
---@field cameraDistanceMax number Camera distance max
---@field afk boolean AFK
---@field afkChat boolean AFK chat
---@field afkSpin boolean AFK spin
---@field cropIcon number Crop icon
---@field objectiveTracker boolean Objective tracker
---@field numberPrefixStyle string Number prefix style
---@field tagUpdateRate number Tag update rate
---@field decimalLength number Decimal length
---@field fontSize number Font size
---@field font string Font
---@field fontStyle string Font style
---@field topPanel boolean Top panel
---@field bottomPanel boolean Bottom panel
---@field bottomPanelSettings ElvUIPanelSettings Bottom panel settings
---@field topPanelSettings ElvUIPanelSettings Top panel settings
---@field raidUtility ElvUIRaidUtility Raid utility settings
---@field fonts ElvUIFonts Font settings
---@field classColors table Class colors
---@field debuffColors table Debuff colors
---@field bordercolor table Border color
---@field backdropcolor table Backdrop color
---@field backdropfadecolor table Backdrop fade color
---@field valuecolor table Value color
---@field itemLevel ElvUIItemLevel Item level settings
---@field rotationAssist ElvUIRotationAssist Rotation assist settings
---@field customGlow ElvUICustomGlow Custom glow settings
---@field altPowerBar ElvUIAltPowerBar Alt power bar settings
---@field minimap ElvUIMinimapProfile Minimap settings
---@field lootRoll ElvUILootRoll Loot roll settings
---@field totems ElvUITotems Totem settings
---@field addonCompartment ElvUIAddonCompartment Addon compartment settings
---@field privateRaidWarning ElvUIPrivateRaidWarning Private raid warning settings
---@field privateAuras ElvUIPrivateAuras Private auras settings
---@field queueStatus ElvUIQueueStatus Queue status settings
---@field guildBank ElvUIGuildBank Guild bank settings
---@field cooldownManager ElvUICooldownManager Cooldown manager settings

---@class ElvUIPanelSettings
---@field transparent boolean Transparent
---@field height number Height
---@field width number Width

---@class ElvUIRaidUtility
---@field modifier string Modifier
---@field modifierSwap string Modifier swap
---@field showTooltip boolean Show tooltip

---@class ElvUIFonts
---@field cooldown ElvUIFontSetting Cooldown font
---@field errortext ElvUIFontSetting Error text font
---@field worldzone ElvUIFontSetting World zone font
---@field worldsubzone ElvUIFontSetting World sub zone font
---@field pvpzone ElvUIFontSetting PvP zone font
---@field pvpsubzone ElvUIFontSetting PvP sub zone font
---@field objective ElvUIFontSetting Objective font
---@field mailbody ElvUIFontSetting Mail body font
---@field questtitle ElvUIFontSetting Quest title font
---@field questtext ElvUIFontSetting Quest text font
---@field questsmall ElvUIFontSetting Quest small font
---@field talkingtitle ElvUIFontSetting Talking title font
---@field talkingtext ElvUIFontSetting Talking text font

---@class ElvUIFontSetting
---@field enable boolean Enable
---@field font string Font
---@field size number Size
---@field outline string Outline

---@class ElvUIItemLevel
---@field displayCharacterInfo boolean Display character info
---@field displayInspectInfo boolean Display inspect info
---@field enchantAbbrev boolean Enchant abbrev
---@field showItemLevel boolean Show item level
---@field showEnchants boolean Show enchants
---@field showGems boolean Show gems
---@field itemLevelRarity boolean Item level rarity
---@field itemLevelFont string Item level font
---@field itemLevelFontSize number Item level font size
---@field itemLevelFontOutline string Item level font outline
---@field totalLevelFont string Total level font
---@field totalLevelFontSize number Total level font size
---@field totalLevelFontOutline string Total level font outline

---@class ElvUIRotationAssist
---@field nextcast table Next cast color
---@field alternative table Alternative color
---@field spells table Spells by class

---@class ElvUICustomGlow
---@field style string Style
---@field color table Color
---@field startAnimation boolean Start animation
---@field useColor boolean Use color
---@field duration number Duration
---@field speed number Speed
---@field lines number Lines
---@field size number Size

---@class ElvUIAltPowerBar
---@field enable boolean Enable
---@field width number Width
---@field height number Height
---@field font string Font
---@field fontSize number Font size
---@field fontOutline string Font outline
---@field statusBar string Status bar
---@field textFormat string Text format
---@field statusBarColorGradient boolean Status bar color gradient
---@field statusBarColor table Status bar color
---@field smoothbars boolean Smooth bars

---@class ElvUIMinimapProfile
---@field size number Size
---@field scale number Scale
---@field circle boolean Circle
---@field rotate boolean Rotate
---@field clusterDisable boolean Cluster disable
---@field clusterBackdrop boolean Cluster backdrop
---@field locationText string Location text
---@field locationFontSize number Location font size
---@field locationFontOutline string Location font outline
---@field locationFont string Location font
---@field timeFontSize number Time font size
---@field timeFontOutline string Time font outline
---@field timeFont string Time font
---@field resetZoom ElvUIResetZoom Reset zoom settings
---@field icons ElvUIMinimapIcons Minimap icons

---@class ElvUIResetZoom
---@field enable boolean Enable
---@field time number Time

---@class ElvUIMinimapIcons
---@field classHall ElvUIMinimapIcon Class hall icon
---@field tracking ElvUIMinimapIcon Tracking icon
---@field calendar ElvUIMinimapIcon Calendar icon
---@field crafting ElvUIMinimapIcon Crafting icon
---@field mail ElvUIMinimapIcon Mail icon
---@field battlefield ElvUIMinimapIcon Battlefield icon
---@field difficulty ElvUIMinimapIcon Difficulty icon

---@class ElvUIMinimapIcon
---@field scale number Scale
---@field position string Position
---@field xOffset number X offset
---@field yOffset number Y offset
---@field hide? boolean Hide
---@field texture? string Texture
---@field spacing? number Spacing
---@field font? string Font
---@field fontOutline? string Font outline
---@field textPosition? string Text position
---@field textXOffset? number Text X offset
---@field textYOffset? number Text Y offset
---@field fontSize? number Font size

---@class ElvUILootRoll
---@field width number Width
---@field height number Height
---@field spacing number Spacing
---@field maxBars number Max bars
---@field buttonSize number Button size
---@field leftButtons boolean Left buttons
---@field qualityName boolean Quality name
---@field qualityItemLevel boolean Quality item level
---@field qualityStatusBar boolean Quality status bar
---@field qualityStatusBarBackdrop boolean Quality status bar backdrop
---@field statusBarColor table Status bar color
---@field statusBarTexture string Status bar texture
---@field style string Style
---@field nameFont string Name font
---@field nameFontSize number Name font size
---@field nameFontOutline string Name font outline

---@class ElvUITotems
---@field growthDirection string Growth direction
---@field sortDirection string Sort direction
---@field size number Size
---@field height number Height
---@field spacing number Spacing
---@field keepSizeRatio boolean Keep size ratio

---@class ElvUIAddonCompartment
---@field size number Size
---@field hide boolean Hide
---@field font string Font
---@field fontSize number Font size
---@field fontOutline string Font outline
---@field frameStrata string Frame strata
---@field frameLevel number Frame level

---@class ElvUIPrivateRaidWarning
---@field scale number Scale

---@class ElvUIPrivateAuras
---@field enable boolean Enable
---@field countdownFrame boolean Countdown frame
---@field countdownNumbers boolean Countdown numbers
---@field icon ElvUIPrivateAurasIcon Icon settings
---@field duration ElvUIPrivateAurasDuration Duration settings
---@field parent ElvUIPrivateAurasParent Parent settings

---@class ElvUIPrivateAurasIcon
---@field offset number Offset
---@field point string Point
---@field amount number Amount
---@field size number Size

---@class ElvUIPrivateAurasDuration
---@field enable boolean Enable
---@field point string Point
---@field offsetX number Offset X
---@field offsetY number Offset Y

---@class ElvUIPrivateAurasParent
---@field point string Point
---@field offsetX number Offset X
---@field offsetY number Offset Y

---@class ElvUIQueueStatus
---@field enable boolean Enable
---@field scale number Scale
---@field position string Position
---@field xOffset number X offset
---@field yOffset number Y offset
---@field font string Font
---@field fontSize number Font size
---@field fontOutline string Font outline
---@field frameStrata string Frame strata
---@field frameLevel number Frame level

---@class ElvUIGuildBank
---@field itemQuality boolean Item quality
---@field itemLevel boolean Item level
---@field itemLevelThreshold number Item level threshold
---@field itemLevelFont string Item level font
---@field itemLevelFontSize number Item level font size
---@field itemLevelFontOutline string Item level font outline
---@field itemLevelCustomColorEnable boolean Item level custom color enable
---@field itemLevelCustomColor table Item level custom color
---@field itemLevelPosition string Item level position
---@field itemLevelxOffset number Item level X offset
---@field itemLevelyOffset number Item level Y offset
---@field countFont string Count font
---@field countFontSize number Count font size
---@field countFontOutline string Count font outline
---@field countFontColor table Count font color
---@field countPosition string Count position
---@field countxOffset number Count X offset
---@field countyOffset number Count Y offset

---@class ElvUICooldownManager
---@field swipeColorSpell table Swipe color spell
---@field swipeColorAura table Swipe color aura
---@field nameFont string Name font
---@field nameFontSize number Name font size
---@field nameFontOutline string Name font outline
---@field nameFontColor table Name font color
---@field namePosition string Name position
---@field namexOffset number Name X offset
---@field nameyOffset number Name Y offset
---@field durationFont string Duration font
---@field durationFontSize number Duration font size
---@field durationFontOutline string Duration font outline
---@field durationFontColor table Duration font color
---@field durationPosition string Duration position
---@field durationxOffset number Duration X offset
---@field durationyOffset number Duration Y offset
---@field countFont string Count font
---@field countFontSize number Count font size
---@field countFontOutline string Count font outline
---@field countFontColor table Count font color
---@field countPosition string Count position
---@field countxOffset number Count X offset
---@field countyOffset number Count Y offset

---@class ElvUIDataBarsProfile
---@field transparent boolean Transparent
---@field statusbar string Status bar
---@field customTexture boolean Custom texture
---@field colors ElvUIDataBarsColors Data bars colors
---@field experience ElvUIDataBar Data bar for experience
---@field reputation ElvUIDataBar Data bar for reputation
---@field honor ElvUIDataBar Data bar for honor
---@field threat ElvUIDataBar Data bar for threat
---@field azerite ElvUIDataBar Data bar for azerite
---@field petExperience ElvUIDataBar Data bar for pet experience

---@class ElvUIDataBarsColors
---@field reputationAlpha number Reputation alpha
---@field useCustomFactionColors boolean Use custom faction colors
---@field petExperience table Pet experience color
---@field experience table Experience color
---@field rested table Rested color
---@field quest table Quest color
---@field honor table Honor color
---@field azerite table Azerite color
---@field factionColors table[] Faction colors

---@class ElvUIDataBar
---@field enable boolean Enable
---@field width number Width
---@field height number Height
---@field textFormat string Text format
---@field fontSize number Font size
---@field font string Font
---@field fontOutline string Font outline
---@field xOffset number X offset
---@field yOffset number Y offset
---@field displayText boolean Display text
---@field anchorPoint string Anchor point
---@field mouseover boolean Mouseover
---@field clickThrough boolean Click through
---@field hideInCombat boolean Hide in combat
---@field orientation string Orientation
---@field reverseFill boolean Reverse fill
---@field showBubbles boolean Show bubbles
---@field frameStrata string Frame strata
---@field frameLevel number Frame level

---@class ElvUIBagsProfile
---@field sortInverted boolean Sort inverted
---@field bankCombined boolean Bank combined
---@field warbandCombined boolean Warband combined
---@field warbandSize number Warband size
---@field bagSize number Bag size
---@field bagButtonSpacing number Bag button spacing
---@field bankButtonSpacing number Bank button spacing
---@field warbandButtonSpacing number Warband button spacing
---@field bankSize number Bank size
---@field bagWidth number Bag width
---@field bankWidth number Bank width
---@field warbandWidth number Warband width
---@field currencyFormat string Currency format
---@field moneyFormat string Money format
---@field moneyCoins boolean Money coins
---@field questIcon boolean Quest icon
---@field junkIcon boolean Junk icon
---@field junkDesaturate boolean Junk desaturate
---@field scrapIcon boolean Scrap icon
---@field upgradeIcon boolean Upgrade icon
---@field newItemGlow boolean New item glow
---@field ignoredItems string[] Ignored items
---@field itemLevel boolean Item level
---@field itemLevelThreshold number Item level threshold
---@field itemLevelFont string Item level font
---@field itemLevelFontSize number Item level font size
---@field itemLevelFontOutline string Item level font outline
---@field itemLevelCustomColorEnable boolean Item level custom color enable
---@field itemLevelCustomColor table Item level custom color
---@field itemLevelPosition string Item level position
---@field itemLevelxOffset number Item level X offset
---@field itemLevelyOffset number Item level Y offset
---@field itemInfo boolean Item info
---@field itemInfoFont string Item info font
---@field itemInfoFontSize number Item info font size
---@field itemInfoFontOutline string Item info font outline
---@field itemInfoColor table Item info color
---@field countFont string Count font
---@field countFontSize number Count font size
---@field countFontOutline string Count font outline
---@field countFontColor table Count font color
---@field countPosition string Count position
---@field countxOffset number Count X offset
---@field countyOffset number Count Y offset
---@field reverseLoot boolean Reverse loot
---@field reverseSlots boolean Reverse slots
---@field clearSearchOnClose boolean Clear search on close
---@field disableBagSort boolean Disable bag sort
---@field disableBankSort boolean Disable bank sort
---@field showAssignedColor boolean Show assigned color
---@field useBlizzardCleanup boolean Use Blizzard cleanup
---@field useBlizzardCleanupBank boolean Use Blizzard cleanup bank
---@field useBlizzardJunk boolean Use Blizzard junk
---@field strata string Strata
---@field qualityColors boolean Quality colors
---@field specialtyColors boolean Specialty colors
---@field showBindType boolean Show bind type
---@field transparent boolean Transparent
---@field showAssignedIcon boolean Show assigned icon
---@field colors ElvUIBagsColors Bags colors
---@field vendorGrays ElvUIVendorGrays Vendor grays settings
---@field split ElvUIBagsSplit Bags split settings
---@field shownBags table Shown bags
---@field autoToggle ElvUIBagsAutoToggle Auto toggle settings
---@field spinner ElvUIBagsSpinner Spinner settings
---@field bagBar ElvUIBagBar Bag bar settings

---@class ElvUIBagsColors
---@field profession table Profession colors
---@field assignment table Assignment colors
---@field items table Item colors

---@class ElvUIVendorGrays
---@field enable boolean Enable
---@field interval number Interval
---@field details boolean Details
---@field progressBar boolean Progress bar

---@class ElvUIBagsSplit
---@field bagSpacing number Bag spacing
---@field bankSpacing number Bank spacing
---@field warbandSpacing number Warband spacing
---@field player boolean Player
---@field bank boolean Bank
---@field warband boolean Warband
---@field alwaysProfessionBags boolean Always profession bags
---@field alwaysProfessionBank boolean Always profession bank

---@class ElvUIBagsAutoToggle
---@field enable boolean Enable
---@field bank boolean Bank
---@field mail boolean Mail
---@field vendor boolean Vendor
---@field soulBind boolean Soul bind
---@field auctionHouse boolean Auction house
---@field professions boolean Professions
---@field guildBank boolean Guild bank
---@field trade boolean Trade

---@class ElvUIBagsSpinner
---@field enable boolean Enable
---@field size number Size
---@field color table Color

---@class ElvUIBagBar
---@field growthDirection string Growth direction
---@field sortDirection string Sort direction
---@field size number Size
---@field spacing number Spacing
---@field backdropSpacing number Backdrop spacing
---@field showBackdrop boolean Show backdrop
---@field mouseover boolean Mouseover
---@field showCount boolean Show count
---@field justBackpack boolean Just backpack
---@field visibility string Visibility
---@field font string Font
---@field fontOutline string Font outline
---@field fontSize number Font size

---@class ElvUICooldownProfile
---@field threshold number Threshold
---@field roundTime boolean Round time
---@field targetAura boolean Target aura
---@field hideBlizzard boolean Hide Blizzard
---@field useIndicatorColor boolean Use indicator color
---@field showModRate boolean Show mod rate
---@field expiringColor table Expiring color
---@field secondsColor table Seconds color
---@field minutesColor table Minutes color
---@field hoursColor table Hours color
---@field daysColor table Days color
---@field expireIndicator table Expire indicator
---@field secondsIndicator table Seconds indicator
---@field minutesIndicator table Minutes indicator
---@field hoursIndicator table Hours indicator
---@field daysIndicator table Days indicator
---@field hhmmColorIndicator table HHMM color indicator
---@field mmssColorIndicator table MMSS color indicator
---@field checkSeconds boolean Check seconds
---@field targetAuraDuration number Target aura duration
---@field modRateColor table Mod rate color
---@field hhmmColor table HHMM color
---@field mmssColor table MMSS color
---@field hhmmThreshold number HHMM threshold
---@field mmssThreshold number MMSS threshold
---@field fonts ElvUICooldownFonts Fonts
---@field enable boolean Enable
---@field override boolean Override
---@field reverse boolean Reverse

---@class ElvUICooldownFonts
---@field enable boolean Enable
---@field font string Font
---@field fontOutline string Font outline
---@field fontSize number Font size

---@class ElvUICDManagerProfile
---@field cooldown ElvUICooldownProfile Cooldown settings

---@class ElvUIWeakAurasProfile
---@field cooldown ElvUICooldownProfile Cooldown settings

---@class ElvUIActionBarProfile
---@field chargeCooldown boolean Charge cooldown
---@field colorSwipeLOC table Color swipe LOC
---@field colorSwipeNormal table Color swipe normal
---@field hotkeyTextPosition string Hotkey text position
---@field macroTextPosition string Macro text position
---@field countTextPosition string Count text position
---@field countTextXOffset number Count text X offset
---@field countTextYOffset number Count text Y offset
---@field desaturateOnCooldown boolean Desaturate on cooldown
---@field equippedItem boolean Equipped item
---@field equippedItemColor table Equipped item color
---@field targetReticleColor table Target reticle color
---@field flashAnimation boolean Flash animation
---@field flyoutSize number Flyout size
---@field font string Font
---@field fontColor table Font color
---@field fontOutline string Font outline
---@field fontSize number Font size
---@field globalFadeAlpha number Global fade alpha
---@field handleOverlay boolean Handle overlay
---@field hideCooldownBling boolean Hide cooldown bling
---@field lockActionBars boolean Lock action bars
---@field movementModifier string Movement modifier
---@field noPowerColor table No power color
---@field noRangeColor table No range color
---@field notUsableColor table Not usable color
---@field checkSelfCast boolean Check self cast
---@field checkFocusCast boolean Check focus cast
---@field rightClickSelfCast boolean Right click self cast
---@field transparent boolean Transparent
---@field usableColor table Usable color
---@field useDrawSwipeOnCharges boolean Use draw swipe on charges
---@field useRangeColorText boolean Use range color text
---@field barPet ElvUIActionBarPet Pet bar settings
---@field stanceBar ElvUIActionBarStance Stance bar settings
---@field microbar ElvUIActionBarMicro Micro bar settings
---@field extraActionButton ElvUIActionBarExtra Extra action button settings
---@field zoneActionButton ElvUIActionBarZone Zone action button settings
---@field vehicleExitButton ElvUIActionBarVehicle Vehicle exit button settings
---@field cooldown ElvUICooldownProfile Cooldown settings

---@class ElvUIActionBarPet
---@field enabled boolean Enabled
---@field mouseover boolean Mouseover
---@field clickThrough boolean Click through
---@field buttons number Buttons
---@field buttonsPerRow number Buttons per row
---@field point string Point
---@field backdrop boolean Backdrop
---@field heightMult number Height mult
---@field widthMult number Width mult
---@field keepSizeRatio boolean Keep size ratio
---@field buttonSize number Button size
---@field buttonHeight number Button height
---@field buttonSpacing number Button spacing
---@field backdropSpacing number Backdrop spacing
---@field alpha number Alpha
---@field inheritGlobalFade boolean Inherit global fade
---@field visibility string Visibility
---@field countColor table Count color
---@field countFont string Count font
---@field countFontOutline string Count font outline
---@field countFontSize number Count font size
---@field countFontXOffset number Count font X offset
---@field countFontYOffset number Count font Y offset
---@field counttext boolean Count text
---@field countTextPosition string Count text position
---@field useCountColor boolean Use count color

---@class ElvUIActionBarStance
---@field enabled boolean Enabled
---@field style string Style
---@field mouseover boolean Mouseover
---@field clickThrough boolean Click through
---@field buttonsPerRow number Buttons per row
---@field buttons number Buttons
---@field point string Point
---@field backdrop boolean Backdrop
---@field heightMult number Height mult
---@field widthMult number Width mult
---@field keepSizeRatio boolean Keep size ratio
---@field buttonSize number Button size
---@field buttonHeight number Button height
---@field buttonSpacing number Button spacing
---@field backdropSpacing number Backdrop spacing
---@field alpha number Alpha
---@field inheritGlobalFade boolean Inherit global fade
---@field visibility string Visibility

---@class ElvUIActionBarMicro
---@field enabled boolean Enabled
---@field mouseover boolean Mouseover
---@field useIcons boolean Use icons
---@field buttonsPerRow number Buttons per row
---@field buttonSize number Button size
---@field keepSizeRatio boolean Keep size ratio
---@field point string Point
---@field buttonHeight number Button height
---@field buttonSpacing number Button spacing
---@field alpha number Alpha
---@field visibility string Visibility
---@field backdrop boolean Backdrop
---@field backdropSpacing number Backdrop spacing
---@field heightMult number Height mult
---@field widthMult number Width mult
---@field frameStrata string Frame strata
---@field frameLevel number Frame level

---@class ElvUIActionBarExtra
---@field alpha number Alpha
---@field scale number Scale
---@field clean boolean Clean
---@field inheritGlobalFade boolean Inherit global fade

---@class ElvUIActionBarZone
---@field alpha number Alpha
---@field scale number Scale
---@field clean boolean Clean
---@field inheritGlobalFade boolean Inherit global fade

---@class ElvUIActionBarVehicle
---@field enable boolean Enable
---@field size number Size
---@field level number Level
---@field strata string Strata

-- ============================================================================
-- ELVUI CORE API FUNCTIONS
-- ============================================================================

---@class ClassColor : RGB
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
---@param class ClassFile Class name
---@param usePriestColor? boolean If true, use priest color for priests
---@return ClassColor color Class color table or nil
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
---@param class ClassFile Class name
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
---@param className ClassFile Class file name
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

-- ============================================================================
-- ADDITIONAL UTILITY FUNCTIONS FROM INIT.LUA
-- ============================================================================

---Escapes special characters in a string
---@param s string String to escape
---@return string escapedString Escaped string
function E:EscapeString(s) end

---Strips color codes and other formatting from a string
---@param s string String to strip
---@param ignoreTextures? boolean If true, ignore texture codes
---@return string strippedString Stripped string
function E:StripString(s, ignoreTextures) end

---Parses version string for an addon
---@param addon string Addon name
---@return number version Version number
---@return string versionString Full version string
---@return string extra Extra version info
---@return boolean isGit True if git version
function E:ParseVersionString(addon) end

---Adds a library to the Libs table
---@param name string Library name
---@param major string|table Library major version or table
---@param minor? number|boolean Library minor version or silent switch
function E:AddLib(name, major, minor) end

---Disables incompatible addons
function E:DisableAddons() end

---Checks for other addon states
function E:CheckAddons() end

---Sets a CVar value
---@param cvar string CVar name
---@param value any CVar value
---@param ... any Additional parameters
function E:SetCVar(cvar, value, ...) end

---Gets addon enable state
---@param addon string Addon name
---@param character? string Character name
---@return number state Addon enable state
function E:GetAddOnEnableState(addon, character) end

---Checks if addon is enabled
---@param addon string Addon name
---@return boolean isEnabled True if enabled
function E:IsAddOnEnabled(addon) end

---Sets easy menu anchor
---@param menu Frame Menu frame
---@param frame Frame Anchor frame
function E:SetEasyMenuAnchor(menu, frame) end

---Resets profile
function E:ResetProfile() end

---Handles profile reset
function E:OnProfileReset() end

---Resets private profile
function E:ResetPrivateProfile() end

---Handles private profile reset
function E:OnPrivateProfileReset() end

---Called when addon is enabled
function E:OnEnable() end

---Sets up database references
function E:SetupDB() end

---Called on addon initialization
function E:OnInitialize() end

---Gets locale for Ace locale files
---@return string locale Converted locale
function E:GetLocale() end

---Addon compartment function
function E:AddonCompartmentFunc() end

---Stops all custom glows
function E:StopAllCustomGlows() end

---Gets screen quadrant for a frame
---@param frame Frame Frame to check
---@return string|nil quadrant Screen quadrant or nil
function E:GetScreenQuadrant(frame) end

---Copies a table
---@param target table Target table
---@param source table Source table
---@return table target Copied table
function E:CopyTable(target, source) end

---No operation function
function E:noop() end

---Staggered update all
function E:StaggeredUpdateAll() end

---Shows static popup
---@param popupName string Popup name
---@param ... any Additional parameters
function E:StaticPopup_Show(popupName, ...) end

---UI multiplier function
function E:UIMult() end

---Updates media
function E:UpdateMedia() end

---Initializes initial modules
function E:InitializeInitialModules() end

---Initializes ElvUI
function E:Initialize() end

---Sets up minimap shape getter
function E:SetGetMinimapShape() end

return E