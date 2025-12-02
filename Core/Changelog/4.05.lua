local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[405] = {
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
			"[通告]-[重置副本] 添加一个选项允许通告副本难度变更. 默认开启",
			"[额外物品条] 在黑名单选项中添加一个新选项可以排除全部量子物品以防止误点. 默认关闭",
			"[游戏条] 选项中新增一个选项, 可以自由对调队伍查找器按钮的左右键, 现在调整回默认左键打开暴雪队伍查找器.",
			"[进度] 新增进度更新提示音. 默认关闭. 感谢 BelegCufea",
		},
		["zhTW"] = {
			"[通告]-[重置副本] 添加一個選項允許通告副本難度變更. 預設開啟",
			"[額外物品列] 在黑名單選項中添加一個新選項可以排除全部量子物品以防止誤點. 預設關閉",
			"[遊戲條] 選項中新增一個選項, 可以自由對調隊伍查找器按鈕的左右鍵, 現在調整回預設左鍵打開暴雪隊伍查找器.",
			"[進度] 新增進度更新提示音. 預設關閉. 感謝 BelegCufea",
		},
		["enUS"] = {
			"[Announcement]-[Reset Instance] Add an option to announce instance difficulty changes. Enabled by default.",
			"[Extra Item Bar] Add a new option in the blacklist to exclude all quantum items to avoid accidentally using them. Disabled by default.",
			"[Game Bar] A new option is added in the options to freely swap the left and right clicks of the Group Finder button, now adjusted back to the default left click to open the Blizzard Group Finder.",
			"[Progress] Add progress update sound notifications. Disabled by default. Thanks to BelegCufea",
		},
		["koKR"] = {
			"[알림]-[인스턴스 초기화] 인스턴스 난이도 변경을 알릴 수 있는 옵션을 추가했습니다. 기본값으로 활성화됩니다.",
			"[아이템 바] 실수로 사용하는 것을 방지하기 위해 모든 양자 아이템을 제외할 수 있는 새로운 옵션을 블랙리스트에 추가했습니다. 기본값으로 비활성화됩니다.",
			"[게임 바] 옵션에 그룹 찾기 버튼의 왼쪽 및 오른쪽 클릭을 자유롭게 전환할 수 있는 새로운 옵션이 추가되었습니다. 이제 기본값인 왼쪽 클릭으로 블리자드 그룹 찾기를 열도록 조정되었습니다.",
			"[진행 상황] 진행 상황 업데이트 사운드 알림을 추가했습니다. 기본값으로 비활성화됩니다. BelegCufea에게 감사드립니다.",
		},
		["ruRU"] = {
			"[Объявления]-[Сброс подземелья] Добавлена опция для объявления об изменении сложности подземелья. Включено по умолчанию.",
			"[Дополнительная панель предметов] Добавлена новая опция в черном списке для исключения всех квантовых предметов, чтобы избежать их случайного использования. Отключено по умолчанию.",
			"[Игровая панель] В параметры добавлена новая опция, позволяющая свободно менять местами левый и правый клики кнопки 'Поиска группы'. Теперь вместо щелчка ЛКМ по умолчанию открывается 'Поиск групп Blizzard'.",
			"[Прогресс] Добавлены звуковые уведомления об обновлении прогресса. Отключено по умолчанию. Спасибо BelegCufea",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"优化世界地图迷雾去除可能引起的变量污染.",
			"[通告] 使用 ChatThrottleLib 来防止极端情况下的卡顿掉线问题.",
			"[右键菜单] 添加了对中国大陆服务器玩家的英雄榜支持.",
			"[美化外观] 优化了地下城手册中首领按钮的高亮效果.",
			"[美化外观] 优化了 TomTom 皮肤.",
			"[美化外观] 优化了 Weakauras 皮肤.",
		},
		["zhTW"] = {
			"優化世界地圖迷霧去除可能引起的變量污染.",
			"[通告] 使用 ChatThrottleLib 來防止極端情況下的卡頓掉線問題.",
			"[右鍵選單] 添加了對中國大陸伺服器玩家的英雄榜支持.",
			"[美化外觀] 優化了地下城手冊中首領按鈕的高亮效果.",
			"[美化外觀] 優化了 TomTom 皮膚.",
			"[美化外觀] 優化了 Weakauras 皮膚.",
		},
		["enUS"] = {
			"Optimize variable taint that may be caused by removing fog of war on the world map.",
			"[Announcement] Use ChatThrottleLib to prevent lag and disconnection issues in extreme cases.",
			"[Context Menu] Add armory support for players on China mainland servers.",
			"[Skins] Optimize the highlight effect of Boss buttons in the Encounter Journal.",
			"[Skins] Optimize the TomTom skin.",
			"[Skins] Optimize the Weakauras skin.",
		},
		["koKR"] = {
			"세계 지도에서 전쟁의 안개를 제거할 때 발생할 수 있는 변수 오염을 최적화했습니다.",
			"[알림] 극단적인 상황에서의 렉 및 연결 끊김 문제를 방지하기 위해 ChatThrottleLib를 사용했습니다.",
			"[컨텍스트 메뉴] 중국 본토 서버 플레이어를 위한 전투기록실 지원을 추가했습니다.",
			"[스킨] 던전 도감에서 보스 버튼의 강조 효과를 최적화했습니다.",
			"[스킨] TomTom 스킨을 최적화했습니다.",
			"[스킨] Weakauras 스킨을 최적화했습니다.",
		},
		["ruRU"] = {
			"Оптимизация загрязнения переменных, которое может быть вызвано удалением тумана войны на карте мира.",
			"[Объявления] Используйте ChatThrottleLib, чтобы предотвратить проблемы с задержкой и отключением в экстремальных случаях.",
			"[Контекстное меню] Добавлена поддержка арены для игроков на серверах материкового Китая.",
			"[Скины] Оптимизирован эффект подсветки кнопок боссов в журнале подземелий.",
			"[Скины] Оптимизирован скин TomTom.",
			"[Скины] Оптимизирован скин Weakauras.",
		},
	},
}
