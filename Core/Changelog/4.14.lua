local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[414] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"更新了 LibRangeCheck-3.0 库, 能够更加准确地检测距离.",
			"调整了任务交接相关的选项名称和描述. 由于默认设定是不会自动交接账户未完成且非日常任务的, 你需要手动去设定中启用条件才能在全部任务上生效.",
		},
		["zhTW"] = {
			"更新了 LibRangeCheck-3.0 函式庫, 能夠更加準確地檢測距離.",
			"調整了任務交接相關的選項名稱和描述. 由於預設設置是不會自動交接帳號未完成且非日常任務的, 你需要手動在設置中啟用條件才能在全部任務上生效.",
		},
		["enUS"] = {
			"Updated the LibRangeCheck-3.0 library, which can now detect distances more accurately.",
			"Adjusted the names and descriptions of the quest turn-in related options. Since the default setting is not to automatically turn in quests that are account incomplete and non-daily, you will need to manually enable the conditions in the settings for it to take effect on all quests.",
		},
		["koKR"] = {
			"LibRangeCheck-3.0 라이브러리가 업데이트되어 거리를 보다 정확하게 감지할 수 있습니다.",
			"퀘스트 인계 관련 옵션의 이름과 설명이 조정되었습니다. 기본 설정은 계정 미완료 및 비일일 퀘스트를 자동으로 인계하지 않도록 되어 있으므로, 모든 퀘스트에 적용하려면 설정에서 조건을 수동으로 활성화해야 합니다.",
		},
		["ruRU"] = {
			"Обновлена библиотека LibRangeCheck-3.0, которая теперь может более точно определять расстояния.",
			"Изменены названия и описания параметров, связанных со сдачей заданий. Поскольку по умолчанию задания, не выполненные на учетной записи и не являющиеся ежедневными, не сдаются автоматически, Вам потребуется вручную включить соответствующие условия в настройках, чтобы они вступили в силу для всех заданий.",
		},
	},
	NEW = {
		["zhCN"] = {
			"新增了 [战斗] - [取消图腾] 模块, 支持绑定按键或者通过宏命令来取消图腾.",
			"[美化外观] 新增了 Angleur 皮肤.",
			"[事件追踪器] 新增了一些至暗之夜周常和事件的追踪.",
		},
		["zhTW"] = {
			"新增了 [戰鬥] - [取消圖騰] 模組, 支持綁定按鍵或者通過宏命令來取消圖騰.",
			"[美化外觀] 新增了 Angleur 皮膚.",
			"[事件追蹤器] 新增了一些至暗之夜周常和事件的追蹤.",
		},
		["enUS"] = {
			"Added a new module [Combat] - [Destroy Totem], which supports binding keys or using macro commands to cancel totems.",
			"[Skins] Added the Angleur skin.",
			"[Event Tracker] Added tracking for some Midnight weekly quests and events.",
		},
		["koKR"] = {
			"새로운 모듈 [전투] - [토템 파괴]가 추가되어 키 바인딩이나 매크로 명령을 사용하여 토템을 취소할 수 있습니다.",
			"[스킨] Angleur 스킨이 추가되었습니다.",
			"[이벤트 추적기] 일부 자정 주간 퀘스트 및 이벤트에 대한 추적이 추가되었습니다.",
		},
		["ruRU"] = {
			"Добавлен новый модуль [Бой] - [Уничтожить тотем], который поддерживает привязку клавиш или использование макрокоманд для отмены тотемов.",
			"[Скины] Добавлен скин Angleur.",
			"[Отслеживатель событий] Добавлено отслеживание некоторых еженедельных заданий и событий Полуночи.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化外观] 修复了与 World Quest Tab 新版本的兼容性.",
			"[美化外观] 屏蔽了 World Quest Tab 的防错鼠标提示中的说明文本显示.",
			"[小地图按钮] 优化了与 RestedXP Guides 插件的兼容性, 现在不会再出现一个空白区域了.",
			"[护盾] 优化了护盾材质的显示.",
			"[游戏条] 调整鼠标中键点击的默认设置为传送到奥术秘社.",
			"[额外物品条] 添加更多可开启物品.",
		},
		["zhTW"] = {
			"[美化外觀] 修復了與 World Quest Tab 新版本的相容性.",
			"[美化外觀] 屏蔽了 World Quest Tab 的防錯滑鼠提示中的說明文本顯示.",
			"[小地圖按鍵] 優化了與 RestedXP Guides 插件的相容性, 現在不會再出現一個空白區域了.",
			"[護盾] 優化了護盾材質的顯示.",
			"[遊戲條] 調整滑鼠中鍵點擊的預設設定為傳送到亞肯提納.",
			"[額外物品條] 添加更多可開啟物品.",
		},
		["enUS"] = {
			"[Skins] Fixed the compatibility with the latest version of World Quest Tab.",
			"[Skins] Suppressed the description text display in the anti-error tooltip of World Quest Tab.",
			"[Minimap Button] Improved compatibility with the RestedXP Guides addon, which should no longer cause a blank area to appear.",
			"[Shield] Improved the display of shield textures.",
			"[Game Bar] Adjusted the default setting for middle mouse button click to teleport to Arcantina.",
			"[Extra Item Bar] Added more openable items.",
		},
		["koKR"] = {
			"[스킨] 최신 버전의 World Quest Tab과의 호환성을 수정했습니다.",
			"[스킨] World Quest Tab의 방지 오류 툴팁에서 설명 텍스트 표시를 억제했습니다.",
			"[미니맵 버튼] RestedXP Guides 애드온과의 호환성이 향상되어 더 이상 빈 영역이 나타나지 않습니다.",
			"[방패] 방패 텍스처의 표시가 개선되었습니다.",
			"[게임 바] 마우스 가운데 버튼 클릭의 기본 설정을 아르칸티나로 텔레포트하도록 조정했습니다.",
			"[추가 아이템 바] 더 많은 열 수 있는 아이템을 추가했습니다.",
		},
		["ruRU"] = {
			"[Скины] Исправлена совместимость с последней версией World Quest Tab.",
			"[Скины] Подавлено отображение текста описания в подсказке от ошибок World Quest Tab.",
			"[Кнопка миникарты] Улучшена совместимость с аддоном RestedXP Guides, который больше не должен вызывать появление пустой области.",
			"[Щит] Улучшено отображение текстур щита.",
			"[Игровая панель] Настройка по умолчанию для нажатия средней кнопки мыши изменена на телепортацию в Аркантину.",
			"[Дополнительная панель предметов] Добавлено больше открываемых предметов.",
		},
	},
}
