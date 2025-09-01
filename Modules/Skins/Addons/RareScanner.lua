local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local floor = floor
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

function S:RareScanner()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rareScanner then
		return
	end

	self:DisableAddOnSkin("RareScanner")

	local scannerButton = _G["RARESCANNER_BUTTON"]
	if not scannerButton or not scannerButton.ModelView then
		return
	end

	scannerButton:SetScript("OnEnter", nil)
	scannerButton:SetScript("OnLeave", nil)

	self:Proxy("HandleButton", scannerButton)

	if scannerButton.CloseButton then
		self:Proxy("HandleCloseButton", scannerButton.CloseButton)
		scannerButton.CloseButton:ClearAllPoints()
		scannerButton.CloseButton:Size(20, 20)
		scannerButton.CloseButton:Point("TOPRIGHT", -3, -3)
	end

	if scannerButton.FilterEntityButton then
		self:Proxy("HandleButton", scannerButton.FilterEntityButton)
		scannerButton.FilterEntityButton:SetNormalTexture(W.Media.Icons.buttonMinus, true)
		scannerButton.FilterEntityButton:SetPushedTexture(W.Media.Icons.buttonMinus, true)
		scannerButton.FilterEntityButton:ClearAllPoints()
		scannerButton.FilterEntityButton:Size(16, 16)
		scannerButton.FilterEntityButton:Point("TOPLEFT", scannerButton, "TOPLEFT", 5, -5)
	end

	if scannerButton.UnfilterEnabledButton then
		self:Proxy("HandleButton", scannerButton.UnfilterEnabledButton)
		scannerButton.UnfilterEnabledButton:SetNormalTexture([[Interface\WorldMap\Skull_64]], true)
		scannerButton.UnfilterEnabledButton:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.5)
		scannerButton.UnfilterEnabledButton:SetPushedTexture([[Interface\WorldMap\Skull_64]], true)
		scannerButton.UnfilterEnabledButton:GetPushedTexture():SetTexCoord(0, 0.5, 0, 0.5)
	end

	if scannerButton.Title then
		F.SetFontOutline(scannerButton.Title)
	end

	if scannerButton.Description_text then
		F.SetFontOutline(scannerButton.Description_text)
	end

	scannerButton:SetTemplate("Transparent")
	self:CreateShadow(scannerButton)

	if scannerButton.Center then
		scannerButton.Center:Show()
	end

	for _, region in pairs({ scannerButton:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			if region:GetTexture() == 235408 then -- title background
				region:SetTexture(nil)
			end
		end
	end

	if scannerButton.LootBar then
		if scannerButton.LootBar.LootBarToolTip then
			hooksecurefunc(scannerButton.LootBar.LootBarToolTip, "Show", function(tooltip)
				TT:SetStyle(_G.LootBarToolTip)

				if scannerButton.LootBar.LootBarToolTipComp1 and scannerButton.LootBar.LootBarToolTipComp1.Show then
					TT:SetStyle(scannerButton.LootBar.LootBarToolTipComp1)
				end

				if scannerButton.LootBar.LootBarToolTipComp2 and scannerButton.LootBar.LootBarToolTipComp2.Show then
					TT:SetStyle(scannerButton.LootBar.LootBarToolTipComp2)
				end
			end)
		end

		T:AddIconTooltip("LootBarToolTip")
		T:AddIconTooltip("LootBarToolTipComp1")
		T:AddIconTooltip("LootBarToolTipComp2")

		hooksecurefunc(scannerButton.LootBar.itemFramesPool, "Acquire", function(pool)
			for button in pool:EnumerateActive() do
				if not button.__windSkin then
					if button.Icon and button.Icon:GetObjectType() == "Texture" then
						button.Icon:SetTexCoord(unpack(E.TexCoords))
					end

					local size = button.Icon:GetWidth() - 2
					button.Icon:Size(size, size)

					button:CreateBackdrop()
					button.backdrop:SetOutside(button.Icon)
					self:CreateShadow(button.backdrop)
					button.__windSkin = true
				end
			end
		end)
	end

	for _, child in pairs({ _G.WorldMapFrame:GetChildren() }) do
		if child:GetObjectType() == "Frame" and child.EditBox and child.relativeFrame then
			for _, region in pairs({ child.EditBox:GetRegions() }) do
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() then
						region:SetTexture(nil)
					end
				end
			end

			child.EditBox:ClearAllPoints()
			child.EditBox:SetAllPoints(child)

			local w, h = child:GetSize()
			child:Size(w, floor(h * 0.62))

			child:ClearAllPoints()
			local ST = W:GetModule("SuperTracker")
			if ST.db and ST.db.enable and ST.db.waypointParse.enable and ST.WorldMapInput then
				child.EditBox:SetTemplate()
				child.EditBox:SetHeight(ST.WorldMapInput:GetHeight())
				child:Point("LEFT", ST.WorldMapInput, "RIGHT", 12, 0)
				local placeholder = child.EditBox:CreateFontString(nil, "ARTWORK")
				placeholder:FontTemplate(nil, nil, "OUTLINE")
				placeholder:SetText("|cff666666RareScanner|r")
				placeholder:Point("CENTER", child, "CENTER", 0, 0)

				child.EditBox:HookScript("OnEditFocusGained", function()
					placeholder:Hide()
				end)

				child.EditBox:HookScript("OnEditFocusLost", function(eb)
					local inputText = eb:GetText()
					if not inputText or gsub(inputText, " ", "") == "" then
						placeholder:Show()
						return
					end
					placeholder:Hide()
				end)
			else
				child.EditBox:SetTemplate("Transparent")
				self:CreateShadow(child.EditBox)
				child:Point("TOP", _G.WorldMapFrame.ScrollContainer, "TOP", 0, -5)
			end
			break
		end
	end
end

S:AddCallbackForAddon("RareScanner")
