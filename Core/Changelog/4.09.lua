local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[409] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"继续优化至暗之夜API改动带来的兼容性问题.",
			"[高级] 移除了战斗日志增强功能.",
			"[标签] 完全重构了标签模块, 并移动到了单位框体分类. 你可以在 [单位框体] - [标签] 中找到新的可适用于新版 ElvUI 单位框体的标签.",
			"[吸收] 该模块现在支持最新版 ElvUI 单位框体, 但是由于暴雪 API 的问题, 溢出时的发光目前无法正确显示.",
			"[单位框体] 该模块现在支持最新版 ElvUI 单位框体.",
		},
		["zhTW"] = {
			"繼續優化至暗之夜API改動帶來的相容性問題.",
			"[進階] 移除了戰鬥日誌增強功能.",
			"[標籤] 完全重構了標籤模組, 並移動到了單位框架分類. 你可以在 [單位框架] - [標籤] 中找到新的可適用於新版 ElvUI 單位框體的標籤.",
			"[吸收] 該模組現在支援最新版 ElvUI 單位框架, 但是由於暴雪 API 的問題, 溢出時的發光目前無法正確顯示.",
			"[單位框架] 該模組現在支援最新版 ElvUI 單位框架.",
		},
		["enUS"] = {
			"Continued to optimize compatibility issues caused by Midnight API changes.",
			"[Advanced] Removed the combat log enhancement feature.",
			"[Tags] Completely rebuilt the module, and move it to the Unit Frames category. You can find the new tags applicable to the new ElvUI unit frames in [Unit Frames] - [Tags].",
			"[Absorb] This module now supports the latest ElvUI unit frames, but due to Blizzard API issues, the glow on overflow cannot be displayed correctly at the moment.",
			"[Unit Frames] This module now supports the latest ElvUI unit frames.",
		},
		["koKR"] = {
			"미드나이트 API 변경으로 인한 호환성 문제를 지속적으로 최적화했습니다.",
			"[고급] 전투 로그 향상 기능이 제거되었습니다.",
			"[태그] 모듈이 완전히 재구성되었으며, 유닛 프레임 범주로 이동되었습니다. 새로운 ElvUI 유닛 프레임에 적용할 수 있는 새로운 태그는 [유닛 프레임] - [태그]에서 찾을 수 있습니다.",
			"[흡수] 이 모듈은 이제 최신 ElvUI 유닛 프레임을 지원하지만, 블리자드 API 문제로 인해 현재 오버플로 시 글로우가 올바르게 표시되지 않습니다.",
			"[유닛 프레임] 이 모듈은 이제 최신 ElvUI 유닛 프레임을 지원합니다.",
		},
		["ruRU"] = {
			"Продолжена оптимизация проблем совместимости, вызванных изменениями API Полуночи.",
			"[Расширенные] Функция улучшения журнала боя была удалена.",
			"[Теги] Модуль был полностью перестроен, и перемещен в категорию Юнит-Фреймы. Новые теги, применимые к новым юнит-фреймам ElvUI, можно найти в разделе [Юнит-Фреймы] - [Теги].",
			"[Поглощение] Этот модуль теперь поддерживает последние юнит-фреймы ElvUI, но из-за проблем с API Blizzard свечение при переполнении в данный момент не может отображаться правильно.",
			"[Юнит-Фреймы] Этот модуль теперь поддерживает последние юнит-фреймы ElvUI.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[智能 Tab] 新增一个选项可以在切换循环中加入 [聊天条] 模块中设定的世界频道. 默认关闭.",
		},
		["zhTW"] = {
			"[智能 Tab] 新增一個選項可以在切換循環中加入 [聊天條] 模組中設定的世界頻道. 預設關閉.",
		},
		["enUS"] = {
			"[Smart Tab] Added an option to include the world channel set in the [Chat Bar] module in the switch cycle. Disabled by default.",
		},
		["koKR"] = {
			"[스마트 탭] 전환 주기에 [채팅 바] 모듈에 설정된 월드 채널을 포함하는 옵션이 추가되었습니다. 기본적으로 비활성화되어 있습니다.",
		},
		["ruRU"] = {
			"[Умная вкладка] Добавлена опция для включения мирового канала, установленного в модуле [Панель чата], в цикл переключения. По умолчанию отключено.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[世界地图] 迷雾去除功能现在支持至暗之夜地图.",
			"[额外物品条] 移除了 SL 和 DF 相关的物品条组别, 并新增了至暗之夜相关的物品条组别.",
			"[额外物品条] 更新了默认的物品条设置, 同时支持地心之战和至暗之夜的物品显示.",
			"[进度] 移除了地心之战 S1, S2 的赛季成就数据, 加入了至暗之夜 S1 赛季成就数据.",
			"[进度] 移除了地心之战除欧米伽以外所有的旧 Raid 进度数据, 加入了至暗之夜 3 个新 Raid 数据.",
			"[快速焦点] 现在会正确使用设定中的鼠标按钮.",
		},
		["zhTW"] = {
			"[世界地圖] 迷霧移除功能現在支援至暗之夜地圖.",
			"[額外物品條] 移除了 SL 和 DF 相關的物品條組別, 並新增了至暗之夜相關的物品條組別.",
			"[額外物品條] 更新了預設的物品條設置, 同時支援地心之戰和至暗之夜的物品顯示.",
			"[進度] 移除了地心之戰 S1, S2 的賽季成就數據, 加入了至暗之夜 S1 賽季成就數據.",
			"[進度] 移除了地心之戰除歐米伽以外所有的舊 Raid 進度數據, 加入了至暗之夜 3 個新 Raid 數據.",
			"[快速焦點] 現在會正確使用設定中的滑鼠按鍵.",
		},
		["enUS"] = {
			"[World Map] The fog removal feature now supports the Midnight map.",
			"[Extra Item Bar] Removed SL and DF related categories, and added categories related to Midnight.",
			"[Extra Item Bar] Updated the default item bar settings to support items from The War Within and Midnight.",
			"[Progress] Removed season achievement data for The War Within S1 and S2, and added season achievement data for Midnight S1.",
			"[Progress] Removed all old raid progress data from The War Within except for Omega, and added data for 3 new raids from Midnight.",
			"[Quick Focus] Now correctly uses the mouse button set in the settings.",
		},
		["koKR"] = {
			"[세계 지도] 안개 제거 기능이 이제 미드나이트 지도를 지원합니다.",
			"[추가 아이템 바] SL 및 DF 관련 카테고리를 제거하고 미드나이트 관련 카테고리를 추가했습니다.",
			"[추가 아이템 바] 기본 아이템 바 설정을 업데이트하여 '내부의 전쟁' 및 '미드나이트'의 아이템을 지원합니다.",
			"[진행 상황] '내부의 전쟁' S1 및 S2의 시즌 업적 데이터를 제거하고 '미드나이트' S1의 시즌 업적 데이터를 추가했습니다.",
			"[진행 상황] '내부의 전쟁'에서 오메가를 제외한 모든 이전 공격대 진행 데이터를 제거하고 '미드나이트'의 3개의 새로운 공격대 데이터를 추가했습니다.",
			"[빠른 집중] 이제 설정에서 설정한 마우스 버튼을 올바르게 사용합니다.",
		},
		["ruRU"] = {
			"[Карта мира] Функция удаления тумана теперь поддерживает карту Полуночи.",
			"[Дополнительная панель предметов] Удалены категории, связанные с SL и DF, и добавлены категории, связанные с Полуночью.",
			"[Дополнительная панель предметов] Обновлены настройки панели предметов по умолчанию для поддержки предметов из Войны внутри и Полуночи.",
			"[Прогресс] Удалены данные о достижениях сезона для Войны внутри S1 и S2, добавлены данные о достижениях сезона для Полуночи S1.",
			"[Прогресс] Удалены все старые данные о прогрессе рейдов из Войны внутри, кроме Омеги, добавлены данные о 3 новых рейдах из Полуночи.",
			"[Быстрый фокус] Теперь правильно используется кнопка мыши, установленная в настройках.",
		},
	},
}
