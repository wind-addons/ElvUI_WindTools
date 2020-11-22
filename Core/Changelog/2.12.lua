local W = unpack(select(2, ...))

W.Changelog[212] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {
            "Tip: If you want to level up with Turn In, don't forget to uncheck the auto select reward!",
            "Fang2hou UI have been updated! You can find import button in [Information]-[Reset]"
        },
        ["zhTW"] = {
            "提醒: 如果你打算使用自动交接来升级, 别忘了取消勾选自动选择奖励!",
            "Fang2hou UI 更新了! 你可以在 [信息]-[重置] 界面中找到导入按钮."
        },
        ["enUS"] = {
            "提醒: 如果你打算使用自動交接來升級, 別忘記取消勾選自動選擇獎勵!",
            "Fang2hou UI 更新了! 你可以在 [信息]-[重置] 介面中找到導入按鍵."
        },
        ["koKR"] = {
            "팁: 레벨업 중 자동 수락을 사용할 생각이라면, 보상 자동 선택 옵션을 꺼두는 것을 잊지 마세요!",
            "Fang2hou UI가 업데이트되었습니다! 가져오기 버튼은 [정보]-[리셋]에서 찾을 수 있습니다."
        }
    },
    NEW = {
        ["zhCN"] = {
            "[标签] 添加了 [smart-power], 比如潜行者会自动变为完整能量(120), 法师会变为百分数(100%).",
            "[标签] 添加了 [smart-power-nosign], 比如潜行者会自动变为完整能量(120), 法师会变为百分数(100).",
            "[其他] 添加了在人物面板显示移动速度的功能.",
            "添加 [地图]-[副本难度] 模块, 支持美化副本难度为文字风格. 感谢 Merathilis."
        },
        ["zhTW"] = {
            "[標籤] 新增了 [smart-power], 盜賊等職業會自動變為完整格式(120), 法師會變為百分數(100%).",
            "[標籤] 新增了 [smart-power-nosign], 盜賊等職業會自動變為完整格式(120), 法師會變為百分數(100).",
            "[其他] 新增了在人物面板顯示移動速度的功能.",
            "新增 [地圖]-[副本難度] 模組, 支持美化副本難度為文字風格. 感謝 Merathilis."
        },
        ["enUS"] = {
            "[Tags] Add [smart-power], e.g. rogue is current power (120), mage is percentage(100%).",
            "[Tags] Add [smart-power-nosign], e.g. rogue is current power (120), mage is percentage(100).",
            "[Misc] Add new feature that showing the move speed in character panel.",
            "New module [Maps]-[Instance Difficulty] supports reskin the difficulty indicator to text style. Thanks Merathilis."
        },
        ["koKR"] = {
            "[태그] 신규 태그 [smart-power]가 자원 카테고리에 추가되었습니다. 적용 예 : 도적은 (120), 마법사는 (100%)",
            "[태그] 신규 태그 [smart-power-nosign]이 자원 카테고리에 추가되었습니다. 적용 예 : 도적은 (120), 마법사는 (100)",
            "[기타] 캐릭터 창에 이동 속도를 보여주는 새로운 기능을 추가합니다.",
            "신규 모듈 [지도]-[인스턴스 난이도]가 추가되었습니다. 미니맵의 인스턴스 난이도를 문자 형식으로 변경합니다. Thanks Merathilis."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "[天赋管家] 添加对 PvP 天赋的支持.",
            "[矩形小地图] 修复了有时上方会有一条横线的问题.",
            "[额外物品条] 就算条中没有按钮, 现在也会进行尺寸更新了.",
            "[额外物品条] 物品 ID 更新至暗影国度版本.",
            "[游戏条] 好友按钮回滚到上个版本.",
            "[美化皮肤] 添加遗漏的 ElvUI 聊天面板选项.",
            "[聊天链接] 修复了切换配置可能导致的错误.",
            "[好友列表] 修复了一个战网好友信息获取时可能发生的错误.",
            "[好友列表] 添加了一个阵营图标的开关, 默认显示魔兽的游戏图标."
        },
        ["zhTW"] = {
            "[天賦管家] 添加對 PvP 天賦的支持.",
            "[矩形小地圖] 修復了有時上方會有一條橫線的問題.",
            "[額外物品條] 就算條中沒有按鍵, 現在也會進行尺寸更新了.",
            "[額外物品條] 物品 ID 更新至暗影之境版本.",
            "[遊戲條] 好友按鍵回滾到上個版本.",
            "[美化皮膚] 添加遺漏的 ElvUI 對話框架設置.",
            "[聊天鏈接] 修復了切換配置可能導致的錯誤.",
            "[好友列表] 修復了一個戰網好友信息獲取時可能發生的錯誤.",
            "[好友列表] 新增了一個陣營圖示的開關, 預設顯示魔獸的遊戲圖示."
        },
        ["enUS"] = {
            "[Talent Manager] Add support for PvP talents.",
            "[Rectangle Minimap] Fix the bug that sometimes there is a line in the top of the minimap.",
            "[Extra Item Bar] Resize the bar even if there is no button on it.",
            "[Extra Item Bar] Update item ID to Shadowlands patch.",
            "[Game Bar] Roll back the change of Friends button.",
            "[Skins] Add the missing option of ElvUI Chat Panels.",
            "[Chat Link] Fix the error occurred in switching profile.",
            "[Friend List] Fix the bug in fetching information of Battle.net friends",
            "[Friend List] Add an option for faction icons, and set WoW icons as default."
        },
        ["koKR"] = {
            "[특성 관리자] vP 특성에 대한 지원이 추가되었습니다.",
            "[미니맵 비율 조정] 가끔씩 미니맵 상단에 선이 나타나는 버그를 수정합니다.",
            "[아이템 바] 아이템 바에 버튼이 없어도 바의 크기를 조정할 수 있습니다.",
            "[아이템 바] 어둠땅 패치로 인해 아이템 ID를 업데이트했습니다.",
            "[게임 바] 친구 버튼이 이전 버전으로 롤백 되었습니다.",
            "[스킨] 누락된 ElvUI 채팅 패널 옵션을 추가했습니다.",
            "[채팅 링크] 프로필 변경으로 인해 발생할 수 있는 오류를 수정했습니다.",
            "[친구 목록] Battle.net 친구 정보 획득 시 발생할 수 있는 오류를 수정했습니다.",
            "[친구 목록] 진영 아이콘 옵션을 추가하고 WoW 아이콘을 기본값으로 설정합니다."
        }
    }
}
