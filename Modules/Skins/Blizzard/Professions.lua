local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

function S:Blizzard_Professions()
	if not self:CheckDB("tradeskill", "professions") then
		return
	end

	self:CreateShadow(_G.ProfessionsFrame)
	self:CreateShadow(_G.ProfessionsFrame.CraftingPage.CraftingOutputLog)
	self:CreateShadow(_G.ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog)

	for _, tab in next, { _G.ProfessionsFrame.TabSystem:GetChildren() } do
		self:ReskinTab(tab)
	end

	local function reskinChild(child)
		if child.NineSlice and child.NineSlice.template == "Transparent" then
			self:CreateShadow(child.NineSlice)
		end
	end

	hooksecurefunc("ToggleProfessionsItemFlyout", function()
		local SchematicForm = _G.ProfessionsFrame.CraftingPage and _G.ProfessionsFrame.CraftingPage.SchematicForm
		if SchematicForm then
			for _, child in next, { SchematicForm:GetChildren() } do
				if child.InitializeContents then
					E:Delay(0.05, reskinChild, child)
					hooksecurefunc(child, "InitializeContents", reskinChild)
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_Professions")
