local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local B = E:GetModule("Bags")

local pairs = pairs

S:AddCallback("ElvUI_Bags", function()
	return E.private.bags.enable and E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.bags and true or false
end)
S:AddCallback("ElvUI_BagBar", S:CreateElvUICheck("bags"))
S:AddCallback("ElvUI_BagSell", S:CreateElvUICheck("bags"))

local function ShowBagSlotIcon(button)
	if not button or not button.icon then
		return
	end

	local mask = button.CircleMask or button.SquareMask
	if mask then
		mask:Hide()
	end

	button.icon.Show = nil
	button.icon:Show()
end

local function ShowContainerHolderIcons(bagFrame)
	local holders = bagFrame and bagFrame.ContainerHolderByBagID
	if not holders then
		return
	end

	for _, button in pairs(holders) do
		ShowBagSlotIcon(button)
	end
end

function S:ElvUI_Bags()
	self:CreateShadow(B.BagFrame)
	self:CreateShadow(B.BagFrame.ContainerHolder)
	self:CreateShadow(B.BankFrame)
	self:CreateShadow(B.BankFrame.BankTabs)
	self:CreateShadow(B.BankFrame.ContainerHolder)

	ShowContainerHolderIcons(B.BagFrame)
	ShowContainerHolderIcons(B.BankFrame)
end

function S:ElvUI_BagBar()
	if E.private.bags.bagBar and B.BagBar and B.BagBar.buttons then
		for _, buttons in pairs(B.BagBar.buttons) do
			self:CreateShadow(buttons)
		end
	end
end

function S:ElvUI_BagSell()
	if B and B.SellFrame then
		self:CreateBackdropShadow(B.SellFrame)
	end
end
