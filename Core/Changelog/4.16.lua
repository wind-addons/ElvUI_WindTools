local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[416] = {
	RELEASE_DATE = "2026/03/20",
	IMPORTANT = {
		["zhCN"] = {
			"继续优化插件的稳定性, 改善对秘密值的数据的处理模式. 感谢 Sargeraz00",
			"本地化文件更新, 感谢 Crazyyoungs (krKR), Dlarge (deDE), Valdemar (ruRU)",
			"[鼠标提示] - [进度] 世界任务的怪物进度提示新增了许多至暗之夜数据, 更多数据将在未来的版本中陆续添加. 感谢 Dack",
			"[鼠标提示] - [进度] 由于进度提示数据较多, 会明显提升插件的内存占用, 现在默认只会保留当前资料片的数据. 如果你有需要, 其他资料片的数据可以通过设定中的按钮来下载.",
		},
		["zhTW"] = {
			"繼續優化插件的穩定性, 改善對秘密值的數據的處理模式. 感謝 Sargeraz00",
			"本地化文件更新, 感謝 Crazyyoungs (krKR), Dlarge (deDE), Valdemar (ruRU)",
			"[滑鼠提示] - [進度] 世界任務的怪物進度提示新增了許多至暗之夜數據, 更多數據將在未來的版本中陸續添加. 感謝 Dack",
			"[滑鼠提示] - [進度] 由於怪物進度提示數據較多, 會明顯提升插件的內存占用, 現在默認只會保留當前資料片的數據. 如果你有需要, 其他資料片的數據可以通過設定中的按鈕來下載.",
		},
		["enUS"] = {
			"Continue to optimize the stability of the plugin and improve the processing of secret values. Thanks to Sargeraz00",
			"Localization file updated, thanks to Crazyyoungs (krKR), Dlarge (deDE), Valdemar (ruRU)",
			"[Tooltip] - [Progress] The objective progress (e.g. +4%) for world quests have been updated for the Midnight Expansion, and more data will be added in future versions. Thanks to Dack",
			"[Tooltip] - [Progress] Due to the large amount of data for the objective progress, it will significantly increase the memory usage of the addon. Now, by default, only the data for the current expansion will be retained. If you need data for other expansions, you can download it through the button in the settings.",
		},
		["koKR"] = {
			"플러그인의 안정성을 개선하고 비밀 값의 데이터 처리를 개선합니다. Sargeraz00에게 감사드립니다.",
			"현지화 파일이 업데이트되었습니다. Crazyyoungs (krKR), Dlarge (deDE), Valdemar (ruRU)에게 감사드립니다.",
			"[툴팁] - [진행 상황] 월드 퀘스트의 목표 진행 상황(예: +4%)이 미드나이트 확장팩에 대해 업데이트되었으며, 향후 버전에 더 많은 데이터가 추가될 예정입니다. Dack에게 감사드립니다.",
			"[툴팁] - [진행 상황] 목표 진행 상황에 대한 데이터가 많기 때문에 애드온의 메모리 사용량이 크게 증가합니다. 이제 기본적으로 현재 확장팩에 대한 데이터만 유지됩니다. 다른 확장팩에 대한 데이터가 필요한 경우 설정의 버튼을 통해 다운로드할 수 있습니다.",
		},
		["ruRU"] = {
			"Повышена стабильность плагина и улучшена обработка секретных значений. Спасибо Sargeraz00",
			"Файл локализации обновлен, спасибо Crazyyoungs (krKR), Dlarge (deDE), Valdemar (ruRU)",
			"[Подсказка] - [Прогресс] Подсказки по прогрессу монстров для мировых заданий добавили много данных для 'Полночи', и в будущих версиях будет добавлено ещё больше данных. Спасибо Dack",
			"[Подсказка] - [Прогресс] Из-за большого объема данных для подсказок по прогрессу монстров, это значительно увеличивает использование памяти аддоном. Теперь по умолчанию сохраняются только данные для текущего дополнения. Если вам нужны данные для других дополнений, вы можете скачать их через кнопку в настройках.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[小地图按钮] 新增一个选项可以开关要塞通知. 默认停用要塞通知.",
		},
		["zhTW"] = {
			"[小地圖按鈕] 新增一個選項可以開關要塞通知. 預設停用要塞通知.",
		},
		["enUS"] = {
			"[Minimap Button] Added a new option to toggle the Garrison notification. The Garrison notification is disabled by default.",
		},
		["koKR"] = {
			"[미니맵 버튼] 요새 알림을 토글하는 새로운 옵션이 추가되었습니다. 요새 알림은 기본적으로 비활성화되어 있습니다.",
		},
		["ruRU"] = {
			"[Кнопка миникарты] Добавлена новая опция для переключения уведомления о гарнизоне. Уведомление о гарнизоне отключено по умолчанию.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化外观] 适配更多的提醒框体.",
			"[装备观察] 修复了一个秘密值导致的出错问题, 感谢 Merathilis",
			"[聊天文字] 同步了最新版本的 ElvUI 聊天模块, 提升了稳定性.",
			"[聊天文字] 优化了公会成员信息的获取逻辑, 大幅减少了获取公会成员信息时的性能消耗, 在人多的公会中效果更明显.",
			"[聊天链接] 优化了装等获取逻辑, 现在会更加准确的显示装等压缩后的真实数值. 感谢 Dack",
			"[额外物品条] 更新符文物品列表 (RUNE) 以及战旗物品列表 (BANNER). 感谢 LvWind",
			"[预组建队伍] 修复了右侧面板的快速访问按钮显示不全的问题.",
		},
		["zhTW"] = {
			"[美化外觀] 適配更多的提醒框體.",
			"[裝備觀察] 修復了一個秘密值導致的出錯問題, 感謝 Merathilis",
			"[聊天文字] 同步了最新版本的 ElvUI 聊天模块, 提升了穩定性.",
			"[聊天文字] 優化了公會成員信息的獲取邏輯, 大幅減少了獲取公會成員信息時的性能消耗, 在人多的公會中效果更明顯.",
			"[聊天連結] 優化了裝等獲取邏輯, 現在會更加準確的顯示裝等壓縮後的真實數值. 感謝 Dack",
			"[額外物品條] 更新符文物品列表 (RUNE) 以及戰旗物品列表 (BANNER). 感謝 LvWind",
			"[預組隊伍] 修復了右側面板的快速訪問按鈕顯示不全的問題.",
		},
		["enUS"] = {
			"[Skins] Adapted to more alert frames.",
			"[Inspect] Fixed an error caused by secret values, thanks to Merathilis",
			"[Chat Text] Synchronized with the latest version of the ElvUI chat module, improving stability.",
			"[Chat Text] Optimized the logic for retrieving guild member information, significantly reducing the performance overhead when retrieving guild member information, which is more noticeable in larger guilds.",
			"[Chat Link] Optimized the item level retrieval logic, now it will more accurately display the real value after item level compression. Thanks to Dack",
			"[Extra Item Bar] Updated the item list for Runes (RUNE) and Banners (BANNER). Thanks to LvWind",
			"[LFG List] Fixed an issue where the quick access buttons on the right panel were not fully displayed.",
		},
		["koKR"] = {
			"[스킨] 더 많은 경고 프레임에 적응했습니다.",
			"[장비 관찰] 비밀 값으로 인해 발생하는 오류를 수정했습니다. Merathilis에게 감사드립니다.",
			"[채팅 텍스트] 최신 버전의 ElvUI 채팅 모듈과 동기화하여 안정성을 향상시켰습니다.",
			"[채팅 텍스트] 길드원 정보를 가져오는 로직이 최적화되어 길드원 정보를 가져올 때의 성능 오버헤드가 크게 줄어들었으며, 대규모 길드에서 더욱 눈에 띄게 개선되었습니다.",
			"[채팅 링크] 아이템 레벨 검색 로직이 최적화되어 이제 아이템 레벨 압축 후 실제 값을 보다 정확하게 표시합니다. Dack에게 감사드립니다.",
			"[추가 아이템 바] 룬(RUNE)과 배너(BANNER)에 대한 아이템 목록이 업데이트되었습니다. LvWind에게 감사드립니다.",
			"[LFG 목록] 오른쪽 패널의 빠른 액세스 버튼이 완전히 표시되지 않는 문제를 수정했습니다.",
		},
		["ruRU"] = {
			"[Скины] Адаптировано к большему количеству фреймов оповещений.",
			"[Осмотр] Исправлена ошибка, вызванная секретными значениями, спасибо Merathilis",
			"[Текст в чате] Синхронизировано с последней версией модуля чата ElvUI, улучшая стабильность.",
			"[Текст в чате] Оптимизирована логика получения информации о членах гильдии, значительно снижая нагрузку на производительность при получении информации о членах гильдии, что более заметно в больших гильдиях.",
			"[Ссылка в чате] Оптимизирована логика получения уровня предмета, теперь он будет более точно отображать реальное значение после сжатия уровня предмета. Спасибо Dack",
			"[Дополнительная панель предметов] Обновлен список предметов для рун (RUNE) и знамен (BANNER). Спасибо LvWind",
			"[Список LFG] Исправлена проблема, из-за которой кнопки быстрого доступа на правой панели отображались не полностью.",
		},
	},
}
