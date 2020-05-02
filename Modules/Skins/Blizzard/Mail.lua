local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:MailFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.mail) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.mail) then return end

    S:CreateShadow(_G.MailFrame)
    S:CreateShadow(_G.OpenMailFrame)

    for i = 1, 2 do S:CreateTabShadow(_G["MailFrameTab" .. i]) end
end

S:AddCallback('MailFrame')
