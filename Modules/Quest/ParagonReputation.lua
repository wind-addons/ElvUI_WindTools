-- 原作：Fail@US-Ragnaros
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 性能优化
local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local S = E:GetModule('Skins')
local PR = E:NewModule('Wind_ParagonReputation', 'AceHook-3.0', 'AceEvent-3.0');

local _G = _G
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetFactionInfo = GetFactionInfo
local GetFactionInfoByID = GetFactionInfoByID
local GetQuestLogIndexByID = GetQuestLogIndexByID
local GetItemInfo = GetItemInfo
local GetQuestLogCompletionText = GetQuestLogCompletionText
local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor
local GameTooltip_AddQuestRewardsToTooltip = GameTooltip_AddQuestRewardsToTooltip
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Timer_After = C_Timer.After
local UIFrameFadeIn = UIFrameFadeIn

local ACTIVE_TOAST = false
local WAITING_TOAST = {}

local PARAGON_QUEST_ID = { --[questID] = {factionID,rewardID}
	--Legion
		[48976] = {2170,152922}, -- Argussian Reach
		[46777] = {2045,152108}, -- Armies of Legionfall
		[48977] = {2165,152923}, -- Army of the Light
		[46745] = {1900,152102}, -- Court of Farondis
		[46747] = {1883,152103}, -- Dreamweavers
		[46743] = {1828,152104}, -- Highmountain Tribes
		[46748] = {1859,152105}, -- The Nightfallen
		[46749] = {1894,152107}, -- The Wardens
		[46746] = {1948,152106}, -- Valarjar
	
	--Battle for Azeroth
		--Neutral
		[54453] = {2164,166298}, --Champions of Azeroth
		[58096] = {2415,174483}, --Rajani
		[55348] = {2391,170061}, --Rustbolt Resistance
		[54451] = {2163,166245}, --Tortollan Seekers
		[58097] = {2417,174484}, --Uldum Accord
		
		--Horde
		[54460] = {2156,166282}, --Talanji's Expedition
		[54455] = {2157,166299}, --The Honorbound
		[53982] = {2373,169940}, --The Unshackled
		[54461] = {2158,166290}, --Voldunai
		[54462] = {2103,166292}, --Zandalari Empire
		
		--Alliance
		[54456] = {2161,166297}, --Order of Embers
		[54458] = {2160,166295}, --Proudmoore Admiralty
		[54457] = {2162,166294}, --Storm's Wake
		[54454] = {2159,166300}, --The 7th Legion
		[55976] = {2400,169939}, --Waveblade Ankoan
}

function PR:ColorWatchbar()
	local factionID = select(6, GetWatchedFactionInfo())
	if factionID and C_Reputation_IsFactionParagon(factionID) then
		self:SetBarColor(PR.db.color.r, PR.db.color.g, PR.db.color.b)
	end
end

function PR:SetupParagonTooltip()
	local _ ,_ , rewardQuestID, hasRewardPending = C_Reputation_GetFactionParagonInfo(self.factionID)
	if hasRewardPending then
		local factionName = GetFactionInfoByID(self.factionID)
		local questIndex = GetQuestLogIndexByID(rewardQuestID)
		local description = GetQuestLogCompletionText(questIndex) or ""
		EmbeddedItemTooltip:SetText(L["PARAGON"])
		EmbeddedItemTooltip:AddLine(description, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
		GameTooltip_AddQuestRewardsToTooltip(EmbeddedItemTooltip,rewardQuestID)
		EmbeddedItemTooltip:Show()
	else
		EmbeddedItemTooltip:Hide()
	end
end

function PR:Tooltip(bar, event)
	if not bar.questID then return end
	if event == "OnEnter" then
		local _, link = GetItemInfo(PARAGON_QUEST_ID[bar.questID][2])
		if link ~= nil then
			GameTooltip:SetOwner(bar,"ANCHOR_NONE")
			GameTooltip:SetPoint("LEFT", bar, "RIGHT", 10, 0)
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	elseif event == "OnLeave" then
		GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
		GameTooltip:Hide()
	end
end

function PR:HookReputationBars()
	for n=1,NUM_FACTIONS_DISPLAYED do
		if _G["ReputationBar"..n] then
			_G["ReputationBar"..n]:HookScript("OnEnter",function(self)
				PR:Tooltip(self,"OnEnter")
			end)
			_G["ReputationBar"..n]:HookScript("OnLeave",function(self)
				PR:Tooltip(self,"OnLeave")
			end)
		end
	end
end

function PR:ShowToast(name, text)
	ACTIVE_TOAST = true
	if self.db.toast.sound then PlaySound(44295, "master", true) end
	PR.toast:EnableMouse(false)
	PR.toast.title:SetText(name)
	PR.toast.title:SetAlpha(0)
	PR.toast.description:SetText(text)
	PR.toast.description:SetAlpha(0)
	UIFrameFadeIn(PR.toast,.5,0,1)
	C_Timer_After(.5,function()
		UIFrameFadeIn(PR.toast.title,.5,0,1)
	end)
	C_Timer_After(.75,function()
		UIFrameFadeIn(PR.toast.description,.5,0,1)
	end)
	C_Timer_After(PR.db.toast.fade_time,function()
		UIFrameFadeOut(PR.toast,1,1,0)
	end)
	C_Timer_After(PR.db.toast.fade_time+1.25,function()
		PR.toast:Hide()
		ACTIVE_TOAST = false
		if #WAITING_TOAST > 0 then
			PR:WaitToast()
		end
	end)
end

function PR:WaitToast()
	local name,text = unpack(WAITING_TOAST[1])
	table.remove(WAITING_TOAST,1)
	PR:ShowToast(name,text)
end

function PR:CreateToast()
	local toast = CreateFrame("FRAME", "ParagonReputation_Toast", UIParent)
	toast:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 250)
	toast:SetSize(302, 70)
	toast:SetClampedToScreen(true)
	toast:Hide()

	-- [Toast] Create Background Texture
	toast:CreateBackdrop('Transparent')
	if E.db.WindTools.Interface.Skins.elvui.general and toast.backdrop then
		toast.backdrop:CreateShadow()
	end

	-- [Toast] Create Title Text
	toast.title = toast:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
	toast.title:SetPoint("TOPLEFT",toast,"TOPLEFT",23,-10)
	toast.title:SetWidth(260)
	toast.title:SetHeight(16)
	toast.title:SetJustifyV("TOP")
	toast.title:SetJustifyH("LEFT")

	-- [Toast] Create Description Text
	toast.description = toast:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
	toast.description:SetPoint("TOPLEFT",toast.title,"TOPLEFT",1,-23)
	toast.description:SetWidth(258)
	toast.description:SetHeight(32)			
	toast.description:SetJustifyV("TOP")
	toast.description:SetJustifyH("LEFT")

	PR.toast = toast
end

function PR:QUEST_ACCEPTED(event,...)
	local questIndex,questID = ...

	if PR.db.toast.enabled and PARAGON_QUEST_ID[questID] then
		local name = GetFactionInfoByID(PARAGON_QUEST_ID[questID][1])
		local text = GetQuestLogCompletionText(questIndex)
		if ACTIVE_TOAST then
			WAITING_TOAST[#WAITING_TOAST+1] = {name,text} --Toast is already active, put this info on the line.
		else
			PR:ShowToast(name,text)
		end
	end
end

function PR:CreateBarOverlay(factionBar)
	if factionBar.ParagonOverlay then return end
	local overlay = CreateFrame("FRAME", nil, factionBar)
	overlay:SetAllPoints(factionBar)
	overlay:SetFrameLevel(3)
	overlay.bar = overlay:CreateTexture("ARTWORK",nil,nil,-1)
	overlay.bar:SetTexture(E.media.normTex)
	overlay.bar:SetPoint("TOP",overlay)
	overlay.bar:SetPoint("BOTTOM",overlay)
	overlay.bar:SetPoint("LEFT",overlay)
	overlay.edge = overlay:CreateTexture("ARTWORK",nil,nil,-1)
	overlay.edge:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	overlay.edge:SetPoint("CENTER",overlay.bar,"RIGHT")
	overlay.edge:SetBlendMode("ADD")
	overlay.edge:SetSize(38,38) --Arbitrary value, I hope there isn't an AddOn that skins the bar and the glow doesnt look right with this size.
	factionBar.ParagonOverlay = overlay
end

function PR:ChangeReputationBars()
	local ReputationFrame = _G.ReputationFrame
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for n=1, NUM_FACTIONS_DISPLAYED,1 do
		local factionIndex = factionOffset+n
		local factionRow = _G["ReputationBar"..n]
		local factionBar = _G["ReputationBar"..n.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..n.."ReputationBarFactionStanding"]
		if factionIndex <= GetNumFactions() then
			local name,_,_,_,_,_,_,_,_,_,_,_,_,factionID = GetFactionInfo(factionIndex)
			if factionID and C_Reputation_IsFactionParagon(factionID) then
				local currentValue,threshold,rewardQuestID,hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
				factionRow.questID = rewardQuestID
				if currentValue then
					local r,g,b = PR.db.color.r, PR.db.color.g, PR.db.color.b
					local value = mod(currentValue,threshold)
					if hasRewardPending then
						local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
						paragonFrame.factionID = factionID
						paragonFrame:SetPoint("RIGHT",factionRow,11,0)
						paragonFrame.Glow:SetShown(true)
						paragonFrame.Check:SetShown(true)
						paragonFrame:Show()
						-- If value is 0 we force it to 1 so we don't get 0 as result, math...
						local over = ((value <= 0 and 1) or value)/threshold
						if not factionBar.ParagonOverlay then PR:CreateBarOverlay(factionBar) end
						factionBar.ParagonOverlay:Show()
						factionBar.ParagonOverlay.bar:SetWidth(factionBar.ParagonOverlay:GetWidth()*over)
						factionBar.ParagonOverlay.bar:SetVertexColor(r+.15,g+.15,b+.15)
						factionBar.ParagonOverlay.edge:SetVertexColor(r+.2,g+.2,b+.2,(over > .05 and .75) or 0)
						value = value+threshold
					else
						if factionBar.ParagonOverlay then factionBar.ParagonOverlay:Hide() end
					end
					factionBar:SetMinMaxValues(0,threshold)
					factionBar:SetValue(value)
					factionBar:SetStatusBarColor(r,g,b)
					factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT,BreakUpLargeNumbers(value),BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE
					
					if PR.db.text == "PARAGON" then
						factionStanding:SetText(L["Paragon"])
						factionRow.standingText = L["Paragon"]
					elseif PR.db.text == "CURRENT"  then
						factionStanding:SetText(BreakUpLargeNumbers(value))
						factionRow.standingText = BreakUpLargeNumbers(value)
					elseif PR.db.text == "VALUE" then
						factionStanding:SetText(" "..BreakUpLargeNumbers(value).." / "..BreakUpLargeNumbers(threshold))
						factionRow.standingText = (" "..BreakUpLargeNumbers(value).." / "..BreakUpLargeNumbers(threshold))
						factionRow.rolloverText = nil					
					elseif PR.db.text == "DEFICIT" then
						if hasRewardPending then
							value = value-threshold
							factionStanding:SetText("+"..BreakUpLargeNumbers(value))
							factionRow.standingText = "+"..BreakUpLargeNumbers(value)
						else
							value = threshold-value
							factionStanding:SetText(BreakUpLargeNumbers(value))
							factionRow.standingText = BreakUpLargeNumbers(value)
						end
						factionRow.rolloverText = nil
					end
					if factionIndex == GetSelectedFaction() and ReputationDetailFrame:IsShown() then
						local count = floor(currentValue/threshold)
						if hasRewardPending then count = count-1 end
						if count > 0 then
							ReputationDetailFactionName:SetText(name.." |cffffffffx"..count.."|r")
						end
					end
				end
			else
				factionRow.questID = nil
				if factionBar.ParagonOverlay then factionBar.ParagonOverlay:Hide() end
			end
		else
			factionRow:Hide()
		end
	end
end

function PR:Initialize()
	if not E.db.WindTools["Quest"]["Paragon Reputation"]["enabled"] then return end
	self.db = E.db.WindTools["Quest"]["Paragon Reputation"]

	tinsert(WT.UpdateAll, function()
		PR.db = E.db.WindTools["Quest"]["Paragon Reputation"]
	end)

	self:RegisterEvent('QUEST_ACCEPTED')

	hooksecurefunc(ReputationBarMixin, "Update", PR.ColorWatchbar)
	hooksecurefunc("ReputationParagonFrame_SetupParagonTooltip", PR.SetupParagonTooltip)
	hooksecurefunc("ReputationFrame_Update", PR.ChangeReputationBars)
	PR:HookReputationBars()
	PR:CreateToast()
	E:CreateMover(PR.toast, "Wind_ParagonReputationToastFrameMover", L["Paragon Reputation Toast"], nil, nil, nil, 'WINDTOOLS,ALL', function() return PR.db.enabled; end)
end

local function InitializeCallback()
	PR:Initialize()
end

E:RegisterModule(PR:GetName(), InitializeCallback)