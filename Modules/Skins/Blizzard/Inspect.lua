local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

local function DeleteBackdrop(count)
	count = count or 0

	if count > 20 then
		return
	end

	if _G.InspectModelFrame.backdrop then
		_G.InspectModelFrame.backdrop:Kill()
	else
		E:Delay(0.05, function()
			DeleteBackdrop(count + 1)
		end)
	end
end

function S:Blizzard_InspectUI()
	if not self:CheckDB("inspect") then
		return
	end

	-- 观察面板
	self:CreateShadow(_G.InspectFrame)
	for i = 1, 4 do
		self:ReskinTab(_G["InspectFrameTab" .. i])
	end

	self:CreateShadow(_G.InspectPaperDollFrame.ViewButton)
	self:CreateShadow(_G.InspectPaperDollItemsFrame.InspectTalents)

	-- 去除人物模型背景
	local InspectModelFrame = _G.InspectModelFrame
	if InspectModelFrame then
		InspectModelFrame:DisableDrawLayer("BACKGROUND")
		InspectModelFrame:DisableDrawLayer("BORDER")
		InspectModelFrame:DisableDrawLayer("OVERLAY")
	end

	DeleteBackdrop()
end

S:AddCallbackForAddon("Blizzard_InspectUI")
