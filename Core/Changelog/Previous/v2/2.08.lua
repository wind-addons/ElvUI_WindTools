local W = unpack((select(2, ...)))

W.Changelog[208] = {
	RELEASE_DATE = "2020/11/08",
	IMPORTANT = {
		["zhCN"] = {
			"[移动框体] 默认关闭记忆功能, 如果出错可以尝试清除记录.",
		},
		["zhTW"] = {
			"[移動框架] 默認關閉記憶功能, 如果出錯可以嘗試清除記錄.",
		},
		["enUS"] = {
			"[Move Frames] Disable remember position by default, try to clear the history of moving if frames get messed.",
		},
		["koKR"] = {
			"[프레임 이동] 위치 기억 기능은 기본적으로 꺼져 있으며 문제가 발생하면 기록을 지워 해결할 수 있습니다.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化皮肤] 添加了网易集合石的美化.",
			"[美化皮肤] 添加了网易集合石加强版的美化.",
			"[其他] 添加新的模块 [预组列表], 用于美化预组队伍和集合石的定位图标.",
			"[游戏条] 添加了游戏菜单按钮.",
		},
		["zhTW"] = {
			"[美化皮膚] 新增了網易集合石的美化.",
			"[美化皮膚] 新增了網易集合石加強版的美化.",
			"[其他] 添加新的模組 [預組列表], 可美化預組隊伍和集合石的定位圖示.",
			"[遊戲條] 新增了遊戲選項按鍵.",
		},
		["enUS"] = {
			"[Skins] Add new skin for NetEase Meeting Stone.",
			"[Skins] Add new skin for NetEase Meeting Stone Plus.",
			"[Misc] Add new module [LFG List] for skinning Blizzard LFG / NetEase Meeting Stone role icons.",
			"[Game Bar] Add Game Menu button.",
		},
		["koKR"] = {
			"[스킨] NetEase Meeting Stone 애드온 스킨 추가.",
			"[스킨] NetEase Meeting Stone Plus 애드온 스킨 추가.",
			"[기타] 블리자드 파티 찾기 및 NetEase Meeting Stone 애드온의 스킨 설정을 위한 새로운 모듈 [파티 찾기 목록]이 추가되었습니다.",
			"[게임 바] 게임 메뉴 버튼이 추가되었습니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[队伍信息] 支持网易集合石.",
			"[美化皮肤] 优化 Ace3 皮肤.",
			"[美化皮肤] 优化 Immersion 皮肤.",
			"[美化皮肤] 优化职业大厅条皮肤.",
			"[美化皮肤] 优化玩家选择界面皮肤.",
			"[游戏条] LFG 按钮优先使用网易集合石.",
			"[游戏条] 修复一边按钮数为 0 时移动框大小错误的问题.",
			"[跳过过场动画] 修复了部分动画无法被处理的问题.",
			"[通告] 修复了有时副本内无法通告的问题.",
			"[通告] 使用任务的链接而不是任务标题纯文本.",
			"[小地图点击者] 防止同一提示多次触发.",
		},
		["zhTW"] = {
			"[隊伍信息] 支援網易集合石.",
			"[美化皮膚] 優化 Ace3 皮膚.",
			"[美化皮膚] 優化 Immersion 皮膚.",
			"[美化皮膚] 優化職業大廳皮膚.",
			"[美化皮膚] 優化玩家選擇皮膚.",
			"[遊戲條] LFG 按鍵優先使用網易集合石",
			"[遊戲條] 修復了一邊按鍵數為 0 時, 移動框大小錯誤的問題.",
			"[跳過過場動畫] 修復了部分動畫無法被處理的問題.",
			"[通告] 修復了有時副本內無法通告的問題.",
			"[通告] 使用任務的鏈接而不是任務標題的純文本.",
			"[小地圖點擊者] 防止同一提示多次觸發.",
		},
		["enUS"] = {
			"[Party Info] Add support of NetEase Meeting Stone.",
			"[Skins] Optimize Ace3 skins.",
			"[Skins] Optimize Immersion skin.",
			"[Skins] Optimize order hall bar skin.",
			"[Skins] Optimize player choice frame skin.",
			"[Game Bar] LFG Button support NetEase Meeting Stone.",
			"[Game Bar] Fix the mover size calculation if there is no button in one side.",
			"[Skip Cut Scene] Fix the bug that some cut scene cannot be handled.",
			"[Announcement] Fix the bug that it not worked when player in an instance group.",
			"[Announcement] Use quest link rather than the text of quest title.",
			"[Who Clicked] Prevent event fires multiple times.",
		},
		["koKR"] = {
			"[파티 정보] NetEase Meeting Stone 애드온 지원.",
			"[스킨] Ace3 스킨 최적화.",
			"[스킨] Immersion 스킨 최적화.",
			"[스킨] 직업 전당 바 스킨 최적화.",
			"[스킨] 플레이어 선택 인터페이스 스킨 최적화.",
			"[게임 바] 파티 찾기 버튼이 NetEase Meeting Stone 애드온을 지원합니다.",
			"[게임 바] 한쪽에 버튼이 없는 경우 움직이는 프레임의 크기가 잘못되는 문제 수정.",
			"[컷신 건너 뛰기] 일부 컷신이 처리되지 않는 버그 수정.",
			"[알림] 간혹 인스턴스에서 알림을 받을 수 없는 문제를 수정했습니다.",
			"[알림] 퀘스트 제목 대신 퀘스트 링크를 사용합니다.",
			"[미니맵을 클릭한 사람] 동일한 이벤트가 여러 번 표시되지 않도록 방지합니다.",
		},
	},
}
