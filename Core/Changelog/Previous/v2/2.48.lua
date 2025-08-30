local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[248] = {
	RELEASE_DATE = "2022/08/18",
	IMPORTANT = {
		["zhCN"] = {
			"由于暴雪一直没有修复预组建队伍相关错误, 工具箱内置了一个修复方案, 但同时这会导致无法举报活动, 目前没有任何更好的解决方案. 如果你非常执着于举报广告, 可以暂时停用工具箱来进行举报.",
		},
		["zhTW"] = {
			"由於暴雪一直沒有修復預組建隊伍相關錯誤, 工具箱內置了一個修復方案, 但同時這會導致無法举报活動, 目前沒有任何更好的解決方案. 如果你非常執著于举报廣告, 可以暫時停用工具箱來進行举报.",
		},
		["enUS"] = {
			"Due to the bugs in Blizzard LFG list, a fix has been applied in WindTools forcely. But the fix will cause the taint of Blizzard report system. Actaully there is no better solution for now, so if you want to report the advertisement in LFG list, just disable WindTools temporarily.",
		},
		["koKR"] = {
			"Due to the bugs in Blizzard LFG list, a fix has been applied in WindTools forcely. But the fix will cause the taint of Blizzard report system. Actaully there is no better solution for now, so if you want to report the advertisement in LFG list, just disable WindTools temporarily.",
		},
	},
	NEW = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[游戏条] 新增新版本炉石的支持. 感谢 Charles Yost",
			"[自动化] 自动接受召唤时将会在接受后隐藏提示框.",
			"[自动化] 自动接受召唤调整到 0.6 秒后执行.",
			"[过滤器] 在启用解锁过滤器功能时, 打开客服界面将会显示提示.",
			"[额外物品条] 新增了 9.2.7 版本中的新周常奖励物品. 感谢 mcc1",
			"[美化皮肤] 修复 WeakAuras 阴影.",
			"[美化皮肤] 修复 ElvUI 信息文字框体背景隐藏时阴影依旧显示的问题.",
		},
		["zhTW"] = {
			"[游戏條] 新增新版本爐石的支持. 感謝 Charles Yost",
			"[自動化] 自動接受召喚時將會在接受後隱藏提示框.",
			"[自動化] 自動接受召喚调整到 0.6 秒後執行.",
			"[過濾器] 在啟用解鎖過濾器功能時, 開啟客服界面將會顯示提示.",
			"[額外物品條] 新增了 9.2,7 版本中的新周常獎勵物品. 感謝 mcc1",
			"[美化皮膚] 修復 WeakAuras 陰影.",
			"[美化皮膚] 修復 ElvUI 資訊文字框体背景隱藏時陰影顯示的問題.",
		},
		["enUS"] = {
			"[GameBar] New heartstone added in latest patch is supported. Thanks Charles Yost",
			"[Automation] Automatically accept summon will hide the popup after confirming.",
			"[Automation] Automatically accept summon will be executed after 0.6 seconds.",
			"[Filter] When enabling the unlock profanity filter, it will show a message when customer service frame opens.",
			"[Extra Item Bar] Added new weekly reward items in 9.2.7 version. Thanks mcc1",
			"[Skins] Fix WeakAuras shadow.",
			"[Skins] Fix the shadow display of ElvUI datatext panels.",
		},
		["koKR"] = {
			"[GameBar] New heartstone added in latest patch is supported. Thanks Charles Yost",
			"[Automation] Automatically accept summon will hide the popup after confirming.",
			"[Automation] Automatically accept summon will be executed after 0.6 seconds.",
			"[Filter] When enabling the unlock profanity filter, it will show a message when customer service frame opens.",
			"[아이템 바] 9.2.7 버전의 신규 주간 보상 아이템들이 추가되였습니다. Thanks mcc1",
			"[스킨] WeakAuras 그림자 수정.",
			"[Skins] Fix the shadow display of ElvUI datatext panels.",
		},
	},
}
