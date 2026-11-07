local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[425] = {
	RELEASE_DATE = "2026/11/07",
	IMPORTANT = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
		["ruRU"] = {},
	},
	NEW = {
		["zhCN"] = {
			"[好友列表] WoW Forever 的好友和近期往来卡片现在会套用状态图标、游戏图标、客户端和职业颜色、等级、位置和字体. Forever 使用单独的游戏图标.",
		},
		["zhTW"] = {
			"[好友名單] WoW Forever 的好友和近期盟友卡片現在會套用狀態圖示、遊戲圖示、客戶端和職業顏色、等級、位置和字體. Forever 使用單獨的遊戲圖示.",
		},
		["enUS"] = {
			"[Friend List] WoW Forever friend and recent ally cards now use the status icons, game icons, client and class colors, level, location, and fonts. Forever has its own game icon.",
		},
		["koKR"] = {
			"[친구 목록] WoW Forever의 친구와 최근 동맹 카드에 상태 아이콘, 게임 아이콘, 클라이언트와 직업 색상, 레벨, 위치, 글꼴이 적용됩니다. Forever 전용 게임 아이콘을 사용합니다.",
		},
		["ruRU"] = {
			"[Список друзей] Карточки друзей и раздела «Недавние союзники» в WoW Forever теперь используют значки статуса, значки игры, цвета клиента и класса, уровень, местоположение и шрифты. У Forever есть собственный значок игры.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化外观] Plumber 皮肤在 WoW Forever 上不再因为没有资料片登陆页面而报错.",
			"[字体] 更新字体时会跳过暴雪框体返回的秘密对齐值, 例如失控提示, 避免污染和报错.",
			"更新了 LibRangeCheck-3.0. GUID 为秘密值时改用单位做缓存, WoW Forever 和至暗之夜上的距离检测可以正常工作.",
		},
		["zhTW"] = {
			"[美化外觀] Plumber 皮膚在 WoW Forever 上不再因為沒有資料片登陸頁面而報錯.",
			"[字體] 更新字體時會跳過暴雪框架回傳的秘密對齊值, 例如失控提示, 避免污染和報錯.",
			"更新了 LibRangeCheck-3.0 函式庫. GUID 為秘密值時改用單位做快取, WoW Forever 和至暗之夜上的距離檢測可以正常工作.",
		},
		["enUS"] = {
			"[Skins] The Plumber skin no longer errors on WoW Forever when the expansion landing page is not loaded.",
			"[Fonts] Font updates skip secret justify values from Blizzard frames such as Loss of Control, so they do not taint or error.",
			"Updated LibRangeCheck-3.0. When the GUID is secret, the cache uses the unit, so range checks work on WoW Forever and Midnight.",
		},
		["koKR"] = {
			"[스킨] WoW Forever에서 확장팩 시작 페이지가 없으면 Plumber 스킨이 더 이상 오류를 내지 않습니다.",
			"[글꼴] 글꼴을 갱신할 때 제어 불가 표시처럼 블리자드 프레임이 돌려주는 비밀 정렬 값은 건너뛰어 오염과 오류를 막습니다.",
			"LibRangeCheck-3.0이 업데이트되었습니다. GUID가 비밀 값이면 유닛으로 캐시하므로 WoW Forever와 미드나이트에서 거리 확인이 동작합니다.",
		},
		["ruRU"] = {
			"[Скины] Скин Plumber больше не вызывает ошибку в WoW Forever, если страница дополнения не загружена.",
			"[Шрифты] При обновлении шрифта секретные значения выравнивания с фреймов Blizzard, например потери контроля, пропускаются, чтобы не вызывать порчу и ошибки.",
			"Обновлена библиотека LibRangeCheck-3.0. Если GUID скрыт, кэш использует юнита, поэтому проверка дистанции работает в WoW Forever и в Полуночи.",
		},
	},
}
