local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local RU = E:GetModule("RaidUtility")

local _G = _G
local pairs = pairs
local InCombatLockdown = InCombatLockdown

function S:RaidUtility()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.nonraid) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.raidUtility) then
        return
    end

    local frames = {_G.RaidUtilityPanel, _G.RaidUtility_ShowButton, _G.RaidUtility_CloseButton, _G.RaidUtilityRoleIcons}

    for _, frame in pairs(frames) do
        S:CreateShadow(frame)
    end

    S:SecureHookScript(
        RaidUtility_ShowButton,
        "OnClick",
        function()
            if not InCombatLockdown() then
                _G.RaidUtility_CloseButton:ClearAllPoints()
                _G.RaidUtility_CloseButton:Point("TOP", _G.RaidUtilityPanel, "BOTTOM", 0, -4)
            end
        end
    )
end

S:AddCallback("RaidUtility")
