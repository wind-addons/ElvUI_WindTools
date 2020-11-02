local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local select = select
local strmatch = strmatch

local GameMovieFinished = GameMovieFinished

function M:SkipCutScene()
    local MovieFrame_PlayMovieOld = _G.MovieFrame_PlayMovie
    local ChatFrame_OnHyperlinkShowOld = _G.ChatFrame_OnHyperlinkShow

    _G.MovieFrame_PlayMovie = function(frame, movieID, override)
        if E.db and E.db.WT and E.db.WT.misc and E.db.WT.misc.skipCutScene and not override then
            GameMovieFinished()
            F.Print(format("%s |cff71d5ff|Hwtcutscene:%s|h[%s]|h|r", L["Skipped the cutscene."], movieID, L["Replay"]))
            return
        end

        MovieFrame_PlayMovieOld(frame, movieID)
    end

    _G.ChatFrame_OnHyperlinkShow = function(...)
        local link = select(2, ...)
        local movieID = link and strmatch(link, "wtcutscene:(%d+)")
        if movieID then
            _G.MovieFrame_PlayMovie(_G.MovieFrame, movieID, true)
            return
        end
        ChatFrame_OnHyperlinkShowOld(...)
    end
end

M:AddCallback("SkipCutScene")
