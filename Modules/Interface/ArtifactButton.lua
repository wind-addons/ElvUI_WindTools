-- 原作：ArtifactButton
-- 原作者：nerino1 (https://wow.curseforge.com/projects/artifactbutton)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 精简代码减少占用
-- 汉化

local E, L, V, P, G = unpack(ElvUI)
local ArtifactButton = E:NewModule('ArtifactButton', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["Artifact Button"] = {
    ["enabled"] = true
}

function openArtifactWeapon()
    SocketInventoryItem(16);
end

function QueryArtifact()
    local QUALITY = {}
    QUALITY.POOR = 0;
    QUALITY.COMMON = 1;
    QUALITY.UNCOMMON = 2;
    QUALITY.RARE = 3;
    QUALITY.EPIC = 4;
    QUALITY.LEGENDARY = 5;
    QUALITY.ARTIFACT = 6;
    QUALITY.HEIRLOOM = 7;
    local currentWeapon = GetInventoryItemID("player", GetInventorySlotInfo("MainHandSlot"));
    if currentWeapon == nil then
        print(L["No Weapon"]);
        return
    end
    name, link, quality, iLvl, reqLvl, class, subclass, maxStack, equipSlot, texture, vendorSellPrice = GetItemInfo(currentWeapon);
    if quality == QUALITY["ARTIFACT"] then
        openArtifactWeapon();
    else
        print(L["Currently equipped weapon is not an Artifact."]);
    end
end

function ArtifactButton:Initialize()
    if not E.db.WindTools["Artifact Button"]["enabled"] then return end
    if UnitLevel("player") <= 97 then return end

    local btn = CreateFrame("Button", "artifactbtn", PaperDollFrame, "OptionsButtonTemplate");

    if IsAddOnLoaded("Pawn") then
        btn:SetPoint("BOTTOMLEFT", 60, 10)
        btn:SetWidth(60)
    else
        btn:SetPoint("BOTTOMLEFT", 15, 10)
    end
    
    btn:SetText(L["Artifact"])
    btn:SetScript("OnClick", function() QueryArtifact() end)
end

E:RegisterModule(ArtifactButton:GetName())