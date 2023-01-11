local W, F, E, L = unpack(select(2, ...))
local CH = W:GetModule("ClassHelper")

-- the calculation logic from https://wago.io/XWYq95lH5

local estimated = 0

local WINDOW_LENGTH = 5 - 1 / 30
local DAMAGE_PERCENT_HEAL = 0.25
local MIN_PERCENT_HEAL = 0.07

local excludeSpells = {
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
    343520 -- 風暴
}

local auras = {
    -- SELF BUFFS
    [55233] = {mod = 0.3}, -- Vampiric Blood
    [273947] = {mod = 0.08, perStack = true}, -- Hemostatis
    [391459] = {mod = 0.05}, -- Sanguine Ground
    -- EXTERNAL BUFFS
    [64843] = {mod = 0.04}, -- Divine Hymn
    [72221] = {mod = 0.05, perStack = true}, -- (LFG) Luck of the Draw
    [47788] = {mod = 0.6}, -- Guardian Spirit
    [139068] = {mod = .05, perStack = true}, -- Determination
    [389574] = {mod = .08} -- Close to Heart monk buff 2pts = 8%

    -- DEBUFFS
    -- [209858] = { mod = -0.02, perStack = true, isDebuff = true },    -- (M+Affix) Necrotic
}

local function getPlayerAura(spellId, filter)
    for i = 1, 255 do
        local name, _, stacks, _, _, _, _, _, _, spellId = UnitAura("player", i, filter)
        if not name then
            return
        end
        if spell == spellId then
            return name, stacks
        end
    end
end

local function getGlow()
    if not _G.ElvUF_Player then
        return
    end

    if not _G.ElvUF_Player.windDSEGlowFrame then
        local dseGlowFrame = CreateFrame("Frame", nil, _G.ElvUF_Player)
        dseGlowFrame:SetAllPoints(_G.ElvUF_Player)
        dseGlowFrame:SetFrameStrata(_G.ElvUF_Player.HealthPrediction.absorbBar:GetFrameStrata())
        dseGlowFrame:SetFrameLevel(_G.ElvUF_Player.HealthPrediction.absorbBar:GetFrameLevel() + 1)
        _G.ElvUF_Player.windDSEGlowFrame = dseGlowFrame

        local glow = dseGlowFrame:CreateTexture(nil, "OVERLAY", nil, 7)
        glow:SetTexture(E.Media.Textures.White8x8)
        glow:SetVertexColor(1, 0, 0, 1)
        glow:SetWidth(5)
        glow:Hide()
        _G.ElvUF_Player.windDSEGlowFrame.glow = glow
    end

    return _G.ElvUF_Player.windDSEGlowFrame.glow
end

local function updateGlow()
    local glow = getGlow()

    if not glow then
        return
    end

    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local percent = (health + estimated) / maxHealth
    if percent > 1 or estimated == 0 then
        glow:Hide()
        return
    end

    glow:SetHeight(36)
    glow:ClearAllPoints()
    glow:SetPoint("CENTER", glow:GetParent(), "LEFT", percent * glow:GetParent():GetWidth(), 0)
    glow:Show()
end

local cache = {
    windowDamage = {},
    windowTimes = {},
    totalDamage = 0
}

function cache:clear()
    wipe(self.windowDamage)
    wipe(self.windowTimes)
    self.totalDamage = 0
end

function cache:add(damage)
    tinsert(self.windowTimes, GetTime())
    tinsert(self.windowDamage, damage)
    self.totalDamage = self.totalDamage + damage

    E:Delay(WINDOW_LENGTH, cache.calculate, cache)
end

function cache:update()
    local currrentTime = GetTime()
    while (#self.windowTimes > 0 and currrentTime > self.windowTimes[1] + WINDOW_LENGTH) do
        local damage = self.windowDamage[1]
        local time = self.windowTimes[1]
        tremove(self.windowDamage, 1)
        tremove(self.windowTimes, 1)
        self.totalDamage = self.totalDamage - damage
    end
end

function cache:calculate()
    self:update()

    -- Versatility Rating
    local vers_mult =
        1 + (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100

    -- reset base on heal
    DAMAGE_PERCENT_HEAL = 0.25
    MIN_PERCENT_HEAL = 0.07

    -- voracious talent
    if (IsPlayerSpell(273953)) then
        MIN_PERCENT_HEAL = MIN_PERCENT_HEAL + 0.011 -- ??? experimentally found
        DAMAGE_PERCENT_HEAL = DAMAGE_PERCENT_HEAL * 1.15
    end

    -- improved death strike talent
    if (IsPlayerSpell(374277)) then
        MIN_PERCENT_HEAL = MIN_PERCENT_HEAL + 0.004 -- ??? experimentally found
        DAMAGE_PERCENT_HEAL = DAMAGE_PERCENT_HEAL * 1.05
    end

    -- improved vampiric blood talent
    local improv_vamp_info = C_Traits.GetNodeInfo(C_ClassTalents.GetActiveConfigID(), 76140)
    local num_improv_vamp = improv_vamp_info and improv_vamp_info.ranksPurchased or 0
    auras[55233].mod = 0.3 + (num_improv_vamp * 0.05)

    -- Multiply Auras
    local aura_mult = 1
    for spellId, param in pairs(auras) do
        local filter = param.isDebuff and "HARMFUL" or "HELPFUL"
        local name, stacks = getPlayerAura(spellId, filter)
        if name then
            aura_mult = aura_mult * (1 + (param.mod * (param.perStack and stacks or 1)))
        end
    end

    local heal = self.totalDamage * DAMAGE_PERCENT_HEAL
    heal = math.max(MIN_PERCENT_HEAL * UnitHealthMax("player"), heal)
    heal = heal * vers_mult * aura_mult
    if (heal ~= estimated) then
        estimated = heal
    end

    updateGlow()
end

local function UNIT_MAXHEALTH(module, event, unitID)
    if unitID == E.myguid then
        cache:calculate()
    end
end

local function UNIT_HEALTH(module, event, target)
    if target == "player" then
        updateGlow()
    end
end

local function UNIT_AURA(module, event, unitID)
    if unitID == E.myguid then
        cache:calculate()
    end
end

local function COMBAT_RATING_UPDATE()
    cache:calculate()
end

local function SWING_DAMAGE(module, params)
    if not (params and params[8] and params[8] == E.myguid) then
        return
    end

    cache:add(params[12])
end

local function SPELL_ABSORBED(module, params)
    if not (params and params[8] and params[8] == E.myguid) then
        return
    end

    if params[20] then
        local spellId = params[12]
        if spellId and not excludeSpells[spellId] then
            return
        end

        return cache:add(params[22])
    end

    cache:add(params[19])
end

local function SPELL_DAMAGE(module, params)
    if not (params and params[8] and params[8] == E.myguid) then
        return
    end

    local spellId = params[12]
    if not spellId or excludeSpells[spellId] then
        return
    end

    cache:add(params[15])
end

CH:RegeisterHelper(
    {
        name = "DeathStrikeEstimator",
        eventHandlers = {
            ["UNIT_MAXHEALTH"] = UNIT_MAXHEALTH,
            ["UNIT_AURA"] = UNIT_AURA,
            ["COMBAT_RATING_UPDATE"] = COMBAT_RATING_UPDATE,
            ["UNIT_HEALTH"] = UNIT_HEALTH
        },
        cleuHandlers = {
            ["SWING_DAMAGE"] = SWING_DAMAGE,
            ["SPELL_ABSORBED"] = SPELL_ABSORBED,
            ["RANGE_DAMAGE"] = SPELL_DAMAGE,
            ["SPELL_DAMAGE"] = SPELL_DAMAGE,
            ["SPELL_PERIODIC_DAMAGE"] = SPELL_DAMAGE,
            ["SPELL_BUILDING_DAMAGE"] = SPELL_DAMAGE
        }
    }
)
