local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[419] = {
	RELEASE_DATE = "2026/07/20",
	IMPORTANT = {
		["zhCN"] = {
			"兼容魔兽世界 12.0.7 版本.",
			"最低支持的 ElvUI 版本提升到 15.18.",
			"同步 LibKeystone, LibOpenRaid 的最新版本.",
		},
		["zhTW"] = {
			"相容魔獸世界 12.0.7 版本.",
			"最低支援的 ElvUI 版本提升到 15.18.",
			"同步 LibKeystone, LibOpenRaid 的最新版本.",
		},
		["enUS"] = {
			"Compatible with WoW 12.0.7.",
			"Minimum supported ElvUI version raised to 15.18.",
			"Synced the latest versions of LibKeystone and LibOpenRaid.",
		},
		["koKR"] = {
			"WoW 12.0.7과 호환됩니다.",
			"최소 지원 ElvUI 버전이 15.18로 상향되었습니다.",
			"LibKeystone 및 LibOpenRaid의 최신 버전과 동기화되었습니다.",
		},
		["ruRU"] = {
			"Совместимо с WoW 12.0.7.",
			"Минимальная поддерживаемая версия ElvUI повышена до 15.18.",
			"Синхронизированы последние версии LibKeystone и LibOpenRaid.",
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
			"[核心] 统一所有 FontTemplate 调用通过 F.FontTemplate 包装器, 确保字体应用与对齐方式的一致性, 适配 ElvUI 15.17 字体对象机制.",
		},
		["zhTW"] = {
			"[核心] 統一所有 FontTemplate 調用通過 F.FontTemplate 包裝器, 確保字體應用與對齊方式的一致性, 適配 ElvUI 15.17 字體物件機制.",
		},
		["enUS"] = {
			"[Core] Unified all FontTemplate calls through the F.FontTemplate wrapper to ensure consistent font application and alignment, adapted to ElvUI 15.17 font object mechanism.",
		},
		["koKR"] = {
			"[코어] 모든 FontTemplate 호출을 F.FontTemplate 래퍼를 통해 통일하여 글꼴 적용과 정렬의 일관성을 보장하며, ElvUI 15.17 폰트 객체 메커니즘에 적응했습니다.",
		},
		["ruRU"] = {
			"[Ядро] Все вызовы FontTemplate объединены через обёртку F.FontTemplate для обеспечения согласованности применения шрифтов и выравнивания, адаптация к механизму объектных шрифтов ElvUI 15.17.",
		},
	},
}
