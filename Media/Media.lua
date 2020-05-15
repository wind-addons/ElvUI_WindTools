local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

W.Media = {
	Icons = {},
	Textures = {}
}

local MediaPath = "Interface\\Addons\\ElvUI_WindUI\\Media\\"

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
	W.Media[type][name] = MediaPath..type.."\\"..file
end

AddMedia("vignetting", "Vignetting.tga", "Textures")
AddMedia("sword", "Sword.tga", "Textures")
AddMedia("shield", "Shield.tga", "Textures")
AddMedia("logo", "WindTools.tga", "Textures")

AddMedia("tools", "Hammer.tga", "Icons")
AddMedia("skins", "Skins.tga", "Icons")
AddMedia("chat", "Chat.tga", "Icons")
AddMedia("combat", "Combat.tga", "Icons")
AddMedia("map", "Map.tga", "Icons")
AddMedia("item", "Item.tga", "Icons")