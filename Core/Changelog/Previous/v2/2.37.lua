local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[237] = {
	RELEASE_DATE = "2022/05/28",
	IMPORTANT = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
	},
	NEW = {
		["zhCN"] = {
			"[进度] 新增了一个选项用于标记最高分地下城.",
			"[聊天链接] 支持显示传奇钥石地下城的图标.",
		},
		["zhTW"] = {
			"[進度] 新增了一個選項用於標記最高分地下城.",
			"[聊天鏈接] 支援顯示傳奇鑰石地城的圖示.",
		},
		["enUS"] = {
			"[Progression] Added an option to mark the highest score dungeon.",
			"[Chat Link] Support showing the icon of keystone dungeon.",
		},
		["koKR"] = {
			"[진행 상태] 최고 점수 던전을 표시하는 옵션을 추가하였습니다.",
			"[채팅 링크] 쐐기돌 던전의 아이콘 표시를 지원합니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"修复了测试环境命令无法按照预期工作的一些问题.",
			"[额外物品条] 物品信息获取更加准确.",
			"[移动框架] 修复了一个可能导致数据库读取错误的问题.",
			"[通告] 修复了在整体模块关闭的情况下会停用暴雪进度通告的问题.",
			"[美化皮肤] 修复了可能出现的数据库读取错误.",
		},
		["zhTW"] = {
			"修復了測試環境命令無法按照預期工作的一些問題.",
			"[額外物品條] 物品資訊獲取更加準確.",
			"[移動框架] 修復了一個可能導致資料庫讀取錯誤的問題.",
			"[通告] 修復了在整體模組關閉的情況下會停用暴雪進度通告的問題.",
			"[美化皮膚] 修復了可能出現的資料庫讀取錯誤.",
		},
		["enUS"] = {
			"Fixed a bug that caused the debug environment command to not work as expected.",
			"[Extra Item Bar] Item information is now more accurate.",
			"[Move Frames] Fixed a bug that may cause an database reading error.",
			"[Announcement] Fix the bug that the Blizzard progress text would not shown even if the entire module was disabled.",
			"[Skins] Fixed possible database read error.",
		},
		["koKR"] = {
			"디버그 명령이 예상대로 작동하지 않는 일부 문제를 수정했습니다.",
			"[아이템 바] 아이템 정보가 더 정확해졌습니다.",
			"[프레임 이동] 데이터베이스 읽기 오류를 일으킬 수 있는 문제를 수정했습니다.",
			"[알림] 전체 모드가 꺼져 있으면 Blizzard 진행 상황 알림이 비활성화되는 문제가 수정되었습니다.",
			"[스킨] 예상치 못한 데이터베이스 읽기 오류를 수정하였습니다.",
		},
	},
}
