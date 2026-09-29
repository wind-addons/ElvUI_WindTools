local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local function AllowBagSkin()
	return not E.private.bags.enable and S:CheckDB("bags")
end

local data = S:AddCallbackForAddon("Blizzard_UIPanels_Game", "Bag")
data.check = AllowBagSkin
data = S:AddCallbackForAddon("Blizzard_UIPanels_Game", "Bank")
data.check = AllowBagSkin

local _G = _G
local hooksecurefunc = hooksecurefunc
local select = select

local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES

local skinnedButtons = {}

local function SkinItemButton(button)
	if not button or not button.IconBorder or skinnedButtons[button] then
		return
	end

	skinnedButtons[button] = true

	hooksecurefunc(button.IconBorder, "SetAlpha", function(border, alpha)
		if alpha ~= 0 then
			border:SetAlpha(0)
		end
	end)
end

local function ShadowRetailBankTabs(pool)
	for tab in pool:EnumerateActive() do
		S:CreateBackdropShadow(tab.Icon)
	end
end

local function ShadowBankPageTabs(bankFrame)
	local pool = bankFrame.bankPageTabPool
	if not pool then
		return
	end

	for tab in pool:EnumerateActive() do
		S:ReskinTab(tab)
	end
end

local function ShadowBankBagButtons(bankFrame)
	local pool = bankFrame.itemButtonBagPool
	if not pool then
		return
	end

	for button in pool:EnumerateActive() do
		SkinItemButton(button)
		S:CreateBackdropShadow(button)
	end
end

local function SkinBankItemSlots(bankPanel)
	local pool = bankPanel.itemButtonPool
	if not pool then
		return
	end

	for button in pool:EnumerateActive() do
		SkinItemButton(button)
	end
end

function S:Bank()
	local bankFrame = _G.BankFrame
	if not bankFrame then
		return
	end

	local bankPanel = _G.BankPanel or bankFrame.BankPanel

	self:CreateBackdropShadow(bankFrame)

	if bankFrame.TabSystem then
		for i = 1, bankFrame.TabSystem:GetNumChildren() do
			self:ReskinTab(select(i, bankFrame.TabSystem:GetChildren()))
		end
	end

	if bankPanel and bankPanel.bankTabPool then
		ShadowRetailBankTabs(bankPanel.bankTabPool)
		hooksecurefunc(bankPanel.bankTabPool, "Acquire", function(pool)
			ShadowRetailBankTabs(pool)
		end)
	end

	if bankFrame.bankPageTabPool and bankFrame.RefreshPageTabs then
		ShadowBankPageTabs(bankFrame)
		hooksecurefunc(bankFrame, "RefreshPageTabs", ShadowBankPageTabs)
	end

	if bankFrame.itemButtonBagPool and bankFrame.RefreshBagButtons then
		ShadowBankBagButtons(bankFrame)
		hooksecurefunc(bankFrame, "RefreshBagButtons", ShadowBankBagButtons)
	end

	if bankPanel and bankPanel.GenerateItemSlotsForSelectedTab then
		SkinBankItemSlots(bankPanel)
		hooksecurefunc(bankPanel, "GenerateItemSlotsForSelectedTab", SkinBankItemSlots)
	end
end

local function SkinBag(bagID, bag)
	local container = bag or _G["ContainerFrame" .. bagID]
	if not container then
		return
	end

	S:CreateShadow(container)

	-- Some other addons like Zygor may change the alpha, so make the alpha more robust
	hooksecurefunc(container, "UpdateItems", function()
		for _, button in container:EnumerateValidItems() do
			SkinItemButton(button)
		end
	end)
end

function S:Bag()
	for bagID = 1, NUM_CONTAINER_FRAMES do
		SkinBag(bagID)
	end

	SkinBag(1, _G.ContainerFrameCombinedBags)
end
