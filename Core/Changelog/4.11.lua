local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[411] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"[通告] 重写了实用技能的通告功能, 现在可以在暴雪不限制的情况下使用通报自己使用的技能.",
		},
		["zhTW"] = {
			"[通告] 重寫了實用技能的通告功能, 現在可以在暴雪不限制的情況下使用通報自己使用的技能.",
		},
		["enUS"] = {
			"[Announcement] Rewrote the announcement feature for utility skills, now you can announce your own skills without Blizzard restrictions.",
		},
		["koKR"] = {
			"[공지] 유틸리티 스킬의 공지 기능을 재작성했습니다. 이제 블리자드의 제한 없이 자신의 스킬을 공지할 수 있습니다.",
		},
		["ruRU"] = {
			"[Оповещения] Переписана функция оповещения для вспомогательных навыков, теперь вы можете оповещать о своих собственных навыках без ограничений Blizzard.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[战斗提醒] 新增了进入战斗, 离开战斗的声音设置选项. 默认关闭.",
		},
		["zhTW"] = {
			"[戰鬥提醒] 新增了進入戰鬥, 離開戰鬥的聲音設置選項. 默認關閉.",
		},
		["enUS"] = {
			"[Combat Reminder] Added sound settings options for entering and leaving combat. Disabled by default.",
		},
		["koKR"] = {
			"[전투 알림] 전투 진입 및 퇴장에 대한 사운드 설정 옵션이 추가되었습니다. 기본적으로 비활성화되어 있습니다.",
		},
		["ruRU"] = {
			"[Боевой напоминатель] Добавлены параметры настройки звука для входа и выхода из боя. По умолчанию отключено.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"优化了一个全局变量泄露问题.",
			"[通告] 移除了通告模块中所有在战斗中受限的功能.",
			"[护盾] 现在护盾只会在伤害护盾上使用自定义材质.",
		},
		["zhTW"] = {
			"優化了一個全局變量洩露問題.",
			"[通告] 移除了通告模塊中所有在戰鬥中受限的功能.",
			"[護盾] 現在護盾只會在傷害護盾上使用自定義材質.",
		},
		["enUS"] = {
			"Optimized a global variable leak issue.",
			"[Announcement] Removed all in-combat restricted features in Announcement module.",
			"[Absorb] Now custom textures are only applied to damage absorbs.",
		},
		["koKR"] = {
			"글로벌 변수 누수 문제를 최적화했습니다.",
			"[공지] 공지 모듈에서 전투 중 제한된 모든 기능을 제거했습니다.",
			"[흡수] 이제 사용자 지정 텍스처가 피해 흡수에만 적용됩니다.",
		},
		["ruRU"] = {
			"Оптимизирована проблема утечки глобальных переменных.",
			"[Оповещения] Удалены все функции, ограниченные в бою, в модуле 'Оповещения'.",
			"[Поглощение] Теперь пользовательские текстуры применяются только к поглощениям урона.",
		},
	},
}
