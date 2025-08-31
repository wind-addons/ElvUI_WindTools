local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local unpack = unpack

local CreateFrame = CreateFrame

local function handleItemButton(item)
	if not item then
		return
	end

	if item then
		item:SetTemplate()
		item:OffsetFrameLevel(2)
	end

	if item.Icon then
		item.IconContainer = CreateFrame("Frame", nil, item)
		item.IconContainer:Size(E.PixelMode and 32 or 29)
		item.IconContainer:Point("TOPLEFT", E.PixelMode and 2 or 4, -(E.PixelMode and 2 or 4))
		item.Icon:SetDrawLayer("ARTWORK")
		item.Icon:SetParent(item.IconContainer)
		item.Icon:SetInside(item.IconContainer)
		item.Icon:SetTexCoord(unpack(E.TexCoords))
		item.IconContainer:SetTemplate()
		if item.IconBorder then
			S:Proxy("HandleIconBorder", item.IconBorder, item.IconContainer)
		end
	end

	if item.Count then
		item.Count:SetDrawLayer("OVERLAY")
		item.Count:ClearAllPoints()
		item.Count:Point("BOTTOMRIGHT", item.Icon, "BOTTOMRIGHT", 0, 0)
	end

	if item.NameFrame then
		item.NameFrame:SetAlpha(0)
		item.NameFrame:Hide()
	end

	if item.IconOverlay then
		item.IconOverlay:SetAlpha(0)
	end

	if item.Name then
		item.Name:FontTemplate()
	end

	if item.CircleBackground then
		item.CircleBackground:SetAlpha(0)
		item.CircleBackgroundGlow:SetAlpha(0)
	end

	for _, region in next, { item:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetTexture() == [[Interface\Spellbook\Spellbook-Parts]] then
			region:SetTexture(E.ClearTexture)
		end
	end
end

local function SetupOptions(frame)
	if not frame.__windSkin then
		S:CreateShadow(frame)

		if frame.shadow then
			frame.shadow:SetShown(frame.template and frame.template == "Transparent")
			hooksecurefunc(frame, "SetTemplate", function(_, template)
				frame.shadow:SetShown(template and template == "Transparent")
			end)
		end
	end

	if frame.optionFrameTemplate and frame.optionPools then
		for option in frame.optionPools:EnumerateActiveByTemplate(frame.optionFrameTemplate) do
			if option.WidgetContainer and option.WidgetContainer.widgetFrames then
				for _, widget in pairs(option.WidgetContainer.widgetFrames) do
					if widget.Text then
						F.SetFontOutline(widget.Text)
					end
					if widget.Item then
						handleItemButton(widget.Item)
					end
				end
			end
		end
	end
end

function S:Blizzard_PlayerChoice()
	if not self:CheckDB("playerChoice") then
		return
	end

	hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

S:AddCallbackForAddon("Blizzard_PlayerChoice")
