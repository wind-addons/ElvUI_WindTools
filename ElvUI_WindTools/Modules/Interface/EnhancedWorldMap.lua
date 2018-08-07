-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EWM = E:NewModule('EnhancedWorldMap', 'AceHook-3.0');
local _G = _G

P["WindTools"]["Enhanced World Map"] = {
	-- 默认开启
	["enabled"] = true,
	["scale"] = 1.2,
}

function EWM:SetMapScale()
	_G["WorldMapFrame"]:SetScale(E.db.WindTools["Enhanced World Map"]["scale"])
	-- 修复指针错误 方案来源 NDui
	RunScript("WorldMapFrame.ScrollContainer.GetCursorPosition=function(f) local x,y=MapCanvasScrollControllerMixin.GetCursorPosition(f);local s=WorldMapFrame:GetScale();return x/s,y/s;end")
end

local function InsertOptions()
	E.Options.args.WindTools.args["Interface"].args["Enhanced World Map"].args["settings"] = {
		order = 10,
		type = "group",
		name = L["Scale"],
		guiInline = true,
		args = {
			scale = {
				order = 1,
				type = "range",
				name = L["World Map Frame Size"],
				min = 0.5, max = 2, step = 0.1,
				get = function(info) return E.db.WindTools["Enhanced World Map"]["scale"] end,
				set = function(info, value) E.db.WindTools["Enhanced World Map"]["scale"] = value; EWM:SetMapScale() end
			},
		}
	}
end

function EWM:Initialize()
	if not E.db.WindTools["Enhanced World Map"]["enabled"] then return end
	self:SetMapScale()
end

WT.ToolConfigs["Enhanced World Map"] = InsertOptions
E:RegisterModule(EWM:GetName())