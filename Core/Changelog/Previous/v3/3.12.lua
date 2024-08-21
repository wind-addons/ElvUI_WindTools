local W = unpack((select(2, ...)))

W.Changelog[312] = {
	RELEASE_DATE = "2022/12/10",
	IMPORTANT = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
	},
	NEW = {
		["zhCN"] = {
			"[物品链接] 新增数字化物品品质功能. 默认启用.",
		},
		["zhTW"] = {
			"[物品鏈接] 新增數字化物品品質功能. 預設啟用.",
		},
		["enUS"] = {
			"[Item Link] Add a new feature to display item quality as number. Enabled by default.",
		},
		["koKR"] = {
			"[Item Link] Add a new feature to display item quality as number. Enabled by default.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[额外物品条] 修复有时候无法正确加载自定义列表和黑名单选项的问题.",
			"[已知配方上色] 修复公会银行中物品颜色显示错误.",
			"[物品链接] 修复启用物品翻译后无法正确显示物品品质的问题.",
			"[物品链接] 修复有时添加图标功能会产生 Lua 错误的问题.",
		},
		["zhTW"] = {
			"[額外物品條] 修復有時候無法正確加載自訂列表和黑名單設定的問題.",
			"[物品鏈接] 修復啟用物品翻譯後無法正確顯示物品品質的問題.",
			"[物品鏈接] 修復有時添加圖示功能會產生 Lua 錯誤的問題.",
			"[已知配方上色] 修復公會銀行中物品顏色顯示錯誤.",
		},
		["enUS"] = {
			"[Extra Item Bar] Fix the problem that the custom list and blacklist options cannot be loaded correctly sometimes.",
			"[Already Known] Fix a bug of item color in guild bank.",
			"[Item Link] Fix the problem that the item quality cannot be displayed correctly after if translate feature is on.",
			"[Item Link] Fix the problem that Lua errors will be generated when add icon is enabled.",
		},
		["koKR"] = {
			"[Extra Item Bar] Fix the problem that the custom list and blacklist options cannot be loaded correctly sometimes.",
			"[Already Known] Fix a bug of item color in guild bank.",
			"[Item Link] Fix the problem that the item quality cannot be displayed correctly after if translate feature is on.",
			"[Item Link] Fix the problem that Lua errors will be generated when add icon is enabled.",
		},
	},
}
