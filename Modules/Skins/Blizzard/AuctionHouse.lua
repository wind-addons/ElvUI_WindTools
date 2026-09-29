local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_AuctionHouseUI")
data.toggle = "auctionhouse"
data.private = "auctionHouse"

local _G = _G
local pairs = pairs

function S:Blizzard_AuctionHouseUI()
	self:CreateShadow(_G.AuctionHouseFrame)
	self:CreateShadow(_G.AuctionHouseFrame.WoWTokenResults.GameTimeTutorial)

	local tabs = { _G.AuctionHouseFrameBuyTab, _G.AuctionHouseFrameSellTab, _G.AuctionHouseFrameAuctionsTab }
	for _, tab in pairs(tabs) do
		if tab then
			self:CreateBackdropShadow(tab)
		end
	end
end

