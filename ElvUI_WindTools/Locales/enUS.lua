local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "enUS")
if not L then return end
-- enUS
-- 设置主界面
L["WindTools"] = "|cff0288d1W|r|cff039be5i|r|cff03a9f4n|r|cff29b6f6d|r|cff4fc3f7T|r|cff81d4fao|r|cffb3e5fco|r|cffe1f5fel|r|cffe1f5fes|r"
L["%s version: %s"] = true
L["%s is a collection of useful tools."] = true
L["Release / Update Link"] = true
L["You can use the following link to get more information (in Chinese)"] = true
L["Author"] = true
-- 功能界面
L["Enable"] = true
L["Disable"] = true
L["Information"] = true
L["Author: %s, Edited by %s"] = true
L["Setting"] = true
L["Frame Setting"] = true
L["Other Setting"] = true
-- 分类
L["Interface"] = true
L["Trade"] = true
L["Chat"] = true
L["Quest"] = true
L["More Tools"] = true
L["Credit List"] = true
-- 任务通告
L["No Detail"] = true
L["Instance"] = true
L["Raid"] = true
L["Party"] = true
L["Solo"] = true
-- 已学配方染色
L["Already Known"] = true
L["Change item color if learned before."] = true
L["Color"] = true
-- 通告系统
L["Announce System"] = true
L["A simply announce system."] = true
L["Interrupt"] = true
L["Solo Yell"] = true
L["Include Pet"] = true
L["Res And Threat"] = true
L["Res Thanks"] = true
L["Raid Useful Spells"] = true
L["Enable Miss"] = true
L["Player Smart"] = true
L["Pet Smart"] = true
L["Other Tank Smart"] = true
L["Include Pet"] = true
L["Include Other Tank"] = true
L["Taunt"] = true
-- 增强世界地图
L["Enhanced World Map"] = true
L["Customize your world map."] = true
L["World Map Frame Size"] = true
L["Reveal"] = true
-- 自动任务物品按键
L["Auto Buttons"] = true
L["Add two bars to contain questitem buttons and inventoryitem buttons."] = true
L["Auto QuestItem Button"] = true
L["Auto InventoryItem Button"] = true
L["Keybind Text"] = true
L["Font Size"] = true
L["Quset Button Number"] = true
L["Buttons Per Row"] = true
L["Size"] = true
L["Slot Button Number"] = true
L["Item-ID"] = true
L["Add ItemID"] = true
L["Delete ItemID"] = true
L["Must is itemID!"] = true
L["Blacklist"] = true
-- 进入战斗提示功能
L["Alert you after enter or leave combat."] = true
L["Enter Combat Alert"] = true
L["Use custom text"] = true
L["Custom text (Enter)"] = true
L["Custom text (Leave)"] = true
L["Default is 0.65"] = true
L["Enter Combat"] = true
L["Leave Combat"] = true
-- 右键菜单增强
L["Right-click Menu"] = true
L["Enhanced right-click menu"] = true
L["Features"] = true
L["Armory"] = true
L["Query Detail"] = true
L["Get Name"] = true
L["Guild Invite"] = true
L["Add Friend"] = true
L["Report MyStats"] = true
L["Invite"] = true
L["Friend Menu"] = true
L["Chat Roster Menu"] = true
L["Guild Menu"] = true
L["Disable REPORT to fix bug"] = true
-- 增强好友菜单
L["Enhanced Friend List"] = true
L["Customize friend frame."] = true
L["Features"] = true
L["Name color & Level"] = true
L["Enhanced Texuture"] = true
L["Name Font"] = true
L["The font that the RealID / Character Name / Level uses."] = true
L["Name Font Size"] = true
L["The font size that the RealID / Character Name / Level uses."] = true
L["Name Font Flag"] = true
L["The font flag that the RealID / Character Name / Level uses."] = true
L["Info Font"] = true
L["The font that the Zone / Server uses."] = true
L["Info Font Size"] = true
L["The font size that the Zone / Server uses."] = true
L["Info Font Outline"] = true
L["The font flag that the Zone / Server uses."] = true
L["Status Icon Pack"] = true
L["Different Status Icons."] = true
L["Default"] = true
L["Square"] = true
L["Diablo 3"] = true
L["Game Icons"] = true
L["Game Icon Preview"] = true
L["Status Icon Preview"] = true
L["Blizzard Chat"] = true
L["Flat Style"] = true
L["Glossy"] = true
L["Launcher"] = true
L["Overwatch"] = true
L["Starcraft"] = true
L["Starcraft 2"] = true
L["App"] = true
L["Mobile"] = true
L["Hearthstone"] = true
L["Destiny 2"] = true
L["Hero of the Storm"] = true
L["None"] = true
L["OUTLINE"] = true
L["MONOCHROME"] = true
L["MONOCROMEOUTLINE"] = true
L["THICKOUTLINE"] = true
-- CVar编辑器
L["CVarsTool"] = true
L["Setting CVars easily."] = true
L["Effect Control"] = true
L["Glow Effect"] = true
L["Death Effect"] = true
L["Nether Effect"] = true
L["Convenient Setting"] = true
L["Auto Compare"] = true
-- 增强暴雪框体
L["Enhanced Blizzard Frame"] = true
L["Move frames and set scale of buttons."] = true
L["Move Frames"] = true
L["Move Blizzard Frame"] = true
L["Move ElvUI Bag"] = true
L["Remember Position"] = true
L["Error Frame"] = true
L["Vehicle Seat Scale"] = true
-- 任务列表增强
L["Quest List Enhanced"] = true
L["Add the level information in front of the quest name."] = true
L["Title Class Color"] = true
L['Quest Level'] = true
L["Tracker Level"] = true
L["Quest details level"] = true
L["Ignore high Level"] = true
L["Left Side Minimize Button"] = true
L["Frame Title"] = true
L["Display level info in quest title (Tracker)"] = true
L["Display level info in quest title (Quest details)"] = true
-- 简单阴影
L["EasyShadow"] = true
L["Add shadow to frames."] = true
L["Game Tooltip"] = true
L["MiniMap"] = true
L["Game Menu"] = true
L["Interface Options"] = true
L["Video Options"] = true
L["Quest Icon"] = true
-- Tag 增强
L["W"] = true
L["Y"] = true
L["Enhanced Tag"] = true
L["Add some tags."] = true
L["Chinese W/Y"] = true
L["Example:"] = true
-- 小地图按钮
L["Minimap Button Bar"] = true
L["Add a bar to contain minimap buttons."] = true
L['Skin Style'] = true
L['Reversed'] = true
L['Layout Direction'] = true
L['Change settings for how the minimap buttons are skinned.'] = true
L['Normal is right to left or top to bottom, or select reversed to switch directions.'] = true
L['The size of the minimap buttons.'] = true
L['No Anchor Bar'] = true
L['Horizontal Anchor Bar'] = true
L['Vertical Anchor Bar'] = true
-- 关闭视频通话
L["Close Quest Voice"] = true
L["Disable TalkingHeadFrame."] = true
-- 屏幕景深
L["iShadow"] = true
L["Movie effect for WoW."] = true
L["Shadow Level"] = true
L["Default is 50."] = true
-- 光速拾取
L["Fast Loot"] = true
L["Let auto-loot quickly."] = true
L["Fast Loot Speed"] = true
L["Default is 0.3, DO NOT change it unless Fast Loot is not worked."] = true
-- 团本进度提示
L["Raid Progression"] = true
L["Add progression info to tooltip."] = true
L["Uldir"] = true
L["Mythic"] = true 
L["Heroic"] = true 
L["Normal"] = true
L["LFR"] = true
L["Raid Setting"] = true
-- 频道切换
L["Tab Chat Mod"] = true
L["Use tab to switch channel."] = true
L["Whisper Cycle"] = true
L["Include Officer Channel"] = true
-- 任务通告
L["Quest Announcment"] = true
L["Let you know quest is completed."] = true
-- 自动摧毁
L["Auto Delete"] = true
L["Enter DELETE automatically."] = true
-- 任务进度
L["Quest Progress"] = true
L["Add quest progress to tooltip."] = true