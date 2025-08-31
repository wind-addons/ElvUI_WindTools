local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local pairs = pairs

local _G = _G
local LibStub = _G.LibStub

function S:Myslot()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.myslot then
		return
	end

	local frame = LibStub("Myslot-5.0").MainFrame
	if not frame then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	for _, child in pairs({ frame:GetChildren() }) do
		local objType = child:GetObjectType()
		if objType == "Button" then
			self:Proxy("HandleButton", child)
			if F.IsAlmost(child:GetWidth(), 25) and child:GetNumPoints() == 1 then
				local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint(1)
				-- Import DropDownBox, Export DropDownBox
				if relativePoint == "RIGHT" then
					xOfs = xOfs + 3
					child:ClearAllPoints()
					child:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
				end
			end
		elseif objType == "EditBox" then
			self:Proxy("HandleEditBox", child)
		elseif objType == "Frame" then
			if F.IsAlmost(child:GetWidth(), 600) and F.IsAlmost(child:GetHeight(), 455) then
				child:SetBackdrop(nil)
				child:CreateBackdrop("Transparent")
				child.backdrop:SetInside(child, 2, 2)
				for _, subChild in pairs({ child:GetChildren() }) do
					if subChild:GetObjectType() == "ScrollFrame" then
						self:Proxy("HandleScrollBar", subChild.ScrollBar)
						break
					end
				end
			elseif child.initialize and child.Icon then
				self:Proxy("HandleDropDownBox", child, 220, nil, true)
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", frame, 7, -45)
			end
		end
	end
end

S:AddCallbackForAddon("Myslot")
