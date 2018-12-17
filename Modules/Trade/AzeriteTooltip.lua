-- 原作：AzeriteTooltip
-- jokair9
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local AzeriteTooltip = E:NewModule('Wind_AzeriteTooltip')

local locationIDs = {
	["Head"] = 1, 
	["Shoulder"] = 3, 
	["Chest"] = 5,
}

local itemEquipLocToSlot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5
}

local rings = {
	[1] = true,
	[3] = true,
}

local point = 2

local addText = ""

function AzeriteTooltip:GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
  	if (powerInfo) then
    	local azeriteSpellID = powerInfo["spellID"]
    	return azeriteSpellID
  	end
end

function AzeriteTooltip:HasUnselectedPower(tooltip)
	local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
        if text and ( text:find(AzeriteUnlock) or text:find(NEW_AZERITE_POWER_AVAILABLE) ) then
        	return true
        end
    end
end

function AzeriteTooltip:ScanSelectedTraits(tooltip, powerName)
	local empowered = GetSpellInfo(263978)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		local newText
		local newPowerName
		if text and text:find("-") then
			newText = string.gsub(text, "-", " ")
		end
		if powerName:find("-") then
			newPowerName = string.gsub(powerName, "-", " ")
		end
        if text and text:find(powerName) then
        	return true
       	elseif (newText and newPowerName and newText:match(newPowerName)) then
       		return true
        elseif (powerName == empowered and not AzeriteTooltip:HasUnselectedPower(tooltip)) then
         	return true
        end
    end
end    

function AzeriteTooltip:GetAzeriteLevel()
	local level
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	if azeriteItemLocation then
		level = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	else
		level = 0
	end
	return level
 end      

function AzeriteTooltip:ClearBlizzardText(tooltip)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			if text then
				local ActiveAzeritePowers = strsplit("(%d/%d)", CURRENTLY_SELECTED_AZERITE_POWERS) -- Active Azerite Powers (%d/%d)
				local AzeritePowers = strsplit("(0/%d)", TOOLTIP_AZERITE_UNLOCK_LEVELS) -- Azerite Powers (0/%d)
				local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL) -- Unlocked at Heart of Azeroth Level %d
				local Durability = strsplit("%d / %d", DURABILITY_TEMPLATE)
				local ReqLevel = strsplit("%d", ITEM_MIN_LEVEL) 
				
				if text:match(NEW_AZERITE_POWER_AVAILABLE) then
					line:SetText("")
				end

				if text:find(AzeriteUnlock) then
					line:SetText("")
				end

				if text:find(Durability) or text:find(ReqLevel) then
					textLeft[i-1]:SetText("")
				end

				if text:find(ActiveAzeritePowers) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				elseif (text:find(AzeritePowers) and not text:find(">")) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				-- 8.1 FIX --
				elseif text:find(AZERITE_EMPOWERED_ITEM_FULLY_UPGRADED) then
					textLeft[i-1]:SetText("")
					line:SetText(addText)
					textLeft[i+1]:SetText("")
				end
			end
		end
	end
end

function AzeriteTooltip:RemovePowerText(tooltip, powerName)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local enchanted = strsplit("%d", ENCHANTED_TOOLTIP_LINE)
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			local newText
			local newPowerName
			if text and text:find("-") then
				newText = string.gsub(text, "-", " ")
			end
			if powerName:find("-") then
				newPowerName = string.gsub(powerName, "-", " ")
			end
			if text then				
				if text:match(CURRENTLY_SELECTED_AZERITE_POWERS_INSPECT) then return end
				if text:find("- "..powerName) then
					line:SetText("")
				elseif (newText and newPowerName and newText:match(newPowerName)) then
       				line:SetText("")
				end
				if ( r < 0.1 and g > 0.9 and b < 0.1 and not text:find(">") and not text:find(ITEM_SPELL_TRIGGER_ONEQUIP) and not text:find(enchanted) ) then
					line:SetText("")
				end
			end
		end
	end
end


local function BuildTooltip(self)
	local name, link = self:GetItem()
  	if not name then return end

  	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then

  		addText = ""
		
		local currentLevel = AzeriteTooltip:GetAzeriteLevel()

		local specID = GetSpecializationInfo(GetSpecialization())
		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(link)

		if not allTierInfo then return end

		local activePowers = {}
		local activeAzeriteTrait = false

		if AzeriteTooltip.db.Compact then
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				local azeriteTooltipText = " "
				for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

					if tierLevel <= currentLevel then
						if AzeriteTooltip:ScanSelectedTraits(self, azeritePowerName) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  >"..azeriteIcon.."<"

							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						elseif not AzeriteTooltip.db.OnlySpec then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then						
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					elseif not AzeriteTooltip.db.OnlySpec then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					end				
				end

				if tierLevel <= currentLevel then
					if j > 1 then 
						addText = addText.."\n \n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					end
				end
				
			end
		else
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				if tierLevel <= currentLevel then
					if j > 1 then 
						--addText = format("%s \n \n|c%s %s %s |r\n" , addText, "FFffcc00", "Level", tierLevel)
						addText = addText.."\n \n|cFFffcc00 Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFFffcc00 Level "..tierLevel.."|r\n"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7a Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFF7a7a7a Level "..tierLevel.."|r\n"
					end
				end

				for i, v in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)
						
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
					local azeriteIcon = '|T'..icon..':20:20:0:0:64:64:4:60:4:60|t'
					local azeriteTooltipText = "  "..azeriteIcon.."  "..azeritePowerName
  
					if tierLevel <= currentLevel then
						if AzeriteTooltip:ScanSelectedTraits(self, azeritePowerName) then
							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true	

							addText = addText.."\n|cFF00FF00"..azeriteTooltipText.."|r"			
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							addText = addText.."\n|cFFFFFFFF"..azeriteTooltipText.."|r"
						elseif not AzeriteTooltip.db.OnlySpec then
							addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					elseif not AzeriteTooltip.db.OnlySpec then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					end	
				end	
			end
		end

		if AzeriteTooltip.db.RemoveBlizzard then
			if activeAzeriteTrait then
				for k, v in pairs(activePowers) do
					AzeriteTooltip:RemovePowerText(self, v.name)
				end
			end
			AzeriteTooltip:ClearBlizzardText(self)
		else
			self:AddLine(addText)
			self:AddLine(" ")
		end
		wipe(activePowers)
	end
end

local function SetContainerAzerite(self)
	local name = self:GetName();
    for i = 1, self.size do
        local button = _G[name .. "Item" .. i];
        local link = GetContainerItemLink(self:GetID(), button:GetID())

	    if not button then
	        return
	    end;	    

		if link then
			local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(self:GetID(), button:GetID())

		    if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

		    	if not button.azerite then
		    		button.azerite = CreateFrame("Frame", "$parent.azerite", button)
		    		button.azerite:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT")
		    		button.azerite:SetSize(37, 18)
		    	else
		    		button.azerite:Show()
				end;

				button.azerite:SetAlpha(button:GetAlpha())

				local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
				local noneSelected = true

				local ringsNumber = 0

				for i=1, 5 do
					if allTierInfo[i] then 
						ringsNumber = ringsNumber+1
					end
				end

				for j, k in pairs(rings) do
					if not allTierInfo[j] then break end

					if (j == 3 and ringsNumber == 5) then
						j = 2
						point = 1
					else
						point = 2
					end

					local tierLevel = allTierInfo[j]["unlockLevel"]
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

					if not allTierInfo[1]["azeritePowerIDs"][1] then return end

					if button.azerite[j] then
						button.azerite[j]:Hide()
						button.azerite[j].overlay:Hide()
					end	

					for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
						local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
						local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
						local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

						if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
							noneSelected = false
							if not button.azerite[j] then
								if j == 1 then
		    						button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
		    						button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
		  							button.azerite[j]:SetSize(16, 16)
		  							button.azerite[j]:SetTexture(icon)
		  							-- Border
							        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
							        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
							        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
							        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
							        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
							        button.azerite[j].overlay:SetBlendMode("ADD")
		  						else
		  							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
		    						button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
		  							button.azerite[j]:SetSize(16, 16)
		  							button.azerite[j]:SetTexture(icon)
		  							-- Border
		  							button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
							        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
							        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
							        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
							        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
							        button.azerite[j].overlay:SetBlendMode("ADD")
		  						end
		  					else
		  						button.azerite[j]:Show()
								button.azerite[j].overlay:Show()
		  						button.azerite[j]:SetTexture(icon)
							end;
						end	
					end					
				end
				if noneSelected	then button.azerite:Hide() end -- Hide if no traits selected
			else
				if button.azerite then
					button.azerite:Hide()
				end
			end
		else
			if button.azerite then
				button.azerite:Hide()
			end
		end
		--if not AzeriteTooltip.db.Bags then button.azerite:Hide() end
	end
end

local function SetFlyoutAzerite(self)
	if self.azerite then
		self.azerite:Hide()
	end

	if ( not self.location ) then
		return;
	end

	if ( self.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION ) then
		return;
	end

    local _, _, _, _, slot, bag = EquipmentManager_UnpackLocation(self.location)
    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    local button = self

    if not bag then return end

    if not button then
        return
    end;

   	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

    	if not button.azerite then
		    button.azerite = CreateFrame("Frame", "$parent.azerite", button)
		    button.azerite:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT")
		    button.azerite:SetSize(37, 18)
		else
			button.azerite:Show()
		end;

		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
		local noneSelected = true

		local ringsNumber = 0

		for i=1, 5 do
			if allTierInfo[i] then 
				ringsNumber = ringsNumber+1
			end
		end

		for j, k in pairs(rings) do
			if not allTierInfo[j] then break end

			if (j == 3 and ringsNumber == 5) then
				j = 2
				point = 1
			else
				point = 2
			end

			local tierLevel = allTierInfo[j]["unlockLevel"]
			local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

			if not allTierInfo[1]["azeritePowerIDs"][1] then return end

			if button.azerite[j] then
				button.azerite[j]:Hide()
				button.azerite[j].overlay:Hide()
			end	

			for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
				local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
				local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

				if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
					noneSelected = false
					if not button.azerite[j] then
						if j == 1 then
    						button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
    						button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
  							button.azerite[j]:SetSize(16, 16)
  							button.azerite[j]:SetTexture(icon)
  							-- Border
					        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
  						else
  							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
    						button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
  							button.azerite[j]:SetSize(16, 16)
  							button.azerite[j]:SetTexture(icon)
  							-- Border
  							button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
  						end
  					else
		  				button.azerite[j]:Show()
						button.azerite[j].overlay:Show()
		  				button.azerite[j]:SetTexture(icon)
					end;
				end	
			end					
		end
		if noneSelected	then button.azerite:Hide() end
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end

local function SetPaperDollAzerite(self)
    local button = self
    local id = self:GetID();

    if (id == 1 or id == 3 or id == 5) and self.hasItem then

	    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromEquipmentSlot(id)

	    if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

		    if not button.azerite then
		        button.azerite = CreateFrame("Frame", "$parent.azerite", button);
		        button.azerite:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		        button.azerite:SetSize(37, 18)
		    else
				button.azerite:Show()
			end

			local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
			local noneSelected = true

			local ringsNumber = 0

			for i=1, 5 do
				if allTierInfo[i] then 
					ringsNumber = ringsNumber+1
				end
			end

			for j, k in pairs(rings) do
				if not allTierInfo[j] then break end

				if (j == 3 and ringsNumber == 5) then
					j = 2
					point = 1
				else
					point = 2
				end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				if button.azerite[j] then
					button.azerite[j]:Hide()
					button.azerite[j].overlay:Hide()
				end	

				for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

					if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
						noneSelected = false
						if not button.azerite[j] then
							if j == 1 then
								button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
								button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
								button.azerite[j]:SetSize(16, 16)
								button.azerite[j]:SetTexture(icon)
									-- Border
						        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
						        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
						        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
						        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
						        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
						        button.azerite[j].overlay:SetBlendMode("ADD")
							else
								button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
								button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
								button.azerite[j]:SetSize(16, 16)
								button.azerite[j]:SetTexture(icon)
									-- Border
								button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
						        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
						        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
						        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
						        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
						        button.azerite[j].overlay:SetBlendMode("ADD")
							end
						else
		  					button.azerite[j]:Show()
							button.azerite[j].overlay:Show()
		  					button.azerite[j]:SetTexture(icon)
						end;
					end	
				end					
			end
			if noneSelected	then button.azerite:Hide() end
		else
			if button.azerite then
				button.azerite:Hide()
			end
		end
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end

function AzeriteTooltip:Initialize()
    if not E.db.WindTools["Trade"]["Azerite Tooltip"]["enabled"] then return end
    self.db = E.db.WindTools["Trade"]["Azerite Tooltip"]
    GameTooltip:HookScript("OnTooltipSetItem", BuildTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", BuildTooltip)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", BuildTooltip)
	WorldMapTooltip.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', BuildTooltip)
	WorldMapCompareTooltip1:HookScript("OnTooltipSetItem", BuildTooltip)
	EmbeddedItemTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", BuildTooltip)

	if AzeriteTooltip.db.Bags then
		hooksecurefunc("ContainerFrame_Update", SetContainerAzerite)
	end

	if AzeriteTooltip.db.Flyout then
		hooksecurefunc("PaperDollItemSlotButton_Update", SetPaperDollAzerite)
		hooksecurefunc("EquipmentFlyout_DisplayButton", SetFlyoutAzerite)
	end
end

local function InitializeCallback()
	AzeriteTooltip:Initialize()
end
E:RegisterModule(AzeriteTooltip:GetName(), InitializeCallback)