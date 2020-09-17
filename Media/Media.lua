local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM
local format = format

W.Media = {
	Icons = {},
	Textures = {}
}

local MediaPath = "Interface\\Addons\\ElvUI_WindTools\\Media\\"

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

local function AddMedia(name, file, type)
	W.Media[type][name] = MediaPath .. type .. "\\" .. file
end

AddMedia("vignetting", "Vignetting.tga", "Textures")
AddMedia("sword", "Sword.tga", "Textures")
AddMedia("shield", "Shield.tga", "Textures")
AddMedia("logo", "WindTools.blp", "Textures")
AddMedia("smallLogo", "WindToolsSmall.tga", "Textures")

AddMedia("ffxivTank", "FFXIV\\Tank.tga", "Icons")
AddMedia("ffxivDPS", "FFXIV\\DPS.tga", "Icons")
AddMedia("ffxivHealer", "FFXIV\\Healer.tga", "Icons")

AddMedia("hexagonTank", "Hexagon\\Tank.tga", "Icons")
AddMedia("hexagonDPS", "Hexagon\\DPS.tga", "Icons")
AddMedia("hexagonHealer", "Hexagon\\Healer.tga", "Icons")

AddMedia("sunUITank", "SunUI\\Tank.tga", "Icons")
AddMedia("sunUIDPS", "SunUI\\DPS.tga", "Icons")
AddMedia("sunUIHealer", "SunUI\\Healer.tga", "Icons")

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
AddMedia("qq", "QQ.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")
AddMedia("nga", "NGA.tga", "Icons")
