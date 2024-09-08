local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local strmatch = strmatch

local cache = {}

local function ModifyGuildNews(button, _, text, name, link, ...)
	if not E.private.WT.misc.guildNewsItemLevel then
		return
	end

	if not _G.CommunitiesFrame or not _G.CommunitiesFrame.IsShown or not _G.CommunitiesFrame:IsShown() then
		return
	end

	if not link or not strmatch(link, "|H(item:%d+:.-)|h.-|h") then
		return
	end

	if not cache[link] then
		cache[link] = F.GetRealItemLevelByLink(link)
	end

	if cache[link] then
		local coloredItemLevel = format("|cfff1c40f%s|r", cache[link])
		link = gsub(link, "|h%[(.-)%]|h", "|h[" .. coloredItemLevel .. ":%1]|h")
		button.text:SetFormattedText(text, name, link, ...)
	end
end

function M:GuildNewsItemLevel()
	if not E.private.WT.misc.guildNewsItemLevel then
		return
	end

	hooksecurefunc("GuildNewsButton_SetText", ModifyGuildNews)
end

M:AddCallbackForAddon("Blizzard_Communities", "GuildNewsItemLevel")
