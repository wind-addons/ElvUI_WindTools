local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[394] = {
	RELEASE_DATE = "2025/08/10",
	IMPORTANT = {
		["zhCN"] = {
			"[移动框体] 本次版本更新会自动重置已经记录的位置, 依旧可以手动开启. 但请配置分享者勿开此项进行分享, 这可能会导致框架错位飞出屏幕.",
		},
		["zhTW"] = {
			"[移動框架] 本次版本更新會自動重置已經記錄的位置, 依舊可以手動開啟. 但請配置分享者勿開此項進行分享, 這可能會導致框架錯位飛出螢幕.",
		},
		["enUS"] = {
			"[Move Frames] This update will automatically reset the recorded positions, but you can still enable it manually. However, please ask the configurator not to enable this option for sharing, as it may cause the frames to misalign and fly off the screen.",
		},
		["koKR"] = {
			"[이동 프레임] 이번 업데이트는 기록된 위치를 자동으로 재설정하지만 여전히 수동으로 활성화할 수 있습니다. 그러나 구성자에게 이 옵션을 공유하지 않도록 요청하십시오. 이로 인해 프레임이 잘못 정렬되어 화면에서 벗어날 수 있습니다.",
		},
		["ruRU"] = {
			"[Перемещение рамок] Это обновление автоматически сбросит записанные позиции, но вы все равно можете включить его вручную. Однако, пожалуйста, попросите конфигуратора не включать эту опцию для общего доступа, так как это может привести к смещению рамок и их вылету за пределы экрана.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化皮肤] 新增了插件 World Quest Tab 的皮肤.",
			"[其他] 新增了一个退出相位潜行的按钮, 会在相位潜行时自动显示.",
		},
		["zhTW"] = {
			"[美化外觀] 新增了插件 World Quest Tab 的美化外觀.",
			"[其他] 新增了一个退出相位深潛的按鍵, 會在相位深潛時自動顯示.",
		},
		["enUS"] = {
			"[Skins] New addon skin for World Quest Tab.",
			"[Misc] Add new button to exit phase diving. It will automatically appear when you are in phase diving.",
		},
		["koKR"] = {
			"[스킨] World Quest Tab을 위한 새로운 애드온 스킨이 추가되었습니다.",
			"[기타] 잠수 중 탈출 버튼이 추가되었습니다. 잠수 중일 때 자동으로 나타납니다.",
		},
		["ruRU"] = {
			"[Скины] Новый скин аддона для World Quest Tab.",
			"[Прочее] Добавлена новая кнопка для выхода из фазового погружения. Она будет автоматически отображаться, когда вы находитесь в фазовом погружении.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[兼容性确认] 更新 MerathilisUI 兼容性确认列表.",
			"[移动框体] 优化工具箱内部模块移动逻辑.",
			"[美化皮肤] 优化世界地图任务部分的皮肤.",
			"[美化皮肤] 更新 Auctionator 皮肤.",
			"[额外物品条] 物品列表更新.",
			"[交接] 自动交接功能将不会作用于可能有跳过选项剧情的对话中.",
			"[聊天链接] 新增了聊天链接图标的设定项目.",
			"[聊天文字] 同步了 ElvUI 聊天的最新版本代码.",
		},
		["zhTW"] = {
			"[相容性確認] 更新 MerathilisUI 相容性確認列表.",
			"[移動框架] 優化工具箱內部模組移動邏輯.",
			"[美化外觀] 優化世界地圖任務部分的皮膚.",
			"[美化外觀] 更新 Auctionator 皮膚.",
			"[額外物品條] 物品列表更新.",
			"[交接] 自動交接功能將不會作用於可能有跳過選項劇情的對話中.",
			"[聊天連結] 新增了聊天連結圖標的設定項目.",
			"[聊天文字] 同步了 ElvUI 聊天的最新版本代碼.",
		},
		["enUS"] = {
			"[Compatibility Check] Update MerathilisUI compatibility check list.",
			"[Move Frames] Optimize the internal module movement logic of the toolbox.",
			"[Skins] Optimize the skin for the world map quest area.",
			"[Skins] Update Auctionator skin.",
			"[Extra Item Bars] Update item list.",
			"[Turn In] The automatic turn-in function will not apply to dialogues that may have skip gossip options.",
			"[Chat Links] Add settings for chat link icons.",
			"[Chat Text] Sync with the latest version of ElvUI chat code.",
		},
		["koKR"] = {
			"[호환성 확인] MerathilisUI 호환성 확인 목록을 업데이트합니다.",
			"[이동 프레임] 툴박스 내부 모듈 이동 로직을 최적화합니다.",
			"[스킨] 세계 지도 퀘스트 영역의 스킨을 최적화합니다.",
			"[스킨] Auctionator 스킨을 업데이트합니다.",
			"[추가 아이템 바] 아이템 목록을 업데이트합니다.",
			"[전달] 자동 전달 기능은 건너뛰기 대화 옵션이 있을 수 있는 대화에 적용되지 않습니다.",
			"[채팅 링크] 채팅 링크 아이콘에 대한 설정을 추가합니다.",
			"[채팅 텍스트] ElvUI 채팅의 최신 버전 코드와 동기화합니다.",
		},
		["ruRU"] = {
			"[Проверка совместимости] Обновление списка проверки совместимости MerathilisUI.",
			"[Перемещение рамок] Оптимизация логики перемещения внутренних модулей инструментария.",
			"[Скины] Оптимизация скина для области квестов на карте мира.",
			"[Скины] Обновление скина Auctionator.",
			"[Дополнительные ячейки предметов] Обновление списка предметов.",
			"[Сдача] Функция автоматической сдачи не будет применяться к диалогам, в которых могут быть варианты пропуска сплетен.",
			"[Чат-ссылки] Добавлены настройки для иконок чат-ссылок.",
			"[Чат-текст] Синхронизация с последней версией кода чата ElvUI.",
		},
	},
}
