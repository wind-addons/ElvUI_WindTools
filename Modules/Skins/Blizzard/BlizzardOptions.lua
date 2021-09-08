local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BlizzardOptions()
    if not self:CheckDB("blizzardOptions") then
        return
    end

    local miscFrames = {
        "GameMenuFrame",
        "InterfaceOptionsFrame",
        "VideoOptionsFrame",
        "AudioOptionsFrame",
        "AutoCompleteBox"
    }

    for _, frame in pairs(miscFrames) do
        self:CreateShadow(_G[frame])
    end
end

S:AddCallback("BlizzardOptions")
