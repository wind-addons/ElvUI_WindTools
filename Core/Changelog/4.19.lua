local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[419] = {
	RELEASE_DATE = "2026/07/18",
	IMPORTANT = {
		["zhCN"] = {
			"兼容魔兽世界 12.0.7 版本.",
			"适配 ElvUI 15.17 字体机制改动.",
		},
		["zhTW"] = {
			"相容魔獸世界 12.0.7 版本.",
			"適配 ElvUI 15.17 字體機制改動.",
		},
		["enUS"] = {
			"Compatible with WoW 12.0.7.",
			"Adapted to ElvUI 15.17 font mechanism changes.",
		},
		["koKR"] = {
			"WoW 12.0.7과 호환됩니다.",
			"ElvUI 15.17 폰트 메커니즘 변경에 적응했습니다.",
		},
		["ruRU"] = {
			"Совместимо с WoW 12.0.7.",
			"Адаптация к изменениям механизма шрифтов ElvUI 15.17.",
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
			"[游戏条] 修复了时间文字在东亚语系 (简中/繁中/韩文) 下被强制重置为默认字体的问题.",
			"[核心] 统一所有 FontTemplate 调用通过 F.FontTemplate 包装器, 确保字体应用与对齐方式的一致性.",
		},
		["zhTW"] = {
			"[遊戲條] 修復了時間文字在東亞語系 (簡中/繁中/韓文) 下被強制重置為預設字體的問題.",
			"[核心] 統一所有 FontTemplate 調用通過 F.FontTemplate 包裝器, 確保字體應用與對齊方式的一致性.",
		},
		["enUS"] = {
			"[Game Bar] Fixed the issue where time text was forced to the default font in East Asian locales (zhCN/zhTW/koKR).",
			"[Core] Unified all FontTemplate calls through the F.FontTemplate wrapper to ensure consistent font application and alignment.",
		},
		["koKR"] = {
			"[게임 바] 동아시아 로케일(zhCN/zhTW/koKR)에서 시간 텍스트가 기본 글꼴로 강제 재설정되는 문제를 수정했습니다.",
			"[코어] 모든 FontTemplate 호출을 F.FontTemplate 래퍼를 통해 통일하여 글꼴 적용과 정렬의 일관성을 보장합니다.",
		},
		["ruRU"] = {
			"[Игровая панель] Исправлена проблема, при которой текст времени принудительно сбрасывался на шрифт по умолчанию в восточноазиатских локалях (zhCN/zhTW/koKR).",
			"[Ядро] Все вызовы FontTemplate объединены через обёртку F.FontTemplate для обеспечения согласованности применения шрифтов и выравнивания.",
		},
	},
}
