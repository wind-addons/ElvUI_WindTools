local W, F, E, L = unpack((select(2, ...)))
local UF = E:GetModule("UnitFrames")
local T = W.Modules.Tooltips
local LFGPI = W.Utilities.LFGPlayerInfo

local format = format
local ipairs = ipairs

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function GetIconString(role, mode)
	local template
	if mode == "NORMAL" then
		template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
	elseif mode == "COMPACT" then
		template = "|T%s:16:16:0:0:64:64:8:56:8:56|t"
	end

	return format(template, UF.RoleIconTextures[role])
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

	-- split line
	if config.title then
		tooltip:AddLine(" ")
		tooltip:AddLine(W.Title .. " " .. L["Party Info"])
	end

	-- compact Mode
	if config.mode == "COMPACT" then
		tooltip:AddLine(" ")
	end

	-- add info
	local data = LFGPI:GetPartyInfo(config.template)

	for order, role in ipairs(LFGPI:GetRoleOrder()) do
		if #data[role] > 0 and config.mode == "NORMAL" then
			tooltip:AddLine(" ")
			tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. LFGPI.GetColoredRoleName(role))
		end

		for _, line in ipairs(data[role]) do
			local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
			tooltip:AddLine(icon .. " " .. line)
		end
	end

	tooltip:Show()
end

function T:GroupInfo()
	if C_AddOns_IsAddOnLoaded("PremadeGroupsFilter") and E.db.WT.tooltips.groupInfo.enable then
		F.Print(
			format(
				L["%s detected, %s will be disabled automatically."],
				"|cffff3860" .. L["Premade Groups Filter"] .. "|r",
				"|cff00a8ff" .. L["Tooltips"] .. " - " .. L["Group Info"] .. "|r"
			)
		)
		E.db.WT.tooltips.groupInfo.enable = false
	end

	T:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")
end

T:AddCallback("GroupInfo")
