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
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	hooksecurefunc(P, "CreateIconFramePool", function()
		if not P.IconPool then
			return
		end
		hooksecurefunc(P.IconPool, "Acquire", function(pool)
			for icon in pool:EnumerateActive() do
				if not icon.__wind then
					self:CreateShadow(icon)
					icon.__wind = true
				end
			end
		end)
	end)
end

function S:OmniCD_Party_StatusBar()
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	local function updateBorderVisibility(borderTex)
		local parent = borderTex:GetParent()
		if not parent or not parent.shadow then
			return
		end

		parent.shadow:SetShown(borderTex:IsShown())
	end

	hooksecurefunc(P, "CreateStatusBarFramePool", function()
		if not P.StatusBarPool then
			return
		end

		hooksecurefunc(P.StatusBarPool, "Acquire", function(pool)
			for bar in pool:EnumerateActive() do
				if not bar.__wind then
					self:CreateLowerShadow(bar)

					-- bind the visibility to the original borders
					if bar.borderTop then
						hooksecurefunc(bar.borderTop, "SetShown", updateBorderVisibility)
						hooksecurefunc(bar.borderTop, "Hide", updateBorderVisibility)
						hooksecurefunc(bar.borderTop, "Show", updateBorderVisibility)
					end
					bar.__wind = true
				end
			end
		end)
	end)
end

function S:OmniCD_Party_ExtraBar()
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	hooksecurefunc(P, "CreateExBarFramePool", function()
		if not P.ExBarPool then
			return
		end

		hooksecurefunc(P.ExBarPool, "Acquire", function(pool)
			for bar in pool:EnumerateActive() do
				if not bar.__wind then
					bar.anchor:StripTextures()
					bar.anchor:SetTemplate("Transparent")
					self:CreateShadow(bar.anchor)
					bar.anchor:SetHeight(bar.anchor:GetHeight() + 8)
					bar.anchor.__SetPoint = bar.anchor.SetPoint
					hooksecurefunc(bar.anchor, "SetPoint", function()
						F.MoveFrameWithOffset(bar.anchor, 0, bar.db and bar.db.growUpward and -11 or 3)
					end)

					bar.__wind = true
				end
			end
		end)
	end)
end

function S:OmniCD()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.omniCD then
		return
	end

	self:OmniCD_ConfigGUI()

	if E.private.WT.skins.addons.omniCDIcon then
		self:OmniCD_Party_Icon()
	end

	if E.private.WT.skins.addons.omniCDStatusBar then
		self:OmniCD_Party_StatusBar()
	end

	if E.private.WT.skins.addons.omniCDExtraBar then
		self:OmniCD_Party_ExtraBar()
	end
end

S:AddCallbackForAddon("OmniCD")
