local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local unpack = unpack

function S:HandleMerchantItem(index)
	for currencyIndex = 1, 3 do
		local itemLine = _G["MerchantItem" .. index .. "AltCurrencyFrameItem" .. currencyIndex]
		for _, region in pairs({ itemLine:GetRegions() }) do
			if region:GetObjectType() == "Texture" then
				region:SetTexCoord(unpack(E.TexCoords))
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

	for i = 1, 10 do
		self:HandleMerchantItem(i)
	end
end

S:AddCallback("MerchantFrame")
