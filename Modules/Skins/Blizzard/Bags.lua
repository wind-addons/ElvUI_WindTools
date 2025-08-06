local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES

function S:ContainerFrame()
	E:Delay(1, function()
		if E.private.bags.enable or not self:CheckDB("bags") then
			return
		end

		for bagID = 1, NUM_CONTAINER_FRAMES do
			local container = _G["ContainerFrame" .. bagID]
			if container and container.template then
				self:CreateShadow(container)
				self:CreateShadow(container.PortraitButton)
			end
		end

		self:CreateShadow(_G.ContainerFrameCombinedBags)

		-- Bank
		self:CreateBackdropShadow(_G.BankFrame)

		for _, frame in pairs({ _G.BankSlotsFrame, _G.ReagentBankFrame, _G.AccountBankPanel }) do
			if frame and frame.EdgeShadows then
				frame.EdgeShadows:SetAlpha(0)
			end
		end

		if _G.BankFrame.TabSystem then
			for _, tab in pairs(_G.BankFrame.TabSystem.tabs) do
				self:ReskinTab(tab)
			end
		end

		local function ReskinPanelTabs(frame)
			if frame.bankTabPool then
				for tab in frame.bankTabPool:EnumerateActive() do
					self:ReskinTab(tab.Icon)
				end
			end
		end

		if _G.BankPanel then
			self:ReskinTab(_G.BankPanel.PurchaseTab.Icon)
			hooksecurefunc(_G.BankPanel, "RefreshBankTabs", ReskinPanelTabs)
		end
	end)
end

S:AddCallback("ContainerFrame")
