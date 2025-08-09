local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local function PositionTabIcons(icon, _, anchor)
	if anchor then
		icon:SetPoint("CENTER")
	end
end

-- Copy from ElvUI WorldMap skin
local function reskinTab(tab)
	if not tab then
		return
	end
	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		tab.Icon:ClearAllPoints()
		tab.Icon:SetPoint("CENTER")

		hooksecurefunc(tab.Icon, "SetPoint", PositionTabIcons)
	end

	if tab.Background then
		tab.Background:SetAlpha(0)
	end

	if tab.SelectedTexture then
		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
		tab.SelectedTexture:SetAllPoints()
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.3)
			region:SetAllPoints()
		end
	end

	if tab.backdrop then
		S:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end
end

local function reskinQuestButton(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame.Bg:SetTexture(E.media.blankTex)
	frame.Bg:SetVertexColor(1, 1, 1, 0.1)

	frame.Highlight:StripTextures()
	local tex = frame.Highlight:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.2)
	tex:SetAllPoints(frame.Bg)
	frame.Highlight.windTex = tex
end

function S:WorldQuestTab()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.worldQuestTab then
		return
	end

	if _G.WQT_QuestMapTab then
		reskinTab(_G.WQT_QuestMapTab)
		_G.WQT_QuestMapTab.__SetPoint = _G.WQT_QuestMapTab.SetPoint
		hooksecurefunc(_G.WQT_QuestMapTab, "SetPoint", function()
			F.MoveFrameWithOffset(_G.WQT_QuestMapTab, 0, -2)
		end)
	end

	if _G.WQT_ListContainer then
		local container = _G.WQT_ListContainer
		self:ESProxy("HandleDropDownBox", container.SortDropdown)
		self:ESProxy(
			"HandleButton",
			container.FilterDropdown,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			true,
			"right"
		)

		S:ESProxy("HandleTrimScrollBar", container.ScrollBar)

		hooksecurefunc(container.QuestScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(reskinQuestButton)
		end)

		container:CreateBackdrop("Transparent")
		container.Background:Hide()
		container.BorderFrame:Hide()
		container.FilterBar:StripTextures()
	end
end

S:AddCallbackForAddon("WorldQuestTab")
