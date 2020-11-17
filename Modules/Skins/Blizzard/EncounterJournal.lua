local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs
local select = select

function S:EncounterJournal_DisplayInstance()
    local bossIndex = 1
    local bossID = select(3, _G.EJ_GetEncounterInfoByIndex(bossIndex))

    while bossID do
        local bossButton = _G["EncounterJournalBossButton" .. bossIndex]
        if bossButton and not bossButton.windStyle then
            self:CreateShadow(bossButton)
            F.SetFontOutline(bossButton.text)
            bossButton.text:ClearAllPoints()
            bossButton.text:Point("LEFT", bossButton, "LEFT", 105, 0)
            bossButton.text:Point("RIGHT", bossButton, "RIGHT", 0, 0)
            bossButton.windStyle = true
        end
        bossIndex = bossIndex + 1
        bossID = select(3, _G.EJ_GetEncounterInfoByIndex(bossIndex))
    end
end

function S:Blizzard_EncounterJournal()
    if not self:CheckDB("encounterjournal", "encounterJournal") then
        return
    end

    self:CreateShadow(_G.EncounterJournal)

    -- Boss 按钮
    if E.private.skins.parchmentRemoverEnable then
        S:SecureHook("EncounterJournal_DisplayInstance")
    end

    -- 下方标签页
    local tabs = {
        _G.EncounterJournal.encounter.info.overviewTab,
        _G.EncounterJournal.encounter.info.lootTab,
        _G.EncounterJournal.encounter.info.bossTab,
        _G.EncounterJournal.encounter.info.modelTab
    }

    for _, tab in pairs(tabs) do
        self:CreateBackdropShadow(tab)
    end
end

S:AddCallbackForAddon("Blizzard_EncounterJournal")
