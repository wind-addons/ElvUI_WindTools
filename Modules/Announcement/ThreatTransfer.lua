local W, F, E, L = unpack((select(2, ...)))
local A = W:GetModule("Announcement")

local gsub = gsub

local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

local ThreatTransferList = {
	[34477] = true, -- 誤導
	[57934] = true, -- 偷天換日
}

-- 格式化自定义字符串
local function FormatMessage(message, sourceName, destName, spellId)
	destName = destName:gsub("%-[^|]+", "")
	sourceName = sourceName:gsub("%-[^|]+", "")
	message = gsub(message, "%%player%%", sourceName)
	message = gsub(message, "%%target%%", destName)
	message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(spellId))
	return message
end

function A:ThreatTransfer(sourceGUID, sourceName, destGUID, destName, spellId)
	local config = self.db.threatTransfer
	if not config or not config.enable then
		return
	end

	if not self:CheckAuthority("THREAT_TRANSFER") then
		return
	end

	if ThreatTransferList[spellId] then
		local needAnnounce = true

		if config.onlyNotTank then
			local role = UnitGroupRolesAssigned(destName)
			if role == "TANK" then
				needAnnounce = false
				if config.forceSourceIsPlayer and sourceGUID == E.myguid then
					needAnnounce = true
				elseif config.forceDestIsPlayer and destGUID == E.myguid then
					needAnnounce = true
				end
			end
		end

		if not self:IsGroupMember(sourceName) then
			return
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
