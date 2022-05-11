local W = unpack(select(2, ...))

W.Changelog[235] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {
            "LibOpenRaid 升级到 33 版本.",
            "修复了未通过账号认证的玩家无法创建预组建队伍的问题."
        },
        ["zhTW"] = {
            "LibOpenRaid 升级到 33 版本.",
            "修復了未通過帳號認證的玩家無法創建預組隊伍的問題."
        },
        ["enUS"] = {
            "Update LibOpenRaid to version 33.",
            "Fixed a bug where unauthenticated players could not create a group."
        },
        ["koKR"] = {
            "Update LibOpenRaid to version 33.",
            "Fixed a bug where unauthenticated players could not create a group."
        }
    },
    NEW = {
        ["zhCN"] = {
            "[通告] (任务) 新增一个选项用于屏蔽暴雪自带的任务进度信息.",
            "[标签] 增加了一些新的不同小数位数缩写的生命值标签.",
            "[标签] 增加了 absorbs-long 用于显示完整护盾数值."
        },
        ["zhTW"] = {
            "[通告] (任務) 新增一個選項用於屏蔽暴雪自帶的任務進度訊息.",
            "[標籤] 增加了一些新的不同小數位數縮寫的生命值標籤.",
            "[標籤] 增加了 absorbs-long 用於顯示完整護盾數值."
        },
        ["enUS"] = {
            "[Announcement] (Quest) Added an option to disable Blizzard quest progress info.",
            "[Tags] Added some new different health tags with different decimal lengths.",
            "[Tags] Added absorbs-long to display full absorb value."
        },
        ["koKR"] = {
            "[Announcement] (Quest) Added an option to disable Blizzard quest progress info.",
            "[Tags] Added some new different health tags with different decimal lengths.",
            "[Tags] Added absorbs-long to display full absorb value."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "[标签] smart-power 和 smart-power-long 现在固定使用整数.",
            "[通告] (任务) 优化了任务进度信息的显示.",
            "[右键菜单] 修复了属性报告功能.",
            "[超级追踪] 由于可能产生的污染, 移除了纯数字的选项.",
            "[交接] 修复了有时任务无法正常接取完成的问题",
            "[美化皮肤] 优化了拍卖行皮肤.",
            "[美化皮肤] 优化了暴雪 UI 组件皮肤.",
            "[美化皮肤] 优化了弹出通知的皮肤.",
            "[美化皮肤] 修复了任务物品按钮的阴影.",
            "[美化皮肤] 修复了额外物品投掷框体的阴影.",
            "[移动框体] 新增一个选项用于提升与 Trade Skill Master 的兼容性.",
            "[吸收] 修复了战斗中重载界面可能导致的污染."
        },
        ["zhTW"] = {
            "[標籤] smart-power 和 smart-power-long 現在固定使用整數.",
            "[通告] (任務) 优化了任務進度訊息的顯示.",
            "[右鍵選單] 修復了屬性報告功能.",
            "[超級追蹤] 由於可能產生的汙染, 移除了僅數字的選項.",
            "[交接] 修復了有時任務無法正常接取完成的問題",
            "[美化皮膚] 優化了拍賣行皮膚.",
            "[美化皮膚] 優化了暴雪 UI 組件皮膚.",
            "[美化皮膚] 優化了彈出通知皮膚.",
            "[美化皮膚] 修復了任務物品按鍵的陰影.",
            "[美化皮膚] 修復了額外物品投擲框架的陰影.",
            "[移動框架] 新增一個選項用於提升與 Trade Skill Master 的相容性.",
            "[吸收] 修復了戰鬥中重載介面可能導致的汙染."
        },
        ["enUS"] = {
            "[Tags] The tag: smart-power and smart-power-long will use integer.",
            "[Announcement] (Quest) Optimized quest progress info display.",
            "[Context Menu] Fixed a bug in stats report.",
            "[Super Tracker] Bacause it may cause taint, the option of only number has been removed.",
            "[Turn In] Fixed a bug that sometimes the module can not accept or complete quests.",
            "[Skins] Optimized Auction House skin.",
            "[Skins] Optimized Blizzard UI Widgets skin.",
            "[Skins] Optimized alerts skin.",
            "[Skins] Fixed the shadow of quest item button.",
            "[Skins] Fixed the shadow of bonus roll frame.",
            "[Move Frames] New option to improve compatibility with Trade Skill Master.",
            "[Absorb] Fixed a bug that the module may cause taint if reload ui in combat."
        },
        ["koKR"] = {
            "[Tags] The tag: smart-power and smart-power-long will use integer.",
            "[Announcement] (Quest) Optimized quest progress info display.",
            "[Context Menu] Fixed a bug in stats report.",
            "[Super Tracker] Bacause it may cause taint, the option of only number has been removed.",
            "[Turn In] Fixed a bug that sometimes the module can not accept or complete quests.",
            "[Skins] Optimized Auction House skin.",
            "[Skins] Optimized Blizzard UI Widgets skin.",
            "[Skins] Optimized alerts skin.",
            "[Skins] Fixed the shadow of quest item button.",
            "[Skins] Fixed the shadow of bonus roll frame.",
            "[Move Frames] New option to improve compatibility with Trade Skill Master.",
            "[Absorb] Fixed a bug that the module may cause taint if reload ui in combat."
        }
    }
}
