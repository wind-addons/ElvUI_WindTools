local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_TalkingHeadUI()
    if not self:CheckDB("talkinghead", "talkingHead") then
        return
    end

    if not E.db.general.talkingHeadFrameBackdrop then
        return
    end

    self:CreateShadow(_G.TalkingHeadFrame)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI")
