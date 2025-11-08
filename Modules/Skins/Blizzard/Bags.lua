local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local select = select

function S:Bank()
	if E.private.bags.enable or not self:CheckDB("bags") then
		return
	end

	local bankFrame = _G.BankFrame
	local bankPanel = _G.BankPanel

	self:CreateBackdropShadow(bankFrame)

	if bankFrame.TabSystem then
		for i = 1, bankFrame.TabSystem:GetNumChildren() do
			self:ReskinTab(select(i, bankFrame.TabSystem:GetChildren()))
		end
	end

	if bankPanel and bankPanel.bankTabPool then
		hooksecurefunc(bankPanel.bankTabPool, "Acquire", function(_pool)
			for tab in _pool:EnumerateActive() do
				self:CreateBackdropShadow(tab.Icon)
			end
		end)
	end
end

local function SkinBag(bagID, bag)
	local container = bag or _G["ContainerFrame" .. bagID]
	if container then
		S:CreateShadow(container)
	end
end

function S:Bag()
	if E.private.bags.enable or not self:CheckDB("bags") then
		return
	end

	for bagID = 1, NUM_CONTAINER_FRAMES do
		SkinBag(bagID)
	end

	SkinBag(1, _G.ContainerFrameCombinedBags)
end

S:AddCallback("Bag")
S:AddCallback("Bank")
