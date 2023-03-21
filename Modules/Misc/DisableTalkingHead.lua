local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G

function M:TalkingHeadFrame_PlayCurrent(frame)
    if frame and E.db.WT.misc.disableTalkingHead then
        frame:CloseImmediately()
    end
end

function M:HookTalkingHeadPlayCurrent()
    self:SecureHook(_G.TalkingHeadFrame, "PlayCurrent", "TalkingHeadFrame_PlayCurrent")
end

function M:DisableTalkingHead()
    if _G.TalkingHeadFrame then
        self:HookTalkingHeadPlayCurrent()
    else
        self:SecureHook("TalkingHead_LoadUI", "HookTalkingHeadPlayCurrent")
    end
end

M:AddCallback("DisableTalkingHead")
