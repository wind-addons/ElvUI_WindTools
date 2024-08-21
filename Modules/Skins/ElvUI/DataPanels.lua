local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local DT = E:GetModule("DataTexts")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function hookPanelSetTemplate(panel, template)
	if not panel.shadow then
		return
	end

	if template == "NoBackdrop" then
		panel.shadow:Hide()
	else
		panel.shadow:Show()
	end
end

local function createPanelShadow(panel)
	if panel.shadow and panel.shadow.__wind then
		return
	end
	S:CreateShadow(panel)
	hooksecurefunc(panel, "SetTemplate", hookPanelSetTemplate)
	hookPanelSetTemplate(panel, panel.template)
end

function S:ElvUI_SkinDataPanel(_, name)
	local panel = DT:FetchFrame(name)
	createPanelShadow(panel)
end

function S:ElvUI_DataPanels()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.dataPanels) then
		return
	end

	if _G.MinimapPanel then
		createPanelShadow(_G.MinimapPanel)
	end

	if DT.PanelPool.InUse then
		for name, frame in pairs(DT.PanelPool.InUse) do
			createPanelShadow(frame)
		end
	end

	if DT.PanelPool.Free then
		for name, frame in pairs(DT.PanelPool.Free) do
			createPanelShadow(frame)
		end
	end

	self:SecureHook(DT, "BuildPanelFrame", "ElvUI_SkinDataPanel")
end

S:AddCallback("ElvUI_DataPanels")
