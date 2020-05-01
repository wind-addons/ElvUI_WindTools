local _, NameSpace = ...
local W, F, DB, E, L, V, P, G = unpack(NameSpace)
local S = W:GetModule('Skins')

local _G = _G

function S:BlizzardMiscFrames()
    S:CreateShadow(_G.GameMenuFrame)
end

S:AddCallback('BlizzardMiscFrames')