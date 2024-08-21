local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local CreateFrame = CreateFrame

local function reskinTooltip(tt)
	if not tt then
		return
	end
	tt:StripTextures()
	tt:SetTemplate("Transparent")
	tt.CreateBackdrop = E.noop
	tt.ClearBackdrop = E.noop
	tt.SetBackdropColor = E.noop
	if tt.backdrop and tt.backdrop.Hide then
		tt.backdrop:Hide()
	end
	tt.backdrop = nil
	S:CreateShadow(tt)
end

function S:MythicDungeonTools()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.mythicDungeonTools then
		return
	end

	if not _G.MDT then
		return
	end

	local skinned = false

	self:SecureHook(_G.MDT, "Async", function(_, _, name)
		if name == "showInterface" and not skinned then
			E:Delay(0.1, function()
				S:ESProxy("HandleMaxMinFrame", _G.MDTFrame.MaxMinButtonFrame)
				S:ESProxy("HandleCloseButton", _G.MDTFrame.closeButton)
			end)
			E:Delay(1, function()
				reskinTooltip(_G.MDT.tooltip)
				reskinTooltip(_G.MDT.pullTooltip)
			end)

			skinned = true
		end
	end)

	self:SecureHook(_G.MDT, "initToolbar", function()
		if _G.MDTFrame then
			local virtualBackground = CreateFrame("Frame", "WT_MDTSkinBackground", _G.MDTFrame)
			virtualBackground:Point("TOPLEFT", _G.MDTTopPanel, "TOPLEFT")
			virtualBackground:Point("BOTTOMRIGHT", _G.MDTSidePanel, "BOTTOMRIGHT")
			self:CreateShadow(virtualBackground)
			self:CreateShadow(_G.MDTToolbarFrame)
		end
	end)
end

S:AddCallbackForAddon("MythicDungeonTools")
