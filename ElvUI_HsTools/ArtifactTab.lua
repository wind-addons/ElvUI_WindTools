-- 快速查看其他专精神器
-- 原作者：ArtifactTab
-- 修改：houshuu

--[[
	ArtifactTab is a simple World of Warcraft addon for displaying additional tabs in the talent tab.
    Copyright (C) 2016 Ignifazius

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
local ArtifactTabDebug = true;
--local lastFrame = PlayerTalentFrameTab3
local lastFrame = ArtifactFrameTab1
local btnList = {}
local arteList = {}
local isReload = false

function ArtifactTab_setLocaleFont()
	local locale = GetLocale();
	if locale == "ruRU" then
		return"Fonts\\FRIZQT___CYR.TTF"
	elseif locale == "koKR" then
		return "Fonts\\2002.TTF"
	elseif locale == "zhTW" then
		return "Fonts\\bLEI00D.TTF"
	elseif locale == "zhCN" then
		return "Fonts\\ARKai_C.ttf"
	else --enUS, enGB, deDE, etc
		return "Fonts\\FRIZQT__.TTF"
	end
end

local UIFont = ArtifactTab_setLocaleFont()

local speccList = {
	-- Fishing
	[133755] = {["name"] = 1, ["priority"] = 0},
	-- DK
	[128402] = {["name"] = 250,["priority"] = 1},
	[128403] = {["name"] = 252,["priority"] = 2},
	[128292] = {["name"] = 251,["priority"] = 3},
	-- Druid	
	[128858] = {["name"] = 102,["priority"] = 1},
	[128860] = {["name"] = 103,["priority"] = 2},
	[128821] = {["name"] = 104,["priority"] = 3},
	[128306] = {["name"] = 105,["priority"] = 4},
	-- Paladin
	[128823] = {["name"] = 65,["priority"] = 1},
	[128867] = {["name"] = 66,["priority"] = 2}, --off
	[128866] = {["name"] = 66,["priority"] = 2},
	[120978] = {["name"] = 70,["priority"] = 3},
	-- Rogue
	[128870] = {["name"] = 259,["priority"] = 1},
	[128872] = {["name"] = 260,["priority"] = 2},
	[134552] = {},
	[128476] = {["name"] = 261,["priority"] = 3},
	-- DH
	[127829] = {["name"] = 577,["priority"] = 1},
	[127830] = {["name"] = 577,["priority"] = 1}, --off
	[128832] = {["name"] = 581,["priority"] = 2},
	[128831] = {["name"] = 581,["priority"] = 2}, --off
	-- Warlock
	[128942] = {["name"] = 265,["priority"] = 1},
	[128943] = {["name"] = 266,["priority"] = 2},  --off
	[137246] = {["name"] = 266,["priority"] = 2},
	[128941] = {["name"] = 267,["priority"] = 3},
	-- Mage
	[127857] = {["name"] = 62,["priority"] = 1},
	[128820] = {["name"] = 63,["priority"] = 2},
	[128862] = {["name"] = 64,["priority"] = 3},
	-- Priest
	[128868] = {["name"] = 256,["priority"] = 1},
	[128825] = {["name"] = 257,["priority"] = 2},
	[128827] = {["name"] = 258,["priority"] = 3},
	-- Monk
	[128938] = {["name"] = 268,["priority"] = 1},
	[128937] = {["name"] = 270,["priority"] = 2},
	[128940] = {["name"] = 269,["priority"] = 3},
	-- Warrior
	[128910] = {["name"] = 71,["priority"] = 1},
	[128908] = {["name"] = 72,["priority"] = 2},
	[128288] = {["name"] = 73,["priority"] = 3},
	[128289] = {["name"] = 73,["priority"] = 3}, --off
	-- Shaman
	[128935] = {["name"] = 262,["priority"] = 1},
	[128819] = {["name"] = 263,["priority"] = 2},
	[128911] = {["name"] = 264,["priority"] = 3},
	[128934] = {["name"] = 264,["priority"] = 3}, --off
	-- Hunter
	[128861] = {["name"] = 253,["priority"] = 1},
	[128826] = {["name"] = 254,["priority"] = 2},
	[128808] = {["name"] = 255,["priority"] = 3}
}

local eventResponseFrame = CreateFrame("Frame", "Helper")
	eventResponseFrame:RegisterEvent("ADDON_LOADED");
	eventResponseFrame:RegisterEvent("BAG_UPDATE");
	eventResponseFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	eventResponseFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

local function eventHandler(self, event, arg1 , arg2, arg3, arg4, arg5)
    if (event == "ADDON_LOADED" and arg1 == "Blizzard_ArtifactUI") then
		ArtifactTab_clearLists()
		ArtifactTab_scanArtes()
		ArtifactTab_createSortedButtons()
		isReload = true;
    elseif (event == "ADDON_LOADED" and arg1 == "Blizzard_TalentUI") then
        ArtifactTab_createAddonButton()
	elseif (event == "BAG_UPDATE" or event == "PLAYER_EQUIPMENT_CHANGED") then
		ArtifactTab_checkIFUpdateIsNeeded()
		--print(event.." "..arg1)
	elseif (event =="PLAYER_ENTERING_WORLD" and isReload) then
		ArtifactTab_clearLists()
		ArtifactTab_scanArtes()
		ArtifactTab_createSortedButtons()
	end
end

eventResponseFrame:SetScript("OnEvent", eventHandler);

function createTempBtn() -- does not work well
    local b = CreateFrame("Button","TmpButton",PlayerTalentFrame, "CharacterFrameTabButtonTemplate")
    b:SetPoint("LEFT", "PlayerTalentFrameTab3" ,"RIGHT", 100, 3)
    b:SetFrameStrata("LOW")
    b:SetWidth(80)
    b:SetHeight(22)
    b:SetText("TMP")
    b:UnlockHighlight()
    b:Show();
end

function ArtifactTab_getFishingString()
	local _, _, _, fishing = GetProfessions();
	local profName = GetProfessionInfo(fishing)
	return profName
end

function ArtifactTab_clearLists()
	for i=1,#btnList do
		btnList[i]:Hide()
	end
	btnList = {}
	arteList = {}
end

function ArtifactTab_getLocalizedSPeccByID(specializationID)
	if specializationID == 1 then
		return ArtifactTab_getFishingString();
	else
		local _, name = GetSpecializationInfoByID(specializationID)
		return name;
	end
end

function ArtifactTab_createAddonButton()
    local slotId = GetInventorySlotInfo("MainHandSlot")
    local itemId = GetInventoryItemID("player", slotId)
    if itemId then -- somehow the ID is nil if the player logs in
        --local name, _, quality = GetItemInfo(itemId)
        local _, _, quality = GetItemInfo(itemId)
        if quality == 6 then
            local _, _, classIndex = UnitClass("player");
            local usedFrame
            if classIndex == 3 then -- hunter
                usedFrame = PlayerTalentFrameTab4
            else
                usedFrame = PlayerTalentFrameTab3
            end
            local buttonArte = ArtifactTab_createButton("TalentFrameButton", usedFrame, PlayerTalentFrame) --name
            buttonArte:SetPoint("LEFT", usedFrame ,"RIGHT", -12, 0)
            buttonArte:SetFrameStrata("LOW")
            local bFontString = buttonArte:CreateFontString()
            bFontString:SetFont(UIFont, 14, "OUTLINE")
            bFontString:SetText(ITEM_QUALITY6_DESC)
            --bFontString:SetAllPoints(buttonArte)
            bFontString:SetPoint("TOP",buttonArte,"TOP",0,3)
            bFontString:SetPoint("LEFT",buttonArte,"LEFT",0,0)
            bFontString:SetPoint("RIGHT",buttonArte,"RIGHT",0,0)
            bFontString:SetPoint("BOTTOM",buttonArte,"BOTTOM",0,3)
            buttonArte:SetFontString(bFontString)
            buttonArte:SetSize(bFontString:GetWidth()-2,33)
            buttonArte:GetFontString():SetTextColor(1,0.84,0, 1)
            buttonArte:SetScript("OnClick", function()
                SocketInventoryItem(slotId)
                ArtifactTab_setActiveButton(btnList[ArtifactTab_findActiveArte()])
            end)
            buttonArte:Show()
        end
    end
end

function ArtifactTab_scanArtes()
	lastFrame = ArtifactFrameTab2 -- is important... not sure why
	for container=0,5 do
		for slot=0,32 do
			local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(container, slot)
			local class = "none"
			if quality == 6 then 
				--local name, link, _, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemID)
				_, _, _, _, _, class = GetItemInfo(itemID)
				--print(name.." | "..class.." | "..equipSlot.." |")
			end
			if quality == 6 and class ~= "Consumable" and ArtifactTab_isValidArtifact(itemID) then -- Artifact research note / skins
				--name = GetItemInfo(itemID)
				table.insert(arteList, ArtifactTab_createArteContainer("bag", container, slot, itemID))
			end			
		end
	end
	local equippedID = ArtifactTab_getEquippedItemID()
	if equippedID ~= nil then -- somehow this info is not availabe directly after login... -.-
		table.insert(arteList, ArtifactTab_createArteContainer("equipped", nil, nil, equippedID))
	end
end

function ArtifactTab_findActiveArte()
    for i=1,#btnList do
        local r,g,b = btnList[i]:GetFontString():GetTextColor()
        if (b == 0) then
            return i
        end
    end
end

function ArtifactTab_countArtes()
	local count = 0
	for container=0,5 do
		for slot=0,32 do
			local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(container, slot)
			--if quality == 6 and itemID ~= 139390 then -- Artifact research note
			if quality == 6 and ArtifactTab_isValidArtifact(itemID) then -- Artifact research note
				count = count+1
			end			
		end
	end
	local eqID = ArtifactTab_getEquippedItemID()
	if eqID ~= nil then
		local _, _, quality = GetItemInfo(eqID)
		if quality == 6 then
			count = count+1
		end
	end
	return count
end

function ArtifactTab_checkIFUpdateIsNeeded()
	local updateRequired = false
	if #arteList ~= ArtifactTab_countArtes() then
		updateRequired = true
	else
		for container=0,5 do
			for slot=0,32 do
				local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(container, slot)
				if quality == 6 and ArtifactTab_isValidArtifact(itemID) then
					--name = GetItemInfo(itemID)
					--print(#arteList)
					for i=1, #arteList do 
						if arteList[i]["id"] == ArtifactTab_getMainhandArtifactID(itemID) then
							--print(arteList[i]["type"])
							if arteList[i]["type"] == "bag" then
							--print(arteList[i]["slot"].. " "..slot.." | "..arteList[i]["container"].." "..container)
								if arteList[i]["slot"] == slot and arteList[i]["container"] == container then						
									--print("(inv) no update needed")
								else
									--print("(inv) update needed")
									updateRequired = true
								end
							elseif arteList[i]["type"] == "equipped" then
								--print(arteList[i]["id"].." "..ArtifactTab_getEquippedItemID())
								if arteList[i]["id"] == ArtifactTab_getEquippedItemID() then
									--print("(eq) no update needed")
								else
									--print("(eq) update needed")
									updateRequired = true
								end
							end
						end
					end
				end
			end
		end
	end
	if updateRequired then
		--print("updating...")
		-- pretty sure there is a better solution than this lazy hotfix
		ArtifactTab_clearLists()
		ArtifactTab_scanArtes()
		ArtifactTab_createSortedButtons()
		-- end of "lazy hotfix"
	end
end

function ArtifactTab_getMainhandArtifactID(id)
	if id == 128289 then -- prot warrior
		return 128288
	elseif id == 128943 then --demo lock
		return 137246
	elseif id == 128866 then --prot pala
		return 128867
	else
		return id
	end
end

function ArtifactTab_isValidArtifact(id)
    for k in pairs(speccList) do
        if (k == id) then
            --print("id "..id.." IS valid")
            return true;
        end
    end
   --print("id "..id.." is NOT valid")
    return false;
end


function ArtifactTab_createArteContainer(typ, con, sl, id)
	local arte = {
		["type"] = typ,
		["slot"] = sl,
		["container"] = con,
		["id"] = id,
		["priority"] = speccList[id]["priority"], -- best way, using the same priority like the talent tree?
	}
	return arte
end

function ArtifactTab_setActiveButton(button)
	for i=1,#btnList do
		btnList[i]:SetSize(btnList[i]:GetFontString():GetWidth(),30)
		local textureN = btnList[i]:GetNormalTexture()
		textureN:SetTexture("Interface\\PaperDollInfoFrame\\UI-CHARACTER-INACTIVETAB")
		btnList[i]:SetNormalTexture(textureN)
		textureN:SetAllPoints(btnList[i])
		local highTexN = btnList[i]:GetHighlightTexture()
		highTexN:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight")
		btnList[i]:SetHighlightTexture(highTexN)
		highTexN:SetAllPoints(btnList[i])
		highTexN:SetPoint("TOP", button ,"TOP", 0, -10)		
	end
	button:SetSize(button:GetFontString():GetWidth(), 30)
	local texture = button:GetNormalTexture()
	texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-CHARACTER-ACTIVETAB")
	texture:SetPoint("TOP", button ,"TOP", 0, -15)
	texture:SetPoint("LEFT", button ,"LEFT", 0, 0)
	texture:SetPoint("RIGHT", button ,"RIGHT", 0, 0)
	texture:SetPoint("BOTTOM", button ,"BOTTOM", 0, -25)
	button:SetNormalTexture(texture)
	local highTexN = button:GetHighlightTexture()
	highTexN:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight")
	button:SetHighlightTexture(highTexN)
	highTexN:SetAllPoints(button)
	highTexN:SetPoint("BOTTOM", button ,"BOTTOM", 0, -5)
end

function ArtifactTab_createArteButton(name, container, slot)
	local buttonArte = ArtifactTab_createButton(name, lastFrame, ArtifactFrame)
	--local buttonArte = ArtifactTab_createButton(name, lastFrame, PlayerTalentFrame)
	buttonArte:SetScript("OnClick", function()
		SocketContainerItem(container, slot)
		ArtifactTab_setActiveButton(buttonArte)
	end)
	buttonArte:Show()
	buttonArte.previousFrame = lastFrame
	table.insert(btnList, buttonArte)
	lastFrame = buttonArte;
end


function ArtifactTab_createButton(name, frame, parentFrame)
	--local b = CreateFrame("Button",name,PlayerTalentFrame)
	local b = CreateFrame("Button","ArtifactTab_Button_" .. name,parentFrame)
	b:SetPoint("LEFT", frame ,"RIGHT", -5, 0)
	local bFontString = b:CreateFontString()
	bFontString:SetFont(UIFont, 14, "OUTLINE")
	bFontString:SetText(ArtifactTab_arteToSpecc(name))
	bFontString:SetAllPoints(b)
	b:SetFontString(bFontString)
	b:SetSize(bFontString:GetWidth()+30,30)--*1.4
	local texture = b:CreateTexture()
	texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-CHARACTER-INACTIVETAB")
	texture:SetAllPoints(b)
	b:SetNormalTexture(texture)
	local highTex = b:CreateTexture()
	highTex:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight")
	highTex:SetAllPoints(b)
	b:SetHighlightTexture(highTex)
	return b
end

function ArtifactTab_getEquippedItemID()
	local slotId = GetInventorySlotInfo("MainHandSlot")
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then -- somehow the ID is nil if the player logs in
		--local name, _, quality = GetItemInfo(itemId)
		local _, _, quality = GetItemInfo(itemId)
		if quality == 6 then
			return itemId
		end
	end
end

function ArtifactTab_createEquipedButton()
	local slotId = GetInventorySlotInfo("MainHandSlot")
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then -- somehow the ID is nil if the player logs in
		--local name, _, quality = GetItemInfo(itemId)
		local _, _, quality = GetItemInfo(itemId)
		if quality == 6 then
			local buttonArte = ArtifactTab_createButton(itemId, lastFrame, ArtifactFrame) --name
			buttonArte:GetFontString():SetTextColor(1,0.84,0, 1)
			buttonArte:SetScript("OnClick", function()
				SocketInventoryItem(slotId)
				ArtifactTab_setActiveButton(buttonArte)
			end)
			buttonArte:Show()
			table.insert(btnList, buttonArte)
			lastFrame = buttonArte;
		end
	end
end

function ArtifactTab_createSortedButtons()
	for i=0,4 do -- 0 for fishing 0-4 -> 5 priorities, nobody has more than 5 artifacts
		for j=1, #arteList do 
			if arteList[j] ~= nil and arteList[j]["priority"] == i then
				if arteList[j]["type"] == "bag" then
					ArtifactTab_createArteButton(arteList[j]["id"], arteList[j]["container"], arteList[j]["slot"])
				elseif arteList[j]["type"] == "equipped" then
					ArtifactTab_createEquipedButton()
				end
			end
		end
	end
end

function ArtifactTab_arteToSpecc(id)
    if (id == "TalentFrameButton") then
        return "Artifacts"
    end
	local retName = ArtifactTab_getLocalizedSPeccByID(speccList[id]["name"])
	if retName == nil then
		local name = GetItemInfo(id)
		return name 
	end
	return retName
end
