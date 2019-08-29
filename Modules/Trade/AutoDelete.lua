-- 原作：SpeedDel
-- 原作者：bulleet (https://wow.curseforge.com/projects/speeddel)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Panel = StaticPopupDialogs["DELETE_GOOD_ITEM"]

local function AddText(boxEditor)
	if not E.db.WindTools["Trade"]["Auto Delete"]["enabled"] then return end
	boxEditor.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
end

hooksecurefunc(Panel, "OnShow", AddText)