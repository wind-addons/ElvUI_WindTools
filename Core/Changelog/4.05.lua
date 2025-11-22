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
		},
		["zhTW"] = {
			"[通告]-[重置副本] 添加一個選項允許通告副本難度變更. 預設開啟",
			"[額外物品列] 在黑名單選項中添加一個新選項可以排除全部量子物品以防止誤點. 預設關閉",
			"[遊戲條] 選項中新增一個選項, 可以自由對調隊伍查找器按鈕的左右鍵, 現在調整回預設左鍵打開暴雪隊伍查找器.",
		},
		["enUS"] = {
			"[Announcement]-[Reset Instance] Add an option to announce instance difficulty changes. Enabled by default.",
			"[Extra Item Bar] Add a new option in the blacklist to exclude all quantum items to avoid accidentally using them. Disabled by default.",
			"[Game Bar] A new option is added in the options to freely swap the left and right clicks of the Group Finder button, now adjusted back to the default left click to open the Blizzard Group Finder.",
		},
		["koKR"] = {
			"[알림]-[인스턴스 초기화] 인스턴스 난이도 변경을 알릴 수 있는 옵션을 추가했습니다. 기본값으로 활성화됩니다.",
			"[아이템 바] 실수로 사용하는 것을 방지하기 위해 모든 양자 아이템을 제외할 수 있는 새로운 옵션을 블랙리스트에 추가했습니다. 기본값으로 비활성화됩니다.",
			"[게임 바] 옵션에 그룹 찾기 버튼의 왼쪽 및 오른쪽 클릭을 자유롭게 전환할 수 있는 새로운 옵션이 추가되었습니다. 이제 기본값인 왼쪽 클릭으로 블리자드 그룹 찾기를 열도록 조정되었습니다.",
		},
		["ruRU"] = {
			"[Объявления]-[Сброс подземелья] Добавлена опция для объявления об изменении сложности подземелья. Включено по умолчанию.",
			"[Дополнительная панель предметов] Добавлена новая опция в черном списке для исключения всех квантовых предметов, чтобы избежать их случайного использования. Отключено по умолчанию.",
			"[Игровая панель] В параметры добавлена новая опция для свободного переключения левого и правого кликов кнопки поиска группы, теперь настроено обратно на стандартный левый клик для открытия поиска группы Blizzard.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"进一步优化 SetPassThroughButtons 修复功能.",
			"[通告] 使用 ChatThrottleLib 来防止极端情况下的卡顿掉线问题.",
			"[右键菜单] 添加了对中国大陆服务器玩家的英雄榜支持.",
			"[美化外观] 优化了地下城手册中首领按钮的高亮效果.",
		},
		["zhTW"] = {
			"進一步優化 SetPassThroughButtons 修復功能.",
			"[通告] 使用 ChatThrottleLib 來防止極端情況下的卡頓掉線問題.",
			"[右鍵選單] 添加了對中國大陸伺服器玩家的英雄榜支持.",
			"[美化外觀] 優化了地下城手冊中首領按鈕的高亮效果.",
		},
		["enUS"] = {
			"Further optimiz the SetPassThroughButtons fix feature.",
			"[Announcement] Use ChatThrottleLib to prevent lag and disconnection issues in extreme cases.",
			"[Context Menu] Add armory support for players on China mainland servers.",
			"[Skins] Optimize the highlight effect of Boss buttons in the Encounter Journal.",
		},
		["koKR"] = {
			"SetPassThroughButtons 수정 기능을 추가로 최적화했습니다.",
			"[알림] 극단적인 상황에서의 렉 및 연결 끊김 문제를 방지하기 위해 ChatThrottleLib를 사용했습니다.",
			"[컨텍스트 메뉴] 중국 본토 서버 플레이어를 위한 전투기록실 지원을 추가했습니다.",
			"[스킨] 던전 도감에서 보스 버튼의 강조 효과를 최적화했습니다.",
		},
		["ruRU"] = {
			"Дальнейшая оптимизация функции исправления SetPassThroughButtons.",
			"[Объявления] Используйте ChatThrottleLib, чтобы предотвратить проблемы с задержкой и отключением в экстремальных случаях.",
			"[Контекстное меню] Добавлена поддержка арены для игроков на серверах материкового Китая.",
			"[Скины] Оптимизирован эффект подсветки кнопок боссов в журнале подземелий.",
		},
	},
}
