local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G

function M:TalkingHeadFrame_PlayCurrent()
    if E.db.WT.misc.disableTalkingHead then
        _G.TalkingHeadFrame_CloseImmediately()
    end
end

function M:TalkingHead_LoadUI()
    self:SecureHook("TalkingHeadFrame_PlayCurrent")
end

function M:DisableTalkingHead()
    if _G.TalkingHeadFrame then
        M:SecureHook("TalkingHeadFrame_PlayCurrent")
    else
        M:SecureHook("TalkingHead_LoadUI")
    end
end

M:AddCallback("DisableTalkingHead")
