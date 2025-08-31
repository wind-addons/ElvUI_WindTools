local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local CH = W:GetModule("ClassHelper")
local LSM = E.Libs.LSM

local _G = _G
local math_max = math.max
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local wipe = wipe

local CreateFrame = CreateFrame
local GetCombatRatingBonus = GetCombatRatingBonus
local GetTime = GetTime
local GetVersatilityBonus = GetVersatilityBonus
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local C_ClassTalents_GetActiveConfigID = C_ClassTalents.GetActiveConfigID
local C_Traits_GetNodeInfo = C_Traits.GetNodeInfo
local C_UnitAuras_GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex

local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
local function getPlayerAura(spellID, filter)
	for i = 1, 255 do
		local auraData = C_UnitAuras_GetAuraDataByIndex("player", i, filter)
		if auraData and auraData.spellId == spellID then
			return auraData.name, auraData.applications
		end
	end
end

-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
local helper = {}

helper.name = L["DS Estimator"]
helper.dbKey = "deathStrikeEstimator"

helper.checkRequirements = function()
	if E.myclass ~= "DEATHKNIGHT" then
		return false
	end

	if not E.private.unitframe.enable or not E.db.unitframe.units.player.enable then
		return false
	end

	if not _G.ElvUF_Player then
		return false
	end

	return true
end

helper.env = {
	estimated = 0,
	windowLength = 5 - 1 / 30,
	excludeSpells = {
		204611, -- 粉碎之握
		204658, -- 粉碎之握
		209858, -- 亡域傷口
		223414, -- 寄生束縛
		240443, -- 爆發
		240447, -- 地震
		240448, -- 地震
		240559, -- 重創傷
		243237, -- 爆發
		258837, -- 劈斬靈魂
		315161, -- 腐化之眼
		343520, -- 風暴
	},
	auras = {
		-- SELF BUFFS
		[55233] = { mod = 0.3 }, -- 血族之裔
		[273947] = { mod = 0.08, perStack = true }, -- 凝血作用
		[391459] = { mod = 0.05 }, -- 血紅之地
		-- EXTERNAL BUFFS
		[64843] = { mod = 0.04, perStack = true }, -- 神聖禮頌
		[72221] = { mod = 0.05, perStack = true }, -- 幸運競逐者
		[47788] = { mod = 0.6 }, -- 守護聖靈
		[139068] = { mod = 0.05, perStack = true }, -- 意志堅定
		[389574] = { mod = 0.02 }, -- 心心相印

		-- DEBUFFS
		-- [209858] = { mod = -0.02, perStack = true, isDebuff = true },    -- 亡域傷口
	},
}

local function init()
	if helper.initialized or not E.private.unitframe.enable or not _G.ElvUF_Player then
		return
	end

	helper.initialized = true

	local frame = CreateFrame("Frame", nil, _G.ElvUF_Player.Health)
	frame:SetAllPoints(_G.ElvUF_Player.Health)
	frame:SetFrameStrata(_G.ElvUF_Player.HealthPrediction.absorbBar:GetFrameStrata())
	frame:SetFrameLevel(_G.ElvUF_Player.HealthPrediction.absorbBar:GetFrameLevel() + 2)
	helper.env.frame = frame

	frame.tex = frame:CreateTexture(nil, "OVERLAY", nil, 7)

	helper.updateUI()
end

local function profileUpdate(_, db)
	helper.db = db

	if not db.enable or not helper.checkRequirements() then
		if helper.env.frame then
			helper.env.frame:Hide()
		end
		return
	end

	init()

	if helper.initialized then
		helper.env.frame.tex:SetWidth(db.width)
		helper.env.frame.tex:SetHeight(db.height)
		if db.sparkTexture then
			helper.env.frame.tex:SetTexture("Interface/RaidFrame/Shield-Overshield")
			helper.env.frame.tex:SetBlendMode("ADD")
		else
			helper.env.frame.tex:SetTexture(LSM:Fetch("statusbar", db.texture))
			helper.env.frame.tex:SetBlendMode("BLEND")
		end
		helper.env.frame.tex:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
		helper.env.frame:Show()
	end

	helper.updateUI()
end

local function updateUI()
	local frame = helper.env.frame
	local tex = frame and frame.tex

	if not tex then
		return
	end

	if helper.env.estimated == 0 or UnitIsDeadOrGhost("player") then
		tex:Hide()
		return
	end

	if E.myclass ~= "DEATHKNIGHT" then
		tex:Hide()
		return
	end

	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local percent = (health + helper.env.estimated) / maxHealth

	if helper.db.hideIfTheBarOutside and percent > 1 then
		tex:Hide()
		return
	end

	if helper.db.onlyInCombat and not InCombatLockdown() then
		tex:Hide()
		return
	end

	tex:ClearAllPoints()
	tex:SetPoint("CENTER", frame, "LEFT", percent * frame:GetWidth(), helper.db.yOffset)
	tex:Show()
end

helper.init = init
helper.profileUpdate = profileUpdate
helper.updateUI = updateUI

-------------------------------------------------------------------------------
-- Core logic
-- Modified from https://wago.io/XWYq95lH5
-------------------------------------------------------------------------------
local damageDB = {
	windowDamage = {},
	windowTimes = {},
	totalDamage = 0,
}

function damageDB:clear()
	wipe(self.windowDamage)
	wipe(self.windowTimes)
	self.totalDamage = 0
end

function damageDB:add(damage)
	if E.myclass ~= "DEATHKNIGHT" then
		return
	end

	tinsert(self.windowTimes, GetTime())
	tinsert(self.windowDamage, damage)
	self.totalDamage = self.totalDamage + damage

	E:Delay(helper.env.windowLength, damageDB.calculate, damageDB)
end

function damageDB:update()
	local currentTime = GetTime()
	while #self.windowTimes > 0 and currentTime > self.windowTimes[1] + helper.env.windowLength do
		local damage = self.windowDamage[1]
		local time = self.windowTimes[1]
		tremove(self.windowDamage, 1)
		tremove(self.windowTimes, 1)
		self.totalDamage = self.totalDamage - damage
	end
end

function damageDB:calculate()
	if E.myclass ~= "DEATHKNIGHT" then
		return
	end

	self:update()

	-- Versatility Rating
	local vers_mult = 1
		+ (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100

	-- reset base on heal
	local healPercent = 0.25
	local healPercentMin = 0.07

	-- voracious talent
	if IsPlayerSpell(273953) then
		healPercentMin = healPercentMin + 0.011 -- ??? experimentally found
		healPercent = healPercent * 1.15
	end

	-- improved death strike talent
	if IsPlayerSpell(374277) then
		healPercentMin = healPercentMin + 0.004 -- ??? experimentally found
		healPercent = healPercent * 1.05
	end

	-- improved vampiric blood talent
	local configID = C_ClassTalents_GetActiveConfigID()
	local improve_vamp_info = configID and C_Traits_GetNodeInfo(configID, 76140)
	local num_improve_vamp = improve_vamp_info and improve_vamp_info.ranksPurchased or 0
	helper.env.auras[55233].mod = 0.3 + (num_improve_vamp * 0.05)

	-- Multiply Auras
	local aura_mult = 1
	for spellID, param in pairs(helper.env.auras) do
		local name, stacks = getPlayerAura(spellID, param.isDebuff and "HARMFUL" or "HELPFUL")
		if name then
			aura_mult = aura_mult * (1 + (param.mod * (param.perStack and stacks or 1)))
		end
	end

	local heal = self.totalDamage * healPercent
	heal = math_max(healPercentMin * UnitHealthMax("player"), heal)
	helper.env.estimated = heal * vers_mult * aura_mult

	updateUI()
end

helper.env.damageDB = damageDB

--------------------------------------------------------------------------------
-- Normal Event Handlers
--------------------------------------------------------------------------------
local function UNIT_MAXHEALTH(module, event, target)
	if target == "player" then
		damageDB:calculate()
	end
end

local function UNIT_HEALTH(module, event, target)
	if target == "player" then
		updateUI()
	end
end

local function UNIT_AURA(module, event, target)
	if target == "player" then
		damageDB:calculate()
	end
end

local function COMBAT_RATING_UPDATE()
	damageDB:calculate()
end

helper.eventHandlers = {
	["UNIT_MAXHEALTH"] = UNIT_MAXHEALTH,
	["UNIT_AURA"] = UNIT_AURA,
	["COMBAT_RATING_UPDATE"] = COMBAT_RATING_UPDATE,
	["UNIT_HEALTH"] = UNIT_HEALTH,
}

--------------------------------------------------------------------------------
-- CLEU Event Handlers
--------------------------------------------------------------------------------
local function SWING_DAMAGE(module, params)
	if not (params and params[8] and params[8] == E.myguid) then
		return
	end

	damageDB:add(params[12])
end

local function SPELL_ABSORBED(module, params)
	if not (params and params[8] and params[8] == E.myguid) then
		return
	end

	if params[20] then
		local spellId = params[12]
		if spellId and not helper.env.excludeSpells[spellId] then
			return
		end

		return damageDB:add(params[22])
	end

	damageDB:add(params[19])
end

local function SPELL_DAMAGE(module, params)
	if not (params and params[8] and params[8] == E.myguid) then
		return
	end

	local spellId = params[12]
	if not spellId or helper.env.excludeSpells[spellId] then
		return
	end

	damageDB:add(params[15])
end

helper.cleuHandlers = {
	["SWING_DAMAGE"] = SWING_DAMAGE,
	["SPELL_ABSORBED"] = SPELL_ABSORBED,
	["RANGE_DAMAGE"] = SPELL_DAMAGE,
	["SPELL_DAMAGE"] = SPELL_DAMAGE,
	["SPELL_PERIODIC_DAMAGE"] = SPELL_DAMAGE,
	["SPELL_BUILDING_DAMAGE"] = SPELL_DAMAGE,
}

CH:RegisterHelper(helper)
