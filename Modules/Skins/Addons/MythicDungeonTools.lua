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
			F.WaitFor(function()
				return _G.MDTFrame and _G.MDTFrame.MaxMinButtonFrame and _G.MDTFrame.closeButton and true or false
			end, function()
				S:ESProxy("HandleMaxMinFrame", _G.MDTFrame.MaxMinButtonFrame)
				S:ESProxy("HandleCloseButton", _G.MDTFrame.closeButton)
			end, 0.05, 10)

			F.WaitFor(function()
				return _G.MDT.tooltip and _G.MDT.pullTooltip and true or false
			end, function()
				reskinTooltip(_G.MDT.tooltip)
				reskinTooltip(_G.MDT.pullTooltip)
			end, 0.05, 10)

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

	self:SecureHook(_G.MDT, "UpdateDungeonDropDown", function()
		local db = _G.MDT:GetDB()
		local dungeonList = db and db.selectedDungeonList
		local currentList = MDT.dungeonSelectionToIndex and dungeonList and MDT.dungeonSelectionToIndex[dungeonList]
		if not currentList then
			return
		end

		for idx = 1, #currentList do
			if _G["MDTDungeonButton" .. idx] and not _G["MDTDungeonButton" .. idx].template then
				local button = _G["MDTDungeonButton" .. idx]

				if button.texture then
					button.texture:SetTexCoord(unpack(E.TexCoords))
					button.texture:SetInside()
				end

				if button.highlightTexture then
					button.highlightTexture:SetTexture(E.media.blankTex)
					button.highlightTexture:SetVertexColor(1, 1, 1, 0.2)
					button.highlightTexture:SetInside()
				end

				if button.selectedTexture then
					button.selectedTexture:SetTexture(E.media.blankTex)
					button.selectedTexture:SetVertexColor(1, 0.85, 0, 0.4)
					button.selectedTexture:SetInside()
				end

				if not button.template then
					button:SetTemplate()
					self:CreateShadow(button)
				end

				local BUTTON_SIZE = 40

				button:ClearAllPoints()
				button:SetPoint("TOPLEFT", MDT.main_frame, "TOPLEFT", (idx - 1) * (BUTTON_SIZE + 2) + 2, -2)
			end
		end
	end)
end

S:AddCallbackForAddon("MythicDungeonTools")
