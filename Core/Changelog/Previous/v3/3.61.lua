local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[361] = {
	RELEASE_DATE = "2024/08/10",
	IMPORTANT = {
		["zhCN"] = {
			"最低支持 ElvUI 版本更新至 13.73。",
			"更新 OpenRaid 到 v135.",
			"一些代码整理优化。",
			"注意：很多模块依旧在修复和优化中，你可以随时通过 Discord 来反馈问题。",
		},
		["zhTW"] = {
			"最低支援 ElvUI 版本更新至 13.73。",
			"更新 OpenRaid 到 v135.",
			"一些代碼整理優化。",
			"注意：很多模組依舊在修復和優化中，你可以隨時通過 Discord 來反饋問題。",
		},
		["enUS"] = {
			"Minimum support for ElvUI version updated to 13.73.",
			"Updated OpenRaid to v135.",
			"Some code cleaning and optimization.",
			"NOTICE: Many modules are still being fixed and optimized, you can always report issues through Discord.",
		},
		["koKR"] = {
			"ElvUI 버전의 최소 지원이 13.73으로 업데이트되었습니다.",
			"OpenRaid가 v135로 업데이트되었습니다.",
			"일부 코드 정리 및 최적화.",
			"주의: 많은 모듈이 여전히 수정 및 최적화 중이며 Discord를 통해 문제를 보고할 수 있습니다.",
		},
		["ruRU"] = {
			"Минимальная поддержка версии ElvUI обновлена до 13.73.",
			"Обновлен OpenRaid до v135.",
			"Некоторая чистка и оптимизация кода.",
			"ВНИМАНИЕ: Многие модули все еще находятся в процессе исправления и оптимизации, вы всегда можете сообщить о проблемах через Discord.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[事件追踪器] 新增光耀回响追踪。",
			"[事件追踪器] 点击事件现在可以快速设置地图了。",
			"[高级] - [重置] - [其他] 中新增了一个按钮用于清除观看过的过场动画。",
		},
		["zhTW"] = {
			"[事件追踪器] 新增璀璨回音追踪。",
			"[事件追踪器] 點擊事件現在可以快速設置地圖了。",
			"[進階] - [重置] - [其他] 中新增了一個按鍵用於清除觀看過的過場動畫。",
		},
		["enUS"] = {
			"[Event Tracker] Added tracking for Echoes of Light.",
			"[Event Tracker] Clicking events can now quickly set the map.",
			"Added a button in [Advanced] - [Reset] - [Others] to clear watched cutscenes.",
		},
		["koKR"] = {
			"[이벤트 추적기] 빛의 메아리 추적이 추가되었습니다.",
			"[이벤트 추적기] 이벤트를 클릭하면 지도를 빠르게 설정할 수 있습니다.",
			"[고급] - [초기화] - [기타]에 시청한 컷신을 지우는 버튼이 추가되었습니다.",
		},
		["ruRU"] = {
			"[Отслеживание событий] Добавлено отслеживание Эха Света.",
			"[Отслеживание событий] При нажатии на события теперь можно быстро установить карту.",
			"Добавлена кнопка в [Расширенные] - [Сброс] - [Другое] для очистки просмотренных видеороликов.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[事件追踪器] 修正国服部分事件的时间计算。",
			"[世界地图] 优化迷雾去除的性能表现。",
			"[世界地图] 修复迷雾去除功能。",
			"[额外物品条] 现在可以使用宏条件来定义条的显示了。",
			"[美化皮肤] 优化成就界面的美化。",
			"[进度] 添加了一个机制用来降低成就界面意外出现的概率。",
			"[进度] 第一次查看玩家时不再会有界面打开的音效了。",
		},
		["zhTW"] = {
			"[事件追踪器] 修正國服部分事件的時間計算。",
			"[世界地圖] 優化迷霧去除的性能表現。",
			"[世界地圖] 修復迷霧去除功能。",
			"[額外物品條] 現在可以使用巨集條件來定義條的顯示了。",
			"[美化皮膚] 優化成就介面的美化。",
			"[進度] 添加了一個機制用來降低成就介面意外出現的概率。",
			"[進度] 第一次查看玩家時不再會有介面打開的音效了。",
		},
		["enUS"] = {
			"[Event Tracker] Corrected the time calculation for some events in CN region.",
			"[World Map] Optimized the performance of revealing.",
			"[World Map] Fixed the reveal feature.",
			"[Extra Item Bar] Now you can use macro conditions to define the display of the bar.",
			"[Skins] Optimized the beautification of the achievement interface.",
			"[Progression] Added a mechanism to reduce the probability of the achievement interface appearing unexpectedly.",
			"[Progression] No longer has the sound effect of opening the interface when viewing the player for the first time.",
		},
		["koKR"] = {
			"[이벤트 추적기] CN 지역의 일부 이벤트에 대한 시간 계산을 수정했습니다.",
			"[월드 맵] 성능을 최적화하여 흐림 제거를 개선했습니다.",
			"[월드 맵] 흐림 제거 기능을 수정했습니다.",
			"[추가 아이템 바] 이제 매크로 조건을 사용하여 바의 표시를 정의할 수 있습니다.",
			"[스킨] 업적 인터페이스의 아름다움을 최적화했습니다.",
			"[진행] 업적 인터페이스가 예기치 않게 나타나는 확률을 줄이기 위한 메커니즘을 추가했습니다.",
			"[진행] 플레이어를 처음 볼 때 인터페이스를 열 때의 소리 효과가 더 이상 없습니다.",
		},
		["ruRU"] = {
			"[Отслеживание событий] Исправлено вычисление времени для некоторых событий в регионе CN.",
			"[Карта мира] Оптимизирована производительность открытия.",
			"[Карта мира] Исправлена функция открытия.",
			"[Панель дополнительных предметов] Теперь вы можете использовать макроусловия для определения отображения панели.",
			"[Скины] Оптимизировано оформление интерфейса достижений.",
			"[Прогресс] Добавлен механизм для снижения вероятности неожиданного появления интерфейса достижений.",
			"[Прогресс] При первом просмотре игрока больше не воспроизводится звук открытия интерфейса.",
		},
	},
}
