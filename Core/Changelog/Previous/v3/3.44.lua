local W = unpack((select(2, ...)))
W.Changelog[344] = {
	RELEASE_DATE = "2023/11/13",
	IMPORTANT = {
		["zhCN"] = {
			"韩语翻译更新. 感谢 Sang Jeon@GitHub",
			"俄语翻译更新. 感谢 Serafim1991@Discord",
			"错误信息的字体可以通过 ElvUI 设定了, 故移除错误信息的字体设定功能.",
			"由于还不清楚 10.2 的词缀循环规律, 故暂时移除预组队列表右侧面板中的词缀循环提示.",
		},
		["zhTW"] = {
			"韓語翻譯更新. 感謝 Sang Jeon@GitHub",
			"俄語翻譯更新. 感謝 Serafim1991@Discord",
			"錯誤訊息的字體可以透過 ElvUI 設定了, 故移除錯誤訊息的字體設定功能.",
			"由於還不清楚 10.2 的詞綴循環規律, 故暫時移除預組列表右側面板中的詞綴循環提示.",
		},
		["enUS"] = {
			"Korean translation updated. Thanks to Sang Jeon@GitHub",
			"Russian translation updated. Thanks to Serafim1991@Discord",
			"The font of error messages can be set through ElvUI, so remove the font setting function of error messages.",
			"Since the affix cycle rules of 10.2 are not clear yet, the affix cycle tooltip in the right panel of the LFG List is temporarily disabled.",
		},
		["koKR"] = {
			"한국어 번역이 업데이트되었습니다. Sang Jeon@GitHub에 감사드립니다.",
			"러시아어 번역이 업데이트되었습니다. Serafim1991@Discord에 감사드립니다.",
			"오류 메시지의 글꼴은 ElvUI를 통해 설정할 수 있으므로 오류 메시지의 글꼴 설정 기능을 제거합니다.",
			"10.2의 접두사 순환 규칙이 아직 명확하지 않으므로 파티 찾기 목록의 오른쪽 패널에 접두사 순환 툴팁을 일시적으로 비활성화했습니다.",
		},
		["ruRU"] = {
			"Обновлен перевод на корейский язык. спасибо Sang Jeon@GitHub",
			"Обновлен перевод на русский язык. спасибо Serafim1991@Discord",
			"Шрифт сообщений об ошибках можно настроить через ElvUI, поэтому удалите функцию настройки шрифта сообщений об ошибках.",
			"Поскольку правила цикла приставок 10.2 еще не ясны, подсказка цикла приставок в правой панели списка LFG временно отключена.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化外观] 新增对施法状态文字的设定功能",
			"[额外物品条] 新增梦境种子分类 SEEDS, 默认加入条 3.",
		},
		["zhTW"] = {
			"[美化外觀] 新增對施法狀態文字的設定功能",
			"[額外物品條] 新增夢境種子分類 SEEDS, 預設加入條 3.",
		},
		["enUS"] = {
			"[Skin] Added the ability to set the font of the action status text.",
			"[Extra Item Bar] Added SEEDS category for dream seeds, default added to bar 3.",
		},
		["koKR"] = {
			"[스킨] 액션 상태 텍스트의 글꼴을 설정할 수 있도록 추가했습니다.",
			"[추가 아이템 바] 꿈의 씨앗을 위한 SEEDS 카테고리를 추가했습니다. 기본적으로 바 3에 추가됩니다.",
		},
		["ruRU"] = {
			"[Скины] Добавлена возможность установки шрифта текста состояния действия.",
			"[Дополнительная панель предметов] Добавлена категория SEEDS для семян сновидений, по умолчанию добавлена на панель 3.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[进度] 更新 10.2 数据.",
			"[进度] 默认追踪 S3 成就, 默认停止追踪 S1 相关成就.",
			"[预组队列表] 更新 10.2 数据.",
			"[事件追踪器] 更新事件缩写.",
			"[额外物品条] 新增 10.2 药水. 感谢 lakeland1990@GitHub",
			"[联系人] 修复小号列表的自动记录关闭后无法正常显示小号列表的问题.",
			"[鼠标提示] 修复宠物类别图标的 Lua 错误.",
		},
		["zhTW"] = {
			"[進度] 更新 10.2 資料.",
			"[進度] 預設追蹤 S3 成就, 預設停止追蹤 S1 相關成就.",
			"[預組列表] 更新 10.2 資料.",
			"[事件追蹤器] 更新事件縮寫.",
			"[額外物品條] 新增 10.2 藥水. 感謝 lakeland1990@GitHub",
			"[聯絡人] 修復分身列表的自動記錄關閉後無法正常顯示分身列表的問題.",
			"[滑鼠提示] 修復寵物類別圖示的 Lua 錯誤.",
		},
		["enUS"] = {
			"[Progression] Update 10.2 data.",
			"[Progression] Track S3 achievements by default, and stop tracking S1 related achievements by default.",
			"[LFG List] Update 10.2 data.",
			"[Event Tracker] Update event abbreviations.",
			"[Extra Item Bar] Added 10.2 potions. Thanks to lakeland1990@GitHub",
			"[Contacts] Fixed an issue where the automatic recording of the alt list could not be displayed normally after it was turned off.",
			"[Tooltips] Fixed Lua error of pet type icon.",
		},
		["koKR"] = {
			"[진행] 10.2 데이터를 업데이트했습니다.",
			"[진행] 기본적으로 S3 업적을 추적하고, 기본적으로 S1 관련 업적 추적을 중지합니다.",
			"[파티 찾기 목록] 10.2 데이터를 업데이트했습니다.",
			"[이벤트 추적기] 이벤트 약어를 업데이트했습니다.",
			"[추가 아이템 바] 10.2 물약을 추가했습니다. lakeland1990@GitHub에 감사드립니다.",
			"[연락처] 대리인 목록의 자동 기록을 끈 후 대리인 목록을 정상적으로 표시할 수 없는 문제를 수정했습니다.",
			"[툴팁] 애완동물 유형 아이콘의 Lua 오류를 수정했습니다.",
		},
		["ruRU"] = {
			"[Прогресс] Обновлены данные 10.2.",
			"[Прогресс] По умолчанию отслеживаются достижения S3, а по умолчанию прекращается отслеживание связанных с S1 достижений.",
			"[Список поиска группы] Обновлены данные 10.2.",
			"[Трекер событий] Обновлены сокращения событий.",
			"[Дополнительная панель предметов] Добавлены зелья 10.2. Спасибо lakeland1990@GitHub",
			"[Контакты] Исправлена проблема, из-за которой после отключения автоматической записи списка альтов он не мог быть отображен нормально.",
			"[Подсказки] Исправлена ошибка Lua иконки типа питомца.",
		},
	},
}
