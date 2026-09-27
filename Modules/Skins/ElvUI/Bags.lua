local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local B = E:GetModule("Bags")

local pairs = pairs

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
	if not E.private.bags.enable then
		return
	end

	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.bags) then
		return
	end

	self:CreateShadow(B.BagFrame)
	self:CreateShadow(B.BagFrame.ContainerHolder)
	self:CreateShadow(B.BankFrame)
	self:CreateShadow(B.BankFrame.BankTabs)
	self:CreateShadow(B.BankFrame.ContainerHolder)

	ShowContainerHolderIcons(B.BagFrame)
	ShowContainerHolderIcons(B.BankFrame)
end

function S:ElvUI_BagBar()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.bags) then
		return
	end

	if E.private.bags.bagBar and B.BagBar and B.BagBar.buttons then
		for _, buttons in pairs(B.BagBar.buttons) do
			self:CreateShadow(buttons)
		end
	end
end

function S:ElvUI_BagSell()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.bags) then
		return
	end

	if B and B.SellFrame then
		self:CreateBackdropShadow(B.SellFrame)
	end
end

S:AddCallback("ElvUI_Bags")
S:AddCallback("ElvUI_BagBar")
S:AddCallback("ElvUI_BagSell")
