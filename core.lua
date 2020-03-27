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
WT.UpdateAll = {}
P["WindTools"] = {}
---------------------------------------------------
-- 常用函数
---------------------------------------------------
-- 此处 r, g, b 各值均为 0~1 之间
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

-- 为字符串添加自定义颜色
function WT:ColorStr(str, r, g, b)
	local hex = r and g and b and RGBToHex(r, g, b) or RGBToHex(52/255, 152/255, 219/255)
	return "|cff"..hex..str.."|r"
end

-- 保持宽高比函数
function WT:GetTexCoord(width, height, keepAspectRatio)
	local left, right, top, bottom = unpack(E.TexCoords)
	if width > height and keepAspectRatio then
		local aspectRatio = height / width
		top = 0.5 - (0.5 - top) * aspectRatio
		bottom = 0.5 + (bottom - 0.5) * aspectRatio
	elseif height > width and keepAspectRatio then
		local aspectRatio = width / height
		left = 0.5 - (0.5 - left) * aspectRatio
		right = 0.5 + (right - 0.5) * aspectRatio
	end
	return left, right, top, bottom
end

-- TODO: 刷新全部设定
-- 或许可以添加到 staggerTable
-- https://git.tukui.org/elvui/elvui/blob/development/ElvUI/Core/Core.lua#L1267

-- 功能列表
local ToolsOrder = {
	["Interface"]  = 1,
	["Trade"]      = 2,
	["Chat"]       = 3,
	["Quest"]      = 4,
	["More Tools"] = 5,
}

-- E.PopupDialogs["WIND_UPDATE_RL"] = {
-- 	text = L["ElvUI WindTools has been updated and the data structure of the stored config has also been greatly changed. In order to make these changes take effect, you may have to reload your User Interface."],
-- 	button1 = ACCEPT,
-- 	button2 = CANCEL,
-- 	OnAccept = ReloadUI,
-- 	timeout = 0,
-- 	whileDead = 1,
-- 	hideOnEscape = false,
-- }

E.PopupDialogs["WIND_RESET"] = {
	text = L["|cffff0000If you click Accept, it will reset your Windtools.|r"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		E.db.WindTools = P["WindTools"]
		E.db.WindTools.InstalledVersion = WT.Version
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["WIND_MODULE_RESET"] = {
	text = L["|cffff0000If you click Accept, it will reset this module."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		if self.data and self.data.cata and self.data.wind_mod then
			E.db.WindTools[self.data.cata][self.data.wind_mod] = P.WindTools[self.data.cata][self.data.wind_mod]
			ReloadUI()
		else
			print(L["Reset is failed."])
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["WIND_RL"] = {
	text = L["WindTools will reload your user interface to apply the change."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = ReloadUI,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

function WT:InsertOptions()
	-- 感谢名单
	local WindToolsCreditList = {
		"Awbee", 
		"Azilroka", 
		"Benik", 
		"Blazeflack", 
		"Elv", 
		"Feraldin", 
		"Leatrix", 
		"Leatrix", 
		"Marcel Menzel", 
		"Permok", 
		"Selias2k", 
		"Simca", 
		"Simca", 
		"Sinaris", 
		"StormFX", 
		"Xruptor", 
		"ahak", 
		"bulleet", 
		"cadcamzy", 
		"heng9999", 
		"icw82", 
		"jjsheets", 
		"jokair9", 
		"kagaro", 
		"loudsoul", 
		"siweia", 
		"wandercga",
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
			-- description1 = {
			-- 	order = 3,
			-- 	type  = "description",
			-- 	name  = format(L["%s is a collection of useful tools."], WT.Title),
			-- },
			-- spacer1 = {
			-- 	order = 4,
			-- 	type  = "description",
			-- 	name  = "\n",
			-- },
			-- header2 = {
			-- 	order = 5,
			-- 	type  = "header",
			-- 	name  = L["Release / Update Link"],
			-- },
			-- ngapage = {
			-- 	order = 6,
			-- 	type  = "input",
			-- 	width = "full",
			-- 	name  = L["You can use the following link to get more information (in Chinese)"],
			-- 	get   = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
			-- 	set   = function(info) return "http://bbs.ngacn.cc/read.php?tid=12142815" end,
			-- },
			-- spacer2 = {
			-- 	order = 7,
			-- 	type  = "description",
			-- 	name  = "\n",
			-- },
			-- header3 = {
			-- 	order = 8,
			-- 	type  = "header",
			-- 	name  = WT:ColorStr(L["Author"]),
			-- },
			-- author = {
			-- 	order = 9,
			-- 	type  = "description",
			-- 	name  = "|cffC79C6Ehoushuu @ NGA|r (|cff00FF96Tabimonk|r @ TW-暗影之月)\nSomeBlu @ Github"
			-- },
			reset_button = {
				order = 10,
				type  = "execute",
				name  = L["Reset"],
				func = function() E:StaticPopup_Show("WIND_RESET") end,
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
				if arg.type == "group" then arg.guiInline = true end
				check_attributes(arg.args)
			else
				arg.type = arg.type or "toggle"
			end
		end
	end
	
	-- local rl_popup = false
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
							name  = L["Module Information"],
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
							width = "normal",
							name  = WT:ColorStr(L["Enable"]),
							get   = function(info) return E.db.WindTools[module_name][feature_name]["enabled"] end,
							set   = function(info, value) E.db.WindTools[module_name][feature_name]["enabled"]     = value; E:StaticPopup_Show("PRIVATE_RL") end,
						},
						resetbtn = {
							order = 4,
							type  = "execute",
							width = "normal",
							name  = L["Reset"],
							func  = function() E:StaticPopup_Show("WIND_MODULE_RESET", nil, nil, {cata=module_name, wind_mod=feature_name}) end,
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

				-- 通告系统的设定项太多了还是分开选择好点
				if feature_name == "Announce System" then
					for arg_name, arg in pairs(E.Options.args.WindTools.args[module_name].args[feature_name].args) do
						if arg.order > 4 then arg.guiInline = false end
					end
				end
			end
		end
	end

	-- if rl_popup then E:StaticPopup_Show("WIND_UPDATE_RL") end

	-- 版本更新需要重置设置的时候使用
	-- if not E.db.WindTools.InstalledVersion then
	-- 	E.db.WindTools["More Tools"]["Announce System"] = P["WindTools"]["More Tools"]["Announce System"]
	-- 	E.db.WindTools.InstalledVersion = WT.Version
	-- 	E:StaticPopup_Show("WIND_UPDATE_RL")
	-- end
end
---------------------------------------------------
-- ElvUI 设定部分初始化
---------------------------------------------------
function WT:Initialize()
	EP:RegisterPlugin(addonName, WT.InsertOptions)
	hooksecurefunc(E, "UpdateEnd", function()
		for _,update in ipairs(WT.UpdateAll) do
			update()
		end
	end)
end

---------------------------------------------------
-- 注册 ElvUI 模块
---------------------------------------------------
local function InitializeCallback()
	WT:Initialize()
end
E:RegisterModule(WT:GetName(), InitializeCallback)