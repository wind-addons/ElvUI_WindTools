local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[420] = {
	RELEASE_DATE = "2026/08/13",
	IMPORTANT = {
		["zhCN"] = {
			"ElvUI 已移除 LibDeflate, WindTools 现自行内置该库以供 LibOpenRaid 与配置导入导出使用.",
			"适配 ElvUI FontTemplate 新 API: 参数改为 LSM 字体名称而非字体路径.",
		},
		["zhTW"] = {
			"ElvUI 已移除 LibDeflate, WindTools 現自行內建該函式庫以供 LibOpenRaid 與設定匯入匯出使用.",
			"適配 ElvUI FontTemplate 新 API: 參數改為 LSM 字型名稱而非字型路徑.",
		},
		["enUS"] = {
			"ElvUI no longer ships LibDeflate; WindTools now vendors it for LibOpenRaid and profile import/export.",
			"Adapted to ElvUI FontTemplate API change: argument is now an LSM font name, not a font path.",
		},
		["koKR"] = {
			"ElvUI가 더 이상 LibDeflate을 포함하지 않으므로, WindTools가 LibOpenRaid 및 프로필 가져오기/내보내기를 위해 해당 라이브러리를 내장합니다.",
			"ElvUI FontTemplate API 변경에 대응: 인자가 글꼴 경로가 아닌 LSM 글꼴 이름입니다.",
		},
		["ruRU"] = {
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
		},
		["zhTW"] = {
			"修復過早初始化導致 E.global.WT 為空的錯誤, 改回在 ElvUI 完成 AceDB 初始化後再啟動.",
			"更新 F.FontTemplate / F.SetFont 等字型輔助函式, 正確區分 LSM 名稱與字型路徑.",
		},
		["enUS"] = {
			"Fixed a nil E.global.WT error from initializing too early; WindTools now starts after ElvUI AceDB is ready again.",
			"Updated F.FontTemplate / F.SetFont helpers to correctly handle LSM names versus font file paths.",
		},
		["koKR"] = {
			"너무 이른 초기화로 인한 E.global.WT nil 오류를 수정했습니다. ElvUI AceDB가 준비된 후에 다시 시작합니다.",
			"F.FontTemplate / F.SetFont 헬퍼가 LSM 이름과 글꼴 파일 경로를 올바르게 구분하도록 업데이트했습니다.",
		},
		["ruRU"] = {
			"Исправлена ошибка nil E.global.WT из‑за слишком ранней инициализации; WindTools снова запускается после готовности AceDB ElvUI.",
			"Обновлены помощники F.FontTemplate / F.SetFont для корректной работы с именами LSM и путями к файлам шрифтов.",
		},
	},
}
