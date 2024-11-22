local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local CreateFrame = CreateFrame

function S:OmniCD_ConfigGUI()
	local O = _G.OmniCD[1]

	hooksecurefunc(O.Libs.ACD, "Open", function(_, arg1)
		if arg1 == O.AddOn then
			local frame = O.Libs.ACD.OpenFrames.OmniCD.frame
			frame:SetTemplate("Transparent")
			self:CreateShadow(frame)
		end
	end)
end

function S:OmniCD_Party_Icon()
	if not E.private.WT.skins.addons.omniCDIcon then
		return
	end

	local O = _G.OmniCD[1]

	if not O.Party or not O.Party.AcquireIcon then
		return
	end

	hooksecurefunc(O.Party, "AcquireIcon", function(_, barFrame, iconIndex, unitBar)
		local icon = barFrame.icons[iconIndex]
		if icon and not icon.__wind then
			self:CreateShadow(icon)
			icon.__wind = true
		end
	end)
end

local function updateBorderVisibility(self)
	local parent = self:GetParent()
	if not parent or not parent.__wind then
		return
	end

	parent.__wind:SetShown(self:IsShown())
end

function S:OmniCD_Party_ExtraBars()
	if not E.private.WT.skins.addons.omniCDStatusBar then
		return
	end

	local O = _G.OmniCD[1]

	if not O.Party or not O.Party.AcquireStatusBar then
		return
	end

	hooksecurefunc(O.Party, "AcquireStatusBar", function(P, icon)
		if icon.statusBar then
			if not icon.statusBar.__wind then
				icon.statusBar.__wind = CreateFrame("Frame", nil, icon.statusBar)
				icon.statusBar.__wind:SetFrameLevel(icon.statusBar:GetFrameLevel() - 1)

				-- bind the visibility to the original borders
				if icon.statusBar.borderTop then
					hooksecurefunc(icon.statusBar.borderTop, "SetShown", updateBorderVisibility)
					hooksecurefunc(icon.statusBar.borderTop, "Hide", updateBorderVisibility)
					hooksecurefunc(icon.statusBar.borderTop, "Show", updateBorderVisibility)
				end
			end

			local x = icon:GetSize()

			icon.statusBar.__wind:ClearAllPoints()
			icon.statusBar.__wind:SetPoint("TOPLEFT", icon.statusBar, "TOPLEFT", -x - 1, 0)
			icon.statusBar.__wind:SetPoint("BOTTOMRIGHT", icon.statusBar, "BOTTOMRIGHT", 0, 0)
			self:CreateShadow(icon.statusBar.__wind)
		end
	end)
end

function S:OmniCD()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.omniCD then
		return
	end

	self:OmniCD_ConfigGUI()
	self:OmniCD_Party_Icon()
	self:OmniCD_Party_ExtraBars()
end

S:AddCallbackForAddon("OmniCD")
