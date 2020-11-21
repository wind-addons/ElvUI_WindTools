local W = unpack(select(2, ...))

W.Changelog[212] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["koKR"] = {}
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
            "[Tags] Add [smart-power], e.g. rogue is current power (120), mage is percentage(100%).",
            "[Tags] Add [smart-power-nosign], e.g. rogue is current power (120), mage is percentage(100).",
            "[Misc] Add new feature that showing the move speed in character panel.",
            "New module [Maps]-[Instance Difficulty] supports reskin the difficulty indicator to text style. Thanks Merathilis."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "[矩形小地图] 修复了有时上方会有一条横线的问题.",
            "[额外物品条] 就算条中没有按钮, 现在也会进行尺寸更新了.",
            "[游戏条] 好友按钮回滚到上个版本.",
            "[美化皮肤] 添加遗漏的 ElvUI 聊天面板选项.",
            "[聊天链接] 修复了切换配置可能导致的错误.",
            "[好友列表] 修复了一个战网好友信息获取时可能发生的错误.",
            "[好友列表] 添加了一个阵营图标的开关, 默认显示魔兽的游戏图标."
        },
        ["zhTW"] = {
            "[矩形小地圖] 修復了有時上方會有一條橫線的問題.",
            "[額外物品條] 就算條中沒有按鍵, 現在也會進行尺寸更新了.",
            "[遊戲條] 好友按鍵回滾到上個版本.",
            "[美化皮膚] 添加遺漏的 ElvUI 對話框架設置.",
            "[聊天鏈接] 修復了切換配置可能導致的錯誤.",
            "[好友列表] 修復了一個戰網好友信息獲取時可能發生的錯誤.",
            "[好友列表] 新增了一個陣營圖示的開關, 預設顯示魔獸的遊戲圖示."
        },
        ["enUS"] = {
            "[Rectangle Minimap] Fix the bug that sometimes there is a line in the top of the minimap.",
            "[Extra Item Bar] Resize the bar even if there is no button on it.",
            "[Game Bar] Roll back the change of Friends button.",
            "[Skins] Add the missing option of ElvUI Chat Panels.",
            "[Chat Link] Fix the error occurred in switching profile.",
            "[Friend List] Fix the bug in fetching information of Battle.net friends",
            "[Friend List] Add an option for faction icons, and set WoW icons as default."
        },
        ["koKR"] = {
            "[Rectangle Minimap] Fix the bug that sometimes there is a line in the top of the minimap.",
            "[Extra Item Bar] Resize the bar even if there is no button on it.",
            "[게임 바] 친구 버튼이 이전 버전으로 롤백 되었습니다.",
            "[Skins] Add the missing option of ElvUI Chat Panels.",
            "[Chat Link] Fix the error occurred in switching profile.",
            "[Friend List] Fix the bug in fetching information of Battle.net friends",
            "[Friend List] Add an option for faction icons, and set WoW icons as default."
        }
    }
}
