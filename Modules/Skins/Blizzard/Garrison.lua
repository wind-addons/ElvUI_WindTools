local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:GarrisonTooltips()
	if not self:CheckDB("garrison") then
		return
	end

	local tooltips = {
		_G.GarrisonFollowerTooltip,
		_G.FloatingGarrisonFollowerTooltip,
		_G.FloatingGarrisonMissionTooltip,
		_G.FloatingGarrisonShipyardFollowerTooltip,
		_G.GarrisonShipyardFollowerTooltip,
		_G.GarrisonFollowerAbilityTooltip,
		_G.FloatingGarrisonFollowerAbilityTooltip,
		_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip,
		_G.GarrisonFollowerAbilityWithoutCountersTooltip,
	}

	for _, tooltip in pairs(tooltips) do
		if tooltip then
			self:CreateBackdropShadow(tooltip)
		end
	end
end

function S:Blizzard_GarrisonUI()
	if not self:CheckDB("garrison") then
		return
	end

	local frames = {
		_G.GarrisonCapacitiveDisplayFrame,
		_G.GarrisonMissionFrame,
		_G.GarrisonLandingPage,
		_G.GarrisonBuildingFrame,
		_G.GarrisonShipyardFrame,
		_G.OrderHallMissionFrame,
		_G.OrderHallCommandBar,
		_G.BFAMissionFrame,
		_G.CovenantMissionFrame,
	}

	local tabs = {
		_G.GarrisonMissionFrameTab1,
		_G.GarrisonMissionFrameTab2,
		_G.GarrisonLandingPageTab1,
		_G.GarrisonLandingPageTab2,
		_G.GarrisonLandingPageTab3,
		_G.GarrisonShipyardFrameTab1,
		_G.GarrisonShipyardFrameTab2,
		_G.OrderHallMissionFrameTab1,
		_G.OrderHallMissionFrameTab2,
		_G.OrderHallMissionFrameTab3,
		_G.BFAMissionFrameTab1,
		_G.BFAMissionFrameTab2,
		_G.BFAMissionFrameTab3,
		_G.CovenantMissionFrameTab1,
		_G.CovenantMissionFrameTab2,
	}

	for _, frame in pairs(frames) do
		if frame then
			self:CreateShadow(frame)
		end
	end
	for _, tab in pairs(tabs) do
		self:ReskinTab(tab)
	end
end

S:AddCallback("GarrisonTooltips")
S:AddCallbackForAddon("Blizzard_GarrisonUI")
