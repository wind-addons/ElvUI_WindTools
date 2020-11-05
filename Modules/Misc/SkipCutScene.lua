local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local select = select
local strmatch = strmatch
local strsub = strsub

local GameMovieFinished = GameMovieFinished

local initialized = false

function M:SkipCutScene()
    if not E.private.WT.misc.skipCutScene or initialized then
        return
    end

    local PlayMovie = _G.MovieFrame_PlayMovie

    _G.MovieFrame_PlayMovie = function(frame, movieID, override)
        if E.private.WT and E.private.WT.misc.skipCutScene and not override then
            GameMovieFinished()
            F.Print(format("%s |cff71d5ff|Hwtcutscene:%s|h[%s]|h|r", L["Skipped the cutscene."], movieID, L["Replay"]))
            return
        end

        PlayMovie(frame, movieID)
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

    initialized = true
end

M:AddCallback("SkipCutScene")
