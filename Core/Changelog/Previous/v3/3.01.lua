local W = unpack((select(2, ...)))

W.Changelog[301] = {
	RELEASE_DATE = "2022/11/12",
	IMPORTANT = {
		["zhCN"] = {
			"此版本为紧急修复版本, 功能更新内容请查看 3.00 更新日志.",
			"适配 ElvUI 13.01.",
			"最低支持的 ElvUI 版本变更为 13.01.",
			"[配置文件] 跟随 ElvUI 13.01 版本的库文件改动, 旧的导出字符串将无法使用.",
			"[配置文件] 本次受影响的范围仅限字符串导入导出功能, 对当前存在配置是无影响的.",
			"[配置文件] 你可以通过降级 ElvUI 和 ElvUI_WindTools 来继续使用旧的导出字符串, 然后再升级到最新版本.",
		},
		["zhTW"] = {
			"此版本為緊急修復版本, 功能更新內容請查看 3.00 更新日誌.",
			"適配 ElvUI 13.01.",
			"最低支援的 ElvUI 版本變更為 13.01.",
			"[設定檔] 跟隨 ElvUI 13.01 版本的函式庫文件改動, 舊的導出字串將無法使用.",
			"[設定檔] 本次受影響的範圍僅限字符串導入導出功能, 對當前存在配置是無影響的.",
			"[設定檔] 你可以通過降級 ElvUI 和 ElvUI_WindTools 來繼續使用舊的導出字串, 然後再升級到最新版本.",
		},
		["enUS"] = {
			"This is a hotfix version, please check the 3.00 changelog for new features.",
			"ElvUI 13.01 compatibility.",
			"ElvUI 13.01 is the minimum supported version.",
			"[Profile] Follow the library file change of ElvUI 13.01, the string exported before 3.01 will not work.",
			"[Profile] The affected range is only the string import and export function, there is no impact on the current configuration.",
			"[Profile] You can downgrade ElvUI and ElvUI_WindTools to continue using the old export string, then upgrade to the latest version.",
		},
		["koKR"] = {
			"이것은 긴급 패치 버전입니다. 새로운 기능은 3.00 변경 로그를 확인하십시오.",
			"ElvUI 13.01 호환성.",
			"ElvUI 13.01은 최소 지원 버전입니다.",
			"[프로필] ElvUI 13.01의 라이브러리 파일 변경에 따라 이전 내보내기 문자열이 작동하지 않습니다.",
			"[프로필] 영향을받는 범위는 문자열 가져 오기 및 내보내기 기능 뿐입니다. 현재 구성에는 영향이 없습니다.",
			"[프로필] 이전 내보내기 문자열을 계속 사용하려면 ElvUI 및 ElvUI_WindTools를 다운그레이드 한 다음 최신 버전으로 업그레이드 할 수 있습니다.",
		},
	},
	NEW = {
		["zhCN"] = {},
		["zhTW"] = {},
		["enUS"] = {},
		["koKR"] = {},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[额外物品条] 加快了载入.",
			"[信息]-[重置] 现在移动到了 [高级]-[重置].",
			"[信息]-[配置文件] 现在移动到了 [高级]-[配置文件].",
			"[配置文件] 单独导入配置设定时不再清空私有设定.",
			"[配置文件] 单独导入私有设定时不再清空配置设定.",
		},
		["zhTW"] = {
			"[額外物品條] 加快了載入.",
			"[資訊]-[重置] 現在移動到了 [進階]-[重置].",
			"[資訊]-[設定檔] 現在移動到了 [進階]-[設定檔].",
			"[設定檔] 單獨導入設定設定時不再清空私有設定.",
			"[設定檔] 單獨導入私有設定時不再清空設定設定.",
		},
		["enUS"] = {
			"[Extra Item Bar] Speed up the loading.",
			"[Info]-[Reset] is now moved to [Advanced]-[Reset].",
			"[Info]-[Profile] is now moved to [Advanced]-[Profile].",
			"[Profile] Do not clear the private settings when importing the profile settings separately.",
			"[Profile] Do not clear the profile settings when importing the private settings separately.",
		},
		["koKR"] = {
			"[아이템 바] 로딩 속도를 높였습니다.",
			"[정보]-[재설정]이 [Advanced]-[재설정]으로 이동되었습니다.",
			"[정보]-[프로필]이 [Advanced]-[프로필]으로 이동되었습니다.",
			"[프로필] 프로필 설정을 개별적으로 가져올 때 개인 설정을 지우지 않습니다.",
			"[프로필] 개인 설정을 개별적으로 가져올 때 프로필 설정을 지우지 않습니다.",
		},
	},
}
