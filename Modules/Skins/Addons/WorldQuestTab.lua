local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames

local _G = _G
local hooksecurefunc = hooksecurefunc
local strfind = strfind

local function reskinFlightMapContainer(frame)
	S:CreateShadow(frame)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function(self)
		F.Move(self, 15, 0)
	end)

	hooksecurefunc(frame, "SetParent", function(self, parent)
		MF:InternalHandle(self, parent)
	end)

	if _G.WQT_FlightMapContainerButton then
		_G.WQT_FlightMapContainerButton.backdrop:SetTemplate("Transparent")
		S:CreateBackdropShadow(_G.WQT_FlightMapContainerButton)
	end
end

function S:WorldQuestTab()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.worldQuestTab then
		return
	end

	local tab = _G.WQT_QuestMapTab
	if tab and tab.backdrop then
		self:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end

	if _G.WQT_FlightMapContainer then
		reskinFlightMapContainer(_G.WQT_FlightMapContainer)
	end

	self:ReskinCustomGameTooltips(_G.WQT_GameTooltip, _G.WQT_ShoppingTooltip1, _G.WQT_ShoppingTooltip2)

	-- Block the "WQT anti-error" line
	self:RawHook(_G.WQT_GameTooltip, "AddLine", function(tt, text, ...)
		if strfind(text, "WQT anti-error", 0, true) then
			return
		end

		return self.hooks[_G.WQT_GameTooltip].AddLine(tt, text, ...)
	end, true)
end

S:AddCallbackForAddon("WorldQuestTab")
