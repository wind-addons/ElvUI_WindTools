local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local WS = S.Widgets
local ES = E.Skins

function WS:HandleTab(_, tab, noBackdrop, template)
end

WS:SecureHook(ES, "HandleTab")
