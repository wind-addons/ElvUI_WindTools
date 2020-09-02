local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local RU = E:GetModule("RaidUtility")

local _G = _G
local pairs = pairs
local InCombatLockdown = InCombatLockdown

function S:RaidUtility_ShowButton_OnClick()
    if InCombatLockdown() then
        return
    end

    _G.RaidUtility_CloseButton:ClearAllPoints()
    _G.RaidUtility_CloseButton:Point("TOP", _G.RaidUtilityPanel, "BOTTOM", 0, -4)
end

function S:RaidUtility()
    if not self:CheckDB("nonraid", "raidUtility") then
        return
    end

    local frames = {
        _G.RaidUtilityPanel,
        _G.RaidUtility_ShowButton,
        _G.RaidUtility_CloseButton,
        _G.RaidUtilityRoleIcons
    }

    for _, frame in pairs(frames) do
        self:CreateShadow(frame)
    end

    self:SecureHookScript(_G.RaidUtility_ShowButton, "OnClick", "RaidUtility_ShowButton_OnClick")
end

S:AddCallback("RaidUtility")
