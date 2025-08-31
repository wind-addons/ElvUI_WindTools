local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

function S:HandleMerchantItem(index)
	for currencyIndex = 1, 3 do
		local itemLine = _G["MerchantItem" .. index .. "AltCurrencyFrameItem" .. currencyIndex] --[[@as SmallDenominationTemplate?]]
		if itemLine then
			for _, region in pairs({ itemLine:GetRegions() }) do
				if region:GetObjectType() == "Texture" then
					region:SetTexCoord(unpack(E.TexCoords))
				end
			end
		end
	end
end

function S:MerchantFrame()
	if not self:CheckDB("merchant") then
		return
	end

	self:CreateShadow(_G.MerchantFrame)

	for i = 1, 2 do
		self:CreateBackdropShadow(_G["MerchantFrameTab" .. i])
	end

	for i = 1, 12 do
		self:HandleMerchantItem(i)
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
				F.SetFontOutline(token.Count)
				F.Move(token.Count, -2, 0)
				token.Icon:SetTexCoord(unpack(E.TexCoords))
				token.__wind = true
			end
		end
	end)
end

S:AddCallback("MerchantFrame")
