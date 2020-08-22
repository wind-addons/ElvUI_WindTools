local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local C_Timer_After = C_Timer.After

local ResurrectionSpellList = {
	[20484] = true, -- 復生
	[61999] = true, -- 盟友復生
	[20707] = true, -- 靈魂石
	[50769] = true, -- 復活
	[2006] = true, -- 復活術
	[7328] = true, -- 救贖
	[2008] = true, -- 先祖之魂
	[115178] = true, -- 回命訣
	[265116] = true -- 不穩定的時間轉移器（工程學）
}

function A:ThanksForResurrection(sourceGUID, sourceName, destGUID, destName, spellId)
	local config = self.db.thanksForResurrection

	if not config or not config.enable then
		return
	end

	if not destGUID or not sourceGUID then
		return
	end

	-- 格式化自定义字符串
	local function FormatMessage(message)
		destName = destName:gsub("%-[^|]+", "")
		sourceNameWithoutServer = sourceName:gsub("%-[^|]+", "")
		message = gsub(message, "%%player%%", destName)
		message = gsub(message, "%%target%%", sourceNameWithoutServer)
		message = gsub(message, "%%spell%%", GetSpellLink(spellId))
		return message
	end

	if ResurrectionSpellList[spellId] then
		if spellId == 20707 and sourceGUID ~= UnitGUID("player") and destGUID == UnitGUID("player") then
			if not UnitIsDeadOrGhost("player") then
				-- 被额外绑定灵魂石
				A:SendMessage(FormatMessage(config.soulstoneText), A:GetChannel(config.channel), nil, sourceName)
				return
			end
		end

		if sourceGUID ~= UnitGUID("player") and destGUID == UnitGUID("player") then
			C_Timer_After(
				config.delay,
				function()
					A:SendMessage(FormatMessage(config.normalText), A:GetChannel(config.channel), nil, sourceName)
				end
			)
		end
	end
end
