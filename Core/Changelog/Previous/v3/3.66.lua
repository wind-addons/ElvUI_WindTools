local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[366] = {
	RELEASE_DATE = "2024/08/18",
	IMPORTANT = {
		["zhCN"] = {
			"进一步适配 11.0.2 API。",
			"[进度] 完全重写了模块，稳定性和性能有所提升。",
		},
		["zhTW"] = {
			"進一步適配 11.0.2 API。",
			"[進度] 完全重寫了模組，穩定性和性能有所提升。",
		},
		["enUS"] = {
			"Further adapted to 11.0.2 API.",
			"[Progression] Completely rewritten the module, stability and performance have been improved.",
		},
		["koKR"] = {
			"11.0.2 API에 대한 추가적인 적응.",
			"[진행] 모듈을 완전히 다시 작성했습니다. 안정성과 성능이 향상되었습니다.",
		},
		["ruRU"] = {
			"Дополнительная адаптация к 11.0.2 API.",
			"[Прогресс] Полностью переписан модуль, улучшена стабильность и производительность.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[进度] 鼠标提示和设定中现在都会显示图标。",
			"[进度] 新增了 11.0 Raid 和成就监控的数据。",
			"[通告] 新增了幻变者道标的通告。",
		},
		["zhTW"] = {
			"[進度] 滑鼠提示和設定中現在都會顯示圖標。",
			"[進度] 新增了 11.0 團隊和成就監控的數據。",
			"[通告] 新增了塑形師道標的通告。",
		},
		["enUS"] = {
			"[Progression] Now icons will be displayed in tooltips and settings.",
			"[Progression] Added data for 11.0 Raid and Achievement tracking.",
			"[Announcement] Added announcements for Transmorpher Beacon.",
		},
		["koKR"] = {
			"[진행] 이제 툴팁과 설정에 아이콘이 표시됩니다.",
			"[진행] 11.0 레이드 및 업적 추적을 위한 데이터가 추가되었습니다.",
			"[공지] 변신자 신호기에 대한 공지가 추가되었습니다.",
		},
		["ruRU"] = {
			"[Прогресс] Теперь значки будут отображаться в подсказках и настройках.",
			"[Прогресс] Добавлены данные для 11.0 Рейда и отслеживания достижений.",
			"[Объявление] Добавлены объявления для Метаморфического знака.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[鼠标提示] 更新了 11.0 S1 套装部位提示的数据。",
			"[其他] - [自定义快捷键别名] 提升替换的稳定性。",
			"[进度] 移除了 10.0 S1 ~ S3 的成就提示。",
			"[交接] 现在不会再自动交 7.0 的起始任务了。",
			"[预组建队伍] 修复了一个可能导致部分非 M+ 地下城无法显示的问题。",
			"[美化皮肤] 修复 Simple Addon Manager 皮肤移动时背景不动的错误。",
			"[美化皮肤] Simple Addon Manager 皮肤现在会调用 Wind 组件皮肤来进一步美化选择按钮。",
		},
		["zhTW"] = {
			"[滑鼠提示] 更新了 11.0 S1 套裝部位提示的數據。",
			"[其他] - [自定義快捷鍵別名] 提升替換的穩定性。",
			"[進度] 移除了 10.0 S1 ~ S3 的成就提示。",
			"[交接] 現在不會再自動交 7.0 的起始任務了。",
			"[預組隊伍] 修復了一個可能導致部分非 M+ 地下城無法顯示的問題。",
			"[美化皮膚] 修復 Simple Addon Manager 皮膚移動時背景不動的錯誤。",
			"[美化皮膚] Simple Addon Manager 皮膚現在會調用 Wind 組件皮膚來進一步美化選擇按鈕。",
		},
		["enUS"] = {
			"[Tooltips] Updated 11.0 S1 set piece tooltips.",
			"[Misc] - [Custom HotKey Alias] Improved the stability of replacement.",
			"[Progression] Removed 10.0 S1 ~ S3 achievement tooltips.",
			"[Quest] Will no longer automatically turn in the starting quest for 7.0.",
			"[Premade Groups] Fixed an issue that may cause some non M+ dungeons to not display.",
			"[Skin] Fixed an issue where the background of Simple Addon Manager skin does not move when moving.",
			"[Skin] Simple Addon Manager skin will now call Wind component skin to further beautify the selection buttons.",
		},
		["koKR"] = {
			"[툴팁] 11.0 S1 세트 아이템 툴팁을 업데이트했습니다.",
			"[기타] - [사용자 지정 단축키 별칭] 대체의 안정성을 향상시켰습니다.",
			"[진행] 10.0 S1 ~ S3 업적 툴팁을 제거했습니다.",
			"[퀘스트] 이제 7.0의 시작 퀘스트를 자동으로 완료하지 않습니다.",
			"[프리메이드 그룹] 일부 M+ 던전이 표시되지 않을 수 있는 문제를 수정했습니다.",
			"[스킨] 이동할 때 Simple Addon Manager 스킨의 배경이 움직이지 않는 문제를 수정했습니다.",
			"[스킨] Simple Addon Manager 스킨은 이제 Wind 구성 요소 스킨을 호출하여 선택 버튼을 더욱 아름답게 만듭니다.",
		},
		["ruRU"] = {
			"[Подсказки] Обновлены подсказки для предметов комплекта 11.0 S1.",
			"[Разное] - [Пользовательские псевдонимы горячих клавиш] Улучшена стабильность замены.",
			"[Прогресс] Удалены подсказки для достижений 10.0 S1 ~ S3.",
			"[Задание] Больше не будет автоматически сдавать стартовое задание для 7.0.",
			"[Группы по интересам] Исправлена проблема, которая могла привести к тому, что некоторые не M+ подземелья не отображались.",
			"[Скин] Исправлена проблема, при которой фон скина Simple Addon Manager не двигался при перемещении.",
			"[Скин] Скин Simple Addon Manager теперь будет вызывать скин компонента Wind для дальнейшего улучшения кнопок выбора.",
		},
	},
}
