local W = unpack(select(2, ...))

W.Changelog[204] = {
    RELEASE_DATE = "2020/10/26",
    IMPORTANT = {
        ["zhCN"] = {
            "添加了初步的韩语支持",
            "添加了与 ElvUI_MerathilisUI 一起使用时的兼容性检查助手.",
            "取消了 TinyInspect 的兼容性模式, 现在将会自带一个精简版."
        },
        ["zhTW"] = {
            "新增了初步的韓文支援.",
            "新增了與 ElvUI_MerathilisUI 一起使用時的兼容性檢查助手.",
            "取消了 TinyInspect 的兼容性模式, 現在將會自帶一個精簡版."
        },
        ["enUS"] = {
            "First time to add incomplete support for Korean.",
            "Add the compatibility check frame of ElvUI_MerathilisUI.",
            "Remove compatible mode of TinyInspect, the modified lite TinyInspect will be added."
        }
    },
    NEW = {
        ["zhCN"] = {
            "[额外物品条] 添加了渐隐时间, 最大最小透明度的功能和选项.",
            "[装备观察] 新物品模块, 移植自 TinyInspect 的观察面板. 感谢 loudsoul"
        },
        ["zhTW"] = {
            "[額外物品條] 新增了漸隱時間, 最大最小透明度的功能和設定.",
            "[裝備觀察] 新物品模組，移植自 TinyInspect 的觀察面板。感謝 loudsoul"
        },
        ["enUS"] = {
            "[Extra Item Bar] Add the support and options of fade time and alpha.",
            "[Inspect] New Module in item category. Ported from TinyInspect. Thanks loudsoul."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "优化部分设定的布局.",
            "优化工具箱自带配置(Fang2hou UI)的导入流程.",
            "[右键菜单] 优化与 RaiderIO 一起使用时的位置.",
            "[联系人] 优化公会成员信息获取方式. 感谢 fgprodigal",
            "[游戏条] 右键藏品按钮可以召唤随机偏好坐骑. 感谢 Merathilis",
            "[游戏条] 右键小伙伴手册按钮可以召唤随机偏好小伙伴. 感谢 Merathilis"
        },
        ["zhTW"] = {
            "優化部分設定項目的佈局.",
            "優化工具箱自帶配置(Fang2hou UI)的導入流程.",
            "[右鍵選單] 優化 RaiderIO 一起使用時的位置.",
            "[聯絡人] 優化公會成員信息獲取方式. 感謝 fgprodigal",
            "[遊戲條] 右鍵收藏按鈕可以召喚隨機偏好坐騎. 感謝 Merathilis",
            "[遊戲條] 右鍵寵物日誌按鈕可以召喚隨機偏好寵物. 感謝 Merathilis"
        },
        ["enUS"] = {
            "Optimize the layout of options.",
            "Optimize the process of importing the default profile(Fang2hou UI).",
            "[Context Menu] Better position with Raider.IO menu.",
            "[Contacts] Obtaining information from guild members now get more robust. Thanks fgprodigal",
            "[Game Bar] Right click the Collections Button to summon favorite mounts randomly. Thanks Merathilis",
            "[Game Bar] Right-click the Pet Journal Button to summon favorite pets randomly. Thanks Merathilis"
        }
    }
}
