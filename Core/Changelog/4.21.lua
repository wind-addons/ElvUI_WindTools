local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[421] = {
	RELEASE_DATE = "2026/08/24",
	IMPORTANT = {
		["zhCN"] = {
			"配置导入导出现已使用暴雪原生 C_EncodingUtil. 此前导出的 WindTools 字符串将无法导入.",
		},
		["zhTW"] = {
			"設定匯入匯出現已使用暴雪原生 C_EncodingUtil. 此前匯出的 WindTools 字串將無法匯入.",
		},
		["enUS"] = {
			"Profile import/export now uses Blizzard C_EncodingUtil. Previously exported WindTools strings can no longer be imported.",
		},
		["koKR"] = {
			"프로필 가져오기/내보내기가 이제 Blizzard C_EncodingUtil을 사용합니다. 이전에 내보낸 WindTools 문자열은 더 이상 가져올 수 없습니다.",
		},
		["ruRU"] = {
			"Импорт/экспорт профилей теперь использует Blizzard C_EncodingUtil. Ранее экспортированные строки WindTools больше нельзя импортировать.",
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
			"[美化皮肤] 适配暴雪伤害统计新的 MinimizeContainer 框体结构.",
			"[伤害统计布局] 预览模式会创建缺失的会话窗口, 并在预览时取消最小化.",
		},
		["zhTW"] = {
			"[美化皮膚] 適配暴雪傷害統計新的 MinimizeContainer 框體結構.",
			"[傷害統計佈局] 預覽模式會建立缺失的會話視窗, 並在預覽時取消最小化.",
		},
		["enUS"] = {
			"[Skins] Update the Blizzard Damage Meter skin for the new MinimizeContainer frame tree.",
			"[Damage Meter Layout] Start Preview now creates missing session windows and un-minimizes them during preview.",
		},
		["koKR"] = {
			"[스킨] 새로운 MinimizeContainer 프레임 구조에 맞게 블리자드 피해 미터 스킨을 업데이트했습니다.",
			"[피해 미터 레이아웃] 미리보기 모드가 없는 세션 창을 생성하고 미리보기 중 최소화를 해제합니다.",
		},
		["ruRU"] = {
			"[Скины] Обновлён скин Blizzard Damage Meter под новую иерархию MinimizeContainer.",
			"[Макет индикатора урона] Режим предпросмотра создаёт отсутствующие окна сессии и снимает свёрнутость на время предпросмотра.",
		},
	},
}
