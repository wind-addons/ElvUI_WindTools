-- 屏幕阴影
-- 原作：iShadow

local f = CreateFrame("Frame", "ShadowBackground")


f:SetPoint("TOPLEFT")

f:SetPoint("BOTTOMRIGHT")

f:SetFrameLevel(0)

f:SetFrameStrata("BACKGROUND")

f.tex = f:CreateTexture()

f.tex:SetTexture([[Interface\Addons\WindTools\Texture\shadow.tga]])

f.tex:SetAllPoints(f)
function 
f:SetShadowLevel(n)
	n = tonumber(n)
	if not n then error("The level must be a number between 100 and 0.") return 

end
	

ncShadowLevel = n
	
f:SetAlpha(n/100)


end


f:SetScript("OnEvent", function()
	
f:SetShadowLevel((ncShadowLevel or 50))
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
SLASH_SHADOW1 = "/shadow"
SlashCmdList["SHADOW"] = function(n) 
f:SetShadowLevel(n) 

end