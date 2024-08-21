local W, F, E, L = unpack((select(2, ...)))
local A = W:GetModule("Announcement")

local gsub = gsub

local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

local resurrectionSpells = {
	[2006] = true, -- 復活術
	[2008] = true, -- 先祖之魂
	[7328] = true, -- 救贖
	[20484] = true, -- 復生
	[20707] = true, -- 靈魂石
	[50769] = true, -- 復活
	[61999] = true, -- 盟友復生
	[115178] = true, -- 回命訣
	[265116] = true, -- 不穩定的時間轉移器
	[361227] = true, -- 返世
	[391054] = true, -- 代禱
}

local enhancementsSpells = {
	[10060] = true, -- 注入能量
	[29166] = true, -- 啟動
}

function A:Thanks(sourceGUID, sourceName, destGUID, destName, spellId)
	local config = self.db.thanks

	if not config or not config.enable then
		return
	end

	if not destGUID or not sourceGUID or sourceGUID == E.myguid or destGUID ~= E.myguid then
		return
	end

	local function FormatMessage(message)
		destName = gsub(destName, "%-[^|]+", "")
		local sourceNameWithoutServer = gsub(sourceName, "%-[^|]+", "")
		message = gsub(message, "%%player%%", destName)
		message = gsub(message, "%%target%%", sourceNameWithoutServer)
		message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(spellId))
		return message
	end

	local function Send(msg)
		if not msg then
			return
		end

		E:Delay(config.delay, A.SendMessage, A, FormatMessage(msg), A:GetChannel(config.channel), nil, sourceName)
	end

	if resurrectionSpells[spellId] then
		if spellId == 20707 and not UnitIsDeadOrGhost("player") then
			-- additional soulstone should be enhancement
			Send(config.enhancement and config.enhancementText)
		else
			Send(config.resurrection and config.resurrectionText)
		end
	elseif enhancementsSpells[spellId] then
		Send(config.enhancement and config.enhancementText)
	end
end
