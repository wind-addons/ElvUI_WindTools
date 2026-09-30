local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local data = S:AddCallback("MerchantFrame", "merchant")

function data:HandleMerchantItem(index)
	for currencyIndex = 1, 3 do
		local itemLine = _G["MerchantItem" .. index .. "AltCurrencyFrameItem" .. currencyIndex] --[[@as SmallDenominationTemplate?]]
		if itemLine then
			for _, region in pairs({ itemLine:GetRegions() }) do
				if region:GetObjectType() == "Texture" then
					region:SetTexCoords()
				end
			end
		end
	end
end

---Entry point kept on the module for Modules/Item/ExtendMerchantPages.lua
---@param index number The merchant item index
function S:HandleMerchantItem(index)
	data:HandleMerchantItem(index)
end

function S:MerchantFrame()
	self:CreateShadow(_G.MerchantFrame)

	for i = 1, 2 do
		self:CreateBackdropShadow(_G["MerchantFrameTab" .. i])
	end

	for i = 1, 12 do
		data:HandleMerchantItem(i)
	end

	for _, region in pairs({ _G.MerchantMoneyFrame.GoldButton:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			F.Move(region, 0, 4)
		end
	end

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, 3 do
			local token = _G["MerchantToken" .. i] --[[@as BackpackTokenTemplate?]]
			if token and not token.__wind then
				token:Width(token:GetWidth() + 2)
				F.SetFont(token.Count)
				F.Move(token.Count, -2, 0)
				token.Icon:SetTexCoords()
				token.__wind = true
			end
		end
	end)
end
