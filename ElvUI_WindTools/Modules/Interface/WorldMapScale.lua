local E, L, V, P, G = unpack(ElvUI)
-- 默认开启
P["WindTools"]["World Map Scale"] = {
	["enabled"] = true,
	["scale"] = 1.3,
}

local function setMapScale()
	_G["WorldMapFrame"]:SetScale(E.db.WindTools["World Map Scale"]["scale"])
end

local function InsertOptions()
	E.Options.args.WindTools.args["Interface"].args["World Map Scale"].args["settings"] = {
		order = 10,
		type = "group",
		name = L["Setting"],
		args = {
			EmN = {
				order = 1,
				type = "range",
				name = L["Scale"],
				min = 0.5, max = 2, step = 0.1,
				get = function(info) return E.db.WindTools["World Map Scale"]["scale"] end,
				set = function(info, value) E.db.WindTools["World Map Scale"]["scale"] = value; setMapScale(); end
			},
		}
	}
end

if E.db.WindTools["World Map Scale"]["enabled"] then setMapScale() end
WT.ToolConfigs["World Map Scale"] = InsertOptions