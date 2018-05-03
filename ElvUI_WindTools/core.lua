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
local format = format
local gsub = string.gsub
---------------------------------------------------
-- 初始化
---------------------------------------------------
-- 获取版本信息
WT.Version = GetAddOnMetadata(addonName, "Version")
-- 根据语言获取插件名
WT.Title = "|cff2980b9"..L["WindTools"].."|r";
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
	["Visual"] = 1,
	["Trade"] = 2,
	["Interface"] = 3,
	["Chat"] = 4,
	["Quest"] = 5,
	["More Tools"] = 6,
}
local Tools = {
	["Visual"] = {
		{"EasyShadow", L["Add shadow to frames."], "houshuu", "houshuu"},
		{"iShadow", L["Movie effect for WoW."], "iShadow", "houshuu"},
		{"No Effect", L["Disable some effect."], "Leatrix", "houshuu"},
	},
	["Trade"] = {
		{"Auto Delete", L["Enter DELETE automatically."], "bulleet", "houshuu"},
		{"Already Known", L["Change item color if learned before."], "ahak", "houshuu"},
	},
	["Interface"] = {
		{"Raid Progression", L["Add progression info to tooltip."], "ElvUI Enhanced (Legion)", "houshuu"},
		{"Minimap Buttons", L["Add a bar to contain minimap buttons."], "ElvUI Enhanced (Legion)", "houshuu"},
		{"Artifact Frame Tab", L["Add tab to your artifact frame."], "ArtifactTab", "houshuu"},
		{"Artifact Button", L["Add a button to your character information frame."], "ArtifactButton", "houshuu"},
		{"World Map Scale", L["Scale your world map."], "houshuu", "houshuu"},
	},
	["Chat"] = {
		{"Chat Link Level", L["Add a tiny icon and basic information to chat link."], "TinyChat", "houshuu"},
		{"Tab Chat Mod", L["Use tab to switch channel."], "EUI", "houshuu"},
	},
	["Quest"] = {
	    {"Close Quest Voice", L["Disable TalkingHeadFrame."], "houshuu", "houshuu"},
	    {"Quest List Enhanced", L["Add the level information in front of the quest name."], "wandercga", "houshuu"},
		{"Quest Progress", L["Add quest progress to tooltip."], "Simca", "houshuu"},
		{"Quest Announcment", L["Let you know quest is completed."], "EUI", "houshuu"},
	},
	["More Tools"] = {
		{"Fast Loot", L["Loot items quickly."], "Leatrix", "houshuu"},
		{"Tag Enhanced", L["Add some customized tags."], "houshuu", "houshuu"},
		{"Announce System", L["A simply announce system."], "Shestak", "houshuu"},
		{"Friend Color", L["Add the class color to friend frame."], "FriendColor", "houshuu"},
	},
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
		order = 1,
		type = "group",
		name = WT.Title,
		args = {
			header1 = {
				order = 1,
				type = "header",
				name = format(L["%s version: %s"], WT.Title, WT.Version),
			},		
			description1 = {
				order = 2,
				type = "description",
				name = format(L["%s is a collection of useful tools."], WT.Title),
			},
			spacer1 = {
				order = 3,
				type = "description",
				name = "\n",
			},
			header2 = {
				order = 4,
				type = "header",
				name = L["Release / Update Link"],
			},
			ngapage = {
				order = 5,
				type = "input",
				width = "full",
				name = L["You can use the following link to get more information (in Chinese)"],
				get = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
				set = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
			},
			spacer2 = {
				order = 6,
				type = "description",
				name = "\n",
			},
			header3 = {
				order = 7,
				type = "header",
				name = WT:ColorStr(L["Author Info"]),
			},
			authorinfo = {
				order = 8,
				type = "description",
				name = "|cffC79C6Ehoushuu @ NGA|r\n\n|cff00FF96雲遊僧|r-語風(TW)"
			},
			credit = {
				order = -1,
				type = "group",
				name = L["Credit List"],
				args = {},
			},
		},
	}
	-- 生成感谢名单
	for i = 1, #WindToolsCreditList do
		local cname = WindToolsCreditList[i]
		E.Options.args.WindTools.args.credit.args[cname] = {
			order = i,
			type = "description",
			name = WindToolsCreditList[i],
		}
	end
	-- 生成功能相关设定列表
	for cat, tools in pairs(Tools) do
		E.Options.args.WindTools.args[cat] = {
			order = ToolsOrder[cat],
			type = "group",
			name = L[cat],
			childGroups = "tab",
			args = {}
		}
		local n = 0
		for _, tool in pairs(tools) do
			local tName   = tool[1]
			local tDesc   = tool[2]
			local oAuthor = tool[3]
			local cAuthor = tool[4]
			n = n + 1
			E.Options.args.WindTools.args[cat].args[tName] = {
				order = n,
				type = "group",
				name = L[tName],
				args = {
					header1 = {
						order = 0,
						type = "header",
						name = L["Information"],
					},
					oriauthor = {
						order = 1,
						type = "description",
						name = format(L["Author: %s, Edited by %s"], oAuthor, cAuthor)
					},
					tooldesc = {
						order = 2,
						type = "description",
						name = tDesc
					},
					header2 = {
						order = 3,
						type = "header",
						name = L["Setting"],
					},
					enablebtn = {
						order = 4,
						type = "toggle",
						name = WT:ColorStr(L["Enable"]),
						get = function(info) return E.db.WindTools[tName]["enabled"] end,
						set = function(info, value) E.db.WindTools[tName]["enabled"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					}
				}
			}
		end
	end
	-- 加载功能内部函数设定
	for _, func in pairs(WT.ToolConfigs) do func() end
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
E:RegisterModule(WT:GetName())