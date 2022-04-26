local W, F, E, L = unpack(select(2, ...))
local T = W:GetModule("Tooltips")

local _G = _G
local gsub = gsub
local pairs = pairs
local strfind = strfind
local unpack = unpack

local GetItemIcon = GetItemIcon
local GetSpellTexture = GetSpellTexture
local IsAddOnLoaded = IsAddOnLoaded
local UnitBattlePetSpeciesID = UnitBattlePetSpeciesID
local UnitBattlePetType = UnitBattlePetType
local UnitFactionGroup = UnitFactionGroup
local UnitIsBattlePet = UnitIsBattlePet
local UnitIsPlayer = UnitIsPlayer

local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

local newString = "0:0:64:64:5:59:5:59"

local PET_TYPE_SUFFIX = PET_TYPE_SUFFIX
_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:" .. newString .. "|t |cffffffff%2$s|r %3$s"
_G.BONUS_OBJECTIVE_REWARD_FORMAT = "|T%1$s:16:16:" .. newString .. "|t %2$s"

local function SetTooltipIcon(self, icon)
    local title = icon and _G[self:GetName() .. "TextLeft1"]
    if title then
        title:SetFormattedText("|T%s:20:20:" .. newString .. ":%d|t %s", icon, 20, title:GetText())
    end
end

local function NewTooltipHooker(method, func)
    return function(tooltip)
        local modified = false
        tooltip:HookScript(
            "OnTooltipCleared",
            function()
                modified = false
            end
        )
        tooltip:HookScript(
            method,
            function(self, ...)
                if not modified then
                    modified = true
                    func(self, ...)
                end
            end
        )
    end
end

local HookItem =
    NewTooltipHooker(
    "OnTooltipSetItem",
    function(self)
        local _, link = self:GetItem()
        if link then
            SetTooltipIcon(self, GetItemIcon(link))
        end
    end
)

local HookSpell =
    NewTooltipHooker(
    "OnTooltipSetSpell",
    function(self)
        local name, id = self:GetSpell()
        if id then
            SetTooltipIcon(self, GetSpellTexture(id))
        end
    end
)

function T:FixCompareItems(_, anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
    local point = shoppingTooltip1:GetPoint(2)
    if secondaryItemShown then
        if point == "TOP" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:Point("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:Point("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 3, 0)
        elseif point == "RIGHT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:Point("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:Point("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -3, 0)
        end
    else
        if point == "LEFT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:Point("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
        elseif point == "RIGHT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:Point("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
        end
    end
end

function T:ReskinRewardIcon(icon)
    if icon and icon.Icon then
        icon.Icon:SetTexCoord(unpack(E.TexCoords))
        icon.IconBorder:Hide()
    end
end

function T:QuestUtils_AddQuestCurrencyRewardsToTooltip(_, _, icon)
    self:ReskinRewardIcon(icon)
end

function T:AddFactionIcon(tt, unit, guid)
    if UnitIsPlayer(unit) then
        local faction = UnitFactionGroup(unit)
        if faction and faction ~= "Neutral" then
            if not tt.factionFrame then
                local f = tt:CreateTexture(nil, "OVERLAY")
                f:SetPoint("TOPRIGHT", 0, -5)
                f:SetSize(35, 35)
                f:SetBlendMode("ADD")
                tt.factionFrame = f
            end
            tt.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-" .. faction)
            tt.factionFrame:SetAlpha(0.5)
        end
    end
end

function T:ClearFactionIcon(tt)
    if tt.factionFrame and tt.factionFrame:GetAlpha() ~= 0 then
        tt.factionFrame:SetAlpha(0)
    end
end

function T:AddPetIcon(tt, unit, guid)
    if UnitIsBattlePet(unit) then
        if not tt.petIcon then
            local f = tt:CreateTexture(nil, "OVERLAY")
            f:SetPoint("TOPRIGHT", -5, -5)
            f:SetSize(35, 35)
            f:SetBlendMode("ADD")
            tt.petIcon = f
        end
        tt.petIcon:SetTexture("Interface\\PetBattles\\PetIcon-" .. PET_TYPE_SUFFIX[UnitBattlePetType(unit)])
        tt.petIcon:SetTexCoord(.188, .883, 0, .348)
        tt.petIcon:SetAlpha(1)
    end
end

function T:ClearPetIcon(tt)
    if tt.petIcon and tt.petIcon:GetAlpha() ~= 0 then
        tt.petIcon:SetAlpha(0)
    end
end

function T:AddPetID(tt, unit, guid)
    if UnitIsBattlePet(unit) then
        local speciesID = UnitBattlePetSpeciesID(unit)
        speciesID = speciesID and F.CreateColorString(speciesID, E.db.general.valuecolor)
        tt:AddDoubleLine(L["Pet ID"] .. ":", speciesID or ("|cffeeeeee" .. L["Unknown"] .. "|r"))
    end
end

function T:Icons()
    if E.private.WT.tooltips.icon then
        HookItem(_G.GameTooltip)
        HookSpell(_G.GameTooltip)
        HookItem(_G.ItemRefTooltip)
        HookSpell(_G.ItemRefTooltip)

        self:SecureHook("EmbeddedItemTooltip_SetItemByQuestReward", "ReskinRewardIcon")
        self:SecureHook("EmbeddedItemTooltip_SetItemByID", "ReskinRewardIcon")
        self:SecureHook("EmbeddedItemTooltip_SetCurrencyByID", "ReskinRewardIcon")
        self:SecureHook("QuestUtils_AddQuestCurrencyRewardsToTooltip")
        self:SecureHook("GameTooltip_AnchorComparisonTooltips", "FixCompareItems")
    end

    if E.private.WT.tooltips.factionIcon then
        self:AddInspectInfoCallback(1, "AddFactionIcon", false, "ClearFactionIcon")
    end

    if E.private.WT.tooltips.petIcon then
        self:AddInspectInfoCallback(2, "AddPetIcon", false, "ClearPetIcon")
    end

    if E.private.WT.tooltips.petId then
        self:AddInspectInfoCallback(3, "AddPetID", false)
    end
end

T:AddCallback("Icons")
