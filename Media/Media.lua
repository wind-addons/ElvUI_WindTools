local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

local ceil = ceil
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
	local cuttedIconTemplate = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local cuttedIconAspectRatioTemplate = "|T%s:%d:%d:0:0:64:64:%d:%d:%d:%d|t"
	local textureTemplate = "|T%s:%d:%d|t"
	local aspectRatioTemplate = "|T%s:0:aspectRatio|t"
	local textureWithTexCoordTemplate = "|T%s:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"
	local s = 14

	function F.GetIconString(icon, height, width, aspectRatio)
		if aspectRatio and height and height > 0 and width and width > 0 then
			local proportionality = height / width
			local offset = ceil((54 - 54 * proportionality) / 2)
			if proportionality > 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5 + offset, 59 - offset, 5, 59)
			elseif proportionality < 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5, 59, 5 + offset, 59 - offset)
			end
		end

		width = width or height
		return format(cuttedIconTemplate, icon, height or s, width or s)
	end

	function F.GetTextureString(texture, height, width, aspectRatio)
		if aspectRatio then
			return format(aspectRatioTemplate, texture)
		else
			width = width or height
			return format(textureTemplate, texture, height or s, width or s)
		end
	end

	function F.GetTextureStringFromTexCoord(texture, width, size, texCoord)
		width = width or size
		F.Developer.Print(texCoord)

		local proportionality = (texCoord[4] - texCoord[3]) / (texCoord[2] - texCoord[1]) -- height / width

		return format(
			textureWithTexCoordTemplate,
			texture,
			ceil(width * proportionality),
			width,
			0,
			0,
			size.x,
			size.y,
			texCoord[1] * size.x,
			texCoord[2] * size.x,
			texCoord[3] * size.y,
			texCoord[4] * size.y
		)
	end
end

function F.GetCompatibleFont(name)
	return name .. (W.CompatibleFont and " (en)" or "")
end

local function AddMedia(name, file, type)
	W.Media[type][name] = MediaPath .. type .. "/" .. file
end

do
	AddMedia("customHeaders", "CustomHeaders.tga", "Textures")

	-- Custom Header
	local texTable = {
		texWidth = 2048,
		texHeight = 256,
		headerWidth = 340,
		headerHeight = 40,
		type = {
			-- OffsetX
			SpecialAchievements = 0,
			Raids = 348,
			MythicDungeons = 693
		},
		languages = {
			-- OffsetY
			zhCN = 0,
			zhTW = 52,
			koKR = 103,
			enUS = 155,
			deDE = 206
		}
	}

	function F.GetCustomHeader(name, scale)
		local offsetX = texTable.type[name]
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetX or not offsetY then
			return
		end

		scale = scale or 1
		return format(
			"|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d:255:255:255|t",
			W.Media.Textures.customHeaders,
			ceil(texTable.headerHeight * scale),
			ceil(texTable.headerWidth * scale),
			texTable.texWidth,
			texTable.texHeight,
			offsetX,
			offsetX + texTable.headerWidth,
			offsetY,
			offsetY + texTable.headerHeight
		)
	end
end

do
	AddMedia("title", "WindToolsTitle.tga", "Textures")

	local texTable = {
		texHeight = 1024,
		titleHeight = 150,
		languages = {
			-- OffsetY
			zhCN = 0,
			zhTW = 160,
			koKR = 320,
			enUS = 480,
			deDE = 640
		}
	}

	function F.GetTitleTexCoord()
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		return {0, 1, offsetY / texTable.texHeight, (offsetY + texTable.titleHeight) / texTable.texHeight}
	end
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

do
	function F.GetClassTexCoord(role)
		return unpack(CLASS_ICON_TCOORDS[role])
	end

	AddMedia("CLASSES", "UI-CLASSES-CIRCLES.blp", "Textures")
end

AddMedia("vignetting", "Vignetting.tga", "Textures")
AddMedia("sword", "Sword.tga", "Textures")
AddMedia("shield", "Shield.tga", "Textures")
AddMedia("smallLogo", "WindToolsSmall.tga", "Textures")
AddMedia("arrowDown", "ArrowDown.tga", "Textures")

AddMedia("complete", "Complete.tga", "Icons")
AddMedia("accept", "Accept.tga", "Icons")

AddMedia("donateKofi", "Ko-fi.tga", "Icons")
AddMedia("donateAiFaDian", "AiFaDian.tga", "Icons")

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

AddMedia("covenantKyrian", "Covenants/Kyrian.tga", "Icons")
AddMedia("covenantNecrolord", "Covenants/Necrolord.tga", "Icons")
AddMedia("covenantNightFae", "Covenants/NightFae.tga", "Icons")
AddMedia("covenantVenthyr", "Covenants/Venthyr.tga", "Icons")

AddMedia("discord", "Discord.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")
AddMedia("nga", "NGA.tga", "Icons")
AddMedia("qq", "QQ.tga", "Icons")

AddMedia("convert", "Convert.tga", "Icons")
AddMedia("favorite", "Favorite.tga", "Icons")
AddMedia("list", "List.tga", "Icons")
AddMedia("star", "Star.tga", "Icons")

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
		LSM:Register("font", "Homespun (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/Homespun.ttf", region)
		LSM:Register("font", "ContinuumMedium (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/ContinuumMedium.ttf", region)
		LSM:Register("font", "Action Man (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/ActionMan.ttf", region)
		LSM:Register("font", "Die Die Die (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/DieDieDie.ttf", region)
		LSM:Register("font", "Expressway (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/Expressway.ttf", region)
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
