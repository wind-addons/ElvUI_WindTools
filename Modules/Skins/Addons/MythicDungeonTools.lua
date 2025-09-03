local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

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

local function reskinDungeonButton(MDT)
	local db = MDT:GetDB()
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
				S:CreateShadow(button)
			end

			F.Move(button.shortText, 0, 2)
			if W.ChineseLocale then
				F.SetFontOutline(button.shortText, nil, "+3")
			end

			local BUTTON_SIZE = 40

			button:ClearAllPoints()
			button:Point("TOPLEFT", MDT.main_frame, "TOPLEFT", (idx - 1) * (BUTTON_SIZE + 2) + 2, -2)
		end
	end
end

local function reskinProgressBar(_, progressBar)
	local bar = progressBar and progressBar.Bar
	bar:StripTextures()
	bar:CreateBackdrop(nil, nil, nil, nil, nil, nil, nil, nil, true)
	bar:SetStatusBarTexture(E.media.normTex)

	bar.Label:ClearAllPoints()
	bar.Label:Point("CENTER", bar, 0, 0)
	F.SetFontOutline(bar.Label)
end

local function reskinButtonTexture(texture, alphaTimes)
	if not texture then
		return
	end

	texture:SetTexCoord(0, 1, 0, 1)
	texture:SetInside()

	texture:SetTexture(E.media.normTex)
	texture.SetVertexColor_ = texture.SetVertexColor
	hooksecurefunc(texture, "SetVertexColor", function(self, r, g, b, a)
		self:SetVertexColor_(r, g, b, a * alphaTimes)
	end)
	texture:SetVertexColor(texture:GetVertexColor())
end

local function reskinContainerIcon(_, icon)
	if icon and icon.image then
		icon.image:SetTexCoord(unpack(E.TexCoords))
	end
end

local function reskinMapPOI(frame)
	if not frame or frame.__windSkin or not frame.Texture then
		return
	end

	frame:SetTemplate()
	S:CreateShadow(frame)

	frame.HighlightTexture:Kill()
	frame.windHighlightTexture = frame:CreateTexture(nil, "OVERLAY")
	frame.windHighlightTexture:SetAllPoints(frame)
	frame.windHighlightTexture:SetTexture(E.media.blankTex)
	frame.windHighlightTexture:SetVertexColor(1, 1, 1, 0.2)

	hooksecurefunc(frame.HighlightTexture, "Show", function()
		frame.windHighlightTexture:Show()
	end)

	hooksecurefunc(frame.HighlightTexture, "Hide", function()
		frame.windHighlightTexture:Hide()
	end)

	frame.Texture:SetTexCoord(unpack(E.TexCoords))
	frame.Texture:SetInside()

	frame.__windSkin = true
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
				S:Proxy("HandleMaxMinFrame", _G.MDTFrame.MaxMinButtonFrame)
				S:Proxy("HandleCloseButton", _G.MDTFrame.closeButton)
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

	self:SecureHook(_G.MDT, "UpdateEnemyInfoFrame", function(MDT)
		if not MDT.enemyInfoFrame then
			return
		end

		local container = MDT.enemyInfoFrame.characteristicsContainer
		if container and not container.__windSkin then
			hooksecurefunc(container, "AddChild", reskinContainerIcon)
			for _, child in pairs(container.children) do
				reskinContainerIcon(nil, child)
			end

			container.__windSkin = true
		end
	end)

	self:SecureHook(_G.MDT, "POI_CreateFramePools", function(MDT)
		for _, template in pairs({ "MapLinkPinTemplate", "DeathReleasePinTemplate", "VignettePinTemplate" }) do
			local pool = MDT.GetFramePool(template)
			if pool then
				self:SecureHook(pool, "Acquire", function(p)
					if p.active then
						for _, frame in pairs(p.active) do
							reskinMapPOI(frame)
						end
					end
				end)
			end
		end
	end)

	self:SecureHook(_G.MDT, "UpdateDungeonDropDown", reskinDungeonButton)
	self:SecureHook(_G.MDT, "SkinProgressBar", reskinProgressBar)
end

function S:Ace3_MDTPullButton(widget)
	reskinButtonTexture(widget.frame.pickedGlow, 0.5)
	reskinButtonTexture(widget.frame.highlight, 0.2)
	reskinButtonTexture(widget.background, 0.3)

	widget.pullNumber:ClearAllPoints()
	widget.pullNumber:Point("CENTER", widget.frame, "LEFT", 12, 1)

	hooksecurefunc(widget.frame.pickedGlow, "Show", function()
		F.SetFontOutline(widget.pullNumber, F.GetCompatibleFont("Accidental Presidency"), 22)
		widget.pullNumber:SetTextColor(1, 1, 1, 1)
	end)

	hooksecurefunc(widget.frame.pickedGlow, "Hide", function()
		F.SetFontOutline(widget.pullNumber, F.GetCompatibleFont("Accidental Presidency"), 16)
		widget.pullNumber:SetTextColor(1, 0.93, 0.76, 0.8)
	end)
end

function S:Ace3_MDTNewPullButton(widget)
	widget.frame:StripTextures()
	reskinButtonTexture(widget.background, 0.2)
	widget.background:SetVertexColor(1, 1, 1, 0.4)
	reskinButtonTexture(widget.frame.highlight, 0.2)
end

function S:Ace3_MDTSpellButton(widget)
	S:Proxy("HandleIcon", widget.icon)
	local width, height = widget.icon:GetSize()
	widget.icon:Size(width - 2, height - 2)
	F.Move(widget.icon, -3, 0)

	widget.frame.background:SetAlpha(0)
	reskinButtonTexture(widget.frame.highlight, 0.2)
	widget.frame:SetTemplate()
end

local function dbChecker(db)
	return db.addons.mythicDungeonTools
end

S:AddCallbackForAddon("MythicDungeonTools")
S:AddCallbackForAceGUIWidget("MDTPullButton", "Ace3_MDTPullButton", dbChecker)
S:AddCallbackForAceGUIWidget("MDTNewPullButton", "Ace3_MDTNewPullButton", dbChecker)
S:AddCallbackForAceGUIWidget("MDTSpellButton", "Ace3_MDTSpellButton", dbChecker)
