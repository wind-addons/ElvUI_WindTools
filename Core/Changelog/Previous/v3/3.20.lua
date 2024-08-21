local W = unpack((select(2, ...)))

W.Changelog[320] = {
	RELEASE_DATE = "2023/01/18",
	IMPORTANT = {
		["zhCN"] = {
			"适配 ElvUI 13.18 版本改动.",
			"最低 ElvUI 支持版本更改为 13.18.",
			"[事件追踪器] 使用一个新的逻辑以解决渔网的时间不准确的问题.",
			"[事件追踪器] 如果你遇到额外渔网无法被正确记录, 请在渔网附近使用 '/wtet findNet' 命令, 并将输出内容通过 Discord 发送给我.",
		},
		["zhTW"] = {
			"適配 ElvUI 13.18 版本改動.",
			"最低 ElvUI 支援版本更改為 13.18.",
			"[事件追蹤器] 使用一個新的邏輯以解決漁網的時間不準確的問題.",
			"[事件追蹤器] 如果你遇到額外漁網無法被正確記錄, 請在漁網旁使用 '/wtet findNet' 命令, 並將輸出內容透過 Discord 發送給我.",
		},
		["enUS"] = {
			"Compatible with ElvUI 13.18.",
			"Minimum ElvUI version changed to 13.18.",
			"[Event Tracker] Use a new logic to fix the inaccurate time of fishing net.",
			"[Event Tracker] If you think the bonus fishing net cannot be recorded correctly, please use the command '/wtet findNet' near the fishing net, and send the output to me via Discord.",
		},
		["koKR"] = {
			"Compatible with ElvUI 13.18.",
			"Minimum ElvUI version changed to 13.18.",
			"[Event Tracker] Use a new logic to fix the inaccurate time of fishing net.",
			"[Event Tracker] If you think the bonus fishing net cannot be recorded correctly, please use the command '/wtet findNet' near the fishing net, and send the output to me via Discord.",
		},
	},
	NEW = {
		["zhCN"] = {
			"新增 [职业助手] 模块, 用于提供一些职业相关的功能. 暂时只有鲜血死亡骑士的灵打治疗量预估功能.",
		},
		["zhTW"] = {
			"新增 [職業助手] 模組, 用於提供一些職業相關的功能. 暫時只有血魄死亡騎士的死打治療量預估功能.",
		},
		["enUS"] = {
			"Add [Class Helper] module, which provides some class-related features. Currently only Death Strike Estimator for BDK.",
		},
		["koKR"] = {
			"Add [Class Helper] module, which provides some class-related features. Currently only Death Strike Estimator for BDK.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[巅峰声望] 更新巨龙时代版本数据.",
			"[通告] 在启用打断通告的情况下, 自动关闭 ElvUI 的打断通告.",
		},
		["zhTW"] = {
			"[巔峰聲望] 更新巨龍崛起版本資料.",
			"[通告] 在啟用打斷通告的情況下, 自動關閉 ElvUI 的打斷通告.",
		},
		["enUS"] = {
			"[Paragon Reputation] Update data for Dragonflight.",
			"[Announcement] Disable ElvUI's interrupt announcement when interrupt announcement is enabled.",
		},
		["koKR"] = {
			"[Paragon Reputation] Update data for Dragonflight.",
			"[Announcement] Disable ElvUI's interrupt announcement when interrupt announcement is enabled.",
		},
	},
}
