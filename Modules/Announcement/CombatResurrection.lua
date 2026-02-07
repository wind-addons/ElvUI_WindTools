local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement

local gsub = gsub

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

local CombatResurrectionList = {
	[20484] = true, -- 复生
	[20707] = true, -- 灵魂石
	[61999] = true, -- 复活盟友
	[265116] = true, -- 不稳定的时空转移器
	[345130] = true, -- 即抛型幽魂相位复生装置
	[391054] = true, -- 代祷
}

--- Format the announcement message
---@param message string
---@param sourceName string
---@param destName string
---@param spellId number
---@return string
local function FormatMessage(message, sourceName, destName, spellId)
	destName = destName:gsub("%-[^|]+", "")
	sourceName = sourceName:gsub("%-[^|]+", "")
	message = gsub(message, "%%player%%", sourceName)
	message = gsub(message, "%%target%%", destName)
	message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(spellId))
	return message
end

function A:CombatResurrection(sourceGUID, sourceName, destName, spellId)
	local config = self.db.combatResurrection
	if not config or not config.enable or not sourceName or not destName then
		return
	end

	if not self:IsGroupMember(sourceName) then
		return
	end

	if not self:CheckAuthority("COMBAT_RESURRECTION") then
		return
	end

	if CombatResurrectionList[spellId] then
		local needAnnounce = true

		if config.onlySourceIsPlayer and sourceGUID ~= E.myguid then
			needAnnounce = false
		end

		if needAnnounce then
			self:SendMessage(
				FormatMessage(config.text, sourceName, destName, spellId),
				self:GetChannel(config.channel),
				config.raidWarning
			)
		end
	end
end
