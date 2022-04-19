local W = unpack(select(2, ...))

W.Changelog[232] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {
            "[移动框体] 提升了移动功能的稳定性."
        },
        ["zhTW"] = {
            "[移動框架] 提升了移動功能的穩定性."
        },
        ["enUS"] = {
            "[Move Frames] Improve the stability of the moving function."
        },
        ["koKR"] = {
            "[프레임 이동] 이동시 안전성을 향상 시켰습니다."
        }
    },
    NEW = {
        ["zhCN"] = {
            "[鼠标提示] 新增了盟约信息. 感谢 NDui_Plus",
            "[鼠标提示] 新增了史诗钥石地下城分数. 感谢 NDui_Plus",
            "[鼠标提示] 新增了套装数量. 感谢 NDui",
            "[移动框体] 新增了一些新框体.",
            "[其他] 新增了一些额外的按键绑定功能, 可以在暴雪的快捷键绑定中设置.",
            "[额外物品条] 新增了掮灵开悟者补给品. 感谢 mcc1",
            "[美化皮肤] 新增了暴雪点击绑定界面的美化皮肤.",
            "[美化皮肤] 新增了 ElvUI 快捷键绑定皮肤.",
            "[美化皮肤] 新增了 WeakAuras 设定中的模板界面皮肤.",
            "[美化皮肤] 新增了社区设定界面皮肤.",
            "[美化皮肤] 新增了 Ace3 下拉菜单皮肤."
        },
        ["zhTW"] = {
            "[浮動提示] 新增了誓盟信息. 感謝 NDui_Plus",
            "[浮動提示] 新增了傳奇鑰石地城分數. 感謝 NDui_Plus",
            "[浮動提示] 新增了套裝數量. 感謝 NDui",
            "[移動框架] 新增了一些新框架.",
            "[其他] 新增了一些額外的按鍵綁定功能, 可以在暴雪的按鍵綁定中設置.",
            "[額外物品條] 新增了受啟迪的仲介者物資. 感謝 mcc1",
            "[美化皮膚] 新增了暴雪點擊綁定介面的美化皮膚.",
            "[美化皮膚] 新增了 WeakAuras 設定中的模板介面皮膚.",
            "[美化皮膚] 新增了社群設定介面皮膚.",
            "[美化皮膚] 新增了 ElvUI 按鍵綁定界面皮膚.",
            "[美化皮膚] 新增了 Ace3 下拉選單皮膚."
        },
        ["enUS"] = {
            "[Tooltips] Add covenant inforamation. Thanks NDui_Plus",
            "[Tooltips] Add new mythic keystone dungeon score. Thanks NDui_Plus",
            "[Tooltips] Add the number of tier set equipments. Thanks NDui",
            "[Move Frames] Add support of more frames.",
            "[Misc] Add some extra key binding features, you can change configuration in Blizzard Key Binding.",
            "[Extra Item Bar] Added enlightened broker supplies. Thanks mcc1",
            "[Skins] Added new skin for Blizzard click binding frame.",
            "[Skins] Added new skin for ElvUI Key Binding.",
            "[Skins] Added new skin for WeakAuras Options templates.",
            "[Skins] Added new skin for community settings.",
            "[Skins] Added new skin for Ace3 dropdown menu."
        },
        ["koKR"] = {
            "[Tooltips] Add covenant inforamation. Thanks NDui_Plus",
            "[Tooltips] Add new mythic keystone dungeon score. Thanks NDui_Plus",
            "[Tooltips] Add the number of tier set equipments. Thanks NDui",
            "[프레임 이동] 새로운 프레임을 추가했습니다.",
            "[기타] Blizzard 단축키 설정에 추가로 몇가지 단축키 설정을 추가했습니다.",
            "[아이템 바] 깨달음을 얻은 중개자 보급품이 추가되였습니다. Thanks mcc1",
            "[스킨] Blizzard 클릭 바인딩 인터페이스 스킨을 추가했습니다.",
            "[스킨] ElvUI 키 바인팅 인터페이스 스킨을 추가했습니다",
            "[스킨] WeakAuras 옵션 템플릿 인터페이스 스킨을 추가했습니다.",
            "[스킨] 커뮤니티 설정 인터페이스 스킨을 추가했습니다",
            "[스킨] Ace3 드롭다운 메뉴 스킨을 추가했습니다."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "[鼠标提示] 大幅优化了性能.",
            "[鼠标提示] 移除了史诗地下城次数显示.",
            "[装备观察] 新增多种附魔显示, 优化图标显示逻辑.",
            "[任务列表] 修复了在停用取消标记功能时标记和完成图标重叠的问题.",
            "[好友列表] 现在可以显示不同账号地区的信息了.",
            "[美化皮膚] 优化了 ElvUI 动作条皮肤."
        },
        ["zhTW"] = {
            "[浮動提示] 大幅優化了性能.",
            "[浮動提示] 移除了傳奇地城次數顯示.",
            "[裝備觀察] 新增多種附魔顯示, 優化圖示顯示逻輯.",
            "[任務列表] 修復了在停用取消標記功能時標記和完成图示重疊的問題.",
            "[好友列表] 現在可以顯示不同賬號地區的資訊了.",
            "[美化皮膚] 優化了 ElvUI 快捷列皮膚."
        },
        ["enUS"] = {
            "[Tooltips] Optimized performance.",
            "[Tooltips] Removed mythic dungeon times.",
            "[Inspect] Added more enchants support, optimized icon display logic.",
            '[Quest List] Fixed the problem that the checked icon and dash overlap while the option "No Dash" is disabling.',
            "[Friend List] Now you can show different account region info.",
            "[Skins] Optimized ElvUI action bar skin."
        },
        ["koKR"] = {
            "[Tooltips] Optimized performance.",
            "[Tooltips] Removed mythic dungeon times.",
            "[살펴보기] 더 많은 마법부여 지원, 최적화된 아이콘 표시 로직을 추가했습니다.",
            "[퀘스트 목록] 표시 해제가 비활성화된 경우 표시 및 완료 아이콘이 겹치는 문제가 수정되었습니다.",
            "[친구 목록] 이제 다른 계정 지역에 대한 정보를 표시할 수 있습니다.",
            "[스킨] ElvUI 액션바 스킨을 최적화했습니다."
        }
    }
}
