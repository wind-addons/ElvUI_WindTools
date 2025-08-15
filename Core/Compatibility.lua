local W, F, E, L, V, P, G = unpack((select(2, ...)))
local MF = W.Modules.MoveFrames
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local strlen = strlen
local strsplit = strsplit
local type = type

local CreateFrame = CreateFrame

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function W:ConstructCompatibilityFrame()
	local frame = CreateFrame("Frame", "WTCompatibilityFrame", E.UIParent)
	frame:SetSize(550, 500)
	frame:SetPoint("CENTER")
	frame:CreateBackdrop("Transparent")
	S:CreateShadowModule(frame.backdrop)
	S:MerathilisUISkin(frame.backdrop)
	frame.numModules = 0
	frame:Hide()
	frame:SetScript("OnHide", function()
		if frame.configChanged then
			E:StaticPopup_Show("PRIVATE_RL")
		end
	end)

	frame:SetFrameStrata("TOOLTIP")
	frame:SetFrameLevel(9000)

	if MF and MF.db and MF.db.enable then
		MF:HandleFrame(frame)
	end

	local close = F.Widgets.New("CloseButton", frame)
	close:SetPoint("TOPRIGHT", frame.backdrop, "TOPRIGHT")
	close:SetFrameLevel(frame:GetFrameLevel() + 1)

	local title = frame:CreateFontString(nil, "ARTWORK")
	title:FontTemplate()
	F.SetFontOutline(title, nil, "2")
	title:SetText(W.Title .. " " .. L["Compatibility Check"])
	title:SetPoint("TOP", frame, "TOP", 0, -10)

	local desc = frame:CreateFontString(nil, "ARTWORK")
	desc:FontTemplate()
	desc:SetJustifyH("LEFT")
	desc:Width(420)
	F.SetFontOutline(desc, nil, "-1")
	desc:SetText(
		L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."]
			.. " "
			.. format(L["Have a good time with %s!"], W.Title)
	)
	desc:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)

	local largeTip = frame:CreateFontString(nil, "ARTWORK")
	largeTip:FontTemplate()
	largeTip:SetJustifyH("CENTER")
	largeTip:Width(500)
	F.SetFontOutline(largeTip, nil, "7")
	largeTip:SetText(
		format(
			"%s %s %s",
			F.CreateColorString("[", E.db.general.valuecolor),
			L["Choose the module you would like to |cff00d1b2use|r"],
			F.CreateColorString("]", E.db.general.valuecolor)
		)
	)
	largeTip:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)

	local tex = frame:CreateTexture("WTCompatibilityFrameIllustration", "ARTWORK")
	tex:SetSize(64, 64)
	tex:SetTexture(W.Media.Textures.illMurloc1)
	tex:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -25)

	local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
	bottomDesc:FontTemplate()
	bottomDesc:SetJustifyH("LEFT")
	bottomDesc:Width(530)
	F.SetFontOutline(bottomDesc, nil, "-1")
	bottomDesc:SetText(
		E.NewSign
			.. format(L["If you find the %s module conflicts with another addon, alert me via Discord."], W.Title)
			.. "\n"
			.. L["You can disable/enable compatibility check via the option in the bottom of [WindTools]-[Advanced]-[Core]."]
	)
	bottomDesc:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

	local completeButton =
		CreateFrame("Button", "WTCompatibilityFrameCompleteButton", frame, "UIPanelButtonTemplate, BackdropTemplate")
	completeButton.Text:SetText(L["Complete"])
	completeButton.Text:SetJustifyH("CENTER")
	completeButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(completeButton.Text, E.db.general.font, "4")
	completeButton:SetSize(350, 35)
	completeButton:SetPoint("BOTTOM", bottomDesc, "TOP", 0, 10)
	S:Proxy("HandleButton", completeButton)
	completeButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	local scrollFrameParent =
		CreateFrame("ScrollFrame", "WTCompatibilityFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
	scrollFrameParent:CreateBackdrop("Transparent")
	scrollFrameParent:SetPoint("TOPLEFT", largeTip, "BOTTOMLEFT", 0, -10)
	scrollFrameParent:SetPoint("RIGHT", frame, "RIGHT", -32, 0)
	scrollFrameParent:SetPoint("BOTTOM", completeButton, "TOP", 0, 10)
	S:Proxy("HandleScrollBar", scrollFrameParent.ScrollBar)
	local scrollFrame = CreateFrame("Frame", "WTCompatibilityFrameScrollFrame", scrollFrameParent)
	scrollFrame:SetSize(scrollFrameParent:GetSize())

	scrollFrameParent:SetScrollChild(scrollFrame)
	frame.scrollFrameParent = scrollFrameParent
	frame.scrollFrame = scrollFrame

	W.CompatibilityFrame = frame
end

local function AddButtonToCompatibilityFrame(data)
	local frame = W.CompatibilityFrame
	frame.numModules = frame.numModules + 1

	local leftButton = CreateFrame(
		"Button",
		"WTCompatibilityFrameLeftButton" .. frame.numModules,
		frame.scrollFrame,
		"UIPanelButtonTemplate, BackdropTemplate"
	)
	leftButton.Text:SetText(format("%s\n%s", data.module1, data.plugin1))
	leftButton.Text:SetJustifyH("CENTER")
	leftButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(leftButton.Text, E.db.general.font)
	leftButton:SetSize(220, 40)
	leftButton:SetPoint("TOPLEFT", frame.scrollFrame, "TOPLEFT", 5, -frame.numModules * 50 + 45)
	S:Proxy("HandleButton", leftButton)
	leftButton:SetScript("OnClick", function(self)
		data.func1()
		frame.configChanged = true
		local name = gsub(self:GetName(), "LeftButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.left)
			_G[name]:SetVertexColor(0, 0.82, 0.698)
		end
	end)

	local middleTexture =
		frame.scrollFrame:CreateTexture("WTCompatibilityFrameMiddleTexture" .. frame.numModules, "ARTWORK")
	middleTexture:SetPoint("CENTER")
	middleTexture:SetSize(20, 20)
	middleTexture:SetTexture(W.Media.Icons.convert)
	middleTexture:SetVertexColor(1, 1, 1)
	middleTexture:SetPoint("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

	local rightButton = CreateFrame(
		"Button",
		"WTCompatibilityFrameRightButton" .. frame.numModules,
		frame.scrollFrame,
		"UIPanelButtonTemplate, BackdropTemplate"
	)
	rightButton.Text:SetText(format("%s\n%s", data.module2, data.plugin2))
	rightButton.Text:SetJustifyH("CENTER")
	rightButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(rightButton.Text, E.db.general.font)
	rightButton:SetSize(220, 40)
	rightButton:SetPoint("TOPRIGHT", frame.scrollFrame, "TOPRIGHT", -5, -frame.numModules * 50 + 45)
	S:Proxy("HandleButton", rightButton)
	rightButton:SetScript("OnClick", function(self)
		data.func2()
		frame.configChanged = true
		local name = gsub(self:GetName(), "RightButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.right)
			_G[name]:SetVertexColor(1, 0.22, 0.376)
		end
	end)
end

local function GetDatabaseRealValue(path)
	local accessTable, accessKey, accessValue = nil, nil, E

	for _, key in ipairs({ strsplit(".", path) }) do
		if key and strlen(key) > 0 then
			if accessValue and accessValue[key] ~= nil then
				if type(accessValue[key]) == "boolean" then
					accessTable = accessValue
					accessKey = key
				end
				accessValue = accessValue[key]
			else
				F.Developer.LogDebug("[Compatibility] database path not found\n" .. path)
				return
			end
		end
	end

	return accessTable, accessKey, accessValue
end

local function GetCheckCompatibilityFunction(targetAddonName, targetAddonLocales)
	if not C_AddOns_IsAddOnLoaded(targetAddonName) then
		return E.noop
	end

	return function(myModuleName, targetAddonModuleName, myDB, targetAddonDB)
		if not (myDB and targetAddonDB and type(myDB) == "string" and type(targetAddonDB) == "string") then
			return
		end

		local myTable, myKey, myValue = GetDatabaseRealValue(myDB)
		local targetTable, targetKey, targetValue = GetDatabaseRealValue(targetAddonDB)

		if myValue == true and targetValue == true then
			AddButtonToCompatibilityFrame({
				module1 = myModuleName,
				plugin1 = W.Title,
				func1 = function()
					myTable[myKey] = true
					targetTable[targetKey] = false
				end,
				module2 = targetAddonModuleName,
				plugin2 = targetAddonLocales,
				func2 = function()
					myTable[myKey] = false
					targetTable[targetKey] = true
				end,
			})
		end
	end
end

local CheckMerathilisUI = GetCheckCompatibilityFunction("ElvUI_MerathilisUI", L["MerathilisUI"])
local CheckShadowAndLight = GetCheckCompatibilityFunction("ElvUI_SLE", L["Shadow & Light"])
local CheckmMediaTag = GetCheckCompatibilityFunction("ElvUI_mMediaTag", L["mMediaTag"])
local CheckElvUIEnhanced = GetCheckCompatibilityFunction("ElvUI_Enhanced", L["ElvUI Enhanced Again"])

function W:CheckCompatibility()
	if not E.global.WT.core.compatibilityCheck then
		return
	end

	self:ConstructCompatibilityFrame()

	-- Merathilis UI
	CheckMerathilisUI(
		L["Extra Items Bar"],
		L["AutoButtons"],
		"db.WT.item.extraItemsBar.enable",
		"db.mui.autoButtons.enable"
	)

	CheckMerathilisUI(L["Game Bar"], L["Micro Bar"], "db.WT.misc.gameBar.enable", "db.mui.microBar.enable")

	CheckMerathilisUI(L["Contacts"], L["Mail"], "db.WT.item.contacts.enable", "db.mui.mail.enable")

	CheckMerathilisUI(
		format("%s-%s", L["Tooltip"], L["Add Icon"]),
		format("%s-%s", L["Tooltip"], L["Tooltip Icons"]),
		"private.WT.tooltips.icon",
		"db.mui.tooltip.icon"
	)

	CheckMerathilisUI(
		L["Group Info"],
		L["LFG Info"],
		"db.WT.tooltips.groupInfo.enable",
		"db.mui.tooltip.groupInfo.enable"
	)

	CheckMerathilisUI(
		L["Role Icon"],
		L["Role Icon"],
		"private.WT.unitFrames.roleIcon.enable",
		"db.mui.unitframes.roleIcons"
	)

	CheckMerathilisUI(
		L["Combat Alert"],
		L["Combat Alert"],
		"db.WT.combat.combatAlert.enable",
		"db.mui.CombatAlert.enable"
	)

	CheckMerathilisUI(
		L["Who Clicked Minimap"],
		L["Minimap Ping"],
		"db.WT.maps.whoClicked.enable",
		"db.mui.maps.minimap.ping.enable"
	)

	CheckMerathilisUI(
		L["Minimap Buttons"],
		L["Minimap Buttons"],
		"private.WT.maps.minimapButtons.enable",
		"db.mui.smb.enable"
	)

	CheckMerathilisUI(
		L["Rectangle Minimap"],
		L["Rectangle Minimap"],
		"db.WT.maps.rectangleMinimap.enable",
		"db.mui.maps.rectangleMinimap.enable"
	)

	CheckMerathilisUI(L["Chat Bar"], L["Chat Bar"], "db.WT.social.chatBar.enable", "db.mui.chat.chatBar.enable")

	CheckMerathilisUI(L["Chat Link"], L["Chat Link"], "db.WT.social.chatLink.enable", "db.mui.chat.chatLink.enable")

	CheckMerathilisUI(
		L["Raid Markers"],
		L["Raid Markers"],
		"db.WT.combat.raidMarkers.enable",
		"db.mui.raidmarkers.enable"
	)

	CheckMerathilisUI(
		format("%s-%s", L["Chat Text"], L["Remove Brackets"]),
		L["Hide Player Brackets"],
		"db.WT.social.chatText.removeBrackets",
		"db.mui.chat.chatText.removeBrackets"
	)

	CheckMerathilisUI(
		L["Super Tracker"],
		L["Super Tracker"],
		"private.WT.maps.superTracker.enable",
		"db.mui.maps.superTracker.enable"
	)

	CheckMerathilisUI(
		L["Instance Difficulty"],
		L["Raid Difficulty"],
		"private.WT.maps.instanceDifficulty.enable",
		"db.mui.maps.instanceDifficulty.enable"
	)

	CheckMerathilisUI(
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		L["Merchant"],
		"private.WT.item.extendMerchantPages.enable",
		"db.mui.merchant.enable"
	)

	CheckMerathilisUI(
		L["Absorb"],
		L["Heal Prediction"],
		"db.WT.unitFrames.absorb.enable",
		"db.mui.unitframes.healPrediction.enable"
	)

	CheckMerathilisUI(
		L["Objective Tracker"],
		L["Objective Tracker"],
		"private.WT.quest.objectiveTracker.enable",
		"private.mui.quest.objectiveTracker.enable"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Button"]),
		L["Button"],
		"private.WT.skins.widgets.button.enable",
		"private.mui.skins.widgets.button.enable"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Check Box"]),
		L["Check Box"],
		"private.WT.skins.widgets.checkBox.enable",
		"private.mui.skins.widgets.checkBox.enable"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tab"]),
		L["Check Box"],
		"private.WT.skins.widgets.tab.enable",
		"private.mui.skins.widgets.tab.enable"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tree Group Button"]),
		L["Check Box"],
		"private.WT.skins.widgets.treeGroupButton.enable",
		"private.mui.skins.widgets.treeGroupButton.enable"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Addons"], L["WeakAuras"]),
		L["WeakAuras"],
		"private.WT.skins.addons.weakAuras",
		"private.mui.skins.addonSkins.wa"
	)

	CheckMerathilisUI(
		format("%s-%s-%s", L["Skins"], L["Addons"], L["WeakAuras Options"]),
		L["WeakAuras Options"],
		"private.WT.skins.addons.weakAurasOptions",
		"private.mui.skins.addonSkins.waOptions"
	)

	CheckMerathilisUI(L["Announcement"], L["Announcement"], "db.WT.announcement.enable", "db.mui.announcement.enable")

	CheckMerathilisUI(
		L["Event Tracker"],
		L["Event Tracker"],
		"db.WT.maps.eventTracker.enable",
		"db.mui.maps.eventTracker.enable"
	)

	CheckMerathilisUI(
		format("%s-%s", L["Quest"], L["Turn In"]),
		format("%s-%s", L["Quest"], L["Turn In"]),
		"db.WT.quest.turnIn.enable",
		"db.mui.quest.turnIn.enable"
	)

	CheckMerathilisUI(
		format("%s-%s", L["Quest"], L["Switch Buttons"]),
		format("%s-%s", L["Quest"], L["Switch Buttons"]),
		"db.WT.quest.switchButtons.enable",
		"db.mui.quest.switchButtons.enable"
	)

	CheckMerathilisUI(
		L["Exit Phase Diving"],
		L["Exit Phase Diving"],
		"db.WT.misc.exitPhaseDiving.enable",
		"db.mui.misc.exitPhaseDiving.enable"
	)

	-- S&L
	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Shadow"]),
		L["Enhanced Shadow"],
		"private.WT.skins.shadow",
		"private.sle.module.shadows.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Tooltip"], L["Progression"]),
		format("%s-%s", L["Tooltip"], L["Raid Progression"]),
		"private.WT.tooltips.progression.enable",
		"db.sle.tooltip.RaidProg.enable"
	)

	CheckShadowAndLight(
		L["Rectangle Minimap"],
		L["Rectangle Minimap"],
		"db.WT.maps.rectangleMinimap.enable",
		"private.sle.minimap.rectangle"
	)

	CheckShadowAndLight(
		L["Raid Markers"],
		L["Raid Markers"],
		"db.WT.combat.raidMarkers.enable",
		"db.sle.raidmarkers.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Scenario"]),
		format("%s-%s", L["Skins"], L["Key Timers"]),
		"private.WT.skins.blizzard.scenario",
		"private.sle.skins.objectiveTracker.keyTimers.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Objective Tracker"], L["Cosmetic Bar"]),
		format("%s-%s", L["Skins"], L["Underline"]),
		"private.WT.quest.objectiveTracker.enable",
		"db.sle.skins.objectiveTracker.underline"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Item"], L["Fast Loot"]),
		L["Loot"],
		"db.WT.item.fastLoot.enable",
		"db.sle.loot.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		L["Merchant"],
		"private.WT.item.extendMerchantPages.enable",
		"private.sle.skins.merchant.enable"
	)

	-- mMediaTag
	CheckmMediaTag(
		format("%s-%s", L["Tooltips"], L["Icon"]),
		L["Tooltip Icons"],
		"private.WT.tooltips.icon",
		"db.mMT.tooltip.enable"
	)

	CheckmMediaTag(
		L["Objective Tracker"],
		L["ObjectiveTracker Skin"],
		"private.WT.quest.objectiveTracker.enable",
		"db.mMT.objectivetracker.enable"
	)

	CheckmMediaTag(
		L["Role Icon"],
		L["Role Symbols"],
		"private.WT.unitFrames.roleIcon.enable",
		"db.mMT.roleicons.enable"
	)

	-- Enhanced Again
	CheckElvUIEnhanced(
		L["Raid Markers"],
		L["Raid Markers"],
		"db.WT.combat.raidMarkers.enable",
		"db.eel.raidmarkerbar.enable"
	)

	CheckElvUIEnhanced(
		format("%s-%s", L["Tooltip"], L["Progression"]),
		format("%s-%s", L["Tooltip"], L["Progression"]),
		"private.WT.tooltips.progression.enable",
		"db.eel.progression.enable"
	)

	CheckElvUIEnhanced(
		L["Minimap Buttons"],
		L["Minimap Button Bar"],
		"private.WT.maps.minimapButtons.enable",
		"db.eel.minimap.minimapbar.enable"
	)

	if self.CompatibilityFrame.numModules > 0 then
		self.CompatibilityFrame:Show()
	end
end
