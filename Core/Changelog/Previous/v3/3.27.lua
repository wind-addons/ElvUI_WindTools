local W = unpack((select(2, ...)))

W.Changelog[327] = {
	RELEASE_DATE = "2023/03/28",
	IMPORTANT = {
		["zhCN"] = {
			"西班牙语翻译大幅度更新. 感谢 Keralin",
			"更新库 LibItemInfo.",
			"更新库 LibObjectiveProgress.",
		},
		["zhTW"] = {
			"西班牙語翻譯大幅度更新. 感謝 Keralin",
			"更新庫 LibItemInfo.",
			"更新庫 LibObjectiveProgress.",
		},
		["enUS"] = {
			"Spanish translation has been updated. Thanks Keralin",
			"Update library LibItemInfo.",
			"Update library LibObjectiveProgress.",
		},
		["koKR"] = {
			"스페인어 번역이 업데이트되었습니다. Keralin님 감사합니다.",
			"라이브러리 LibItemInfo를 업데이트했습니다.",
			"라이브러리 LibObjectiveProgress를 업데이트했습니다.",
		},
		["ruRU"] = {
			"Обновлен перевод на испанский язык. Спасибо, Keralin",
			"Обновлена библиотека LibItemInfo.",
			"Обновлена библиотека LibObjectiveProgress.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[聊天文字] 新增战网好友魔兽世界角色状态提示.",
			"[聊天链接] 为货币链接添加对应图标显示.",
			"[鼠标提示] 为成就提示添加对应图标显示.",
		},
		["zhTW"] = {
			"[聊天文字] 新增戰網好友魔獸世界角色狀態提示.",
			"[聊天鏈接] 為貨幣鏈接添加對應圖示顯示.",
			"[浮動提示] 為成就提示添加對應圖示顯示.",
		},
		["enUS"] = {
			"[Chat Text] Add Battle.net friend WoW character status message.",
			"[Chat Link] Add the icon to currency link.",
			"[Tooltip] Add the icon to achievement tooltip.",
		},
		["koKR"] = {
			"[대화창 글자] 배틀넷 친구의 WoW 캐릭터 상태 메시지를 추가했습니다.",
			"[대화창 링크] 통화 링크에 아이콘을 추가했습니다.",
			"[툴팁] 업적 툴팁에 아이콘을 추가했습니다.",
		},
		["ruRU"] = {
			"[Текст чата] Добавлена подсказка о статусе персонажей друзей Battle.net в World of Warcraft.",
			"[Ссылки чата] Добавлен значок для ссылки на валюту.",
			"[Подсказки] Добавлен значок для подсказок по достижениям.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[预组列表] 修复右侧面板中词缀无法显示的问题.",
			"[预组列表] 由于暴雪的限制, 右侧面板自动刷新模式现更改为立刻刷新.",
			"[额外物品条] 更新可开启物品列表.",
			"[聊天文字] 公会成员状态信息现在跟随系统频道设定.",
			"[聊天文字] 合并后的成就信息现在跟随系统频道设定.",
			"[聊天文字] 现在可以关闭显示职业图标.",
			"[美化皮肤] 更新 Auctionator 皮肤.",
			"[好友列表] 优化暴雪游戏图标显示.",
		},
		["zhTW"] = {
			"[預組列表] 修復右側面板中詞綴無法顯示的問題.",
			"[預組列表] 由於暴雪的限制, 右側面板自動刷新模式現更改為立刻刷新.",
			"[額外物品條] 更新可開啟物品列表.",
			"[聊天文字] 公會成員狀態信息現在跟隨系統頻道設定.",
			"[聊天文字] 合併後的成就信息現在跟隨系統頻道設定.",
			"[聊天文字] 現在可以關閉顯示職業圖標.",
			"[美化皮膚] 更新 Auctionator 皮膚.",
			"[好友列表] 優化暴雪遊戲圖標顯示.",
		},
		["enUS"] = {
			"[LFG List] Fix affixes not showing in right panel.",
			"[LFG List] Due to Blizzard's limitation, right panel auto refresh mode is now changed to instant refresh.",
			"[Extra Item Bar] Updated openable item list.",
			"[Chat Text] Guild member status message now follows system channel setting.",
			"[Chat Text] Merged achievement message now follows system channel setting.",
			"[Chat Text] Now you can disable showing class icon.",
			"[Skins] Update Auctionator skin.",
			"[Friends List] Optimize Blizzard game icon display.",
		},
		["koKR"] = {
			"[파티 찾기 목록] 오른쪽 패널에 접두사가 표시되지 않는 문제를 수정했습니다.",
			"[파티 찾기 목록] 블리자드의 제한으로 인해, 오른쪽 패널 자동 새로고침 모드가 즉시 새로고침으로 변경되었습니다.",
			"[아이템 바] 열 수 있는 아이템 목록이 업데이트되었습니다.",
			"[대화창 글자] 길드원 상태 메시지가 이제 시스템 채널 설정에 따라 표시됩니다.",
			"[대화창 글자] 병합된 업적 메시지가 이제 시스템 채널 설정에 따라 표시됩니다.",
			"[대화창 글자] 이제 직업 아이콘을 표시하지 않도록 설정할 수 있습니다.",
			"[스킨] Auctionator 스킨이 업데이트되었습니다.",
			"[친구 목록] 블리자드 게임 아이콘 표시를 최적화했습니다.",
		},
		["ruRU"] = {
			"[Список LFG] Исправлена ошибка отображения аффиксов в правой панели.",
			"[Список LFG] Из-за ограничений Blizzard, режим автоматического обновления правой панели теперь изменен на мгновенное обновление.",
			"[Панель дополнительных предметов] Обновление списка открываемых предметов.",
			"[Текст чата] Сообщение о статусе члена гильдии теперь соответствует настройкам системного канала.",
			"[Текст чата] Сообщение о слиянии достижений теперь соответствует настройкам системного канала.",
			"[Текст чата] Теперь можно отключить отображение значка класса.",
			"[Скины] Обновлен скин Auctionator.",
			"[Список друзей] Оптимизировано отображение игровых значков Blizzard.",
		},
	},
}
