local W = unpack(select(2, ...))

W.Changelog[207] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {
            "[交接] 跳过过场动画 => [其他] 一般设定-跳过过场动画"
        },
        ["zhTW"] = {
            "[交接] 跳過過場動畫 => [其他] 一般設置-跳過過場動畫."
        },
        ["enUS"] = {
            "[Turn In] Skip Cut Scene => [Misc] General-Skip Cut Scene"
        },
        ["koKR"] = {
            "[자동 수락] 컷신 건너뛰기 설정이 => [기타] 일반 - 컷신 건너뛰기로 이동했습니다."
        }
    },
    NEW = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["koKR"] = {}
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "清理代码",
            "默认配置优化.",
            "兼容性检查工具更新.",
            "[好友列表] 修复了有时候无法获取名字时的报错.",
            "[其他] 跳过过场动画在跳过后会显示提示, 支持点击链接重播.",
            "[额外物品条] 可以选择继承 ElvUI 全局渐隐了.",
            "[任务列表] 修复了修改风格可能带来的污染.",
            "[切换按钮] 修复了有可能被暴雪追踪框体挡住的问题.",
            "[美化皮肤] 添加天赋界面的图标美化."
        },
        ["zhTW"] = {
            "清理代碼",
            "默認配置優化",
            "相容性確認工具更新.",
            "[好友名單] 修復了有時無法獲取名字時的報錯.",
            "[其他] 跳過過場動畫在跳過後會顯示提示, 支持點擊鏈接重播.",
            "[額外物品條] 可以選擇繼承 ElvUI 全局漸隱了.",
            "[任務列表] 修復了修改風格可能帶來的污染.",
            "[切換按鈕] 修復了有可能被暴雪追蹤框架擋住的問題.",
            "[美化皮膚] 新增了天賦介面的圖示美化."
        },
        ["enUS"] = {
            "Cleanup codes.",
            "Update default profile.",
            "Update compatibility check.",
            "[Friend List] Fix the bug occurred if the name cannot been obtained.",
            "[Misc] Skip Cut Scene will display a message after skipping, you can click the link inside the message to replay the cut scene.",
            "[Extra Item Bar] Now you can choose to inherit the ElvUI global fade.",
            "[Objective Tracker] Fix the taint by changing style.",
            "[Switch Buttons] Fix the bug that sometimes it might be hided by Blizzard Objective Tracker.",
            "[Skins] Apply new role icons in Talent UI."
        },
        ["koKR"] = {
            "코드 정리.",
            "기본 프로필 업데이트.",
            "호환성 검사 업데이트.",
            "[친구 목록] 가끔 이름을 얻을 수 없는 오류를 수정했습니다.",
            "[기타] 컷신을 건너뛰면 메시지가 표시되며 링크를 클릭하여 리플레이할 수 있습니다.",
            "[아이템 바] ElvUI의 페이드 설정을 상속 하도록 선택할 수 있습니다.",
            "[퀘스트 추적기] 스타일 수정으로 발생할 수 있는 오염 문제 수정",
            "[스위치 버튼] 블리자드 기본 퀘스트 추적기에 의해 차단될 수 있는 문제를 수정했습니다.",
            "[스킨] 특성 UI에 새로운 역할 아이콘을 적용합니다."
        }
    }
}
