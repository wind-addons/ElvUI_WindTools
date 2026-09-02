local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[421] = {
	RELEASE_DATE = "2026/08/24",
	IMPORTANT = {
		["zhCN"] = {
			"最低支持的 ElvUI 版本提升到 15.26.",
			"配置导入导出已改用暴雪内置编码. 旧版 WindTools 导出的字符串将无法导入, 请更新后重新导出.",
		},
		["zhTW"] = {
			"最低支援的 ElvUI 版本提升到 15.26.",
			"設定匯入匯出已改用暴雪內建編碼. 舊版 WindTools 匯出的字串將無法匯入, 請更新後重新匯出.",
		},
		["enUS"] = {
			"Minimum supported ElvUI version raised to 15.26.",
			"Profile import/export now uses Blizzard's built-in encoding. Strings exported from older WindTools versions can no longer be imported; please re-export after updating.",
		},
		["koKR"] = {
			"최소 지원 ElvUI 버전이 15.26로 상향되었습니다.",
			"프로필 가져오기/내보내기가 이제 블리자드 내장 인코딩을 사용합니다. 이전 버전 WindTools에서 내보낸 문자열은 가져올 수 없으니, 업데이트 후 다시 내보내세요.",
		},
		["ruRU"] = {
			"Минимальная поддерживаемая версия ElvUI повышена до 15.26.",
			"Импорт/экспорт профилей теперь использует встроенное кодирование Blizzard. Строки, экспортированные из старых версий WindTools, больше нельзя импортировать — экспортируйте заново после обновления.",
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
			"[美化皮肤] 适配暴雪伤害统计的新窗口布局.",
			"[伤害统计布局] 会话窗口改由游戏自己管理, 战斗计时和条目更新可正常工作.",
			"[美化皮肤] 修复伤害统计会话窗口鼠标悬停可能干扰默认界面的问题.",
			"[离开相位潜行] 修复战斗中检测相位潜行状态时报错的问题.",
			"[观察] 修复战斗中目标身份被隐藏时观察专精报错的问题.",
			"[美化皮肤] ElvUI 光环阴影现已正确显示在玩家光环、单位框体和姓名板上.",
		},
		["zhTW"] = {
			"[美化皮膚] 適配暴雪傷害統計的新視窗佈局.",
			"[傷害統計佈局] 會話視窗改由遊戲自己管理, 戰鬥計時和條目更新可正常運作.",
			"[美化皮膚] 修復傷害統計會話視窗滑鼠懸停可能干擾預設介面的問題.",
			"[離開相位潛行] 修復戰鬥中偵測相位潛行狀態時報錯的問題.",
			"[觀察] 修復戰鬥中目標身分被隱藏時觀察專精報錯的問題.",
			"[美化皮膚] ElvUI 光環陰影現已正確顯示在玩家光環、單位框體和姓名板上.",
		},
		["enUS"] = {
			"[Skins] Update the Blizzard Damage Meter skin for the new window layout.",
			"[Damage Meter Layout] Let the game manage session windows so the combat timer and entries update correctly.",
			"[Skins] Fix Damage Meter session window mouseover interfering with the default UI.",
			"[Exit Phase Diving] Fix an error when checking Phase Diving status in combat.",
			"[Inspect] Fix inspect specialization errors when the target's identity is hidden in combat.",
			"[Skins] ElvUI aura shadows now show on player auras, unit frames, and nameplates.",
		},
		["koKR"] = {
			"[스킨] 새로운 창 레이아웃에 맞게 블리자드 피해 미터 스킨을 업데이트했습니다.",
			"[피해 미터 레이아웃] 세션 창을 게임이 관리하도록 하여 전투 타이머와 항목이 정상적으로 갱신됩니다.",
			"[스킨] 피해 미터 세션 창 마우스오버가 기본 UI를 방해하던 문제를 수정했습니다.",
			"[위상 잠수 종료] 전투 중 위상 잠수 상태를 확인할 때 발생하던 오류를 수정했습니다.",
			"[살펴보기] 전투 중 대상 신원이 숨겨져 있을 때 전문화 살펴보기가 오류를 내던 문제를 수정했습니다.",
			"[스킨] ElvUI 오라 그림자가 이제 플레이어 오라, 유닛 프레임, 이름표에 정상적으로 표시됩니다.",
		},
		["ruRU"] = {
			"[Скины] Обновлён скин Blizzard Damage Meter под новое расположение окна.",
			"[Макет индикатора урона] Окна сессии снова управляются игрой, поэтому таймер боя и строки обновляются правильно.",
			"[Скины] Исправлено наведение на окно сессии Damage Meter, мешавшее стандартному интерфейсу.",
			"[Выход из фазового погружения] Исправлена ошибка при проверке фазового погружения в бою.",
			"[Осмотр] Исправлена ошибка осмотра специализации, когда личность цели скрыта в бою.",
			"[Скины] Тени аур ElvUI снова отображаются на аурах игрока, рамках юнитов и индикаторах.",
		},
	},
}
