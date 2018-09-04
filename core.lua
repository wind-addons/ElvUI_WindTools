-- 作者：houshuu
---------------------------------------------------
-- 插件创建声明
---------------------------------------------------
local E, L, V, P, G = unpack(ElvUI);
local WT = E:NewModule('WindTools', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local EP = LibStub("LibElvUIPlugin-1.0")
local addonName, addonTable = ...
---------------------------------------------------
-- 缓存及提高代码可读性
---------------------------------------------------
local linebreak = "\n"
local format    = format
local gsub      = string.gsub
---------------------------------------------------
-- 初始化
---------------------------------------------------
-- 获取版本信息
WT.Version = GetAddOnMetadata(addonName, "Version")
-- 根据语言获取插件名
WT.Title = L["WindTools"]
-- 初始化设定
WT.ToolConfigs = {}
P["WindTools"] = {}
---------------------------------------------------
-- 常用函数
---------------------------------------------------
-- 摘自 ElvUI 源代码
-- 转换 RGB 数值为 16 进制
-- 此处 r, g, b 各值均为 0~1 之间
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("%02x%02x%02x", r*255, g*255, b*255)
end
-- 改自 ElvUI_CustomTweaks
-- 为字符串添加自定义颜色
function WT:ColorStr(str, r, g, b)
	local hex
	local coloredString
	
	if r and g and b then
		hex = RGBToHex(r, g, b)
	else
		-- 默认设置为浅蓝色
		hex = RGBToHex(52/255, 152/255, 219/255)
	end
	
	coloredString = "|cff"..hex..str.."|r"
	return coloredString
end
-- 功能列表
local ToolsOrder = {
	["Interface"]  = 1,
	["Trade"]      = 2,
	["Chat"]       = 3,
	["Quest"]      = 4,
	["More Tools"] = 5,
}

E.PopupDialogs["WIND_UPDATE_RL"] = {
	text = L["ElvUI WindTools has been updated and the structure of the stored config data has also been greatly changed. In order to make these changes take effect, you may have to reload your User Interface."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = ReloadUI,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

function WT:InsertOptions()
	-- 感谢名单
	local WindToolsCreditList = {
		"Blazeflack",
		"Elv",
		"Leatrix",
		"bulleet",
		"ahak",
		"Simca",
		"EUI",
		"wandercga",
		"Leatrix",
		"iShadow",
		"Masque",
	}
	E.Options.args.WindTools = {
		-- 插件基本信息
		order = 2,
		type = "group",
		name = WT.Title,
		args = {
			titleimage = {
				order = 1,
				type = "description",
				name = "",
				image = function(info) return "Interface\\Addons\\ElvUI_WindTools\\Texture\\WindTools.blp", 512, 128 end,
			},
			header1 = {
				order = 2,
				type = "header",
				name = format(L["%s version: %s"], WT.Title, WT.Version),
			},		
			description1 = {
				order = 3,
				type  = "description",
				name  = format(L["%s is a collection of useful tools."], WT.Title),
			},
			spacer1 = {
				order = 4,
				type  = "description",
				name  = "\n",
			},
			header2 = {
				order = 5,
				type  = "header",
				name  = L["Release / Update Link"],
			},
			ngapage = {
				order = 6,
				type  = "input",
				width = "full",
				name  = L["You can use the following link to get more information (in Chinese)"],
				get   = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
				set   = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
			},
			spacer2 = {
				order = 7,
				type  = "description",
				name  = "\n",
			},
			header3 = {
				order = 8,
				type  = "header",
				name  = WT:ColorStr(L["Author"]),
			},
			author = {
				order = 9,
				type  = "description",
				name  = "|cffC79C6Ehoushuu @ NGA|r (|cff00FF96五氣歸元|r @ TW-暗影之月)\nSomeBlu @ Github"
			},
			credit = {
				order = -1,
				type  = "group",
				name  = L["Credit List"],
				args  = {},
			},
		},
	}
	-- 生成感谢名单
	for i = 1, #WindToolsCreditList do
		local cname = WindToolsCreditList[i]
		E.Options.args.WindTools.args.credit.args[cname] = {
			order = i,
			type  = "description",
			name  = WindToolsCreditList[i],
		}
	end

	local function check_attributes(feature) -- check type and guiInline attributes
		for arg_name, arg in pairs(feature) do
			if arg.args then
				arg.type = arg.type or "group"
				arg.guiInline = true
				check_attributes(arg.args)
			else
				arg.type = arg.type or "toggle"
			end
		end
	end
	
	local rl_popup = false
	for module_name, module in pairs(WT.ToolConfigs) do
		E.Options.args.WindTools.args[module_name] = {
			order       = ToolsOrder[module_name],
			type        = "group",
			name        = L[module_name],
			childGroups = "tab",
			args        = {}
		}
		local n = 0
		for feature_name, feature in pairs(module) do
			n = n + 1
			-- 生成功能相关设定列表
			if feature.tDesc then
				E.Options.args.WindTools.args[module_name].args[feature_name] = {
					order = n,
					type  = "group",
					name  = L[feature_name],
					args  = {
						header1 = {
							order = 0,
							type  = "header",
							name  = L["Information"],
						},
						oriauthor = {
							order = 1,
							type  = "description",
							name  = format(L["Author: %s, Edited by %s"], feature.oAuthor, feature.cAuthor)
						},
						tooldesc = {
							order = 2,
							type  = "description",
							name  = feature.tDesc
						},
						header2 = {
							order = 3,
							type  = "header",
							name  = L["Setting"],
						},
						enablebtn = {
							order = 4,
							type  = "toggle",
							width = "full",
							name  = WT:ColorStr(L["Enable"]),
							get   = function(info) return E.db.WindTools[module_name][feature_name]["enabled"] end,
							set   = function(info, value) E.db.WindTools[module_name][feature_name]["enabled"]     = value; E:StaticPopup_Show("PRIVATE_RL") end,
						}
					}
				}
				feature.tDesc, feature.oAuthor, feature.cAuthor = nil, nil, nil
				
				-- 加载功能内部函数设定
				if feature.func then
					feature.func()
					feature.func = nil
				end
				check_attributes(feature)
				for arg_name, arg in pairs(feature) do
					local disabled = arg.disabled
					E.Options.args.WindTools.args[module_name].args[feature_name].args[arg_name] = arg
					E.Options.args.WindTools.args[module_name].args[feature_name].args[arg_name].disabled = function(info)
						if disabled then
							return disabled(info) or not E.db.WindTools[module_name][feature_name]["enabled"]
						else
							return not E.db.WindTools[module_name][feature_name]["enabled"]
						end
					end
				end

				-- 转换旧的数据, 经过一两个小版本迭代后可以考虑删除
				if E.db.WindTools[feature_name] then
					E.db.WindTools[module_name][feature_name] = E.db.WindTools[feature_name]
					E.db.WindTools[feature_name] = nil
					rl_popup = true
				end
			end
		end
	end
	if rl_popup then E:StaticPopup_Show("WIND_UPDATE_RL") end
end
---------------------------------------------------
-- ElvUI 设定部分初始化
---------------------------------------------------
function WT:Initialize()
	EP:RegisterPlugin(addonName, WT.InsertOptions)
end

---------------------------------------------------
-- 注册 ElvUI 模块
---------------------------------------------------
local function InitializeCallback()
	WT:Initialize()
end
E:RegisterModule(WT:GetName(), InitializeCallback)