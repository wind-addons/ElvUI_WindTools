local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local M = W.Modules.Misc ---@class Misc
local C = W.Utilities.Color

local _G = _G
local format = format
local hooksecurefunc = hooksecurefunc
local time = time

local CinematicFrame_CancelCinematic = CinematicFrame_CancelCinematic
local EventRegistry = EventRegistry
local IsModifierKeyDown = IsModifierKeyDown

local Enum_CinematicType_GameMovie = Enum.CinematicType.GameMovie

local initialized = false
local forceSkipMovie = false
local cinematicStartTime = 0
local lastTryCinematicSkipTime = 0

local function setForceSkipMovie(value)
	if value then
		forceSkipMovie = true
		E:Delay(3, function()
			forceSkipMovie = false
		end)
	else
		forceSkipMovie = false
	end
end

local function trySkipCinematic(numTry)
	if not _G.CinematicFrame:IsShown() then
		F.Print(L["Skipped the cutscene."])
		return
	end

	if numTry > 3 then
		F.Print(L["This cutscene cannot be skipped."])
		return
	end

	CinematicFrame_CancelCinematic()
	E:Delay(1, trySkipCinematic, numTry + 1)
end

local function CinematicFrame_CinematicStarting_Callback()
	if not E.private.WT or not E.private.WT.misc.skipCutScene then
		return
	end

	cinematicStartTime = time()
end

local function Subtitles_OnMovieCinematicPlay_Callback()
	if not E.private.WT or not E.private.WT.misc.skipCutScene then
		return
	end

	if IsModifierKeyDown() then
		return
	end

	if E.private.WT.misc.onlyStopWatched then
		return
	end

	if time() - cinematicStartTime < 4 and time() - lastTryCinematicSkipTime > 3 then
		cinematicStartTime = 0
		lastTryCinematicSkipTime = time()
		trySkipCinematic(1)
	end
end

function M:MovieCinematicStarted(movieType, movieID)
	-- /run MovieFrame_PlayMovie(MovieFrame, 993)
	if not E.private.WT or movieType ~= Enum_CinematicType_GameMovie then
		return
	end

	local skip = not E.private.WT.misc.onlyStopWatched or E.global.WT.misc.watched.movies[movieID]
	E.global.WT.misc.watched.movies[movieID] = true

	if not E.private.WT.misc.skipCutScene then
		return
	end

	if IsModifierKeyDown() or not skip then
		setForceSkipMovie(false)
	else
		setForceSkipMovie(true)
		_G.MovieFrame_StopMovie(_G.MovieFrame)
		local link = format("|Hwtlink:cutscene:%s|h[%s]|h", movieID, L["Replay"])
		F.Print(L["Skipped the cutscene."], C.StringByTemplate(link, "sky-400"))
	end
end

function M:AddCutSceneReplayCustomLink()
	W:RegisterLinkOperation("cutscene", function(movieID, ...)
		if not movieID then
			return
		end
		E.global.WT.misc.watched.movies[movieID] = nil
		_G.MovieFrame_PlayMovie(_G.MovieFrame, movieID)
	end)
end

function M:HookSubtitlesFrame()
	if not _G.MovieFrame or not _G.SubtitlesFrame then
		return
	end

	-- Try to hide SubtitlesFrame when it shows after delay
	hooksecurefunc(_G.SubtitlesFrame, "Show", function(frame)
		if not forceSkipMovie then
			return
		end

		frame:Hide()
	end)

	-- Fix: SubtitlesFrame not hide when MovieFrame hide
	if _G.MovieFrame then
		hooksecurefunc(_G.MovieFrame, "Hide", function()
			E:Delay(1, _G.SubtitlesFrame.Hide, _G.SubtitlesFrame)
		end)
	end

	-- Fix: SubtitlesFrame not hide when CinematicFrame hide
	if _G.CinematicFrame then
		hooksecurefunc(_G.CinematicFrame, "Hide", function()
			E:Delay(1, _G.SubtitlesFrame.Hide, _G.SubtitlesFrame)
		end)
	end
end

function M:SkipCutScene()
	if not E.private.WT.misc.skipCutScene or initialized then
		return
	end

	self:AddCutSceneReplayCustomLink()
	self:SecureHook("CinematicStarted", "MovieCinematicStarted") -- Movie
	EventRegistry:RegisterCallback("CinematicFrame.CinematicStarting", CinematicFrame_CinematicStarting_Callback) -- Cinematic
	EventRegistry:RegisterCallback("Subtitles.OnMovieCinematicPlay", Subtitles_OnMovieCinematicPlay_Callback) -- Subtitles

	initialized = true
end

M:AddCallback("SkipCutScene")
M:AddCallbackForAddon("Blizzard_Subtitles", "HookSubtitlesFrame")
