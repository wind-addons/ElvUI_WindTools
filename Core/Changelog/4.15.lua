local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[415] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
		["ruRU"] = {},
	},
	NEW = {
		["zhCN"] = {
			"新增 [战斗] - [伤害统计布局] 模块. 该模块能够帮助你快速建立多个对齐布局并根据条件自动切换. 默认关闭.",
			"[美化外观] 新增了 Extra Quest Button 美化外观.",
		},
		["zhTW"] = {
			"新增 [戰鬥] - [傷害統計佈局] 模組. 該模組能夠幫助你快速建立多個對齊佈局並根據條件自動切換. 預設關閉.",
			"[美化外觀] 新增了 Extra Quest Button 美化外觀.",
		},
		["enUS"] = {
			"Added a new module [Combat] - [Damage Meter Layout]. This module helps you quickly set up multiple aligned layouts and automatically switch between them based on conditions. Disabled by default.",
			"[Skins] Added a new skin for Extra Quest Button.",
		},
		["koKR"] = {
			"[전투] - [데미지 미터 레이아웃] 모듈이 추가되었습니다. 이 모듈은 여러 정렬된 레이아웃을 빠르게 설정하고 조건에 따라 자동으로 전환하는 데 도움이 됩니다. 기본적으로 비활성화되어 있습니다.",
			"[스킨] Extra Quest Button에 대한 새로운 스킨이 추가되었습니다.",
		},
		["ruRU"] = {
			"Добавлен новый модуль [Бой] - [Макет счетчика урона]. Этот модуль помогает быстро настроить несколько выровненных макетов и автоматически переключаться между ними в зависимости от условий. По умолчанию отключено.",
			"[Скины] Добавлен новый скин для Extra Quest Button.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[游戏条] 修复了点击好友列表图标有时候会变为添加好友的问题.",
			"[游戏条] 修复了有时会提示炉石无法找到的问题.",
			"[装备观察] 更新了至暗之夜中额外宝石插槽的显示逻辑.",
			"[右键菜单] 放宽污染防止策略, 现在只有在右键战网好友时才需要使用 Shift 来显示菜单, 其他情况下无需按住 Shift 键.",
			"[美化外观] 优化了暴雪背包的美化外观性能问题.",
			"[额外物品条] 更新了至暗之夜专业物品, 同时分离了不同版本的专业物品列表. 你可以使用 PROFTWW, PROFMN 来使用不同版本的专业物品列表.",
			"[任务列表] 大幅优化了任务列表的内存占用情况.",
		},
		["zhTW"] = {
			"[遊戲條] 修復了點擊好友列表圖標有時候會變為添加好友的問題.",
			"[遊戲條] 修復了有時會提示爐石無法找到的問題.",
			"[裝備觀察] 更新了至暗之夜中額外寶石插槽的顯示邏輯.",
			"[右鍵菜單] 放寬污染防止策略, 現在只有在右鍵戰網好友時才需要使用 Shift 來顯示菜單, 其他情況下無需按住 Shift 鍵.",
			"[美化外觀] 優化了暴雪背包的美化外觀性能問題.",
			"[額外物品條] 更新了至暗之夜專業物品, 同時分離了不同版本的專業物品列表. 你可以使用 PROFTWW, PROFMN 來使用不同版本的專業物品列表.",
			"[任務列表] 大幅優化了任務列表的內存佔用情況.",
		},
		["enUS"] = {
			"[Game Bar] Fixed an issue where clicking the friends list icon sometimes changed to add friend.",
			"[Game Bar] Fixed an issue where it sometimes prompts hearthstone not found.",
			"[Inspect] Updated the display logic for additional gem sockets in Midnight.",
			"[Context Menu] Relaxed the anti-taint strategy, now only requiring Shift to show the menu when right-clicking a Battle.net friend, and no longer requiring Shift for other cases.",
			"[Skins] Optimized the skinning performance for Blizzard's bags.",
			"[Extra Item Bar] Updated the profession items for Midnight, and separated the profession item lists for different versions. You can use PROFTWW, PROFMN to use the profession item lists for different versions.",
			"[Objective Tracker] Significantly optimized the memory usage.",
		},
		["koKR"] = {
			"[게임 바] 친구 목록 아이콘을 클릭할 때 가끔 친구 추가로 변경되는 문제를 수정했습니다.",
			"[게임 바] 가끔 '하스스톤을 찾을 수 없습니다'라는 메시지가 표시되는 문제를 수정했습니다.",
			"[검사] 한밤중에서 추가 보석 슬롯에 대한 표시 로직을 업데이트했습니다.",
			"[컨텍스트 메뉴] 오염 방지 전략을 완화하여 이제 Battle.net 친구를 오른쪽 클릭할 때 Shift 키를 눌러야 메뉴가 표시되고, 다른 경우에는 Shift 키가 더 이상 필요하지 않습니다.",
			"[스킨] 블리자드 가방의 스킨 성능을 최적화했습니다.",
			"[추가 아이템 바] 한밤중의 전문 아이템을 업데이트하고, 다른 버전의 전문 아이템 목록을 분리했습니다. PROFTWW, PROFMN을 사용하여 다른 버전의 전문 아이템 목록을 사용할 수 있습니다.",
			"[목적 추적기] 메모리 사용량을 크게 최적화했습니다.",
		},
		["ruRU"] = {
			"[Панель игры] Исправлена проблема, из-за которой при нажатии на значок списка друзей иногда происходило добавление друга.",
			"[Панель игры] Исправлена проблема, из-за которой иногда появлялось сообщение о том, что не найден Hearthstone.",
			"[Осмотр] Обновлена логика отображения дополнительных слотов для самоцветов в Полночь.",
			"[Контекстное меню] Ослаблена стратегия предотвращения ошибок Blizzard. Теперь для отображения меню при ПКМ на друга в Battle.net требуется нажать Shift, а в других случаях Shift больше не требуется.",
			"[Скины] Оптимизирована производительность скинов для сумок Blizzard.",
			"[Дополнительная панель предметов] Обновлены профессиональные предметы для Полночи, а также разделены списки профессиональных предметов для разных версий. Вы можете использовать PROFTWW, PROFMN для использования списков профессиональных предметов для разных версий.",
			"[Отслеживание задач] Значительно оптимизировано использование памяти.",
		},
	},
}
