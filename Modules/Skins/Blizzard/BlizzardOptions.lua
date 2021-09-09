local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

local pairs = pairs

function S:BlizzardOptions()
    if not self:CheckDB("blizzardOptions") then
        return
    end

    local frames = {
        "InterfaceOptionsFrame",
        "VideoOptionsFrame",
        "AudioOptionsFrame"
    }

    for _, frame in pairs(frames) do
        self:CreateShadow(_G[frame])
    end
end

S:AddCallback("BlizzardOptions")
