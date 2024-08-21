local W = unpack((select(2, ...)))

W.Changelog[244] = {
	RELEASE_DATE = "2022/06/18",
	IMPORTANT = {
		["zhCN"] = {
			"LibOpenRaid 升级到 43 版本.",
			"[盟约助手] 自动切换灵魂羁绊的规则现在更改为专精绑定, 2.43 版本以前的配置将会被删除.",
		},
		["zhTW"] = {
			"LibOpenRaid 升級到 43 版本.",
			"[誓盟助手] 自動切換靈魂之絆的規則現在更改為專精綁定, 2.43 版本以前的配置將會被刪除.",
		},
		["enUS"] = {
			"Update LibOpenRaid to version 43.",
			"[Covenant Helper] soulbind auto-switch rule now support specialization, the previous configuration will be deleted once.",
		},
		["koKR"] = {
			"LibOpenRaid를 버전 43으로 업그레이드하였습니다.",
			"[성약단 도우미] 영혼 결속 자동 전환 규칙은 이제 전문화 결속으로 변경되며 2.43 버전 이전의 구성은 제거됩니다.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[美化外观] 新增了 LibUIDropDownMenu 的皮肤.",
			"[任务追踪] 新增了背景的选项.",
			"[任务追踪] 新增了顶部文字职业色的选项.",
			"[团队标记] 新增了无按钮背景的支持.",
			"[团队标记] 新增了鼠标进入和移出的动画.",
		},
		["zhTW"] = {
			"[美化外觀] 新增了 LibUIDropDownMenu 的皮膚.",
			"[任務追蹤] 新增了背景的選項.",
			"[任務追蹤] 新增了頂部文字職業色的選項.",
			"[團隊標記] 新增了無按鍵背景的支援.",
			"[團隊標記] 新增了滑鼠進入和移出的動畫.",
		},
		["enUS"] = {
			"[Skins] Add the LibUIDropDownMenu skin.",
			"[Objective Tracker] Add options for creating backdrop.",
			"[Objective Tracker] Add a class color option in header text setting.",
			"[Raid Markers] Add support for no button backdrop.",
			"[Raid Markers] Add mouse enter and mouse leave animation.",
		},
		["koKR"] = {
			"[스킨] LibUIDropDownMenu 스킨 추가.",
			"[퀘스트 추적기] 배경 옵션이 추가되었습니다.",
			"[퀘스트 추적기] 상단 텍스트에 직업 색상에 대한 옵션이 추가되었습니다.",
			"[공격대 징표] 버튼 배경 삭제 옵션이 추가되었습니다.",
			"[공격대 징표] 마우스 오버 애니메이션을 추가했습니다.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"重置模块支持最新的一些改动.",
			"更正了日志记录函数注入模块的时机.",
			"[美化外观] 修复了当按钮组件不可用时播放动画效果的问题.",
			"[美化外观] 优化了光环的阴影颜色逻辑.",
			"[美化外观] 优化了 Azeroth Auto Pilot 皮肤.",
			"[美化外观] 优化了 BugSack 皮肤.",
			"[美化外观] 优化了 WeakAuras 皮肤.",
			"[美化外观] 优化了 TLDRMissions 皮肤.",
			"[交易] 感谢按钮可以对跨服角色产生作用了.",
		},
		["zhTW"] = {
			"重置模組支持最新的一些改動.",
			"更正了日誌記錄函式注入模組的時機.",
			"[美化外觀] 修復了當按鍵組件不可用時播放動畫效果的問題.",
			"[美化外觀] 優化了光環的陰影顏色邏輯.",
			"[美化外觀] 優化了 Azeroth Auto Pilot 皮膚.",
			"[美化外觀] 優化了 BugSack 皮膚.",
			"[美化外觀] 優化了 WeakAuras 皮膚.",
			"[美化外觀] 優化了 TLDRMissions 皮膚.",
			"[交易] 感謝按鈕可以對跨服角色產生作用了.",
		},
		["enUS"] = {
			"Added the support of new modules resetting.",
			"Corrected the logger injection to the modules.",
			"[Skins] Fixed the bug that the animation plays even if the button is disabled.",
			"[Skins] Optimized the shadow color logic of auras.",
			"[Skins] Optimized the Azeroth Auto Pilot skin.",
			"[Skins] Optimized the BugSack skin.",
			"[Skins] Optimized the WeakAuras skin.",
			"[Skins] Optimized the TLDRMissions skin.",
			"[Trade] Thanks button now works with cross-server players.",
		},
		["koKR"] = {
			"신규 모듈에 대한 재설정 옵션이 추가되었습니다.",
			"모듈에 대한 logger injection을 수정했습니다.",
			"[스킨] 주요 구성 요소를 사용할 수 없을 때 재생되는 애니메이션 효과를 수정했습니다.",
			"[스킨] 오라의 그림자색 로직 최적화.",
			"[스킨] Azeroth Auto Pilot 스킨 최적화.",
			"[스킨] BugSack 스킨 최적화.",
			"[스킨] WeakAuras 스킨 최적화.",
			"[스킨] TLDRMissions 스킨 최적화.",
			"[거래 창] 이제 감사 버튼이 다른 서버 간 캐릭터에서도 작동합니다.",
		},
	},
}
