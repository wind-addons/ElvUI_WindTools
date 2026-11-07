local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[424] = {
	RELEASE_DATE = "2026/11/03",
	IMPORTANT = {
		["zhCN"] = {
			"最低支持的 ElvUI 版本提升到 16.01.",
		},
		["zhTW"] = {
			"最低支援的 ElvUI 版本提升到 16.01.",
		},
		["enUS"] = {
			"Minimum supported ElvUI version raised to 16.01.",
		},
		["koKR"] = {
			"최소 지원 ElvUI 버전이 16.01로 상향되었습니다.",
		},
		["ruRU"] = {
			"Минимальная поддерживаемая версия ElvUI повышена до 16.01.",
		},
	},
	NEW = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
		["ruRU"] = {},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[单位框体] 驱散覆盖的虚线边框现在会流动. 战斗中开始的更新会等到脱离战斗后再执行, 避免报错.",
			"[额外物品条] 更新了 12.1.5 的物品列表, 新增可打开容器和地下堡物品. 灵魂碎片仅在数量达到 3 个或以上时显示. 已移除晦暗虚空宝箱, 它们是隐藏的额外拾取追踪, 不是可使用物品.",
			"[事件追踪] 至暗之夜每周任务标签 Silvermoon Court、Zul'jarra's Forces 和 Slayer's Duellum 现在使用本地化的阵营名称.",
			"[右键菜单] 单位名称为秘密值时, 会隐藏公会邀请、查询、英雄榜和报告属性, 避免菜单报错.",
		},
		["zhTW"] = {
			"[單位框架] 驅散覆蓋的虛線邊框現在會流動. 戰鬥中開始的更新會等到脫離戰鬥後再執行, 避免報錯.",
			"[額外物品條] 更新了 12.1.5 的物品列表, 新增可打開容器和探究物品. 靈魂碎片僅在數量達到 3 個或以上時顯示. 已移除晦暗虛空寶箱, 它們是隱藏的額外拾取追蹤, 不是可使用物品.",
			"[事件追蹤] 至暗之夜每週任務標籤 Silvermoon Court、Zul'jarra's Forces 和 Slayer's Duellum 現在使用本地化的陣營名稱.",
			"[右鍵選單] 單位名稱為秘密值時, 會隱藏公會邀請、查詢、英雄榜和屬性報告, 避免選單報錯.",
		},
		["enUS"] = {
			"[Unit Frames] Dispel Overlay border now marches. Slot updates that start in combat wait until combat ends.",
			"[Extra Item Bar] Item list updated for 12.1.5: new openable containers and delve items, soul fragments only at 3 or more. Nebulous Void Cache entries were removed because they are hidden bonus-roll trackers.",
			"[Event Tracker] Midnight weekly labels for Silvermoon Court, Zul'jarra's Forces, and Slayer's Duellum now use the localized faction name.",
			"[Context Menu] Guild Invite, Who, Armory, and Report Stats stay hidden when the unit name is secret, so the menu does not error.",
		},
		["koKR"] = {
			"[유닛프레임] 해제 오버레이의 점선 테두리가 이제 움직입니다. 전투 중에 시작된 칸 갱신은 전투가 끝난 뒤에 적용됩니다.",
			"[아이템 바] 12.1.5 아이템 목록을 갱신했습니다. 열 수 있는 용기와 구렁 아이템을 추가했고, 영혼 조각은 3개 이상일 때만 표시됩니다. 숨겨진 보너스 주사위 추적기인 Nebulous Void Cache 항목은 제거했습니다.",
			"[이벤트 추적기] 미드나이트 주간 표시인 Silvermoon Court, Zul'jarra's Forces, Slayer's Duellum이 이제 현지화된 진영 이름을 사용합니다.",
			"[컨텍스트 메뉴] 유닛 이름이 비밀 값이면 길드 초대, 누구, 전투정보실, 내 스탯 전송을 숨겨 메뉴가 오류를 내지 않습니다.",
		},
		["ruRU"] = {
			"[Фреймы юнитов] Пунктирная рамка наложения рассеивания теперь движется. Обновления слотов, начатые в бою, выполняются после выхода из боя.",
			"[Панель дополнительных предметов] Список предметов обновлён для 12.1.5: добавлены открываемые контейнеры и предметы вылазок, осколки душ показываются только от 3 штук. Записи Nebulous Void Cache убраны: это скрытые отслеживатели бонусного броска, а не используемые предметы.",
			"[Трекер событий] Подписи еженедельных заданий Полуночи для Двора Луносвета, Сил Зул'джарры и Дуэлянтов Зубца убийцы теперь берут локализованное название фракции.",
			"[Контекстное меню] Приглашение в гильдию, Кто, Оружейная и Статистика отчетов скрываются, если имя юнита скрыто, чтобы меню не вызывало ошибку.",
		},
	},
}
