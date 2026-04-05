local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[418] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"更新库 LibOpenRaid. 感谢 Valdemar",
			"[兼容性检查] 优化和 mMediaTag 的兼容性检查. 感谢 Merathilis",
		},
		["zhTW"] = {
			"更新庫 LibOpenRaid. 感謝 Valdemar",
			"[兼容性检查] 優化和 mMediaTag 的兼容性检查. 感謝 Merathilis",
		},
		["enUS"] = {
			"Updated library LibOpenRaid. Thanks to Valdemar",
			"[Compatibility Check] Optimized compatibility check with mMediaTag. Thanks to Merathilis",
		},
		["koKR"] = {
			"라이브러리 LibOpenRaid가 업데이트되었습니다. Valdemar에게 감사드립니다.",
			"[호환성 검사] mMediaTag와의 호환성 검사가 최적화되었습니다. Merathilis에게 감사드립니다.",
		},
		["ruRU"] = {
			"Обновлена библиотека LibOpenRaid. Спасибо Valdemar",
			"[Проверка совместимости] Оптимизирована проверка совместимости с mMediaTag. Спасибо Merathilis",
		},
	},
	NEW = {
		["zhCN"] = {
			"[静音] 新增了 黑曜夜之翼 的静音选项. 默认关闭.",
			"[美化外观] 新增了 [失控警报] 美化的独立选项. 默认开启.",
			"[预创建队伍] 新增了右侧面板过滤按钮的提示信息选项. 默认开启.",
		},
		["zhTW"] = {
			"[靜音] 中新增了 黑曜夜翼 的靜音選項. 預設關閉.",
			"[美化外觀] 新增了 [失控警報] 美化的獨立選項. 預設開啟.",
			"[預組列表] 新增了右側面板過濾器按鈕的提示資訊選項. 預設開啟.",
		},
		["enUS"] = {
			"[Mute] Added a new mute option for Obsidian Nightwing. Disabled by default.",
			"[Skins] Added new independent options for [Loss of Control] skin. Enabled by default.",
			"[LFG List] Added a tooltip option for filter buttons in the right panel. Enabled by default.",
		},
		["koKR"] = {
			"[음소거] 흑요석 밤날개표범 음소거 옵션이 추가되었습니다. 기본적으로 비활성화되어 있습니다.",
			"[스킨] [제어 상실] 스킨에 대한 새로운 독립 옵션이 추가되었습니다. 기본적으로 활성화되어 있습니다.",
			"[파티 찾기 목록] 오른쪽 패널의 필터 버튼에 대한 툴팁 옵션이 추가되었습니다. 기본적으로 활성화되어 있습니다.",
		},
		["ruRU"] = {
			"[Отключение звуков] Добавлена новая опция отключения звука для Обсидианового ночного крыла. Отключено по умолчанию.",
			"[Скины] Добавлены новые независимые опции для скина [Потеря контроля]. Включено по умолчанию.",
			"[Поиск группы] Добавлена опция подсказки для кнопок фильтров на правой панели. Включено по умолчанию.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[额外物品条] 更新大餐还有传送门的物品数据. 感谢 Dack",
			"[额外物品条] 更新可打开物品数据. 感谢 mcc",
			"[预组建队伍] 优化了西方语系中副本名的缩写, 使其更加贴合 Raider.IO 风格.",
			"[美化皮肤] 由于 World Quest Tab 现在自带对 ElvUI 的美化支持, 现在精简了相关重复美化, 依旧保留了对鼠标提示文字去边框, 框体阴影, 世界地图框体跟随移动等功能.",
			"[美化皮肤] 修复了 Simple Addon Manager 右侧内容无法快速跟随框体移动的问题.",
		},
		["zhTW"] = {
			"[額外物品條] 更新大餐還有傳送門的物品數據. 感謝 Dack",
			"[額外物品條] 更新可打開物品數據. 感謝 mcc",
			"[預組建隊伍] 優化了西方語系中副本名的縮寫, 使其更加貼合 Raider.IO 風格.",
			"[美化皮膚] 由於 World Quest Tab 現在自帶對 ElvUI 的美化支持, 現在精簡了相關重複美化, 依舊保留了對鼠標提示文字去邊框, 框體陰影, 世界地圖框體跟隨移動等功能.",
		},
		["enUS"] = {
			"[Extra Item Bar] Updated the item data for the Feasts and Portals. Thanks to Dack",
			"[Extra Item Bar] Updated the item data for openable items. Thanks to mcc",
			"[LFG List] Optimized the abbreviation of dungeon names in Western languages to better fit the Raider.IO style.",
		},
		["koKR"] = {
			"[추가 아이템 바] 잔치와 포탈에 대한 아이템 데이터를 업데이트했습니다. Dack에게 감사드립니다.",
			"[추가 아이템 바] 열 수 있는 아이템에 대한 아이템 데이터를 업데이트했습니다. mcc에게 감사드립니다.",
			"[파티 찾기 목록] Raider.IO 스타일에 더 잘 맞도록 서양 언어의 던전 이름 약어를 최적화했습니다.",
			"[스킨] World Quest Tab이 이제 ElvUI에 대한 스킨 지원을 기본적으로 제공하기 때문에 관련 중복 스킨을 간소화했습니다. 여전히 마우스 툴팁 텍스트의 테두리 제거, 프레임 그림자, 세계 지도 프레임 이동과 같은 기능을 유지합니다.",
		},
		["ruRU"] = {
			"[Дополнительная панель предметов] Обновлены данные предметов для праздников и порталов. Спасибо Dack",
			"[Дополнительная панель предметов] Обновлены данные предметов для открываемых предметов. Спасибо mcc",
			"[Поиск группы] Оптимизировано сокращение названий подземелий в западных языках, чтобы лучше соответствовать стилю Raider.IO.",
			"[Скины] Поскольку вкладка World Quest теперь по умолчанию поддерживает скины для ElvUI, были упрощены связанные повторяющиеся скины, при этом по-прежнему сохраняются функции, такие как удаление границ текста подсказки мыши, тени рамок и перемещение рамок на карте мира.",
		},
	},
}
