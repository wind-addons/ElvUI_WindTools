local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM
local format = format

W.Media = {
	Icons = {},
	Textures = {}
}

local MediaPath = "Interface/Addons/ElvUI_WindTools/Media/"

--[[
    获取图标字符串
    @param {string} icon 图标路径
    @param {number} size 图标大小
    @returns {string} 图标字符串
]]
do
	local template = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local s = 14
	function F.GetIconString(icon, size)
		return format(template, icon, size or s, size or s)
	end
end

function F.GetCompatibleFont(name)
	return name .. (W.CompatibleFont and " (en)" or "")
end

local function AddMedia(name, file, type)
	W.Media[type][name] = MediaPath .. type .. "/" .. file
end

do
	local titlePath = "enUS"
	if E.global.general.locale then
		if E.global.general.locale == "zhCN" or E.global.general.locale == "zhTW" or E.global.general.locale == "koKR" then
			titlePath = E.global.general.locale
		end
	end
	AddMedia("logo", format("Title/%s.tga", titlePath), "Textures")
end

do
	function F.GetRoleTexCoord(role)
		if role == "TANK" then
			return .32 / 9.03, 2.04 / 9.03, 2.65 / 9.03, 4.3 / 9.03
		elseif role == "DPS" or role == "DAMAGER" then
			return 2.68 / 9.03, 4.4 / 9.03, 2.65 / 9.03, 4.34 / 9.03
		elseif role == "HEALER" then
			return 2.68 / 9.03, 4.4 / 9.03, .28 / 9.03, 1.98 / 9.03
		elseif role == "LEADER" then
			return .32 / 9.03, 2.04 / 9.03, .28 / 9.03, 1.98 / 9.03
		elseif role == "READY" then
			return 5.1 / 9.03, 6.76 / 9.03, .28 / 9.03, 1.98 / 9.03
		elseif role == "PENDING" then
			return 5.1 / 9.03, 6.76 / 9.03, 2.65 / 9.03, 4.34 / 9.03
		elseif role == "REFUSE" then
			return 2.68 / 9.03, 4.4 / 9.03, 5.02 / 9.03, 6.7 / 9.03
		end
	end

	AddMedia("ROLES", "UI-LFG-ICON-ROLES.blp", "Textures")
end

AddMedia("vignetting", "Vignetting.tga", "Textures")
AddMedia("sword", "Sword.tga", "Textures")
AddMedia("shield", "Shield.tga", "Textures")
AddMedia("smallLogo", "WindToolsSmall.tga", "Textures")
AddMedia("arrowDown", "ArrowDown.tga", "Textures")

AddMedia("ffxivTank", "FFXIV/Tank.tga", "Icons")
AddMedia("ffxivDPS", "FFXIV/DPS.tga", "Icons")
AddMedia("ffxivHealer", "FFXIV/Healer.tga", "Icons")

AddMedia("hexagonTank", "Hexagon/Tank.tga", "Icons")
AddMedia("hexagonDPS", "Hexagon/DPS.tga", "Icons")
AddMedia("hexagonHealer", "Hexagon/Healer.tga", "Icons")

AddMedia("sunUITank", "SunUI/Tank.tga", "Icons")
AddMedia("sunUIDPS", "SunUI/DPS.tga", "Icons")
AddMedia("sunUIHealer", "SunUI/Healer.tga", "Icons")

AddMedia("lynUITank", "LynUI/Tank.tga", "Icons")
AddMedia("lynUIDPS", "LynUI/DPS.tga", "Icons")
AddMedia("lynUIHealer", "LynUI/Healer.tga", "Icons")

AddMedia("announcement", "Announcement.tga", "Icons")
AddMedia("calendar", "Calendar.tga", "Icons")
AddMedia("chat", "Chat.tga", "Icons")
AddMedia("combat", "Combat.tga", "Icons")
AddMedia("information", "Information.tga", "Icons")
AddMedia("item", "Item.tga", "Icons")
AddMedia("map", "Map.tga", "Icons")
AddMedia("misc", "Misc.tga", "Icons")
AddMedia("quest", "Quest.tga", "Icons")
AddMedia("skins", "Skins.tga", "Icons")
AddMedia("tools", "Hammer.tga", "Icons")
AddMedia("tooltips", "Tooltips.tga", "Icons")
AddMedia("unitFrames", "UnitFrames.tga", "Icons")

AddMedia("discord", "Discord.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")
AddMedia("nga", "NGA.tga", "Icons")
AddMedia("qq", "QQ.tga", "Icons")

AddMedia("convert", "Convert.tga", "Icons")
AddMedia("favorite", "Favorite.tga", "Icons")
AddMedia("list", "List.tga", "Icons")

AddMedia("barAchievements", "GameBar/Achievements.tga", "Icons")
AddMedia("barBags", "GameBar/Bags.tga", "Icons")
AddMedia("barBlizzardShop", "GameBar/BlizzardShop.tga", "Icons")
AddMedia("barCharacter", "GameBar/Character.tga", "Icons")
AddMedia("barCollections", "GameBar/Collections.tga", "Icons")
AddMedia("barEncounterJournal", "GameBar/EncounterJournal.tga", "Icons")
AddMedia("barFriends", "GameBar/Friends.tga", "Icons")
AddMedia("barGameMenu", "GameBar/GameMenu.tga", "Icons")
AddMedia("barGroupFinder", "GameBar/GroupFinder.tga", "Icons")
AddMedia("barGuild", "GameBar/Guild.tga", "Icons")
AddMedia("barHome", "GameBar/Home.tga", "Icons")
AddMedia("barMissionReports", "GameBar/MissionReports.tga", "Icons")
AddMedia("barOptions", "GameBar/Options.tga", "Icons")
AddMedia("barPetJournal", "GameBar/PetJournal.tga", "Icons")
AddMedia("barProfession", "GameBar/Profession.tga", "Icons")
AddMedia("barScreenShot", "GameBar/ScreenShot.tga", "Icons")
AddMedia("barSpellBook", "GameBar/SpellBook.tga", "Icons")
AddMedia("barTalents", "GameBar/Talents.tga", "Icons")
AddMedia("barToyBox", "GameBar/ToyBox.tga", "Icons")
AddMedia("barVolume", "GameBar/Volume.tga", "Icons")
AddMedia("barNotification", "GameBar/Notification.tga", "Icons")

AddMedia("buttonLock", "Button/Lock.tga", "Icons")
AddMedia("buttonUnlock", "Button/Unlock.tga", "Icons")
AddMedia("buttonMinus", "Button/Minus.tga", "Icons")
AddMedia("buttonPlus", "Button/Plus.tga", "Icons")
AddMedia("buttonForward", "Button/Forward.tga", "Icons")

AddMedia("inspectGemBG", "InspectGemBG.blp", "Textures")
AddMedia("exchange", "Exchange.tga", "Textures")
AddMedia("illMurloc1", "Illustration/Murloc1.tga", "Textures")

do
	local locale = GetLocale()
	if LSM["LOCALE_BIT_" .. locale] then
		local region = LSM["LOCALE_BIT_" .. locale]
		LSM:Register("font", "Accidental Presidency (en)", MediaPath .. "Fonts/AccidentalPresidency.ttf", region)
		LSM:Register("font", "Montserrat (en)", MediaPath .. "Fonts/Montserrat.ttf", region)
		LSM:Register("font", "Roadway (en)", MediaPath .. "Fonts/Roadway.ttf", region)
		LSM:Register("font", "Homespun (en)", "Interface/Addons/ElvUI/Media/Fonts/Homespun.ttf", region)
		LSM:Register("font", "ContinuumMedium (en)", "Interface/Addons/ElvUI/Media/Fonts/ContinuumMedium.ttf", region)
		W.CompatibleFont = true
	else
		LSM:Register("font", "Accidental Presidency", MediaPath .. "Fonts/AccidentalPresidency.ttf", LSM.LOCALE_BIT_western)
		LSM:Register("font", "Montserrat", MediaPath .. "Fonts/Montserrat.ttf", LSM.LOCALE_BIT_western)
		LSM:Register("font", "Roadway", MediaPath .. "Fonts/Roadway.ttf", LSM.LOCALE_BIT_western)
		W.CompatibleFont = false
	end
end

LSM:Register("statusbar", "WindTools Glow", MediaPath .. "Textures/StatusbarGlow.tga")
LSM:Register("statusbar", "WindTools Flat", MediaPath .. "Textures/StatusbarFlat.blp")
LSM:Register("statusbar", "WindTools Light", MediaPath .. "Textures/StatusbarLight.tga")

LSM:Register("sound", "OnePlus Light", MediaPath .. "Sounds/OnePlusLight.ogg")
LSM:Register("sound", "OnePlus Surprise", MediaPath .. "Sounds/OnePlusSurprise.ogg")
