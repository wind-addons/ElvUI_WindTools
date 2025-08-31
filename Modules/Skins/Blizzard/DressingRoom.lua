local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:DressUpFrame()
	if not self:CheckDB("dressingroom", "dressingRoom") then
		return
	end

	self:CreateShadow(_G.DressUpFrame)
	self:CreateShadow(_G.DressUpFrame.SetSelectionPanel)
	self:CreateBackdropShadow(_G.DressUpFrame.OutfitDetailsPanel)

	hooksecurefunc(_G.DressUpFrame.SetSelectionPanel.ScrollBox, "Update", function(box)
		box:ForEachFrame(function(frame)
			if frame.__windSkin then
				return
			end
			F.SetFontOutline(frame.ItemName)
			local width = frame.ItemSlot:GetWidth()
			F.SetFontOutline(frame.ItemSlot)
			frame.ItemSlot:SetWidth(width + 4)

			frame.__windSkin = true
		end)
	end)
end

S:AddCallback("DressUpFrame")
