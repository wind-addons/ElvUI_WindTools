local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_InspectUI()
	if not self:CheckDB("inspect") then
		return
	end

	self:CreateShadow(_G.InspectFrame)
	for i = 1, 4 do
		self:ReskinTab(_G["InspectFrameTab" .. i])
	end

	self:CreateShadow(_G.InspectPaperDollFrame.ViewButton)
	self:CreateShadow(_G.InspectPaperDollItemsFrame.InspectTalents)

	-- Remove character model background
	local InspectModelFrame = _G.InspectModelFrame
	if InspectModelFrame then
		InspectModelFrame:DisableDrawLayer("BACKGROUND")
		InspectModelFrame:DisableDrawLayer("BORDER")
		InspectModelFrame:DisableDrawLayer("OVERLAY")
	end

	F.WaitFor(function()
		return _G.InspectModelFrame and _G.InspectModelFrame.backdrop
	end, function()
		_G.InspectModelFrame.backdrop:Kill()
	end)
end

S:AddCallbackForAddon("Blizzard_InspectUI")
