local W, F, E, L, V, P, G = unpack((select(2, ...)))

local format = format
local pairs = pairs
local print = print
local tonumber = tonumber
local type = type

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", W.Media.Icons.accept)

local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		F.PrintGradientLine()
		F.Print(L["Update"])
	end

	E:Delay(1, function()
		print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, W.Version) .. DONE_ICON)
	end)
end

function W:UpdateScripts()
	local currentVersion = tonumber(W.Version) -- installed WindTools Version
	local globalVersion = tonumber(E.global.WT.version or "0") -- version in ElvUI Global

	-- from old updater
	if globalVersion == 0 then
		globalVersion = tonumber(E.global.WT.Version or "0")
		E.global.WT.Version = nil
	end

	local profileVersion = tonumber(E.db.WT.version or globalVersion) -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.WT.version or globalVersion) -- Version in ElvUI Private

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	-- Clear the history of move frames.
	if privateVersion >= 2.27 and privateVersion <= 2.31 then
		E.private.WT.misc.framePositions = {}
		UpdateMessage(L["Move Frames"] .. " - " .. L["Clear History"], globalVersion)
	end

	-- Copy old move frames options to its new db.
	if privateVersion <= 2.33 then
		local miscDB = E.private.WT.misc
		miscDB.moveFrames.enable = miscDB.moveBlizzardFrames or miscDB.moveFrames.enable
		miscDB.moveFrames.elvUIBags = miscDB.moveElvUIBags or miscDB.moveFrames.elvUIBags
		miscDB.moveFrames.rememberPositions = miscDB.rememberPositions or miscDB.moveFrames.rememberPositions
		miscDB.moveFrames.framePositions = miscDB.framePositions or miscDB.moveFrames.framePositions

		miscDB.moveBlizzardFrames = nil
		miscDB.moveElvUIBags = nil
		miscDB.rememberPositions = nil
		miscDB.framePositions = nil

		UpdateMessage(L["Move Frames"] .. " - " .. L["Update Database"], globalVersion)
	end

	if profileVersion <= 2.34 then
		local miscDB = E.db.WT.misc
		miscDB.automation.hideBagAfterEnteringCombat = miscDB.autoHideBag
			or miscDB.automation.hideBagAfterEnteringCombat
		miscDB.automation.hideWorldMapAfterEnteringCombat = miscDB.autoHideWorldMap
			or miscDB.automation.hideWorldMapAfterEnteringCombat

		miscDB.autoHideBag = nil
		miscDB.autoHideWorldMap = nil

		UpdateMessage(L["Automation"] .. " - " .. L["Update Database"], profileVersion)
	end

	if profileVersion < 3.56 then
		E.db.WT.maps.eventTracker.spacing = nil
		E.db.WT.maps.eventTracker.height = nil
		E.db.WT.maps.eventTracker.yOffset = nil
		E.db.WT.maps.eventTracker.backdrop = nil
		UpdateMessage(L["Event Tracker"] .. " - " .. L["Update Database"], profileVersion)
	end

	if privateVersion < 3.66 then
		if E.private.WT.tooltips.progression then
			E.private.WT.tooltips.progression.mythicDungeons = nil
			E.private.WT.tooltips.progression.raids = nil
			E.private.WT.tooltips.progression.special = nil

			UpdateMessage(L["Progression"] .. " - " .. L["Update Database"], privateVersion)
		end
	end

	if profileVersion < 3.68 then
		if E.db.WT.social.contextMenu then
			E.db.WT.social.contextMenu.reportStats = nil
			UpdateMessage(L["Social"] .. " - " .. L["Context Menu"] .. ": " .. L["Update Database"], profileVersion)
		end
	end

	if privateVersion < 3.69 then
		if E.private.WT.misc then
			E.private.WT.misc.keybindTextAbove = E.private.WT.misc.hotKeyAboveCD or false
			E.private.WT.misc.hotKeyAboveCD = nil
			UpdateMessage(L["Misc"] .. " - " .. L["Keybind Text Above"] .. ": " .. L["Update Database"], privateVersion)
		end

		if E.private.WT.skins then
			for _, widget in pairs({
				"button",
				"tab",
				"treeGroupButton",
			}) do
				if E.private.WT.skins.widgets[widget] and E.private.WT.skins.widgets[widget].backdrop then
					E.private.WT.skins.widgets[widget].backdrop.alpha = nil
					E.private.WT.skins.widgets[widget].backdrop.animationType = nil
					E.private.WT.skins.widgets[widget].backdrop.animationDuration = nil
				end
			end
			UpdateMessage(L["Skins"] .. " - " .. L["Widgets"] .. ": " .. L["Update Database"], privateVersion)
		end
	end

	if profileVersion < 3.72 then
		if E.db.WT then
			if E.db.WT.social.friendList then
				E.db.WT.social.friendList.client = nil
				E.db.WT.social.friendList.factionIcon = nil

				UpdateMessage(L["Friend List"] .. " - " .. L["Update Database"], profileVersion)
			end

			if E.db.WT.social.chatBar and E.db.WT.social.chatBar.channels and E.db.WT.social.chatBar.channels.world then
				E.db.WT.social.chatBar.channels.world.enable = false
				if W.RealRegion == "CN" or W.RealRegion == "TW" and W.CurrentRealmID == 963 then
					E.db.WT.social.chatBar.channels.world.enable = true
				end
				E.db.WT.social.chatBar.channels.world.autoJoin = nil
				E.db.WT.social.chatBar.channels.world.name = nil

				UpdateMessage(L["Chat Bar"] .. " - " .. L["Update Database"], profileVersion)
			end
		end
	end

	if profileVersion < 3.73 then
		if E.db.WT and E.db.WT.maps.eventTracker then
			if E.db.WT.maps.eventTracker.iskaaranFishingNet then
				E.db.WT.maps.eventTracker.iskaaranFishingNet.enable = false
				UpdateMessage(L["Event Tracker"] .. ": " .. L["Update Database"], profileVersion)
			end
		end
	end

	if globalVersion < 3.75 then
		if E.global.WT and E.global.WT.core then
			E.global.WT.core.fixPlaystyle = nil
			UpdateMessage(L["Core"] .. " - " .. L["Update Database"], globalVersion)
		end
	end

	if profileVersion < 3.76 then
		if E.db.WT and E.db.WT.maps.eventTracker then
			if E.db.WT.maps.eventTracker.worldSoul then
				E.db.WT.maps.eventTracker.worldSoul = nil
				UpdateMessage(L["Event Tracker"] .. ": " .. L["Update Database"], profileVersion)
			end
		end
	end

	if profileVersion < 3.80 then
		if E.db.WT and E.db.WT.quest.paragonReputation then
			E.db.WT.quest.paragonReputation = nil
			UpdateMessage(L["Database cleanup"], profileVersion)
		end
	end

	if privateVersion < 3.92 then
		if E.private.WT and E.private.WT.skins and E.private.WT.skins.addons then
			E.private.WT.skins.addons.tldrMissions = nil

			UpdateMessage(L["Skins"] .. ": " .. L["Update Database"], privateVersion)
		end
	end

	if privateVersion < 3.94 then
		if E.private.WT and E.private.WT.misc and E.private.WT.misc.moveFrames then
			E.private.WT.misc.moveFrames.rememberPositions = false
			E.private.WT.misc.moveFrames.framePositions = {}

			UpdateMessage(L["Move Frames"] .. ": " .. L["Clear History"], privateVersion)
		end
	end

	if privateVersion < 3.97 or profileVersion < 3.97 then
		if E.private.WT and E.private.WT.tooltips then
			local db = E.private.WT.tooltips

			if db.icon ~= nil then
				db.titleIcon.enable = db.icon
				db.icon = nil
			end

			if type(db.objectiveProgress) ~= "table" then
				local saved = db.objectiveProgress
				db.objectiveProgress = {}

				E:CopyTable(db.objectiveProgress, V.tooltips.objectiveProgress)
				if type(saved) == "boolean" then
					db.objectiveProgress.enable = saved
				end
			end
		end

		if E.db.WT and E.db.WT.tooltips then
			local db = E.db.WT.tooltips

			if db.yOffsetOfHealthBar ~= nil and db.elvUITweaks and db.elvUITweaks.healthBar then
				db.elvUITweaks.healthBar.barYOffset = db.yOffsetOfHealthBar
				db.yOffsetOfHealthBar = nil
			end

			if db.yOffsetOfHealthText ~= nil and db.elvUITweaks and db.elvUITweaks.healthBar then
				db.elvUITweaks.healthBar.textYOffset = db.yOffsetOfHealthText
				db.yOffsetOfHealthText = nil
			end

			if db.elvUITweaks and db.elvUITweaks.raceIcon then
				if db.elvUITweaks.raceIcon.iconWidth ~= nil then
					db.elvUITweaks.raceIcon.width = db.elvUITweaks.raceIcon.iconWidth
					db.elvUITweaks.raceIcon.iconWidth = nil
				end

				if db.elvUITweaks.raceIcon.iconHeight ~= nil then
					db.elvUITweaks.raceIcon.height = db.elvUITweaks.raceIcon.iconHeight
					db.elvUITweaks.raceIcon.iconHeight = nil
				end
			end

			if db.elvUITweaks and db.elvUITweaks.specIcon then
				if db.elvUITweaks.specIcon.iconWidth ~= nil then
					db.elvUITweaks.specIcon.width = db.elvUITweaks.specIcon.iconWidth
					db.elvUITweaks.specIcon.iconWidth = nil
				end

				if db.elvUITweaks.specIcon.iconHeight ~= nil then
					db.elvUITweaks.specIcon.height = db.elvUITweaks.specIcon.iconHeight
					db.elvUITweaks.specIcon.iconHeight = nil
				end
			end

			if db.elvUITweaks and db.elvUITweaks.betterMythicPlusInfo then
				if type(db.elvUITweaks.betterMythicPlusInfo.icon) ~= "table" then
					local saved = db.elvUITweaks.betterMythicPlusInfo.icon
					db.elvUITweaks.betterMythicPlusInfo.icon = {}
					E:CopyTable(
						db.elvUITweaks.betterMythicPlusInfo.icon,
						P.tooltips.elvUITweaks.betterMythicPlusInfo.icon
					)
					if type(saved) == "boolean" then
						db.elvUITweaks.betterMythicPlusInfo.icon.enable = saved
					end
				end

				if db.elvUITweaks.betterMythicPlusInfo.iconWidth ~= nil then
					db.elvUITweaks.betterMythicPlusInfo.icon.width = db.elvUITweaks.betterMythicPlusInfo.iconWidth
					db.elvUITweaks.betterMythicPlusInfo.iconWidth = nil
				end

				if db.elvUITweaks.betterMythicPlusInfo.iconHeight ~= nil then
					db.elvUITweaks.betterMythicPlusInfo.icon.height = db.elvUITweaks.betterMythicPlusInfo.iconHeight
					db.elvUITweaks.betterMythicPlusInfo.iconHeight = nil
				end
			end

			if db.keystone then
				if type(db.keystone.icon) ~= "table" then
					local saved = db.keystone.icon
					db.keystone.icon = {}
					E:CopyTable(db.keystone.icon, P.tooltips.keystone.icon)
					if type(saved) == "boolean" then
						db.keystone.icon.enable = saved
					end
				end

				if db.keystone.iconWidth ~= nil then
					db.keystone.icon.width = db.keystone.iconWidth
					db.keystone.iconWidth = nil
				end

				if db.keystone.iconHeight ~= nil then
					db.keystone.icon.height = db.keystone.iconHeight
					db.keystone.iconHeight = nil
				end
			end
		end

		UpdateMessage(L["Tooltips"] .. ": " .. L["Update Database"], privateVersion)
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.WT.version = W.Version
	E.db.WT.version = W.Version
	E.private.WT.version = W.Version
end
