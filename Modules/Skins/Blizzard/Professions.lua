local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

S:AddCallbackForAddon("Blizzard_Professions", nil, "tradeskill", "professions")

function S:Blizzard_Professions()
	local professionsFrame = _G.ProfessionsFrame

	self:CreateShadow(professionsFrame)
	self:CreateShadow(professionsFrame.CraftingPage.CraftingOutputLog)

	local ordersPage = professionsFrame.OrdersPage
	if ordersPage then
		self:CreateShadow(ordersPage.OrderView.CraftingOutputLog)
	end

	local tabSystem = professionsFrame.TabSystem
	if tabSystem then
		for _, tab in next, { tabSystem:GetChildren() } do
			self:ReskinTab(tab)
		end
	end

	local function reskinChild(child)
		if child.NineSlice and child.NineSlice.template == "Transparent" then
			self:CreateShadow(child.NineSlice)
		end
	end

	hooksecurefunc("OpenProfessionsItemFlyout", function()
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
