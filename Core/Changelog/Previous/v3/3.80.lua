local W = unpack((select(2, ...)))

W.Changelog[380] = {
	RELEASE_DATE = "2024/09/23",
	IMPORTANT = {
		["zhCN"] = {
			"更新 LibOpenRaid 到最新版本。",
			"无论是否开启预组队列表功能，透过 OpenRaid 进行的数据联动将会始终进行。",
			"考虑到当前版本已经不再非常需要此功能，移除 [巅峰声望] 模块。你依旧可以下载原版 ParagonReputation 来使用。",
		},
		["zhTW"] = {
			"更新 LibOpenRaid 到最新版本。",
			"無論是否開啟預組隊列表功能，透過 OpenRaid 進行的數據聯動將會始終進行。",
			"考慮到當前版本已經不再非常需要此功能，移除 [巔峰聲望] 模組。你依舊可以下載原版 ParagonReputation 來使用。",
		},
		["enUS"] = {
			"Update LibOpenRaid to the latest version.",
			"Whether the LFG List module is enabled or not, the player data sync through OpenRaid will always be performed.",
			"Considering that the feature is no longer very necessary in the current patch, the [Paragon Reputation] module is removed. You can still download the original ParagonReputation to use.",
		},
		["koKR"] = {
			"LibOpenRaid를 최신 버전으로 업데이트했습니다.",
			"LFG 목록 모듈이 활성화되어 있든 아니든, OpenRaid를 통한 플레이어 데이터 동기화는 항상 수행됩니다.",
			"현재 패치에서 더 이상 매우 필요하지 않다고 생각되는 기능으로 인해 [무릉인 업적] 모듈이 제거되었습니다. 여전히 사용하려면 원본 ParagonReputation을 다운로드할 수 있습니다.",
		},
		["ruRU"] = {
			"Обновлена библиотека LibOpenRaid до последней версии.",
			"Синхронизация данных игрока через OpenRaid будет выполняться независимо от того, включен ли модуль списка LFG или нет.",
			"Учитывая, что функция больше не является очень необходимой в текущем патче, модуль [Парагон Репутации] удален. Вы по-прежнему можете загрузить оригинальный ParagonReputation для использования.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[鼠标提示] 新增了钥石信息功能，不过此功能需要对方也安装有 Wind 工具箱或是 Details!。",
		},
		["zhTW"] = {
			"[浮動提示] 新增了鑰石資訊功能，不過此功能需要對方也安裝有 Wind 工具箱或是 Details!。",
		},
		["enUS"] = {
			"[Tooltip] Add new keystone information, but this feature requires the target to have WindTools or Details! installed.",
		},
		["koKR"] = {
			"[툴팁] 새로운 쐐기돌 정보를 추가했지만, 이 기능은 대상이 WindTools 또는 Details!를 설치해야 합니다.",
		},
		["ruRU"] = {
			"[Подсказка] Добавлена новая информация о ключах, но эта функция требует, чтобы у цели были установлены WindTools или Details!",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[额外物品条] 新增节日物品 HOLIDAY 分组，默认加入条 1。",
			"[游戏条] 如果鼠标提示的锚点方向设定为上方，那么现在系统信息也会显示在上方。",
			"[预组队列表] 优化了预组队列表的布局，同时新增了鼠标提示，可以插件新版本中不同等级的词缀详情。",
			"[预组队列表] 更新每周奖励计算数据。",
			"[美化皮肤] 优化声望详细信息的美化皮肤。",
			"[美化皮肤] 优化部分场景中进度条对比度太低的问题。",
			"[美化皮肤] 新增对 主机觉醒 的进度的特殊美化。",
			"[美化皮肤] 提升 MDT 皮肤的稳定性。",
		},
		["zhTW"] = {
			"[額外物品條] 新增節慶物品 HOLIDAY 分組，預設加入條 1。",
			"[遊戲條] 如果浮動提示的錨點方向設定為上方，那麼現在系統訊息也會顯示在上方。",
			"[預組隊列表] 優化了預組隊列表的佈局，同時新增了浮動提示，可以插件新版本中不同等級的詞綴詳情。",
			"[預組隊列表] 更新每周獎勵計算數據。",
			"[美化皮膚] 優化聲望詳細信息的美化皮膚。",
			"[美化皮膚] 優化部分場景中進度條對比度太低的問題。",
			"[美化皮膚] 新增對 甦醒機械 的進度的特殊美化。",
			"[美化皮膚] 提升 MDT 皮膚的穩定性。",
		},
		["enUS"] = {
			"[Extra Item Bar] Add HOLIDAY group for holiday items, which is added to bar 1 by default.",
			"[Game Bar] If the anchor direction of the tooltip is set to the top, then the system message will also be displayed at the top.",
			"[LFG List] Optimize the layout of the LFG List, and added a tooltip that can display the details of affixes in each levels.",
			"[LFG List] Update the weekly reward calculation data.",
			"[Skin] Optimize the skin of reputation details.",
			"[Skin] Optimize the low contrast of progress bars in some scenes.",
			"[Skin] Add special skin for the progress of Awakening The Machine.",
			"[Skin] Improve the stability of MDT skin.",
		},
		["koKR"] = {
			"[추가 아이템 바] 기본적으로 바 1에 추가되는 휴일 아이템을 위한 HOLIDAY 그룹을 추가했습니다.",
			"[게임 바] 툴팁의 앵커 방향이 위로 설정된 경우 시스템 메시지도 위쪽에 표시됩니다.",
			"[LFG 목록] LFG 목록의 레이아웃을 최적화하고, 각 레벨의 접두사 세부 정보를 표시할 수 있는 툴팁을 추가했습니다.",
			"[LFG 목록] 매주 보상 계산 데이터를 업데이트했습니다.",
			"[스킨] 평판 세부 정보의 스킨을 최적화했습니다.",
			"[스킨] 일부 장면에서 진행 표시줄의 대비가 낮은 문제를 최적화했습니다.",
			"[스킨] 기계의 각성 진행에 대한 특별한 스킨을 추가했습니다.",
			"[스킨] MDT 스킨의 안정성을 향상했습니다.",
		},
		["ruRU"] = {
			"[Дополнительная панель предметов] Добавлена группа HOLIDAY для праздничных предметов, которая по умолчанию добавляется в панель 1.",
			"[Игровая панель] Если направление привязки подсказки установлено вверх, то системное сообщение также будет отображаться вверху.",
			"[Список LFG] Оптимизирован макет списка LFG и добавлена подсказка, которая может отображать подробности аффиксов в каждом уровне.",
			"[Список LFG] Обновлены данные расчета еженедельного вознаграждения.",
			"[Скин] Оптимизирован скин деталей репутации.",
			"[Скин] Оптимизирован низкий контраст полос прогресса в некоторых сценах.",
			"[Скин] Добавлен специальный скин для прогресса Пробуждение машины.",
			"[Скин] Улучшена стабильность скина MDT.",
		},
	},
}
