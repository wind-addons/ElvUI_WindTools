local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local UF = E:GetModule("UnitFrames")
local T = W.Modules.Tooltips
local LFGPI = W.Utilities.LFGPlayerInfo

local C = W.Utilities.Color

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local strfind = strfind

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local ROLE_ICON_PATTERN = "^|A:groupfinder%-icon%-role%-micro"

local function GetIconString(role, mode)
	local template
	if mode == "NORMAL" then
		template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
	elseif mode == "COMPACT" then
		template = "|T%s:16:16:0:0:64:64:8:56:8:56|t"
	end

	return format(template, UF.RoleIconTextures[role])
end

-- Clean empty or whitespace-only text from tooltip line
---@param line FontString The tooltip line to check
local function clearEmptyTooltipLine(line)
	if line then
		local raw = line:GetText()
		if raw and gsub(raw, "%s+$", "") == "" then
			line:SetText("")
		end
	end
end

-- Cleanup all Blizzard Group Info
---@param tooltip GameTooltip The tooltip to clean up
---@return boolean delistedFound
local function cleanupBlizzardGroupInfo(tooltip)
	local delistedFound = false
	local titleFound = false

	for i = 5, tooltip:NumLines() do
		local line = _G["GameTooltipTextLeft" .. i] ---@type FontString?
		local raw = line and line:GetText()
		---@cast line FontString
		if raw then
			if raw == _G.MEMBERS_COLON then
				line:SetText("")
				clearEmptyTooltipLine(_G["GameTooltipTextLeft" .. (i - 1)])
				clearEmptyTooltipLine(_G["GameTooltipTextLeft" .. (i - 2)])
				titleFound = true
			elseif raw == _G.LFG_LIST_ENTRY_DELISTED then
				delistedFound = true
			elseif titleFound then
				if strfind(raw, ROLE_ICON_PATTERN) then
					line:SetText("")
				else
					clearEmptyTooltipLine(line)
				end
			end
		end
	end

	return delistedFound
end

-- Helper function to add role information with proper spacing
local function addRoleInformation(tooltip, data, config)
	for _, role in ipairs(LFGPI:GetRoleOrder()) do
		local roleData = data[role]
		if #roleData > 0 then
			if config.mode == "NORMAL" then
				tooltip:AddLine(" ")
				tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. LFGPI.GetColoredRoleName(role))
			end

			for _, line in ipairs(roleData) do
				local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
				tooltip:AddLine(icon .. " " .. line)
			end
		end
	end
end

function T:AddGroupInfo(tooltip, resultID)
	local config = E.db.WT.tooltips.groupInfo
	if not config or not config.enable then
		return
	end

	if config.excludeDungeon and LFGPI:IsIDDungeons(resultID) then
		return
	end

	LFGPI:SetClassIconStyle(config.classIconStyle)
	LFGPI:Update(resultID)

	local foundDelisted = false
	if config.hideBlizzard then
		foundDelisted = cleanupBlizzardGroupInfo(tooltip)
	else
		tooltip:AddLine(" ")
	end

	if config.title then
		if foundDelisted then
			-- If the line already exists (we need to add a separator)
			tooltip:AddLine(" ")
		end
		tooltip:AddLine(W.Title .. " " .. L["Party Info"])
	end

	addRoleInformation(tooltip, LFGPI:GetPartyInfo(config.template), config)

	tooltip:Show()
end

function T:GroupInfo()
	if C_AddOns_IsAddOnLoaded("PremadeGroupsFilter") and E.db.WT.tooltips.groupInfo.enable then
		F.Print(
			format(
				L["%s detected, %s will be disabled automatically."],
				C.StringByTemplate(L["Premade Groups Filter"], "yellow-400"),
				C.StringByTemplate(L["Tooltips"] .. " - " .. L["Group Info"], "sky-400")
			)
		)
		E.db.WT.tooltips.groupInfo.enable = false
	end

	self:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")

	-- Fix taint issue with "Report Advertisement" dropdown option.
	-- Addons that modify the LFG dropdown menu can cause taint that breaks
	-- the Report Advertisement functionality. This fix aliases the function
	-- to prevent the taint from propagating.
	-- Reference: https://github.com/RaiderIO/raiderio-addon/blob/edee8290d281f6bffaa28612d01f6b9ae768d37b/core.lua#L7504-L7510
	-- Original issue: https://github.com/Stanzilla/WoWUIBugs/issues/237
	if _G.LFGList_ReportAdvertisement and _G.LFGList_ReportListing then
		_G.LFGList_ReportAdvertisement = _G.LFGList_ReportListing
	end
end

T:AddCallback("GroupInfo")
