local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[420] = {
	RELEASE_DATE = "2026/08/13",
	IMPORTANT = {
		["zhCN"] = {
			"ElvUI 已移除 LibDeflate, WindTools 现自行内置该库以供 LibOpenRaid 与配置导入导出使用.",
		},
		["zhTW"] = {
			"ElvUI 已移除 LibDeflate, WindTools 現自行內建該函式庫以供 LibOpenRaid 與設定匯入匯出使用.",
		},
		["enUS"] = {
			"ElvUI no longer ships LibDeflate; WindTools now vendors it for LibOpenRaid and profile import/export.",
		},
		["koKR"] = {
			"ElvUI가 더 이상 LibDeflate을 포함하지 않으므로, WindTools가 LibOpenRaid 및 프로필 가져오기/내보내기를 위해 해당 라이브러리를 내장합니다.",
		},
		["ruRU"] = {
			"ElvUI больше не поставляет LibDeflate; WindTools теперь включает эту библиотеку для LibOpenRaid и импорта/экспорта профилей.",
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
		},
		["zhTW"] = {
			"修復過早初始化導致 E.global.WT 為空的錯誤, 改回在 ElvUI 完成 AceDB 初始化後再啟動.",
		},
		["enUS"] = {
			"Fixed a nil E.global.WT error from initializing too early; WindTools now starts after ElvUI AceDB is ready again.",
		},
		["koKR"] = {
			"너무 이른 초기화로 인한 E.global.WT nil 오류를 수정했습니다. ElvUI AceDB가 준비된 후에 다시 시작합니다.",
		},
		["ruRU"] = {
			"Исправлена ошибка nil E.global.WT из‑за слишком ранней инициализации; WindTools снова запускается после готовности AceDB ElvUI.",
		},
	},
}
