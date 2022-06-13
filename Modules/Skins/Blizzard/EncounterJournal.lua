local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local select = select
local tinsert = tinsert
local unpack = unpack

function S:EncounterJournal_DisplayInstance()
    local bossIndex = 1
    local bossID = select(3, _G.EJ_GetEncounterInfoByIndex(bossIndex))

    while bossID do
        local bossButton = _G["EncounterJournalBossButton" .. bossIndex]
        if bossButton and not bossButton.__windSkin then
            self:CreateShadow(
                bossButton,
                nil,
                E.db.general.valuecolor.r * 0.7,
                E.db.general.valuecolor.g * 0.7,
                E.db.general.valuecolor.b * 0.7
            )

            if bossIndex == 1 then -- move the buttons little bit right
                local history = {}
                for i = 1, bossButton:GetNumPoints() do
                    local point, relativeTo, relativePoint, x, y = bossButton:GetPoint(i)
                    tinsert(history, {point, relativeTo, relativePoint, x + 5, y})
                end
                bossButton:ClearAllPoints()
                for i = 1, #history do
                    bossButton:SetPoint(unpack(history[i]))
                end
            end

            F.SetFontOutline(bossButton.text)
            bossButton.text:ClearAllPoints()
            bossButton.text:Point("LEFT", bossButton, "LEFT", 105, 0)
            bossButton.text:Point("RIGHT", bossButton, "RIGHT", 0, 0)
            bossButton.__windSkin = true
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

    -- Boss Button
    if E.private.skins.parchmentRemoverEnable then
        S:SecureHook("EncounterJournal_DisplayInstance")
    end

    -- Bottom tabs
    local tabs = {
        _G.EncounterJournal.encounter.info.overviewTab,
        _G.EncounterJournal.encounter.info.lootTab,
        _G.EncounterJournal.encounter.info.bossTab,
        _G.EncounterJournal.encounter.info.modelTab
    }

    for _, tab in pairs(tabs) do
        self:CreateShadow(tab)
    end
end

S:AddCallbackForAddon("Blizzard_EncounterJournal")
