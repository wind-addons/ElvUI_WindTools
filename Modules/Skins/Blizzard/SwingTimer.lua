local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

if not E.Forever then
	return
end

local _G = _G
local next = next

S:AddCallbackForAddon("Blizzard_SwingTimer", nil, "swingTimer")

local function HandleSwingTimer(swingFrame)
	local statusBar = swingFrame and swingFrame.StatusBar
	if not statusBar then
		return
	end

	S:CreateBackdropShadow(statusBar, true)

	local statusBarTexture = statusBar:GetStatusBarTexture()
	local statusBarPip = statusBar.Pip
	if statusBarPip and statusBarTexture then
		statusBarPip:SetTexture(E.media.blankTex)
		statusBarPip:SetVertexColor(0.9, 0.9, 0.9, 0.6)
		statusBarPip:SetBlendMode("ADD")
		statusBarPip:Width(2)
		statusBarPip:ClearAllPoints()
		statusBarPip:Point("TOP", statusBarTexture, "TOPRIGHT", 0, 0)
		statusBarPip:Point("BOTTOM", statusBarTexture, "BOTTOMRIGHT", 0, 0)
	end

	local typeLabel = statusBar.TypeLabel
	if typeLabel then
		F.SetFont(typeLabel)
		typeLabel:SetJustifyH("LEFT")
	end

	local timeLabel = statusBar.TimeLabel
	if timeLabel then
		F.SetFont(timeLabel)
		timeLabel:SetJustifyH("RIGHT")
	end

	swingFrame:ApplyRangePresentation()
end

function S:Blizzard_SwingTimer()
	for _, swingFrame in next, { _G.SwingTimerMainHandFrame, _G.SwingTimerOffHandFrame, _G.SwingTimerRangedFrame } do
		HandleSwingTimer(swingFrame)
	end
end
