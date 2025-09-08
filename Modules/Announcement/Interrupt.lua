local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement") ---@class Announcement

local _G = _G
local gsub = gsub
local strsplit = strsplit

local IsInInstance = IsInInstance
local IsPartyLFG = IsPartyLFG
local UnitGUID = UnitGUID

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

function A:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
	local config = self.db.interrupt

	if not config.enable or config.onlyInstance and not (IsInInstance() or IsPartyLFG()) then
		return
	end

	if not (spellId and extraSpellId) then
		return
	end

	if not self:CheckAuthority("INTERRUPT_OTHERS") then
		return
	end

	-- 格式化自定义字符串
	local function FormatMessage(message)
		sourceName = gsub(sourceName, "%-[^|]+", "")
		message = gsub(message, "%%player%%", sourceName)
		message = gsub(message, "%%target%%", destName)
		message = gsub(message, "%%player_spell%%", C_Spell_GetSpellLink(spellId))
		message = gsub(message, "%%target_spell%%", C_Spell_GetSpellLink(extraSpellId))
		return message
	end

	if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") then
		-- 自己及宠物打断
		if config.player.enable and destName and destName ~= E.myname then
			self:SendMessage(FormatMessage(config.player.text), self:GetChannel(config.player.channel))
		end
	elseif config.others.enable then
		-- 他人打断
		local sourceType = strsplit("-", sourceGUID)

		if sourceType == "Pet" then
			sourceName = self:GetPetInfo(sourceName)
		end

		if not self:IsGroupMember(sourceName) then
			return
		end

		self:SendMessage(FormatMessage(config.others.text), self:GetChannel(config.others.channel))
	end
end
