local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:HelpFrame()
    if not self:CheckDB("help") then
        return
    end

    if _G.HelpFrame then
        self:CreateBackdropShadow(_G.HelpFrame)
        if _G.HelpFrame.Header then
            self:CreateBackdropShadowAfterElvUISkins(_G.HelpFrame.Header)
        end
    end
end

S:AddCallback("HelpFrame")
