local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local GetNumArchaeologyRaces = _G.GetNumArchaeologyRaces

function S:MinimalArchaeology()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.minimalArchaeology then
		return
	end

	self:DisableAddOnSkin("MinimalArchaeology")

	local MinArchMain = _G.MinArchMain ---@type Frame
	local MinArchMainSkillBar = _G.MinArchMainSkillBar ---@type Frame
	local MinArchDigsites = _G.MinArchDigsites ---@type Frame
	local MinArchHist = _G.MinArchHist ---@type Frame
	local MinArchHistStats = _G.MinArchHistStats ---@type Frame

	if MinArchMain then
		S:Proxy("HandleFrame", MinArchMain)
		S:CreateShadow(MinArchMain)
	end

	if MinArchMainSkillBar then
		S:Proxy("HandleStatusBar", MinArchMainSkillBar)
		MinArchMainSkillBar:SetPoint("TOP", MinArchMain, "TOP", 2, -24)
		MinArchMainSkillBar:SetWidth(253)
	end

	local buttonOpenADI = _G.MinArchMainButtonOpenADI ---@type Button
	if buttonOpenADI then
		buttonOpenADI:SetPoint("TOPRIGHT", MinArchMain, "TOPRIGHT", -66, -2)
	end

	local buttonOpenHist = _G.MinArchMainButtonOpenHist ---@type Button
	if buttonOpenHist then
		buttonOpenHist:SetPoint("TOPRIGHT", MinArchMain, "TOPRIGHT", -46, -2)
	end

	local buttonOpenArch = _G.MinArchMainButtonOpenArch ---@type Button
	if buttonOpenArch then
		buttonOpenArch:SetPoint("TOPRIGHT", MinArchMain, "TOPRIGHT", -26, -2)
	end

	local buttonClose = _G.MinArchMainButtonClose  ---@type Button
	if buttonClose then
		S:Proxy("HandleCloseButton", buttonClose)
		buttonClose:SetPoint("TOPRIGHT", MinArchMain, "TOPRIGHT", 2, 2)
	end

	if MinArchDigsites then
		S:Proxy("HandleFrame", MinArchDigsites)
		S:CreateShadow(MinArchDigsites)

		if MinArchDigsites.grad then
			MinArchDigsites.grad:StripTextures()
		end
	end

	local digsitesButtonClose = _G.MinArchDigsitesButtonClose  ---@type Button
	if digsitesButtonClose then
		S:Proxy("HandleCloseButton", digsitesButtonClose)
	end

	if MinArchHist then
		S:Proxy("HandleFrame", MinArchHist)
		S:CreateShadow(MinArchHist)

		if MinArchHist.grad then
			MinArchHist.grad:StripTextures()
		end
	end

	local histButtonClose = _G.MinArchHistButtonClose  ---@type Button
	if histButtonClose then
		S:Proxy("HandleCloseButton", histButtonClose)
	end

	if MinArchHistStats then
		S:Proxy("HandleFrame", MinArchHistStats)
		S:CreateShadow(MinArchHistStats)
	end

	for i = 1, GetNumArchaeologyRaces() do
		local artifactBar = _G["MinArchMainArtifactBar" .. i]
		if artifactBar then
			S:Proxy("HandleStatusBar", artifactBar, { 1.0, 0.4, 0 })
			S:CreateShadow(artifactBar)
		end

		local artifactBars = _G.MinArchArtifactBars
		local solveButton = artifactBars and artifactBars[i] and artifactBars[i].buttonSolve
		if solveButton then
			S:Proxy("HandleButton", solveButton)
		end
	end
end

S:AddCallbackForAddon("MinimalArchaeology")
