local W = unpack((select(2, ...)))

W.Changelog[377] = {
	RELEASE_DATE = "Alpha",
	IMPORTANT = {
		["zhCN"] = {
			"[鼠标提示] 目标进度功能将使用 MDT API 的小怪进度数据，同时改良了显示样式。",
		},
		["zhTW"] = {
			"[浮動提示] 目標進度功能將使用 MDT API 的小怪進度數據，同時改良了顯示樣式。",
		},
		["enUS"] = {
			"[Tooltip] Objective progress feature will use MDT API for fetching enemy force in Mythic+, and the display style has been improved.",
		},
		["koKR"] = {
			"[툴팁] 목표 진행률 기능이 MDT API를 사용하여 미틱+의 적 힘을 가져오며, 표시 스타일이 개선되었습니다.",
		},
		["ruRU"] = {
			"[Подсказка] Функция прогресса цели будет использовать MDT API для получения вражеской силы в Мифик+, и стиль отображения был улучшен.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[任务列表] 新增了信息颜色的修改功能。",
			"[游戏条] 使用鼠标中键点击中间的时间面板现在可以快速重载界面。",
			"[额外物品条] 新增 FISHING, FISHINGTWW 钓鱼物品分组。感谢 LvWind",
		},
		["zhTW"] = {
			"[任務列表] 新增了信息顏色的修改功能。",
			"[遊戲條] 使用滑鼠中鍵點擊中間的時間面板現在可以快速重載介面。",
			"[額外物品條] 新增 FISHING, FISHINGTWW 釣魚物品分組。感謝 LvWind",
		},
		["enUS"] = {
			"[Objective Tracker] Added the ability to change the color of the information.",
			"[Game Bar] Now you can quickly reload the interface by clicking the middle time panel with the middle mouse button.",
			"[Extra Item Bar] Added FISHING, FISHINGTWW fishing item groups. Thanks LvWind",
		},
		["koKR"] = {
			"[퀘스트 목록] 정보 색상 변경 기능 추가.",
			"[게임 바] 마우스 중간 버튼으로 중간 시간 패널을 클릭하면 인터페이스를 빠르게 다시로드 할 수 있습니다.",
			"[추가 아이템 바] FISHING, FISHINGTWW 낚시 아이템 그룹 추가. 감사합니다 LvWind",
		},
		["ruRU"] = {
			"[Список заданий] Добавлена возможность менять цвет информации.",
			"[Игровая панель] Теперь вы можете быстро перезагрузить интерфейс, щелкнув средней кнопкой мыши по средней панели времени.",
			"[Дополнительная панель предметов] Добавлены группы предметов для рыбалки FISHING, FISHINGTWW. Спасибо LvWind",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[额外物品条] 更新了地下堡物品分组。感谢 mcc1",
			"[观察] 同步最新的 TinyInspect 改动。",
			"[游戏条] 新增一些炉石支持。感谢 LvWind",
			"[游戏条] 鼠标移动到中间面板时现在会出现功能提示。",
			"[职业助手] 灵界打击预测现在可以用在全部专精中。感谢 AngelosNaoumis",
			"[美化外观] 优化了场景战役中的标题背景大小。",
			"[美化外观] 美化了通知上方的奖励图标。",
		},
		["zhTW"] = {
			"[額外物品條] 更新了地下城物品分組。感謝 mcc1",
			"[觀察] 同步最新的 TinyInspect 改動。",
			"[遊戲條] 新增一些爐石支援。感謝 LvWind",
			"[遊戲條] 滑鼠移動到中間面板時現在會出現功能提示。",
			"[職業助手] 死亡打擊預測現在可以用在 DK 全部專精中。感謝 AngelosNaoumis",
			"[美化外觀] 優化了場景戰役中的標題背景大小。",
			"[美化外觀] 美化了通知上方的獎勵圖標。",
		},
		["enUS"] = {
			"[Extra Item Bar] Updated the dungeon item groups. Thanks mcc1",
			"[Inspect] Synchronize the latest code from TinyInspect.",
			"[Game Bar] Added some Hearthstone support. Thanks LvWind",
			"[Game Bar] Now a tooltip will appear when you hover on the middle panel.",
			"[Class Helper] Death Strike prediction can now be used in all DK specializations. Thanks AngelosNaoumis",
			"[Skins] Optimize the size of the title background in the Scenario.",
			"[Skins] Add skin for the reward icon on the top of alerts.",
		},
		["koKR"] = {
			"[추가 아이템 바] 던전 아이템 그룹을 업데이트했습니다. 감사합니다 mcc1",
			"[인스펙션] TinyInspect의 최신 코드를 동기화했습니다.",
			"[게임 바] 일부 하스스톤 지원을 추가했습니다. 감사합니다 LvWind",
			"[게임 바] 중간 패널에 마우스를 올리면 툴팁이 나타납니다.",
			"[직업 도우미] 죽음의 일격 예측이 이제 모든 DK 전문화에서 사용할 수 있습니다. 감사합니다 AngelosNaoumis",
			"[스킨] 시나리오의 제목 배경 크기를 최적화했습니다.",
			"[스킨] 알림 상단의 보상 아이콘에 스킨 추가.",
		},
		["ruRU"] = {
			"[Дополнительная панель предметов] Обновлены группы предметов подземелий. Спасибо mcc1",
			"[Осмотр] Синхронизированы последние изменения из TinyInspect.",
			"[Игровая панель] Добавлена поддержка некоторых карт Хартстоуна. Спасибо LvWind",
			"[Игровая панель] Теперь при наведении на среднюю панель появится подсказка.",
			"[Классовый помощник] Прогнозирование 'Удара смерти' теперь можно использовать во всех специализациях Рыцаря смерти. Спасибо AngelosNaoumis",
			"[Скины] Оптимизирован размер фона заголовка в сценарии.",
			"[Скины] Добавлен скин для иконки награды в верхней части уведомлений.",
		},
	},
}
