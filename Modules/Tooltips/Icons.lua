-- 来自 Ndui
local W, F, E, L = unpack(select(2, ...))
local T = W:GetModule("Tooltips")

local _G = _G
local strfind, gsub = strfind, gsub
local GetItemIcon, GetSpellTexture = GetItemIcon, GetSpellTexture
local IsAddOnLoaded, IsAzeriteEmpoweredItemByID = IsAddOnLoaded, IsAzeriteEmpoweredItemByID

local newString = "0:0:64:64:5:59:5:59"

_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:" .. newString .. "|t |cffffffff%2$s|r %3$s"
_G.BONUS_OBJECTIVE_REWARD_FORMAT = "|T%1$s:16:16:" .. newString .. "|t %2$s"

local function SetTooltipIcon(self, icon)
    local title = icon and _G[self:GetName() .. "TextLeft1"]
    if title then
        title:SetFormattedText("|T%s:20:20:" .. newString .. ":%d|t %s", icon, 20, title:GetText())
    end

    if self.NoWindItemIcon then
        return
    end
    for i = 2, self:NumLines() do
        local line = _G[self:GetName() .. "TextLeft" .. i]
        if not line then
            break
        end
        local text = line:GetText() or ""
        if strfind(text, "|T.+|t") then
            line:SetText(gsub(text, ":(%d+)|t", ":20:20:" .. newString .. "|t"))
        end
    end
end

local function FixCompareItems(self, anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
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
            if IsAddOnLoaded("AzeriteTooltip") and IsAzeriteEmpoweredItemByID(link) then
                self.NoWindItemIcon = true
            end

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

local function ReskinRewardIcon(self)
    if self and self.Icon then
        self.Icon:SetTexCoord(unpack(E.TexCoords))
        self.IconBorder:Hide()
    end
end

function T:Icons()
    if not E.private.WT.tooltips.icon then
        return
    end

    for _, tooltip in pairs {GameTooltip, ItemRefTooltip} do
        HookItem(tooltip)
        HookSpell(tooltip)
    end

    hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward", ReskinRewardIcon)
    hooksecurefunc("EmbeddedItemTooltip_SetItemByID", ReskinRewardIcon)
    hooksecurefunc("EmbeddedItemTooltip_SetCurrencyByID", ReskinRewardIcon)
    hooksecurefunc(
        "QuestUtils_AddQuestCurrencyRewardsToTooltip",
        function(_, _, self)
            ReskinRewardIcon(self)
        end
    )
    hooksecurefunc("GameTooltip_AnchorComparisonTooltips", FixCompareItems)
end

T:AddCallback("Icons")
