local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[379] = {
	RELEASE_DATE = "2024/09/19",
	IMPORTANT = {
		["zhCN"] = {
			"引入了对地下堡中部分插件事件的延迟去重处理机制，现在应该能大幅缓解暴雪 Bug 带来的一些性能下降（处理数大概降低至原先的 1%）。",
		},
		["zhTW"] = {
			"引入了探究中部分插件事件的延遲去重處理機制，現在應該能大幅緩解暴雪 Bug 帶來的一些性能下降（處理數大概降低至原先的 1%）。",
		},
		["enUS"] = {
			"Introduced a delayed deduplication mechanism for some addon events in delves, which should significantly alleviate some performance degradation caused by Blizzard bugs (processing count reduced to about 1% of the original).",
		},
		["koKR"] = {
			"델브에서 일부 애드온 이벤트에 대한 지연된 중복 제거 메커니즘을 도입했으며, 이로 인해 블리자드 버그로 인한 성능 저하가 크게 완화되었습니다 (처리 횟수가 원래의 약 1%로 감소).",
		},
		["ruRU"] = {
			"Введен механизм отложенного дедуплицирования для некоторых событий аддонов в вылазках, что должно значительно облегчить некоторые проблемы с производительностью, вызванные ошибками Blizzard (количество обработок снижено примерно до 1% от исходного).",
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
			"优化了插件版本处理逻辑，开发版本，修复版本等变体信息现在也会出现在标题栏了。",
			"[鼠标提示] 进一步优化进度信息的兼容性，现在可以和 NeatPlates 等插件一起使用也不会造成多行问题了。",
			"[额外物品条] 更新了实用工具的列表。感谢 LvWind",
		},
		["zhTW"] = {
			"優化了插件版本處理邏輯，開發版本，修復版本等變體資訊現在也會出現在標題欄了。",
			"[滑鼠提示] 進一步優化進度資訊的相容性，現在可以和 NeatPlates 等插件一起使用也不會造成多行問題了。",
			"[額外物品條] 更新了實用工具的列表。感謝 LvWind",
		},
		["enUS"] = {
			"Optimized the plugin version processing logic, the development version, fix version and other variant information will now appear in the option title bar.",
			"[Tooltips] Further optimize the compatibility of progress information, now you can use it with NeatPlates and other addons without causing multi-line problems.",
			"[Extra Item Bar] Update utilities list. Thanks to LvWind.",
		},
		["koKR"] = {
			"플러그인 버전 처리 로직을 최적화했습니다. 개발 버전, 수정 버전 및 기타 변형 정보가 이제 옵션 제목 표시줄에 표시됩니다.",
			"[툴팁] 진행 정보의 호환성을 더욱 최적화했습니다. 이제 NeatPlates 등의 애드온과 함께 사용해도 다중 행 문제가 발생하지 않습니다.",
			"[추가 아이템 바] 유틸리티 목록을 업데이트했습니다. LvWind에게 감사드립니다.",
		},
		["ruRU"] = {
			"Оптимизирована логика обработки версий плагинов, информация о версиях разработки, исправлении и другие варианты теперь будут отображаться в заголовке параметров.",
			"[Подсказки] Дополнительно оптимизирована совместимость информации о прогрессе, теперь вы можете использовать ее с NeatPlates и другими аддонами, не вызывая проблем с многострочным текстом.",
			"[Дополнительная панель предметов] Обновлен список утилит. Спасибо LvWind.",
		},
	},
}
