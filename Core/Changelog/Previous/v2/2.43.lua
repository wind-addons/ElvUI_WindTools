local W = unpack((select(2, ...)))

W.Changelog[243] = {
	RELEASE_DATE = "2022/06/08",
	IMPORTANT = {
		["zhCN"] = {
			"登录信息, 兼容性检查的选项将会存储到全局设定中.",
			"除错模式的选项变更为日志等级选项.",
			"在 [美化外观] 的设定中新增了一个按钮用来打开资源下载页面.",
			"新增了对于 ElvUI 下拉窗体库支持的补丁. (自动载入, 不可设置)",
			"新增了修复预组建队伍界面中重复队伍显示的补丁. (自动载入, 不可设置)",
		},
		["zhTW"] = {
			"登入訊息, 相容性檢查的選項將會保存全局設定中.",
			"除錯模式的選項變更為日誌等級選項.",
			"在 [美化外觀] 的設定中新增了一個按鍵用來打開資源下載頁面.",
			"新增了對於 ElvUI 下拉窗体庫支持的补丁. (自動載入, 不可設定)",
			"新增了修復預組隊伍界面中重複隊伍顯示的补丁. (自動載入, 不可設定)",
		},
		["enUS"] = {
			"Login message, compatibility check option will be saved to ElvUI Global Database.",
			"Debug mode option will be changed to log level option.",
			"Added a button to open the additional resource download page in [Skins].",
			"Added a patch for ElvUI dropdown menu library support. (Load automatically and not configurable)",
			"Added a patch for fixing the duplicate team display in the LFG list. (Load automatically and not configurable)",
		},
		["koKR"] = {
			"로그인 메시지 및 호환성 확인 옵션은 ElvUI 전역 설정에 저장됩니다.",
			"디버그 모드 옵션이 로그 레벨 옵션으로 변경되었습니다.",
			"[스킨] 항목에 추가 리소스 다운로드 페이지를 여는 버튼을 추가했습니다.",
			"ElvUI 드롭다운 라이브러리 지원을 위한 패치가 추가되었습니다. (자동으로 로딩되며, 설정할 수 없음)",
			"파티찾기 목록에서 중복된 팀 표시를 수정하기 위한 패치를 추가했습니다. (자동으로 로딩되며, 설정할 수 없음)",
		},
	},
	NEW = {
		["zhCN"] = {
			"新增 [盟约助手] 模块. 支持提示更换魂契和自动更换盟约技能.",
			"[美化皮肤] 新增了 TLDR Missions 的皮肤.",
			"[天赋管家] 在天赋框体中新增了一个按钮用于打开盟约魂契界面.",
		},
		["zhTW"] = {
			"新增 [誓盟助手] 模組. 支持提示更換靈魂之約和自動更換誓盟技能.",
			"[美化皮膚] 新增了 TLDR Missions 的皮膚.",
			"[天賦管家] 在天賦框架中新增了一個按鍵用於打開誓盟靈魂之約界面.",
		},
		["enUS"] = {
			"Added [Covenant Helper] module. It will remind you to change your covenant and automatically change covenant skills.",
			"[Skins] New skin for TLDR Missions.",
			"[Talent Manager] Added a button in talent frame to open the covenant souldbind viewer.",
		},
		["koKR"] = {
			"[성약단 도우미] 모듈이 추가되었습니다. 성약을 변경하고 자동으로 성약 스킬을 변경하도록 상기시켜줍니다.",
			"[스킨] TLDR Missions 스킨이 추가되었습니다.",
			"[특성 관리자] 특성 프레임에 성약단 영혼 결속 창을 열 수 있는 버튼을 추가했습니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"兼容了网易集合石开心版的最新改动.",
			"[额外物品条] 使用厚重荒芜护甲片的时候将会自动选择装备.",
			"[美化皮肤] 移除了部分无用的设置.",
			"[聊天链接] 支持导灵器的链接图标.",
			"[副本难度] 修复随机难度的文本.",
			"[好友列表] 注释作为名字现在支持离线玩家.",
			"[移动框体] 修复了在启用别的移动框体插件时导致的报错.",
		},
		["zhTW"] = {
			"兼容了網易集合石開心版的最新改动.",
			"[額外物品條] 使用厚重荒寂護甲片的時候將會自動選擇裝備.",
			"[美化皮膚] 移除了部分無用的設定.",
			"[聊天鏈接] 支援靈印的鏈接圖示.",
			"[副本難度] 修復隨機難度的文本.",
			"[好友列表] 注記作為名字現在支持離線玩家.",
			"[移動框架] 修復了在啟用別的移動框架插件時導致的報錯.",
		},
		["enUS"] = {
			"Compatible with the latest changes of NetEase MeetingStone Happy Edit.",
			"[Extra Item Bar] The equipment will be selected automatically when you use Heavy Desolate Armor Kit.",
			"[Skins] Removed some useless options.",
			"[Chat Link] Support conduit link icon.",
			"[Dungeon Difficulty] Fix the text for LFG difficulty.",
			"[Friends List] Note as name now supports offline players.",
			"[Move Frames] Fix the error may caused by other move frame addons.",
		},
		["koKR"] = {
			"NetEase MeetingStone Happy Edit의 최신 변경 사항과 호환됩니다.",
			"[아이템 바] 질긴 황폐 방어구 강화도구 사용 시 자동으로 장비가 선택되어 사용됩니다.",
			"[스킨] 일부 쓸모없는 옵션을 제거했습니다.",
			"[채팅 링크] 도관 링크 시 아이콘 표시를 지원합니다.",
			"[던전 난이도] 파티찾기 난이도에 대한 텍스트를 수정합니다.",
			"[친구 목록] 이름 대신 메모가 오프라인 플레이어에도 지원됩니다.",
			"[프레임 이동] 다른 프레임 이동 애드온으로 인해 발생할 수 있는 오류를 수정합니다.",
		},
	},
}
