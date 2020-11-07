local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local select = select
local strmatch = strmatch
local strsub = strsub

local CinematicFrame_CancelCinematic = CinematicFrame_CancelCinematic
local IsModifierKeyDown = IsModifierKeyDown
local GameMovieFinished = GameMovieFinished

do
    local alreadySkipped = false
    local function TrySkip()
        if alreadySkipped then
            return
        end
        CinematicFrame_CancelCinematic()
        E:Delay(
            0.1,
            function()
                if not _G.CinematicFrame:IsShown() then
                    F.Print(L["Skipped the cutscene."])
                    alreadySkipped = true
                end
            end
        )
    end

    function M:CINEMATIC_START()
        if E.private.WT and E.private.WT.misc.skipCutScene and not IsModifierKeyDown() then
            E:Delay(0.1, TrySkip)
            E:Delay(1, TrySkip)
            E:Delay(3, TrySkip)
            E:Delay(
                3.5,
                function()
                    if not alreadySkipped then
                        F.Print(L["This cutscene cannot be skipped."])
                    else
                        alreadySkipped = false
                    end
                end
            )
        end
    end
end

do
    local initialized = false
    function M:SkipCutScene()
        if not E.private.WT.misc.skipCutScene or initialized then
            return
        end

        local PlayMovie = _G.MovieFrame_PlayMovie

        _G.MovieFrame_PlayMovie = function(frame, movieID, override)
            if E.private.WT and E.private.WT.misc.skipCutScene and not override then
                if not IsModifierKeyDown() then
                    GameMovieFinished()
                    F.Print(
                        format(
                            "%s |cff71d5ff|Hwtcutscene:%s|h[%s]|h|r",
                            L["Skipped the cutscene."],
                            movieID,
                            L["Replay"]
                        )
                    )
                    return
                end
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

        M:RegisterEvent("CINEMATIC_START")

        initialized = true
    end
end

M:AddCallback("SkipCutScene")
