local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[420] = {
	RELEASE_DATE = "2026/08/14",
	IMPORTANT = {
		["zhCN"] = {
			"最低支持的 ElvUI 版本提升到 15.21.",
			"ElvUI 已移除 LibDeflate, WindTools 现自行内置该库以供 LibOpenRaid 与配置导入导出使用.",
			"适配 ElvUI FontTemplate 新 API: 参数改为 LSM 字体名称而非字体路径.",
		},
		["zhTW"] = {
			"最低支援的 ElvUI 版本提升到 15.21.",
			"ElvUI 已移除 LibDeflate, WindTools 現自行內建該函式庫以供 LibOpenRaid 與設定匯入匯出使用.",
			"適配 ElvUI FontTemplate 新 API: 參數改為 LSM 字型名稱而非字型路徑.",
		},
		["enUS"] = {
			"Minimum supported ElvUI version raised to 15.21.",
			"ElvUI no longer ships LibDeflate; WindTools now vendors it for LibOpenRaid and profile import/export.",
			"Adapted to ElvUI FontTemplate API change: argument is now an LSM font name, not a font path.",
		},
		["koKR"] = {
			"최소 지원 ElvUI 버전이 15.21로 상향되었습니다.",
			"ElvUI가 더 이상 LibDeflate을 포함하지 않으므로, WindTools가 LibOpenRaid 및 프로필 가져오기/내보내기를 위해 해당 라이브러리를 내장합니다.",
			"ElvUI FontTemplate API 변경에 대응: 인자가 글꼴 경로가 아닌 LSM 글꼴 이름입니다.",
		},
		["ruRU"] = {
			"Минимальная поддерживаемая версия ElvUI повышена до 15.21.",
			"ElvUI больше не поставляет LibDeflate; WindTools теперь включает эту библиотеку для LibOpenRaid и импорта/экспорта профилей.",
			"Адаптация к новому API FontTemplate ElvUI: аргумент теперь имя шрифта LSM, а не путь к файлу.",
		},
	},
	NEW = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
		["ruRU"] = {},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"修复过早初始化导致 E.global.WT 为空的错误, 改回在 ElvUI 完成 AceDB 初始化后再启动.",
			"更新 F.FontTemplate / F.SetFont 等字体辅助函数, 正确区分 LSM 名称与字体路径.",
			"[世界地图] 更新了迷雾去除数据库。",
			"[鼠标提示] 更新了 12.1 套装部位提示的数据。",
			"[鼠标提示] 添加了 12.1 新团队副本进度提示。",
			"[鼠标提示] 更新了 S2 传奇钥石地下城的数据。",
			"[预创建队伍] 更新了 S2 传奇钥石地下城的数据。",
		},
		["zhTW"] = {
			"修復過早初始化導致 E.global.WT 為空的錯誤, 改回在 ElvUI 完成 AceDB 初始化後再啟動.",
			"更新 F.FontTemplate / F.SetFont 等字型輔助函式, 正確區分 LSM 名稱與字型路徑.",
			"[世界地圖] 更新了迷霧去除資料庫。",
			"[滑鼠提示] 更新了 12.1 套裝部位提示的數據。",
			"[滑鼠提示] 添加了 12.1 新團隊副本進度提示。",
			"[滑鼠提示] 更新了 S2 傳奇鑰石地城的數據。",
			"[預組隊伍] 更新了 S2 傳奇鑰石地城的數據。",
		},
		["enUS"] = {
			"Fixed a nil E.global.WT error from initializing too early; WindTools now starts after ElvUI AceDB is ready again.",
			"Updated F.FontTemplate / F.SetFont helpers to correctly handle LSM names versus font file paths.",
			"[World Map] Update fog removal database.",
			"[Tooltips] Update 12.1 tier set tooltips.",
			"[Tooltips] Add new 12.1 raid progression tooltips.",
			"[Tooltips] Update S2 Mythic+ dungeons tooltips.",
			"[LFG List] Update S2 Mythic+ dungeons data.",
		},
		["koKR"] = {
			"너무 이른 초기화로 인한 E.global.WT nil 오류를 수정했습니다. ElvUI AceDB가 준비된 후에 다시 시작합니다.",
			"F.FontTemplate / F.SetFont 헬퍼가 LSM 이름과 글꼴 파일 경로를 올바르게 구분하도록 업데이트했습니다.",
			"[월드맵] 안개 제거 데이터베이스를 업데이트했습니다.",
			"[툴팁] 12.1 티어 세트 툴팁을 업데이트했습니다.",
			"[툴팁] 새로운 12.1 레이드 진행 툴팁을 추가했습니다.",
			"[툴팁] S2 신화+ 던전 툴팁을 업데이트했습니다.",
			"[파티 찾기] S2 신화+ 던전 데이터를 업데이트했습니다.",
		},
		["ruRU"] = {
			"Исправлена ошибка nil E.global.WT из‑за слишком ранней инициализации; WindTools снова запускается после готовности AceDB ElvUI.",
			"Обновлены помощники F.FontTemplate / F.SetFont для корректной работы с именами LSM и путями к файлам шрифтов.",
			"[Карта мира] Обновлена база данных по удалению тумана.",
			"[Подсказки] Обновлены подсказки для комплектов брони (12.1).",
			"[Подсказки] Добавлены новые подсказки для рейдов 12.1.",
			"[Подсказки] Обновлены подсказки для М+ 2-го сезона.",
			"[Поиск группы] Обновлены данные для М+ 2-го сезона.",
		},
	},
}
