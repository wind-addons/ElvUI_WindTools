local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local select = select

local function SkinTabButton(self, btn)
	if not btn or btn.__windSkin or btn.GetObjectType and btn:GetObjectType() ~= "Button" then
		return
	end
	self:ReskinTab(btn)
	self:CreateShadow(btn)
	btn.__windSkin = true
end

local function HookBankTabPool(self, panel)
	local pool = panel and panel.bankTabPool
	if not pool or pool.__windHook then
		return
	end
	pool.__windHook = true

	hooksecurefunc(pool, "Acquire", function(p)
		for tab in p:EnumerateActive() do
			SkinTabButton(self, tab)
		end
	end)
end

local function HookItemButtonPool(self, panel)
	local pool = panel and panel.itemButtonPool
	if not pool or pool.__windHook then
		return
	end
	pool.__windHook = true

	hooksecurefunc(pool, "Acquire", function(p)
		for button in p:EnumerateActive() do
			if not button.__windSkin then
				self:CreateShadow(button)
				button.__windSkin = true
			end
		end
	end)
end

local function SkinBottomTabSystem(self, frame)
	if not frame then
		return
	end

	local function SkinAllTabs()
		-- The tabs are children of the TabSystem.
		if frame.TabSystem then
			for i = 1, frame.TabSystem:GetNumChildren() do
				local child = select(i, frame.TabSystem:GetChildren())
				SkinTabButton(self, child)
			end
		end
	end

	-- Initial scan for existing tabs.
	SkinAllTabs()
end

local function SkinBankPanelControls(self, panel)
	if not panel then
		return
	end

	-- Right-side vertical bank tabs.
	HookBankTabPool(self, panel)

	-- Item buttons (pooled).
	HookItemButtonPool(self, panel)

	-- Deposit button.
	if panel.AutoDepositFrame and panel.AutoDepositFrame.DepositButton then
		local depositBtn = panel.AutoDepositFrame.DepositButton
		if not depositBtn.__windSkin then
			self:CreateShadow(depositBtn)
			depositBtn.__windSkin = true
		end
	end

	-- Auto sort button.
	if panel.AutoSortButton then
		if not panel.AutoSortButton.__windSkin then
			self:CreateShadow(panel.AutoSortButton)
			panel.AutoSortButton.__windSkin = true
		end
	end

	-- Hide Blizzard baked edge shadows.
	if panel.EdgeShadows then
		panel.EdgeShadows:SetAlpha(0)
	end
end

local function SkinSearchBox(self)
	if _G.BankItemSearchBox and _G.BankItemSearchBox.backdrop then
		local searchBox = _G.BankItemSearchBox.backdrop
		if not searchBox.__windSkin then
			self:CreateShadow(searchBox)
			searchBox.__windSkin = true
		end
	end
end

function S:ContainerFrame()
	if E.private.bags.enable or not self:CheckDB("bags") then
		return
	end
	local bankFrame = _G.BankFrame
	local bankPanel = _G.BankPanel

	if bankFrame and not bankFrame.__windSkin then
		self:CreateShadow(bankFrame)
		bankFrame.__windSkin = true
	end

	if bankPanel and not bankPanel.__windSkin then
		self:CreateShadow(bankPanel)
		bankPanel.__windSkin = true
	end

	SkinBankPanelControls(self, bankPanel)
	SkinBottomTabSystem(self, bankFrame)
	SkinSearchBox(self)
end

S:AddCallback("ContainerFrame")
