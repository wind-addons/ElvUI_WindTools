local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local C = W.Utilities.Color
local OF = W.Utilities.ObjectFinder

local _G = _G
local format = format
local next = next
local pairs = pairs
local pcall = pcall
local tinsert = tinsert
local tremove = tremove
local unpack = unpack

local CreateFrame = CreateFrame

local pool = {
	spark = {},
	backdrops = {},
}

function pool:Get(type)
	if type == "backdrop" then
		if #pool.backdrops > 0 then
			return tremove(pool.backdrops)
		end

		local backdrop = CreateFrame("Frame", nil, E.UIParent)
		backdrop:SetTemplate("Transparent")
		S:CreateShadow(backdrop)
		backdrop.windPoolType = "backdrop"

		return backdrop
	elseif type == "spark" then
		if #pool.spark > 0 then
			return tremove(pool.spark)
		end

		local spark = E.UIParent:CreateTexture(nil, "ARTWORK", nil, 1)
		spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		spark:SetBlendMode("ADD")
		spark:SetSize(4, 26)

		spark.windPoolType = "spark"

		return spark
	end
end

function pool:Release(target)
	if target.windPoolType == "backdrop" then
		target:Hide()
		target:SetParent(E.UIParent)
		target:ClearAllPoints()
		tinsert(pool.backdrops, target)
	elseif target.windPoolType == "spark" then
		target:Hide()
		target:SetParent(E.UIParent)
		target:ClearAllPoints()
		tinsert(pool.spark, target)
	end
end

local function getPoints(object)
	local points = {}
	local point, relativeTo, relativePoint, xOfs, yOfs = object:GetPoint()
	while point do
		points[#points + 1] = { point, relativeTo, relativePoint, xOfs, yOfs }
		point, relativeTo, relativePoint, xOfs, yOfs = object:GetPoint(#points + 1)
	end
	return points
end

local function applyPoints(object, points)
	if not points or #points == 0 then
		return
	end

	object:ClearAllPoints()
	for i = 1, #points do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(points[i])
		object:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
	end
end

local function modifyStyle(frame)
	local emphasized = frame:Get("bigwigs:emphasized")

	local db = emphasized and E.private.WT.skins.bigWigsSkin.emphasizedBar or E.private.WT.skins.bigWigsSkin.normalBar

	E:SetSmoothing(frame.candyBarBar, db.smooth)

	local barColor = frame:Get("bigwigs:windtools:barcolor")

	if db.colorOverride then
		local statusBarTexture = frame.candyBarBar:GetStatusBarTexture()

		if not barColor then
			frame:Set("bigwigs:windtools:barcolor", { statusBarTexture:GetVertexColor() })
		end

		statusBarTexture:SetGradient(
			"HORIZONTAL",
			C.CreateColorFromTable(db.colorLeft),
			C.CreateColorFromTable(db.colorRight)
		)
	else
		if barColor then
			frame.candyBarBar:GetStatusBarTexture():SetVertexColor(unpack(barColor))
		end
	end

	local spark = frame:Get("bigwigs:windtools:spark")

	if spark then
		spark:SetSize(4, frame.candyBarBar:GetHeight() * 2)
		spark:SetShown(db.spark)
	end
end

local function applyStyle(frame)
	-- BigWigs update the bar type after styling, need hook Set method to update the style
	if not S:IsHooked(frame, "Set") then
		S:SecureHook(frame, "Set", function(self, key, value)
			if key == "bigwigs:emphasized" then
				modifyStyle(self)
			end
		end)
	end

	local height = frame:GetHeight()
	frame:SetHeight(height * 0.618)
	frame:Set("bigwigs:windtools:originalheight", height)

	local spark = pool:Get("spark")
	spark:SetParent(frame.candyBarBar)
	spark:ClearAllPoints()
	spark:SetPoint("CENTER", frame.candyBarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
	spark:SetBlendMode("ADD")
	spark:Show()
	frame:Set("bigwigs:windtools:spark", spark)

	modifyStyle(frame)

	local barBackdrop = pool:Get("backdrop")
	barBackdrop:SetParent(frame.candyBarBar)
	barBackdrop:ClearAllPoints()
	barBackdrop:SetOutside(frame.candyBarBar, E.twoPixelsPlease and 2 or 1, E.twoPixelsPlease and 2 or 1)
	barBackdrop:SetFrameStrata(frame.candyBarBackdrop:GetFrameStrata())
	barBackdrop:SetFrameLevel(frame.candyBarBackdrop:GetFrameLevel())
	barBackdrop:Show()
	frame:Set("bigwigs:windtools:barbackdrop", barBackdrop)

	frame:Set("bigwigs:windtools:barbackgroundisshown", frame.candyBarBackground:IsShown())
	frame.candyBarBackground:Hide()

	local tex = frame:GetIcon()
	if tex then
		frame:SetIcon(nil)
		frame.candyBarIconFrame:SetTexture(tex)
		frame.candyBarIconFrame:Show()

		frame:Set("bigwigs:windtools:iconpoints", getPoints(frame.candyBarIconFrame))

		if frame.iconPosition == "RIGHT" then
			frame.candyBarIconFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
		else
			frame.candyBarIconFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -5, 0)
		end

		frame.candyBarIconFrame:SetSize(height + 2, height + 2)
		frame:Set("bigwigs:windtools:tex", tex)

		local iconBackdrop = pool:Get("backdrop")
		iconBackdrop:SetParent(frame)
		iconBackdrop:ClearAllPoints()
		iconBackdrop:SetOutside(frame.candyBarIconFrame, E.twoPixelsPlease and 2 or 1, E.twoPixelsPlease and 2 or 1)
		iconBackdrop:SetFrameStrata(frame.candyBarIconFrameBackdrop:GetFrameStrata())
		iconBackdrop:SetFrameLevel(frame.candyBarIconFrameBackdrop:GetFrameLevel())
		iconBackdrop:Show()
		frame:Set("bigwigs:windtools:iconbackdrop", iconBackdrop)
	end

	frame:Set("bigwigs:windtools:durationpoints", getPoints(frame.candyBarDuration))
	frame.candyBarLabel:SetShadowOffset(0, 0)
	frame.candyBarLabel:ClearAllPoints()
	frame.candyBarLabel:SetPoint("BOTTOMLEFT", frame.candyBarBar, "TOPLEFT", 3, -height * 0.22)

	frame:Set("bigwigs:windtools:labelpoints", getPoints(frame.candyBarLabel))
	frame.candyBarDuration:SetShadowOffset(0, 0)
	frame.candyBarDuration:ClearAllPoints()
	frame.candyBarDuration:SetPoint("BOTTOMRIGHT", frame.candyBarBar, "TOPRIGHT", -3, -height * 0.22)
end

local function barStopped(frame)
	local durationPoints = frame:Get("bigwigs:windtools:durationpoints")
	if durationPoints then
		applyPoints(frame.candyBarDuration, durationPoints)
		frame:Set("bigwigs:windtools:durationpoints", nil)
	end

	local labelPoints = frame:Get("bigwigs:windtools:labelpoints")
	if labelPoints then
		applyPoints(frame.candyBarLabel, labelPoints)
		frame:Set("bigwigs:windtools:labelpoints", nil)
	end

	local iconBackdrop = frame:Get("bigwigs:windtools:iconbackdrop")
	if iconBackdrop then
		pool:Release(iconBackdrop)
		iconBackdrop:Hide()
		frame:Set("bigwigs:windtools:iconbackdrop", nil)
	end

	local iconPoints = frame:Get("bigwigs:windtools:iconpoints")
	if iconPoints then
		applyPoints(frame.candyBarIconFrame, iconPoints)
		frame:Set("bigwigs:windtools:iconpoints", nil)
	end

	local tex = frame:Get("bigwigs:windtools:tex")
	if tex then
		frame:SetIcon(tex)
		frame:Set("bigwigs:windtools:tex", nil)
	end

	local barBackgroundIsShown = frame:Get("bigwigs:windtools:barbackgroundisshown")
	if barBackgroundIsShown then
		frame.candyBarBackground:SetShown(barBackgroundIsShown)
		frame:Set("bigwigs:windtools:barbackgroundisshown", nil)
	end

	local barBackdrop = frame:Get("bigwigs:windtools:barbackdrop")
	if barBackdrop then
		pool:Release(barBackdrop)
		barBackdrop:Hide()
		frame:Set("bigwigs:windtools:barbackdrop", nil)
	end

	local spark = frame:Get("bigwigs:windtools:spark")
	if spark then
		spark:Hide()
		pool:Release(spark)
		frame:Set("bigwigs:windtools:spark", nil)
	end

	local barColor = frame:Get("bigwigs:windtools:barcolor")
	if barColor then
		frame.candyBarBar:GetStatusBarTexture():SetVertexColor(unpack(barColor))
		frame:Set("bigwigs:windtools:barcolor", nil)
	end

	E:SetSmoothing(frame.candyBarBar, false)

	local height = frame:Get("bigwigs:windtools:originalheight")
	if height then
		frame:SetHeight(height)
	end
end

function S:BigWigs_Plugins()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigs then
		return
	end

	if not _G.BigWigs or not _G.BigWigsAPI then
		return
	end

	_G.BigWigsAPI:RegisterBarStyle(W.PlainTitle, {
		apiVersion = 1,
		version = 1,
		barSpacing = 23,
		fontSizeNormal = 13,
		fontSizeEmphasized = 15,
		fontOutline = "OUTLINE",
		ApplyStyle = applyStyle,
		BarStopped = barStopped,
		GetStyleName = function()
			return W.Title
		end,
	})
end

function S:BigWigs_QueueTimer()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigsQueueTimer then
		return
	end

	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage("WindTools", "BigWigs_FrameCreated", function(_, frame, name)
			local db = E.private.WT.skins.bigWigsSkin.queueTimer
			if name == "QueueTimer" then
				local parent = frame:GetParent()
				frame:StripTextures()
				frame:CreateBackdrop("Transparent")
				self:CreateBackdropShadow(frame)

				E:SetSmoothing(frame, db.smooth)

				local statusBarTexture = frame:GetStatusBarTexture()
				statusBarTexture:SetGradient(
					"HORIZONTAL",
					C.CreateColorFromTable(db.colorLeft),
					C.CreateColorFromTable(db.colorRight)
				)

				statusBarTexture:SetTexture(E.media.normTex)

				if db.spark then
					frame.spark = frame:CreateTexture(nil, "ARTWORK", nil, 1)
					frame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
					frame.spark:SetBlendMode("ADD")
					frame.spark:SetSize(4, frame:GetHeight())
				end

				frame:SetSize(parent:GetWidth(), 10)
				frame:ClearAllPoints()
				frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 1, -5)
				frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", -1, -5)
				frame.text.SetFormattedText = function(textFrame, _, time)
					textFrame:SetText(format("%d", time))
				end
				F.SetFontWithDB(frame.text, db.countDown)
				frame.text:ClearAllPoints()
				frame.text:SetPoint("TOP", frame, "TOP", db.countDown.offsetX, db.countDown.offsetY)
			end
		end)

		E:Delay(2, function()
			_G.BigWigsLoader.UnregisterMessage("AddOnSkins", "BigWigs_FrameCreated")
		end)
	end
end

function S:BigWigs_Keystone()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigs then
		return
	end

	local BigWigsL = _G.BigWigsAPI and _G.BigWigsAPI:GetLocale("BigWigs")
	local titleText = BigWigsL and BigWigsL.keystoneTitle

	local finder = OF:New()
	finder:Find("Frame", function(frame)
		-- Because the function is run on any type objects, need to ensure the safety
		local text = frame and frame.TitleContainer and frame.TitleContainer.TitleText
		if text and text.GetText then
			local success, result = pcall(text.GetText, text)
			if success and result == titleText then
				return true
			end
		end
		return false
	end, function(frame)
		for _, child in next, { frame:GetChildren() } do
			if child.ScrollBar then
				self:Proxy("HandleTrimScrollBar", child.ScrollBar)
			end
		end

		frame.NineSlice:StripTextures()
		frame.PortraitContainer:Hide()
		frame.TopTileStreaks:Hide()
		frame.Bg:Hide()
		frame:SetTemplate("Transparent")
		self:CreateShadow(frame)
		self:Proxy("HandleCloseButton", frame.CloseButton)

		for _, tab in next, frame.Tabs do
			self:Proxy("HandleTab", tab)
			self:ReskinTab(tab)
			tab:SetHeight(32)

			if tab:GetPoint(1) == "BOTTOMLEFT" then
				tab:ClearAllPoints()
				tab:SetPoint("BOTTOMLEFT", 10, -31)
			end
		end
	end)

	finder:Start()
end

S:AddCallbackForAddon("BigWigs_Plugins")
S:AddCallbackForEnterWorld("BigWigs_QueueTimer")
S:AddCallbackForEnterWorld("BigWigs_Keystone")
