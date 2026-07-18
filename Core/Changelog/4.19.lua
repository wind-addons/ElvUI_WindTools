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
			"[核心] 统一所有 FontTemplate 调用通过 F.FontTemplate 包装器, 确保字体应用与对齐方式的一致性, 适配 ElvUI 15.17 新字体对象机制.",
			"[游戏条] 修复了东亚语系下时间文字被强制重置为默认字体的问题, 同时修复了字体闪烁问题.",
		},
		["zhTW"] = {
			"[核心] 統一所有 FontTemplate 調用通過 F.FontTemplate 包裝器, 確保字體應用與對齊方式的一致性, 適配 ElvUI 15.17 新字體物件機制.",
			"[遊戲條] 修復了東亞語系下時間文字被強制重置為預設字體的問題, 同時修復了字體閃爍問題.",
		},
		["enUS"] = {
			"[Core] Unified all FontTemplate calls through the F.FontTemplate wrapper to ensure consistent font application and alignment, adapted to ElvUI 15.17 new font object mechanism.",
			"[Game Bar] Fixed the issue where time text was forced to the default font in East Asian locales, and fixed the font flickering issue.",
		},
		["koKR"] = {
			"[코어] 모든 FontTemplate 호출을 F.FontTemplate 래퍼를 통해 통일하여 글꼴 적용과 정렬의 일관성을 보장하며, ElvUI 15.17 새 폰트 객체 메커니즘에 적응했습니다.",
			"[게임 바] 동아시아 로케일에서 시간 텍스트가 기본 글꼴로 강제 재설정되는 문제와 글꼴 깜빡임 문제를 수정했습니다.",
		},
		["ruRU"] = {
			"[Ядро] Все вызовы FontTemplate объединены через обёртку F.FontTemplate для обеспечения согласованности применения шрифтов и выравнивания, адаптация к новому механизму объектных шрифтов ElvUI 15.17.",
			"[Игровая панель] Исправлена проблема, при которой текст времени принудительно сбрасывался на шрифт по умолчанию в восточноазиатских локалях, а также исправлена проблема мерцания шрифта.",
		},
	},
}
