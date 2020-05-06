local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

function S:Blizzard_EncounterJournal()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.encounterjournal) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.encounterJournal) then return end

    local EncounterJournal = _G.EncounterJournal
    local EncounterInfo = EncounterJournal.encounter.info

    S:CreateShadow(EncounterJournal)

    -- Boss 按钮
    if E.private.skins.parchmentRemover.enable then
        hooksecurefunc("EncounterJournal_DisplayInstance", function()
            local bossIndex = 1;
            local _, _, bossID = _G.EJ_GetEncounterInfoByIndex(bossIndex);
            local bossButton;
            while bossID do
                bossButton = _G["EncounterJournalBossButton" .. bossIndex];
                if bossButton and not bossButton.windStyle then
                    S:CreateShadow(bossButton)
                    F.SetFontOutline(bossButton.text)
                    bossButton.text:ClearAllPoints()
                    bossButton.text:Point("LEFT", bossButton, "LEFT", 105, 0)
                    bossButton.text:Point("RIGHT", bossButton, "RIGHT", 0, 0)
                    bossButton.windStyle = true
                end
                bossIndex = bossIndex + 1;
                _, _, bossID = _G.EJ_GetEncounterInfoByIndex(bossIndex);
            end
        end)
    end

    -- 下方标签页
    local tabs = {
		EncounterInfo.overviewTab,
		EncounterInfo.lootTab,
		EncounterInfo.bossTab,
		EncounterInfo.modelTab
	}

	for _, tab in pairs(tabs) do
        S:CreateBackdropShadowAfterElvUISkins(tab)
    end
end

S:AddCallbackForAddon('Blizzard_EncounterJournal')
