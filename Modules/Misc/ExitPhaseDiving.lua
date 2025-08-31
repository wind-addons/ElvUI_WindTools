local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local async = W.Utilities.Async
local M = W.Modules.Misc ---@class Misc
local S = W.Modules.Skins ---@type Skins

local _G = _G
local select = select

local CreateFrame = CreateFrame

local tooltipTitle = "Exit Phase Diving"
async.WithSpellID(1250255, function(spell)
	tooltipTitle = F.GetWindStyleText(spell:GetSpellName())
end)

local function visuallyHide(button)
	button.backdrop:SetAlpha(0)
	button.Icon:SetAlpha(0)
	button.Highlight:SetAlpha(0)
end

local function visuallyShow(button)
	button.backdrop:SetAlpha(1)
	button.Icon:SetAlpha(1)
	button.Highlight:SetAlpha(1)
end

local function updateVisual(button)
	if E:GetAuraByID("player", 1214374, "HELPFUL") then
		visuallyShow(button)
	else
		visuallyHide(button)
	end
end

local function updateButton(button, db)
	if E.db.WT.misc.exitPhaseDiving.enable then
		button:Show()
		button:SetSize(db.width, db.height)
		button.Icon:SetTexCoord(E:CropRatio(db.width, db.height))
		updateVisual(button)
	else
		button:Hide()
	end
end

local function createButton()
	local button = CreateFrame("Button", "WTExitPhaseDivingButton", E.UIParent, "SecureActionButtonTemplate")

	button:SetAttribute("type*", "macro")
	button:SetAttribute("macrotext1", "/cancelaura 1214374\n/run _G.GameTooltip:Hide()")
	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")
	button:SetPoint("TOP", 0, -90)

	button:StripTextures()
	button:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(button)

	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetAllPoints()
	button.Icon:EnableMouse(false)
	button.Icon:SetTexture(4913234)

	button.Highlight = button:CreateTexture(nil, "HIGHLIGHT")
	button.Highlight:SetAllPoints()
	button.Highlight:SetTexture(E.media.blankTex)
	button.Highlight:SetColorTexture(1, 1, 1, 0.15)
	button.Highlight:Hide()

	button:SetScript("OnEnter", function()
		if E:GetAuraByID("player", 1214374, "HELPFUL") then
			button.Highlight:Show()
			_G.GameTooltip:SetOwner(button, "ANCHOR_BOTTOM", 0, -5)
			_G.GameTooltip:SetText(tooltipTitle, 1, 1, 1)
			_G.GameTooltip:Show()
		end
	end)

	button:SetScript("OnLeave", function()
		button.Highlight:Hide()
		_G.GameTooltip:Hide()
	end)

	E:CreateMover(
		button,
		"WTExitPhaseDivingButtonMover",
		L["Exit Phase Diving Button"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.db.WT.misc.exitPhaseDiving.enable
		end,
		"WindTools,misc,exitPhaseDiving"
	)

	button:RegisterEvent("UNIT_AURA")
	button:SetScript("OnEvent", function(self, event, ...)
		if event == "UNIT_AURA" then
			if select(1, ...) == "player" then
				updateVisual(self)
			end
		end
	end)

	return button
end

function M:ExitPhaseDiving()
	if E.db.WT.misc.exitPhaseDiving.enable then
		self.ExitPhaseDivingButton = createButton()
		updateButton(self.ExitPhaseDivingButton, E.db.WT.misc.exitPhaseDiving)
	end
end

function M:UpdateExitPhaseDivingButton()
	F.TaskManager:OutOfCombat(function()
		if E.db.WT.misc.exitPhaseDiving.enable and not self.ExitPhaseDivingButton then
			self.ExitPhaseDivingButton = createButton()
		end
		if self.ExitPhaseDivingButton then
			updateButton(self.ExitPhaseDivingButton, E.db.WT.misc.exitPhaseDiving)
		end
	end)
end

M:AddCallback("ExitPhaseDiving")
M:AddCallbackForUpdate("UpdateExitPhaseDivingButton")
