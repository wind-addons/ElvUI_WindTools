local W, F, E, L = unpack(select(2, ...))
local T = W.Modules.Tooltips

local _G = _G
local hooksecurefunc = hooksecurefunc
local select = select
local strfind = strfind
local unpack = unpack

local GetItemIcon = GetItemIcon
local GetSpellTexture = GetSpellTexture
local UnitBattlePetSpeciesID = UnitBattlePetSpeciesID
local UnitBattlePetType = UnitBattlePetType
local UnitFactionGroup = UnitFactionGroup
local UnitIsBattlePet = UnitIsBattlePet
local UnitIsPlayer = UnitIsPlayer

local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_EquipmentSet_GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall

local Enum_TooltipDataType_Item = Enum.TooltipDataType.Item
local Enum_TooltipDataType_Spell = Enum.TooltipDataType.Spell
local Enum_TooltipDataType_Toy = Enum.TooltipDataType.Toy
local Enum_TooltipDataType_Mount = Enum.TooltipDataType.Mount
local Enum_TooltipDataType_Currency = Enum.TooltipDataType.Currency
local Enum_TooltipDataType_EquipmentSet = Enum.TooltipDataType.EquipmentSet

local tooltips = {
    "GameTooltip",
    "ItemRefTooltip",
    "ShoppingTooltip1",
    "ShoppingTooltip2",
    "ItemRefShoppingTooltip1",
    "ItemRefShoppingTooltip2"
}

local PET_TYPE_SUFFIX = PET_TYPE_SUFFIX
_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:0:0:64:64:5:59:5:59|t |cffffffff%2$s|r %3$s"
_G.BONUS_OBJECTIVE_REWARD_FORMAT = "|T%1$s:16:16:0:0:64:64:5:59:5:59|t %2$s"

local iconFunctions = {
    [Enum_TooltipDataType_Item] = function(data)
        return GetItemIcon(data.id)
    end,
    [Enum_TooltipDataType_Spell] = function(data)
        return GetSpellTexture(data.id)
    end,
    [Enum_TooltipDataType_Toy] = function(data)
        return GetItemIcon(data.id)
    end,
    [Enum_TooltipDataType_Mount] = function(data)
        return select(3, C_MountJournal_GetMountInfoByID(data.id))
    end,
    [Enum_TooltipDataType_Currency] = function(data)
        local info = C_CurrencyInfo_GetCurrencyInfo(data.id)
        return info and info.iconFileID
    end,
    [Enum_TooltipDataType_EquipmentSet] = function(data)
        return select(2, C_EquipmentSet_GetEquipmentSetInfo(data.id))
    end
}

local function setTooltipIcon(tt, data, type)
    local icon = iconFunctions[type] and iconFunctions[type](data)
    local title = data.lines and data.lines[1] and data.lines[1].leftText
    local iconString = icon and F.GetIconString(icon, 18, 18, true)

    if not title or not iconString then
        return
    end

    for i = 1, 3 do
        local row = _G[tt:GetName() .. "TextLeft" .. i]
        local existingText = row and row:GetText()
        if existingText and strfind(existingText, title) then
            if iconString and existingText and not strfind(existingText, "^|T") then
                row:SetText(iconString .. " " .. existingText)
            end
            return
        end
    end
end

local function alignShoppingTooltip(tt)
    if not tt or not tt.GetNumPoints or tt:GetNumPoints() < 2 or not tt.__SetPoint then
        return
    end

    local shoppingTooltip1 = _G.ShoppingTooltip1
    local shoppingTooltip2 = _G.ShoppingTooltip2

    local point, anchorFrame = shoppingTooltip1:GetPoint(2)
    if shoppingTooltip2:IsShown() then
        if point == "TOP" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:SetPoint("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 3, 0)
        elseif point == "RIGHT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -3, 0)
        end
    else
        if point == "LEFT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
        elseif point == "RIGHT" then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
        end
    end
end

local function handle(type)
    TooltipDataProcessor_AddTooltipPostCall(
        type,
        function(tt, data)
            if not data or not data.id or not data.lines or not tt.GetName or not F.In(tt:GetName(), tooltips) then
                return
            end

            setTooltipIcon(tt, data, type)
        end
    )
end

function T:ReskinRewardIcon(tt)
    if tt and tt.Icon then
        tt.Icon:SetTexCoord(unpack(E.TexCoords))
        tt.IconBorder:Hide()
    end
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
        handle(Enum_TooltipDataType_Item)
        handle(Enum_TooltipDataType_Spell)
        handle(Enum_TooltipDataType_Toy)
        handle(Enum_TooltipDataType_Mount)
        handle(Enum_TooltipDataType_Currency)
        handle(Enum_TooltipDataType_EquipmentSet)

        _G.ShoppingTooltip1.__SetPoint = _G.ShoppingTooltip1.SetPoint
        hooksecurefunc(_G.ShoppingTooltip1, "SetPoint", alignShoppingTooltip)

        self:ReskinRewardIcon(_G.GameTooltip.ItemTooltip)
        self:ReskinRewardIcon(_G.EmbeddedItemTooltip.ItemTooltip)
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
