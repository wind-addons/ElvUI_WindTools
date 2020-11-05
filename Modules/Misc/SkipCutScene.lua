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

    local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
    function _G.ItemRefTooltip:SetHyperlink(data, ...)
        if strsub(data, 1, 10) == "wtcutscene" then
            local movieID = strmatch(data, "wtcutscene:(%d+)")
            if movieID then
                _G.MovieFrame_PlayMovie(_G.MovieFrame, movieID, true)
                return
            end
        end
        SetHyperlink(self, data, ...)
    end
end

M:AddCallback("SkipCutScene")
