local W, F, E, L = unpack((select(2, ...)))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

function T:ChangeHealthBarPosition(_, tt)
	local barYOffset = E.db.WT.tooltips.elvUITweaks.healthBar.barYOffset
	local textYOffset = E.db.WT.tooltips.elvUITweaks.healthBar.textYOffset

	if barYOffset == 0 and textYOffset == 0 then
		return
	end

	if E.private.tooltip.enable ~= true then
		return
	end

	if tt:IsForbidden() or not ET.db.visibility then
		return
	end

	if tt:GetAnchorType() ~= "ANCHOR_NONE" then
		return
	end

	if tt.StatusBar then
		if ET.db.healthBar.statusPosition == "BOTTOM" then
			if not tt.StatusBar.anchoredToTop then
				tt.StatusBar:ClearAllPoints()
				tt.StatusBar:SetPoint("TOPLEFT", tt, "BOTTOMLEFT", E.Border, -(E.Spacing * 3) + barYOffset)
				tt.StatusBar:SetPoint("TOPRIGHT", tt, "BOTTOMRIGHT", -E.Border, -(E.Spacing * 3) + barYOffset)
				tt.StatusBar.text:SetPoint("CENTER", tt.StatusBar, 0, textYOffset)
			end
		else
			if tt.StatusBar.anchoredToTop then
				tt.StatusBar:ClearAllPoints()
				tt.StatusBar:SetPoint("BOTTOMLEFT", tt, "TOPLEFT", E.Border, (E.Spacing * 3) + barYOffset)
				tt.StatusBar:SetPoint("BOTTOMRIGHT", tt, "TOPRIGHT", -E.Border, (E.Spacing * 3) + barYOffset)
				tt.StatusBar.text:SetPoint("CENTER", tt.StatusBar, 0, textYOffset)
			end
		end
	end
end

function T:HealthBar()
	T:SecureHook(ET, "GameTooltip_SetDefaultAnchor", "ChangeHealthBarPosition")
end

T:AddCallback("HealthBar")
