local W = unpack((select(2, ...)))

W.Changelog[227] = {
	RELEASE_DATE = "2021/11/08",
	IMPORTANT = {
		["zhCN"] = {
			"[移动框体] 暂时屏蔽了收藏品界面(坐骑, 玩具箱等)的移动功能. (等待暴雪修复)",
		},
		["zhTW"] = {
			"[移動框架] 暫時屏蔽了收藏品介面(坐騎, 玩具箱等)的移動功能. (等待暴雪修復)",
		},
		["enUS"] = {
			"[Move Frames] Remove moving feature of collections journal for 9.1.5. (Until Blizzard fix it)",
		},
		["koKR"] = {
			"[프레임 이동] 수집 인터페이스(탈것, 장난감 상자 등)의 이동 기능을 일시적으로 차단했습니다.(블리자드에서 수정할 때 까지)",
		},
	},
	NEW = {
		["zhCN"] = {
			"新增 [物品等级] 模块. 用于为飞出按钮和分解机添加额外的物品等级文字.",
		},
		["zhTW"] = {
			"新增 [物品等級] 模組. 用於為飛出按鍵和分解機添加額外的物品等級文字.",
		},
		["enUS"] = {
			"Add new [Item Level] module. It adds an extra item level text to flyout buttons and scrapping machine.",
		},
		["koKR"] = {
			"[아이템 레벨] 모듈이 추가되었습니다. 장비 관리창의 아이템 펼침 버튼 및 자동분해기계 사용시 아이템 레벨 텍스트를 추가하는 데 사용됩니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[小地图图标] 修复部分图标材质的错位问题.",
			"[矩形小地图] 修复小地图信息文字条的错位问题.",
			"[已知物品染色] 修复 9.1.5 公会银行改版带来的问题.",
			"[信息文字] 目标距离现使用 ElvUI 内置的距离检测库.",
			'[标签] 由于 ElvUI 已提供 "range" (距离), 移除相同名字的标签.',
			'[标签] "range:expectation" (预估距离) 现使用 ElvUI 内置的距离检测库.',
		},
		["zhTW"] = {
			"[小地圖圖示] 修復部分圖示材質的錯位問題.",
			"[矩形小地圖] 修復小地圖資訊文字條的錯位問題.",
			"[已知物品染色] 修復 9.1.5 公會銀行帶來的問題.",
			"[資訊文字] 目標距離現使用 ElvUI 內置的距離檢測函式庫.",
			'[标签] 由於 ElvUI 已提供 "range" (距離), 移除同名之標籤.',
			'[標籤] "range:expectation" (估算距離) 現使用 ElvUI 內置的距離檢測函式庫.',
		},
		["enUS"] = {
			"[Minimap Buttons] Fix texture misplacement of minimap icon.",
			"[Rectangle Minimap] Fix the position of the minimap datatext.",
			"[Already Known] Fix bugs of 9.1.5 new guild bank.",
			"[Datatext] Distance now use LibRangeCheck-ElvUI instead.",
			'[Tags] Remove "range" since ElvUI start to provide the same tag.',
			'[Tags] "range:expectation" now use LibRangeCheck-ElvUI instead.',
		},
		["koKR"] = {
			"[미니맵 버튼 통합 바] 미니맵 아이콘의 잘못된 텍스처 위치를 수정합니다.",
			"[미니맵 비율 조정] 미니맵 정보 문자의 위치를 수정합니다.",
			"[이미 알고 있는 항목] 9.1.5에서 발생한 길드 은행 관련 문제를 수정했습니다. ",
			"[정보 문자] 거리는 이제 ElvUI의 내장된 거리 감지 라이브러리를 사용합니다.",
			'[태그] ElvUI가 동일한 태그를 제공하므로 "range" 태그를 제거 하였습니다.',
			'[태그] "range:expectation"은 이제 ElvUI에 내장된 거리 감지 라이브러리를 사용합니다.',
		},
	},
}
