local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local B = E:GetModule("Bags")

local _G = _G
local pairs = pairs

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
