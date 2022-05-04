local W = unpack(select(2, ...))

W.Changelog[234] = {
    RELEASE_DATE = "TBD",
    IMPORTANT = {
        ["zhCN"] = {
            "插件设计风格焕新.",
            "新增意大利语支持",
            "[移动框体] 配置文件表位置更改, 更新后会自动拷贝旧配置并清理."
        },
        ["zhTW"] = {
            "插件設計風格更新.",
            "新增義大利語支援",
            "[移動框架] 配置文件表位置更改, 更新後會自動拷貝舊配置並清理."
        },
        ["enUS"] = {
            "Updated the overall designs.",
            "Added Italian language support",
            "[Move Frames] The location of settings are changed, the old settings will be copied and cleaned."
        },
        ["koKR"] = {
            "전반적인 디자인을 업데이트했습니다.",
            "이탈리아어 지원 추가",
            "[프레임 이동] 설정 위치가 변경되면 이전 구성이 자동으로 복사되어 정리됩니다."
        }
    },
    NEW = {
        ["zhCN"] = {
            "新增模块: [吸收], 可以自定义 ElvUI 吸收盾材质, 同时增加暴雪风格的吸收火花.",
            "[美化皮肤] 新增 TomCat's Tour 皮肤."
        },
        ["zhTW"] = {
            "新增模組: [吸收], 可以自定義 ElvUI 吸收盾材質, 同時增加暴雪風格的吸收火花.",
            "[美化皮膚] 新增 TomCat's Tour 美化."
        },
        ["enUS"] = {
            "New module [Absorb], you can customize the texture of ElvUI absorb shield, and add Blizzard style absorb spark.",
            "[Skin] Added a new skin for TomCat's Tour."
        },
        ["koKR"] = {
            "새로운 모듈 [보호막], ElvUI의 Absorb Shield 텍스처를 커스터마이징 할 수 있으며, Blizzard 스타일의 Absorb Sparks를 추가할 수 있습니다.",
            "[스킨] TomCat's Tour 스킨 추가."
        }
    },
    IMPROVEMENT = {
        ["zhCN"] = {
            "优化了部分设定项的显示",
            "优化了更新助手.",
            "配置重置模块更新.",
            "[交接] 大幅优化了模块代码.",
            "[交接] 支持自定义暂停修饰键.",
            "[交接] 支持仅开启接受任务或仅开启完成任务.",
            "[交接] 新增了自动选择最高奖励物品并完成任务的功能.",
            "[交接] 新增了智能聊天选项功能, 同时并入原有的盗贼职业大厅传送功能.",
            "[美化皮肤] 修复了跳过动画框体的阴影.",
            "[美化皮肤] 修复了举报玩家框体的阴影.",
            "[美化皮肤] 修复了灵魂医者框体的阴影.",
            "[美化皮肤] 修复了分离物品框体的阴影.",
            "[游戏条] 立即截图时会自动隐藏鼠标提示.",
            "[游戏条] 修复了 Ctrl + Shift + 点击时间区域无法开启 CPU 占用统计的问题.",
            "[额外物品条] 新增了圣墓宝物箱(英雄难度). 感谢 mcc1"
        },
        ["zhTW"] = {
            "優化了部分設置項的顯示.",
            "優化了更新助手.",
            "配置重置模塊更新.",
            "[交接] 大幅优化了模組代碼.",
            "[交接] 支援自訂暫停修飾鍵.",
            "[交接] 支援仅開啟接受任務或仅開啟完成任務.",
            "[交接] 新增了自動選擇最高獎勵物品並完成任務的功能.",
            "[交接] 新增了智能聊天選項功能, 同時也并入原有的盜賊職業大廳傳送功能.",
            "[美化皮膚] 修復了跳過動畫框架的陰影.",
            "[美化皮膚] 修復了舉報玩家框架的陰影.",
            "[美化皮膚] 修復了靈魂醫者框架的陰影.",
            "[美化皮膚] 修復了分離物品框架的陰影.",
            "[游戏條] 立即截圖時會自動隱藏滑鼠提示.",
            "[游戏條] 修復了 Ctrl + Shift + 點擊時間區域無法開啟 CPU 占用統計的問題.",
            "[額外物品條] 新增了聖塚寶藏箱(英雄難度). 感謝 mcc1"
        },
        ["enUS"] = {
            "Improved some options.",
            "Improved upgrade assistant.",
            "Update the module reset buttons with latest changes.",
            "[Turn In] Greatly optimized module code.",
            "[Turn In] Support customization of pause modifier key.",
            "[Turn In] Support only auto-accepting or only auto-completing.",
            "[Turn In] New feature: Get Best Reward, completing the quest with the most valuable reward.",
            "[Turn In] New feature: Smart Chat, also included the old option of Rogue Class Hall Insignia.",
            "[Skin] Fixed the shadow of the skip cutscene frame.",
            "[Skin] Fixed the shadow of the report player frame.",
            "[Skin] Fixed the shadow of the spirit healer frame.",
            "[Skin] Fixed the shadow of the separate item frame.",
            "[Game Bar] Automatically hide the tooltip when taking a screenshot.",
            "[Game Bar] Fixed the issue of Ctrl + Shift + click on the time area.",
            "[Extra Item Bar] Added cache of sepulcher treasures (Heroic). Thanks mcc1"
        },
        ["koKR"] = {
            "일부 설정 항목의 표시 최적화.",
            "업데이트 도우미 최적화.",
            "구성 재설정 모듈 업데이트.",
            "[자동 수락] 모듈 코드 최적화. ",
            "[자동 수락] 사용자 정의 일시 중지 키를 지원합니다.",
            "[자동 수락] 자동 수락 또는 자동 완료만 지원합니다.",
            "[자동 수락] 새로운 기능: 최고 보상 획득은 가장 높은 보상 아이템을 자동으로 선택하고 퀘스트를 완료합니다.",
            "[자동 수락] 새로운 기능: 스마트 채팅에는 도적 클래스의 직업 전당 이동시 자동 선택 옵션도 포함되어 있습니다.",
            "[스킨] 컷신 건너뛰기 프레임의 그림자 수정.",
            "[스킨] Report player 프레임의 그림자 수정.",
            "[스킨] Spirit healer 프레임의 그림자 수정.",
            "[스킨] Separate item 프레임의 그림자 수정.",
            "[게임 바] 스크린샷을 찍을 때 마우스 툴팁이 자동으로 숨겨집니다.",
            "[게임 바] Ctrl + Shift + 시계를 클릭하면 CPU 사용량 통계가 활성화되지 않는 문제가 수정되었습니다.",
            "[아이템 바] 올리아 보관함(영웅 난이도)이 추가되였습니다. Thanks mcc1"
        }
    }
}
