local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[362] = {
	RELEASE_DATE = "2024/08/13",
	IMPORTANT = {
		["zhCN"] = {
			"更新了爱发电的捐助链接。",
			"为 11.0.2 做一些准备工作。",
			"任务物品按钮污染的问题可以通过关闭任务列表模块解决，长期解决方案依旧在探索中。",
		},
		["zhTW"] = {
			"更新了愛發電的捐助連結。",
			"為 11.0.2 做一些準備工作。",
			"任務物品按鈕污染的問題可以通過關閉任務列表模組解決，長期解決方案依舊在探索中。",
		},
		["enUS"] = {
			"Updated the donation link of Afdian (爱发电).",
			"Prepare for 11.0.2.",
			"The problem of taint of the quest item button can be solved by closing the quest list module, and the long-term solution is still being explored.",
		},
		["koKR"] = {
			"Afdian (爱发电)의 기부 링크를 업데이트했습니다.",
			"11.0.2를 위한 준비를 하십시오.",
			"퀘스트 아이템 버튼 오염 문제는 퀘스트 목록 모듈을 닫음으로써 해결할 수 있으며, 장기적인 해결책은 여전히 탐색 중입니다.",
		},
		["ruRU"] = {
			"Обновлена ссылка на пожертвование Afdian (爱发电).",
			"Подготовка к 11.0.2.",
			"Проблему загрязнения кнопки предмета задания можно решить, закрыв модуль списка заданий, и долгосрочное решение все еще находится в процессе исследования.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[其他] 新增一个选项用于开启反和谐。（简体中文默认开启）",
		},
		["zhTW"] = {
			"[其他] 新增一個選項用於開啟反和諧。（簡體中文默認開啟）",
		},
		["enUS"] = {
			"[Misc] Added an option to enable anti-override. (Simplified Chinese is enabled by default)",
		},
		["koKR"] = {
			"[기타] 반해피를 활성화하는 옵션을 추가했습니다. (기본적으로 간체 중국어가 활성화됨)",
		},
		["ruRU"] = {
			"[Разное] Добавлена опция для включения анти-переопределения. (По умолчанию включено для упрощенного китайского)",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化皮肤] 修复 Myslot 插件美化皮肤。",
			"[美化皮肤] 优化了商栈的美化皮肤。",
			"[美化皮肤] 优化了编辑模式美化皮肤。",
			"[美化皮肤] 优化了通知的美化皮肤。",
			"[美化皮肤] 优化了 ElvUI 替代能量条的美化皮肤。",
			"[美化皮肤] 优化了 Simple Addon Manager 插件的美化皮肤。",
			"[事件追踪器] 现在可以设定每日完成后图标是否为黑白了。",
			"[事件追踪器] 现在在切换全屏地图和窗口地图后计时器的位置会被重新计算。",
			"[切换按钮] 现在切换按钮会在宠物战斗中自动隐藏。",
			"[任务列表] 顶部文字现在能够正确被美化了。",
		},
		["zhTW"] = {
			"[美化皮膚] 修復 Myslot 插件美化皮膚。",
			"[美化皮膚] 優化了貿易站的美化皮膚。",
			"[美化皮膚] 優化了編輯模式美化皮膚。",
			"[美化皮膚] 優化了通知的美化皮膚。",
			"[美化皮膚] 優化了 ElvUI 替代能量條的美化皮膚。",
			"[美化皮膚] 優化了 Simple Addon Manager 插件的美化皮膚。",
			"[事件追蹤器] 現在可以設定每日完成後圖標是否為黑白了。",
			"[事件追蹤器] 現在在切換全屏地圖和窗口地圖後計時器的位置會被重新計算。",
			"[切換按鍵] 現在切換按鈕會在寵物戰鬥中自動隱藏。",
			"[任務列表] 頂部文字現在能夠正確被美化了。",
		},
		["enUS"] = {
			"[Skins] Fixed Myslot skin.",
			"[Skins] Optimized the skin of the Perks Program.",
			"[Skins] Optimized the skin of the Edit Mode.",
			"[Skins] Optimized the skin of the Alerts.",
			"[Skins] Optimized the skin of the ElvUI alternative power bar.",
			"[Skins] Optimized the skin of the Simple Addon Manager plugin.",
			"[Event Tracker] Now you can set the desaturate icon after daily completion.",
			"[Event Tracker] Now the timer position will be recalculated after switching between full screen map and windowed map.",
			"[Switch Button] The switch button will now automatically hide during pet battles.",
			"[Quest List] The header text can now be properly skinned.",
		},
		["koKR"] = {
			"[스킨] Myslot 스킨이 수정되었습니다.",
			"[스킨] 혜택 프로그램의 스킨이 최적화되었습니다.",
			"[스킨] 편집 모드의 스킨이 최적화되었습니다.",
			"[스킨] 알림의 스킨이 최적화되었습니다.",
			"[스킨] ElvUI 대체 전력 바 스킨이 최적화되었습니다.",
			"[스킨] Simple Addon Manager 플러그인의 스킨이 최적화되었습니다.",
			"[이벤트 추적기] 이제 일일 완료 후 아이콘을 흑백으로 설정할 수 있습니다.",
			"[이벤트 추적기] 이제 전체 화면 지도와 창 모드 지도 사이를 전환한 후 타이머 위치가 다시 계산됩니다.",
			"[전환 버튼] 전환 버튼은 이제 애왔 전투 중에 자동으로 숨겨집니다.",
			"[퀘스트 목록] 헤더 텍스트가 올바르게 스킨되었습니다.",
		},
		["ruRU"] = {
			"[Скины] Исправлен скин Myslot.",
			"[Скины] Оптимизирован скин программы привилегий.",
			"[Скины] Оптимизирован скин режима редактирования.",
			"[Скины] Оптимизирован скин уведомлений.",
			"[Скины] Оптимизирован скин альтернативной панели энергии ElvUI.",
			"[Скины] Оптимизирован скин плагина Simple Addon Manager.",
			"[Отслеживание событий] Теперь вы можете установить оттенок иконки после ежедневного завершения.",
			"[Отслеживание событий] Теперь позиция таймера будет пересчитана после переключения между полноэкранной картой и оконной картой.",
			"[Кнопка переключения] Кнопка переключения теперь автоматически скрывается во время битвы питомцев.",
			"[Список заданий] Заголовок теперь можно правильно оформить.",
		},
	},
}
