local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc
local select = select

local GetInstanceInfo = GetInstanceInfo
local IsInJailersTower = IsInJailersTower

local function SetupOptions()
    if not _G.PlayerChoiceFrame.windStyle then
        S:CreateShadow(_G.PlayerChoiceFrame)
    end

    local instanceType, _, _, _, _, _, instanceID = select(2, GetInstanceInfo())
    local needDisable = IsInJailersTower() or instanceType == "party" or instanceType == "raid" or instanceID == 2374

    -- Hold shadow in garrison
    if needDisable then
        if instanceID == 1159 then
            needDisable = false
        end
    end

    if _G.PlayerChoiceFrame.shadow then
        if needDisable then
            _G.PlayerChoiceFrame.shadow:Hide()
        else
            _G.PlayerChoiceFrame.shadow:Show()
        end
    end
end

function S:Blizzard_PlayerChoice()
    if not self:CheckDB("playerChoice") then
        return
    end

    hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

S:AddCallbackForAddon("Blizzard_PlayerChoice")
