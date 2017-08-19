-- 人物面板神器按鈕
-- 来源：ArtifactButton
-- 修改：houshuu

local f=CreateFrame("frame");
f:RegisterEvent("PLAYER_LOGIN");
loaded = IsAddOnLoaded("Pawn");

local AB_Locale   = {
		["Artifact"]    = "Artifact",
		["NoWeapon"]    = "You do not have any weapon equipped.",
		["NotArtifact"] = "Currently equipped weapon is not an Artifact.",
}
if GetLocale() == 'zhCN' then
	AB_Locale = {
		["Artifact"]    = "神器",
		["NoWeapon"]    = "你还没有装备武器",
		["NotArtifact"] = "当前武器不是神器",
	}
elseif GetLocale() == 'zhTW' then
	AB_Locale = {
		["Artifact"]    = "神兵",
		["NoWeapon"]    = "你還沒有裝備武器",
		["NotArtifact"] = "當前武器不是神兵武器",
	}
end

local function eventhandler(self,event)
	if event == "PLAYER_LOGIN" then
		if UnitLevel("player") <= 97 then
			artifactbtn:Hide()
			do return end
		end
	if IsAddOnLoaded("Pawn") then
		-- print("Pawn's on");
		btn:SetPoint("BOTTOMLEFT", 60, 10)
		btn:SetWidth(60)
	else
		btn:SetPoint("BOTTOMLEFT", 15, 10)
	end
		-- DEFAULT_CHAT_FRAME:AddMessage("Artifact Button Loaded.");
	end
end

f:SetScript("OnEvent",eventhandler);

btn = CreateFrame("Button", "artifactbtn", PaperDollFrame, "OptionsButtonTemplate");
btn:SetText(AB_Locale["Artifact"])
btn:SetScript("OnClick", function() QueryArtifact() end)


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
        print(AB_Locale["NoWeapon"]);
        return
    end
    name, link, quality, iLvl, reqLvl, class, subclass, maxStack, equipSlot, texture, vendorSellPrice = GetItemInfo(currentWeapon);
    if quality == QUALITY["ARTIFACT"] then
        openArtifactWeapon();
    else
        print(AB_Locale["NotArtifact"]);
    end
end