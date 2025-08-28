local W = unpack((select(2, ...)))

W.Changelog[399] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"优化了一些内部函数的性能.",
			"由于暴雪已经修复相关Bug, 移除对地下堡部分事件的节流处理.",
		},
		["zhTW"] = {
			"優化了一些內部函式的性能.",
			"由於暴雪已經修復相關Bug, 移除對地下堡部分事件的節流處理.",
		},
		["enUS"] = {
			"Optimize the performance of some internal functions.",
			"Remove throttling for some Delves events since Blizzard has fixed the related bugs.",
		},
		["koKR"] = {
			"일부 내부 함수의 성능을 최적화했습니다.",
			"블리자드에서 관련 버그를 수정했으므로 지하 던전 일부 이벤트의 제한 처리를 제거했습니다.",
		},
		["ruRU"] = {
			"Оптимизирована производительность некоторых внутренних функций.",
			"Удалено ограничение для некоторых событий подземелий, поскольку Blizzard исправила связанные ошибки.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化皮肤] 新增了 WhisperPop 美化外观. 感谢 DaguDuiyuan",
			"[美化皮肤] 新增了 Paragon Reputation 美化外观.",
		},
		["zhTW"] = {
			"[美化皮膚] 新增了 WhisperPop 美化外觀. 感謝 DaguDuiyuan",
			"[美化皮膚] 新增了 Paragon Reputation 美化外觀.",
		},
		["enUS"] = {
			"[Skins] Add WhisperPop skin. Thanks DaguDuiyuan.",
			"[Skins] Add Paragon Reputation skin.",
		},
		["koKR"] = {
			"[스킨] WhisperPop 외관 추가. DaguDuiyuan에게 감사드립니다.",
			"[스킨] Paragon Reputation 외관 추가.",
		},
		["ruRU"] = {
			"[Скины] Добавлен скин для WhisperPop. Спасибо DaguDuiyuan.",
			"[Скины] Добавлен скин для Paragon Reputation.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"修复了启用高级战斗事件追踪时可能出现的错误.",
			"[美化皮肤] 优化 Simulationcraft 外观.",
			"[美化皮肤] 优化 SilverDragon 皮肤的一些逻辑, 现在能够更加快速的捕获窗口执行美化.",
			"[扩展商人界面] 优化了购回按钮的位置.",
			"[游戏条] 优化了一些错误提示, 使其更加贴合系统错误的风格.",
			"[游戏条] 新增一个选项, 可以防止在战斗中误触导致界面重载.",
			"[游戏条] 重构了随机炉石功能，现在支持盟约炉石的使用, 同时点击按钮后立即更换下一个炉石.",
		},
		["zhTW"] = {
			"修復了啟用進階戰鬥事件追蹤時可能出現的錯誤.",
			"[美化外觀] 優化 Simulationcraft 外觀.",
			"[美化外觀] 優化 SilverDragon 外觀的一些邏輯, 現在能夠更加快速的捕獲視窗執行美化.",
			"[擴展商人頁面] 優化了購回按鈕的位置.",
			"[遊戲條] 優化了一些錯誤提示, 使其更加貼合系統錯誤的風格.",
			"[遊戲條] 新增一個選項, 可以防止在戰鬥中誤觸導致介面重載.",
			"[遊戲條] 重構了隨機爐石功能，現在支援誓盟爐石的使用, 同時點擊按鈕後立即更換下一個爐石.",
		},
		["enUS"] = {
			"Fix errors that could occur when advanced combat event tracking was enabled.",
			"[Skins] Optimize Simulationcraft skin.",
			"[Skins] Optimize some logic of SilverDragon skin, now it can capture windows and apply skinning more quickly.",
			"[Extend Merchant Pages] Optimize the position of buyback button.",
			"[Game Bar] Optimize some error messages to better match the style of system errors.",
			"[Game Bar] Add an option to prevent accidental triggering of UI reload during combat.",
			"[Game Bar] Refactor the random hearthstone feature, now supports covenant hearthstones and immediately switches to the next hearthstone after clicking the button.",
		},
		["koKR"] = {
			"고급 전투 이벤트 추적이 활성화되었을 때 발생할 수 있는 오류를 수정했습니다.",
			"[스킨] Simulationcraft 외관 최적화.",
			"[스킨] SilverDragon 스킨의 일부 로직을 최적화하여 이제 창을 더 빠르게 캡처하고 스킨을 적용할 수 있습니다.",
			"[상인 목록 확장] 되사기 버튼의 위치를 최적화했습니다.",
			"[게임 바] 일부 오류 메시지를 최적화하여 시스템 오류 스타일에 더 잘 맞도록 했습니다.",
			"[게임 바] 전투 중 실수로 UI 재로드를 트리거하는 것을 방지하는 옵션을 추가했습니다.",
			"[게임 바] 랜덤 귀환석 기능을 재구성하여 이제 성약 귀환석을 지원하고 버튼을 클릭한 후 즉시 다음 귀환석으로 전환됩니다.",
		},
		["ruRU"] = {
			"Исправлены ошибки, которые могли возникнуть при включенном расширенном отслеживании боевых событий.",
			"[Скины] Оптимизирован внешний вид Simulationcraft.",
			"[Скины] Оптимизирована некоторая логика скина SilverDragon, теперь он может быстрее захватывать окна и применять скины.",
			"[Расширить страницы продавца] Оптимизировано положение кнопки выкупа.",
			"[Игровая панель] Оптимизированы некоторые сообщения об ошибках, чтобы лучше соответствовать стилю системных ошибок.",
			"[Игровая панель] Добавлена опция для предотвращения случайного запуска перезагрузки UI во время боя.",
			"[Игровая панель] Переработана функция случайного камня возвращения, теперь поддерживает камни ковенантов и сразу переключается на следующий камень после нажатия кнопки.",
		},
	},
}
