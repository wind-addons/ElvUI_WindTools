local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[422] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"事件分发已改用 NumyAceEvent-3.0, CPU 性能分析会将用量归属到 WindTools, 而不再归属到最先加载 AceEvent 的插件.",
		},
		["zhTW"] = {
			"事件分發已改用 NumyAceEvent-3.0, CPU 效能分析會將用量歸屬到 WindTools, 而不再歸屬到最先載入 AceEvent 的插件.",
		},
		["enUS"] = {
			"Event handling now uses NumyAceEvent-3.0 so CPU profiling attributes usage to WindTools instead of the first addon that loaded AceEvent.",
		},
		["koKR"] = {
			"이벤트 처리가 이제 NumyAceEvent-3.0을 사용하므로 CPU 프로파일링 사용량이 AceEvent를 먼저 로드한 애드온이 아니라 WindTools에 귀속됩니다.",
		},
		["ruRU"] = {
			"Обработка событий теперь использует NumyAceEvent-3.0, поэтому профилирование CPU относит нагрузку к WindTools, а не к аддону, который первым загрузил AceEvent.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[事件追踪] 新增至暗之夜每周任务线: 怪物狩猎、Silvermoon Court、Zul'jarra's Forces 和 Slayer's Duellum.",
			"[美化皮肤] 新增了 Talent Loadout Manager 美化外观.",
		},
		["zhTW"] = {
			"[事件追蹤] 新增至暗之夜每週任務線: 獵物狩獵、Silvermoon Court、Zul'jarra's Forces 和 Slayer's Duellum.",
			"[美化外觀] 新增了 Talent Loadout Manager 美化外觀.",
		},
		["enUS"] = {
			"[Event Tracker] Added new Midnight weekly quest lines: Prey Hunt, Silvermoon Court, Zul'jarra's Forces, and Slayer's Duellum.",
			"[Skins] Add Talent Loadout Manager skin.",
		},
		["koKR"] = {
			"[이벤트 추적기] 새로운 미드나이트 주간 퀘스트 라인을 추가했습니다: 사냥감 활동, Silvermoon Court, Zul'jarra's Forces, Slayer's Duellum.",
			"[스킨] Talent Loadout Manager 외관을 추가했습니다.",
		},
		["ruRU"] = {
			"[Трекер событий] Добавлены новые еженедельные цепочки заданий Полуночи: Охота на добычу, Двор Луносвета, Силы Зул'джарры и Дуэлянты Зубца убийцы.",
			"[Скины] Добавлен скин для Talent Loadout Manager.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化皮肤] 修复 SilverDragon 战利品窗口与提示框在从对象池中被重复使用后, 皮肤会还原为暴雪默认外观的问题.",
		},
		["zhTW"] = {
			"[美化外觀] 修復 SilverDragon 戰利品視窗與提示框在從物件池中被重複使用後, 皮膚會還原為暴雪預設外觀的問題.",
		},
		["enUS"] = {
			"[Skins] Fix SilverDragon's loot window and tooltips reverting to the default Blizzard look after being reused from its object pool.",
		},
		["koKR"] = {
			"[스킨] SilverDragon 전리품 창과 툴팁이 오브젝트 풀에서 재사용된 후 기본 블리자드 모양으로 되돌아가던 문제를 수정했습니다.",
		},
		["ruRU"] = {
			"[Скины] Исправлена проблема, когда окно добычи и подсказки SilverDragon возвращались к стандартному виду Blizzard после повторного использования из пула объектов.",
		},
	},
}
