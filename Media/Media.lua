local W, F, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM

local _G = _G
local ceil = ceil
local format = format
local strlower = strlower
local strupper = strupper

W.Media = {
	Icons = {},
	Textures = {},
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

		return format(
			textureWithTexCoordTemplate,
			texture,
			ceil(width * (texCoord[4] - texCoord[3]) / (texCoord[2] - texCoord[1])),
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

do
	local raceAtlasMap = {
		["Human"] = {
			["Male"] = "raceicon128-human-male",
			["Female"] = "raceicon128-human-female",
		},
		["Orc"] = {
			["Male"] = "raceicon128-orc-male",
			["Female"] = "raceicon128-orc-female",
		},
		["Dwarf"] = {
			["Male"] = "raceicon128-dwarf-male",
			["Female"] = "raceicon128-dwarf-female",
		},
		["NightElf"] = {
			["Male"] = "raceicon128-nightelf-male",
			["Female"] = "raceicon128-nightelf-female",
		},
		["Scourge"] = {
			["Male"] = "raceicon128-undead-male",
			["Female"] = "raceicon128-undead-female",
		},
		["Tauren"] = {
			["Male"] = "raceicon128-tauren-male",
			["Female"] = "raceicon128-tauren-female",
		},
		["Gnome"] = {
			["Male"] = "raceicon128-gnome-male",
			["Female"] = "raceicon128-gnome-female",
		},
		["Troll"] = {
			["Male"] = "raceicon128-troll-male",
			["Female"] = "raceicon128-troll-female",
		},
		["Goblin"] = {
			["Male"] = "raceicon128-goblin-male",
			["Female"] = "raceicon128-goblin-female",
		},
		["BloodElf"] = {
			["Male"] = "raceicon128-bloodelf-male",
			["Female"] = "raceicon128-bloodelf-female",
		},
		["Draenei"] = {
			["Male"] = "raceicon128-draenei-male",
			["Female"] = "raceicon128-draenei-female",
		},
		["Worgen"] = {
			["Male"] = "raceicon128-worgen-male",
			["Female"] = "raceicon128-worgen-female",
		},
		["Pandaren"] = {
			["Male"] = "raceicon128-pandaren-male",
			["Female"] = "raceicon128-pandaren-female",
		},
		["Nightborne"] = {
			["Male"] = "raceicon128-nightborne-male",
			["Female"] = "raceicon128-nightborne-female",
		},
		["HighmountainTauren"] = {
			["Male"] = "raceicon128-highmountain-male",
			["Female"] = "raceicon128-highmountain-female",
		},
		["VoidElf"] = {
			["Male"] = "raceicon128-voidelf-male",
			["Female"] = "raceicon128-voidelf-female",
		},
		["LightforgedDraenei"] = {
			["Male"] = "raceicon128-lightforged-male",
			["Female"] = "raceicon128-lightforged-female",
		},
		["ZandalariTroll"] = {
			["Male"] = "raceicon128-zandalari-male",
			["Female"] = "raceicon128-zandalari-female",
		},
		["KulTiran"] = {
			["Male"] = "raceicon128-kultiran-male",
			["Female"] = "raceicon128-kultiran-female",
		},
		["DarkIronDwarf"] = {
			["Male"] = "raceicon128-darkirondwarf-male",
			["Female"] = "raceicon128-darkirondwarf-female",
		},
		["Vulpera"] = {
			["Male"] = "raceicon128-vulpera-male",
			["Female"] = "raceicon128-vulpera-female",
		},
		["MagharOrc"] = {
			["Male"] = "raceicon128-magharorc-male",
			["Female"] = "raceicon128-magharorc-female",
		},
		["Mechagnome"] = {
			["Male"] = "raceicon128-mechagnome-male",
			["Female"] = "raceicon128-mechagnome-female",
		},
		["Dracthyr"] = {
			["Male"] = "raceicon128-dracthyr-male",
			["Female"] = "raceicon128-dracthyr-female",
		},
		["EarthenDwarf"] = {
			["Male"] = "raceicon128-earthen-male",
			["Female"] = "raceicon128-earthen-female",
		},
	}

	function F.GetRaceAtlasString(englishRace, gender, height, width)
		local englishGender = gender == 2 and "Male" or gender == 3 and "Female"
		if not englishGender or not englishRace or not raceAtlasMap[englishRace] then
			return
		end
		return format("|A:%s:%d:%d|a", raceAtlasMap[englishRace][englishGender], height or 16, width or 16)
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
			MythicPlus = 693,
		},
		languages = {
			-- OffsetY
			zhCN = 0,
			zhTW = 52,
			koKR = 103,
			enUS = 155,
			deDE = 206,
		},
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
			deDE = 640,
		},
	}

	function F.GetTitleTexCoord()
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		return { 0, 1, offsetY / texTable.texHeight, (offsetY + texTable.titleHeight) / texTable.texHeight }
	end
end

do
	AddMedia("widgetsTips", "WidgetsTips.tga", "Textures")

	local texTable = {
		texWidth = 2048,
		texHeight = 1024,
		tipWidth = 512,
		tipHeight = 170,
		languages = {
			zhCN = 0,
			zhTW = 170,
			enUS = 340,
		},
		type = {
			button = { 0, 0 },
			checkBox = { 512, 0 },
			tab = { 1024, 0 },
			treeGroupButton = { 1536, 0 },
			slider = { 0, 510 },
		},
	}

	function F.GetWidgetTips(widgetType)
		if not texTable.type[widgetType] then
			return
		end
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		local xStart = texTable.type[widgetType][1]
		local yStart = texTable.type[widgetType][2] + offsetY
		local xEnd = xStart + texTable.tipWidth
		local yEnd = yStart + texTable.tipHeight

		return {
			xStart / texTable.texWidth,
			xEnd / texTable.texWidth,
			yStart / texTable.texHeight,
			yEnd / texTable.texHeight,
		}
	end

	function F.GetWidgetTipsString(widgetType)
		if not texTable.type[widgetType] then
			return
		end
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		local xStart = texTable.type[widgetType][1]
		local yStart = texTable.type[widgetType][2] + offsetY
		local xEnd = xStart + texTable.tipWidth
		local yEnd = yStart + texTable.tipHeight

		return format(
			"|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d:255:255:255|t",
			W.Media.Textures.widgetsTips,
			ceil(texTable.tipHeight * 0.4),
			ceil(texTable.tipWidth * 0.4),
			texTable.texWidth,
			texTable.texHeight,
			xStart,
			xEnd,
			yStart,
			yEnd
		)
	end
end

do
	function F.GetRoleTexCoord(role)
		if role == "TANK" then
			return 0.32 / 9.03, 2.04 / 9.03, 2.65 / 9.03, 4.3 / 9.03
		elseif role == "DPS" or role == "DAMAGER" then
			return 2.68 / 9.03, 4.4 / 9.03, 2.65 / 9.03, 4.34 / 9.03
		elseif role == "HEALER" then
			return 2.68 / 9.03, 4.4 / 9.03, 0.28 / 9.03, 1.98 / 9.03
		elseif role == "LEADER" then
			return 0.32 / 9.03, 2.04 / 9.03, 0.28 / 9.03, 1.98 / 9.03
		elseif role == "READY" then
			return 5.1 / 9.03, 6.76 / 9.03, 0.28 / 9.03, 1.98 / 9.03
		elseif role == "PENDING" then
			return 5.1 / 9.03, 6.76 / 9.03, 2.65 / 9.03, 4.34 / 9.03
		elseif role == "REFUSE" then
			return 2.68 / 9.03, 4.4 / 9.03, 5.02 / 9.03, 6.7 / 9.03
		end
	end

	AddMedia("ROLES", "UI-LFG-ICON-ROLES.blp", "Textures")
end

function F.GetClassIconStyleList()
	return { "flat", "flatborder", "flatborder2", "round", "square", "warcraftflat" }
end

function F.GetClassIconWithStyle(class, style)
	if not class or not F.In(strupper(class), _G.CLASS_SORT_ORDER) then
		return
	end

	if not style or not F.In(style, F.GetClassIconStyleList()) then
		return
	end

	return MediaPath .. "Icons/ClassIcon/" .. strlower(class) .. "_" .. style .. ".tga"
end

function F.GetClassIconStringWithStyle(class, style, width, height)
	local path = F.GetClassIconWithStyle(class, style)
	if not path then
		return
	end

	if not width and not height then
		return format("|T%s:0|t", path)
	end

	if not height then
		height = width
	end

	return format("|T%s:%d:%d:0:0:64:64:0:64:0:64|t", path, height, width)
end

AddMedia("vignetting", "Vignetting.tga", "Textures")
AddMedia("sword", "Sword.tga", "Textures")
AddMedia("shield", "Shield.tga", "Textures")
AddMedia("smallLogo", "WindToolsSmall.tga", "Textures")
AddMedia("arrowDown", "ArrowDown.tga", "Textures")

AddMedia("leader", "Leader.tga", "Icons")

AddMedia("complete", "Complete.tga", "Icons")
AddMedia("accept", "Accept.tga", "Icons")

AddMedia("donateKofi", "Ko-fi.tga", "Icons")
AddMedia("donateAiFaDian", "AiFaDian.tga", "Icons")

AddMedia("ffxivTank", "FFXIV/Tank.tga", "Icons")
AddMedia("ffxivDPS", "FFXIV/DPS.tga", "Icons")
AddMedia("ffxivHealer", "FFXIV/Healer.tga", "Icons")

AddMedia("philModTank", "PhilMod/Tank.tga", "Icons")
AddMedia("philModDPS", "PhilMod/DPS.tga", "Icons")
AddMedia("philModHealer", "PhilMod/Healer.tga", "Icons")

AddMedia("hexagonTank", "Hexagon/Tank.tga", "Icons")
AddMedia("hexagonDPS", "Hexagon/DPS.tga", "Icons")
AddMedia("hexagonHealer", "Hexagon/Healer.tga", "Icons")

AddMedia("sunUITank", "SunUI/Tank.tga", "Icons")
AddMedia("sunUIDPS", "SunUI/DPS.tga", "Icons")
AddMedia("sunUIHealer", "SunUI/Healer.tga", "Icons")

AddMedia("lynUITank", "LynUI/Tank.tga", "Icons")
AddMedia("lynUIDPS", "LynUI/DPS.tga", "Icons")
AddMedia("lynUIHealer", "LynUI/Healer.tga", "Icons")

AddMedia("elvUIOldTank", "ElvUI_Old/Tank.tga", "Icons")
AddMedia("elvUIOldDPS", "ElvUI_Old/DPS.tga", "Icons")
AddMedia("elvUIOldHealer", "ElvUI_Old/Healer.tga", "Icons")

AddMedia("announcement", "Categories/Announcement.tga", "Icons")
AddMedia("advanced", "Categories/Advanced.tga", "Icons")
AddMedia("social", "Categories/Social.tga", "Icons")
AddMedia("combat", "Categories/Combat.tga", "Icons")
AddMedia("information", "Categories/Information.tga", "Icons")
AddMedia("item", "Categories/Item.tga", "Icons")
AddMedia("map", "Categories/Map.tga", "Icons")
AddMedia("misc", "Categories/Misc.tga", "Icons")
AddMedia("quest", "Categories/Quest.tga", "Icons")
AddMedia("skins", "Categories/Skins.tga", "Icons")
AddMedia("tooltips", "Categories/Tooltips.tga", "Icons")
AddMedia("unitFrames", "Categories/UnitFrames.tga", "Icons")

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
		LSM:Register(
			"font",
			"ContinuumMedium (en)",
			"Interface/Addons/ElvUI/Core/Media/Fonts/ContinuumMedium.ttf",
			region
		)
		LSM:Register("font", "Action Man (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/ActionMan.ttf", region)
		LSM:Register("font", "Die Die Die (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/DieDieDie.ttf", region)
		LSM:Register("font", "Expressway (en)", "Interface/Addons/ElvUI/Core/Media/Fonts/Expressway.ttf", region)
		W.CompatibleFont = true
	else
		LSM:Register(
			"font",
			"Accidental Presidency",
			MediaPath .. "Fonts/AccidentalPresidency.ttf",
			LSM.LOCALE_BIT_western
		)
		LSM:Register("font", "Montserrat", MediaPath .. "Fonts/Montserrat.ttf", LSM.LOCALE_BIT_western)
		LSM:Register("font", "Roadway", MediaPath .. "Fonts/Roadway.ttf", LSM.LOCALE_BIT_western)
		W.CompatibleFont = false
	end
end

LSM:Register("statusbar", "WindTools Glow", MediaPath .. "Textures/StatusbarGlow.tga")
LSM:Register("statusbar", "WindTools Flat", MediaPath .. "Textures/StatusbarFlat.blp")
LSM:Register("statusbar", "WindTools Light", MediaPath .. "Textures/StatusbarLight.tga")
LSM:Register("statusbar", "WindTools Clean", MediaPath .. "Textures/StatusbarClean.tga")
LSM:Register("statusbar", "WindTools Background", MediaPath .. "Textures/StatusbarBackground.tga")

LSM:Register("statusbar", "ToxiUI Clean", MediaPath .. "Textures/ToxiUI/ToxiUI-clean.tga")
LSM:Register("statusbar", "ToxiUI Dark", MediaPath .. "Textures/ToxiUI/ToxiUI-dark.tga")
LSM:Register("statusbar", "ToxiUI Gradient 1", MediaPath .. "Textures/ToxiUI/ToxiUI-g1.tga")
LSM:Register("statusbar", "ToxiUI Gradient 2", MediaPath .. "Textures/ToxiUI/ToxiUI-g2.tga")
LSM:Register("statusbar", "ToxiUI Gradient 3", MediaPath .. "Textures/ToxiUI/ToxiUI-grad.tga")
LSM:Register("statusbar", "ToxiUI Half", MediaPath .. "Textures/ToxiUI/ToxiUI-half.tga")

LSM:Register("sound", "OnePlus Light", MediaPath .. "Sounds/OnePlusLight.ogg")
LSM:Register("sound", "OnePlus Surprise", MediaPath .. "Sounds/OnePlusSurprise.ogg")
