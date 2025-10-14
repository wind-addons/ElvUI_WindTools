local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames
local C = W.Utilities.Color
local OF = W.Utilities.ObjectFinder
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local strfind = strfind
local unpack = unpack

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemQualityByID = C_Item.GetItemQualityByID

local function ReskinResetButton(button)
	button:SetTemplate()
	local HighlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
	HighlightTexture:SetInside()
	HighlightTexture:SetBlendMode("ADD")
	HighlightTexture:SetTexture(E.media.blankTex)
	HighlightTexture:SetColorTexture(1, 1, 1, 0.3)
	button.HighlightTexture = HighlightTexture
	button:HookScript("OnEnter", function()
		button.HighlightTexture:Show()
	end)
	button:HookScript("OnLeave", function()
		button.HighlightTexture:Hide()
	end)
	button.HighlightTexture:Hide()
end

local function ReskinScrapPanel(panel)
	for _, grandChild in pairs({ panel:GetChildren() }) do
		local objectType = grandChild:GetObjectType()
		if objectType == "CheckButton" then
			S:Proxy("HandleCheckBox", grandChild)
		elseif objectType == "EditBox" then
			S:Proxy("HandleEditBox", grandChild)
		elseif grandChild.Arrow then
			S:Proxy("HandleDropDownBox", grandChild)
		elseif grandChild.ScrollTarget and grandChild.ForEachFrame then
			local function ReskinScrollBox()
				grandChild:ForEachFrame(function(frame)
					if not frame or not frame.Icon or frame.__windSkin then
						return
					end

					local itemIconComponent = frame.Icon
					for _, region in pairs({ itemIconComponent.frame:GetRegions() }) do
						if
							region
							and region.GetAtlas
							and region:GetAtlas() == "UI-HUD-ActionBar-IconFrame-Mouseover"
						then
							region:SetTexture(E.media.blankTex)
							region:SetVertexColor(C.ExtractRGBFromTemplate("amber-300"))
							region:SetAlpha(0.2)
							break
						end
					end

					itemIconComponent.border:Kill()

					S:Proxy("HandleIcon", itemIconComponent.icon)
					itemIconComponent.icon:SetInside()
					itemIconComponent.icon:CreateBackdrop()

					hooksecurefunc(itemIconComponent, "SetBorder", function(_, quality)
						---@cast quality Enum.ItemQuality
						itemIconComponent.icon.backdrop:SetBackdropBorderColor(E:GetItemQualityColor(quality))
					end)
					if itemIconComponent.frame.itemLink then
						itemIconComponent:SetBorder(C_Item_GetItemQualityByID(itemIconComponent.frame.itemLink))
					end

					frame.__windSkin = true
				end)
			end

			hooksecurefunc(grandChild, "Update", ReskinScrollBox)
			ReskinScrollBox()
		elseif grandChild.Back and grandChild.Forward and grandChild.Track then
			S:Proxy("HandleTrimScrollBar", grandChild)
		end
	end
	S:Proxy("HandleFrame", panel)
	S:CreateShadow(panel)
end

local function ReskinScrappingUI()
	F.WaitFor(function()
		local ScrappingMachineFrame = _G.ScrappingMachineFrame
		if not ScrappingMachineFrame then
			return false
		end

		for _, child in pairs({ ScrappingMachineFrame:GetChildren() }) do
			if child and child.texture and child.texture.GetAtlas then
				local texture = child.texture ---@type Texture
				if texture:GetAtlas() == "GM-raidMarker-reset" then
					return true
				end
			end
		end

		return false
	end, function()
		local ScrappingMachineFrame = _G.ScrappingMachineFrame
		for _, child in pairs({ ScrappingMachineFrame:GetChildren() }) do
			if child.texture and child.texture.GetAtlas then
				local texture = child.texture ---@type Texture
				if texture:GetAtlas() == "GM-raidMarker-reset" then
					ReskinResetButton(child)
				end
			elseif child.GetPoint then
				local point = { child:GetPoint(1) }
				if point[1] == "TOPLEFT" and point[2] == ScrappingMachineFrame and point[3] == "TOPRIGHT" then
					ReskinScrapPanel(child)
					MF:InternalHandle(child, ScrappingMachineFrame)
				end
			end
		end
	end, 0.01, 100)
end

local function ReskinFlyoutFrame(parent)
	for _, child in pairs({ parent:GetChildren() }) do
		if child.layoutType == "PortraitFrameTemplate" and child.TitleContainer then
			if child.__windSkin then
				return
			end
			S:Proxy("HandleFrame", child)
			S:CreateShadow(child)
			MF:InternalHandle(child, _G.CollectionsJournal)
			F.WaitFor(function()
				for _, grandChild in pairs({ child:GetChildren() }) do
					if grandChild.ScrollTarget and grandChild.ForEachFrame then
						return true
					end
				end
				return false
			end, function()
				for _, grandChild in pairs({ child:GetChildren() }) do
					if grandChild.ScrollTarget and grandChild.ForEachFrame then
						local function ReskinScrollBox()
							grandChild:ForEachFrame(function(frame)
								if not frame or frame.__windSkin then
									return
								end
								frame.icon:Size(frame.icon:GetWidth() - 2)
								frame.icon:CreateBackdrop()
								frame.__windSkin = true
							end)
						end

						hooksecurefunc(grandChild, "Update", ReskinScrollBox)
						ReskinScrollBox()
					elseif grandChild.Back and grandChild.Forward and grandChild.Track then
						S:Proxy("HandleTrimScrollBar", grandChild)
					end
				end
			end, 0.01, 100)
			child.__windSkin = true
			return
		end
	end
end

local function ReskinCollectionTabScrollBox(scrollBox)
	scrollBox:ForEachFrame(function(button)
		if button.__windSkin then
			return
		end

		local iconTex, borderTex, description, _, hoverTex = button.icon:GetRegions()
		iconTex:SetTexCoord(unpack(E.TexCoords))
		F.InternalizeMethod(iconTex, "SetTexCoord", true)
		iconTex:CreateBackdrop()
		borderTex:SetAlpha(0)
		iconTex:Size(button.icon:GetWidth() - 2)
		if description then
			F.SetFont(description)
		end
		hoverTex:SetTexture(E.media.blankTex)
		hoverTex:SetVertexColor(C.ExtractRGBFromTemplate("amber-300"))
		hoverTex:SetAlpha(0.2)
		hoverTex:SetInside(iconTex.backdrop)

		hooksecurefunc(button.icon, "SetCollected", function(_, collected)
			local itemID = button.icon.itemID
			-- -1 to let ElvUI API reset to default border color
			local quality = collected and itemID and C_Item_GetItemQualityByID(itemID) or -1
			iconTex.backdrop:SetBackdropBorderColor(E:GetItemQualityColor(quality))
		end)

		button.icon:SetCollected(borderTex:GetAtlas() == "collections-itemborder-collected")
		button.__windSkin = true
	end)
end

local function ReskinCollectionTab(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child.Back and child.Forward and child.Track then
			S:Proxy("HandleTrimScrollBar", child)
		elseif child.intrinsic == "DropdownButton" then
			S:Proxy("HandleButton", child, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
		elseif child.obj and child.obj.bar then
			S:Proxy("HandleStatusBar", child.obj.bar)
		elseif child:IsObjectType("EditBox") then
			S:Proxy("HandleEditBox", child)
		elseif child.ScrollTarget and child.ForEachFrame then
			hooksecurefunc(child, "Update", ReskinCollectionTabScrollBox)
			ReskinCollectionTabScrollBox(child)
		end
	end
end

local function ReskinContentTabs(frame)
	if frame.__windSkin then
		return
	end

	if frame:GetNumChildren() == 1 and frame:GetNumRegions() == 1 then
		-- Collections Tab
		frame:StripTextures()
		local Content = select(1, frame:GetChildren())
		if Content and Content:GetNumChildren() == 5 then
			ReskinCollectionTab(Content)
		end
		frame.__windSkin = true
	elseif frame:GetNumChildren() == 6 and frame:GetNumRegions() == 1 then
		-- Artifact Tab
		frame:StripTextures()
		for _, grandChild in pairs({ frame:GetChildren() }) do
			if grandChild:IsObjectType("Frame") and not grandChild.obj and grandChild:GetNumChildren() == 5 then
				grandChild:StripTextures()
				for _, greatGrandChild in pairs({ grandChild:GetChildren() }) do
					for _, greatGreatGrandChild in pairs({ greatGrandChild:GetChildren() }) do
						if greatGreatGrandChild:IsObjectType("Button") then
							S:Proxy("HandleButton", greatGreatGrandChild, true)
							greatGreatGrandChild.Center:Show()
							greatGreatGrandChild.Center:SetAtlas(nil)
							greatGreatGrandChild.Center:SetTexture(E.media.normTex)
							F.InternalizeMethod(greatGreatGrandChild.Center, "SetAtlas", true)
						end
					end
				end
			end
		end
		frame.__windSkin = true
	end
end

local function ReskinCollectionFrame(frame)
	frame:StripTextures()

	for _, child in pairs({ frame:GetChildren() }) do
		if child.tabs and child.tabPool then
			-- Tabs
			for tab in child.tabPool:EnumerateActive() do
				S:Proxy("HandleTab", tab)
				tab:HookScript("OnClick", function()
					for _, sibling in pairs({ frame:GetChildren() }) do
						ReskinContentTabs(sibling)
					end
				end)
			end
		elseif child.obj and child.obj.bar then
			-- Progress Bar (Top Right)
			S:Proxy("HandleStatusBar", child.obj.bar)
		elseif child:GetNumChildren() == 1 and child:GetNumRegions() == 0 then
			-- Expand Button
			local grandChild = select(1, child:GetChildren())
			if grandChild:GetNumRegions() == 4 and grandChild:IsObjectType("Button") then
				grandChild.Icon = grandChild:CreateTexture(nil, "ARTWORK")
				grandChild.Icon:SetTexture(E.Media.Textures.ArrowUp)
				grandChild.Icon:SetRotation(ES.ArrowRotation.right)
				grandChild.Icon:SetVertexColor(1, 1, 1)
				grandChild.Icon:Point("CENTER")
				grandChild.Icon:Size(14)
				S:Proxy("HandleButton", grandChild)
				hooksecurefunc(grandChild, "SetNormalAtlas", function(button, atlas)
					button.Icon:SetRotation(
						atlas == "RedButton-Expand" and ES.ArrowRotation.right or ES.ArrowRotation.left
					)
				end)
				grandChild:GetNormalTexture():SetAlpha(0)
				grandChild:GetPushedTexture():SetAlpha(0)
				grandChild:GetHighlightTexture():SetAlpha(0)
				grandChild:GetDisabledTexture():SetAlpha(0)

				grandChild:HookScript("OnClick", function()
					ReskinFlyoutFrame(frame)
				end)
			end
		else
			ReskinContentTabs(child)
		end
	end
end

local function ReskinCollectionTabUI()
	F.WaitFor(function()
		return _G.CollectionsJournalTab7 ~= nil
	end, function()
		local tab = _G.CollectionsJournalTab7
		S:Proxy("HandleTab", tab)
		S:ReskinTab(tab)
		tab.Text:Width(tab:GetWidth())

		local finder = OF.New({ parent = _G.CollectionsJournal, objectsPerFrame = 10 })
		finder:Find("Frame", function(frame)
			if not strfind(frame:GetDebugName(), "CollectionsJournal.", 1, true) then
				return false
			end
			if frame.layoutType ~= "InsetFrameTemplate" then
				return false
			end
			if frame.NineSlice == nil then
				return false
			end
			return true
		end, ReskinCollectionFrame)

		finder:Start()
	end, 0.01, 100)
end

function S:LegionRemixHelper()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.legionRemixHelper then
		return
	end

	if C_AddOns_IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
		ReskinScrappingUI()
	else
		S:AddCallbackForAddon("Blizzard_ScrappingMachineUI", ReskinScrappingUI)
	end

	if C_AddOns_IsAddOnLoaded("Blizzard_Collections") then
		ReskinCollectionTabUI()
	else
		S:AddCallbackForAddon("Blizzard_Collections", ReskinCollectionTabUI)
	end
end

S:AddCallbackForAddon("LegionRemixHelper")
