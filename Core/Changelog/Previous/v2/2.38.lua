local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[238] = {
	RELEASE_DATE = "2022/06/01",
	IMPORTANT = {
		["zhCN"] = {
			"支持 9.2.5 游戏版本.",
			"[物品等级] 重写了模块, 以支持所有的飞出物品按钮的等级显示.",
		},
		["zhTW"] = {
			"支援 9.2.5 遊戲版本.",
			"[物品等級] 重寫了模組, 以支援所有的飛出物品按鈕的等級顯示.",
		},
		["enUS"] = {
			"Support WoW build 9.2.5.",
			"[Item Level] Rewrote the module, to support all the flyout buttons' item level.",
		},
		["koKR"] = {
			"WoW 9.2.5 버전 지원",
			"[아이템 레벨] 모든 펼침 버튼에 대한 아이템 레벨 표시를 지원하도록 모듈이 재작성되었습니다.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化皮肤] 新增物品插入框体皮肤.",
			"[美化皮肤] 新增物品交互框体皮肤.",
			"[美化皮肤] 新增按钮组件选中背景效果.",
		},
		["zhTW"] = {
			"[美化皮膚] 新增物品插入框架皮膚.",
			"[美化皮膚] 新增物品互動框架皮膚.",
			"[美化皮膚] 新增按鈕組件選中背景效果.",
		},
		["enUS"] = {
			"[Skins] New item socketing frame skin.",
			"[Skins] New item interaction frame skin.",
			"[Skins] New button widget selected background effect.",
		},
		["koKR"] = {
			"[스킨] 아이템 소켓 프레임 스킨 추가.",
			"[스킨] 아이템 상호작용 프레임 스킨 추가.",
			"[스킨] 버튼 배경 효과 선택을 추가했습니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[表情] 修复了聊天气泡的表情显示.",
			"[矩形小地图] 修复了切换场景时可能产生的错位问题.",
			"[小地图按钮] 修复了 Zygor 小地图按钮的材质显示.",
			"[通告] 任务通告现在支持当前地图的世界任务.",
			"[进度追踪] 修复标记的显示错误.",
			"[进度追踪] 略微改动了默认装饰条设定.",
			"[美化皮肤] 修正组件延后载入的逻辑.",
			"[美化皮肤] 更新了对 ElvUI MerathilisUI 的兼容.",
			"[美化皮肤] 对于停用的按键, 将不再显示动画效果.",
		},
		["zhTW"] = {
			"[表情] 修復了聊天氣泡的表情顯示.",
			"[矩形小地圖] 修復了切換場景時可能產生的錯位問題.",
			"[小地圖按鈕] 修復了 Zygor 小地圖按鍵的材質顯示.",
			"[通告] 任務通告現在支持當前地圖的世界任務.",
			"[進度追蹤] 修復標記的顯示錯誤.",
			"[進度追蹤] 稍微改動了預設裝飾條設定.",
			"[美化皮膚] 修正組件延後載入的邏輯.",
			"[美化皮膚] 更新了對 ElvUI MerathilisUI 的兼容.",
			"[美化皮膚] 對於停用的按鍵, 將不再顯示動畫效果.",
		},
		["enUS"] = {
			"[Emote] Fixed the emote code parsing in chat bubbles.",
			"[Rectangle Minimap] Fixed the position error of the minimap after changing maps.",
			"[Minimap Button] Fix the Zygor minimap button texture.",
			"[Announcement] Now supports the world quests on the current map.",
			"[Objective Tracker] Fix the display error of the dashes.",
			"[Objective Tracker] Minor change the default cosmetic bar setting.",
			"[Skins] Fix the logic of widget skins lazy loading.",
			"[Skins] Improved ElvUI MerathilisUI compatibility.",
			"[Skins] No animation effect for disabled buttons.",
		},
		["koKR"] = {
			"[감정 표현(이모티콘)] 말풍선의 이모티콘 표시를 수정했습니다.",
			"[미니맵 비율 조정] 지도가 변경될 때 발생할 수 있는 오정렬 문제를 수정했습니다.",
			"[미니맵 버튼] Zygor 미니맵 버튼의 텍스처 표시를 수정했습니다.",
			"[알림] 퀘스트 알림은 이제 현재 지역에 대한 전역 퀘스트를 지원합니다.",
			"[퀘스트 추적기] 마커 표시 버그 수정.",
			"[퀘스트 추적기] 기본 장식띠 설정을 약간 변경했습니다.",
			"[스킨] 위젯 스킨 지연 로딩 로직을 수정합니다.",
			"[스킨] ElvUI MerathilisUI 호환성 개선.",
			"[스킨] 비활성화된 버튼에 대한 애니메이션이 더 이상 표시되지 않습니다.",
		},
	},
}
