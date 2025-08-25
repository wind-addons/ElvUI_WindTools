local W, F, E, L = unpack((select(2, ...)))
local TT = E:GetModule("Tooltip")
local S = W.Modules.Skins

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local strfind = strfind

function S:TT_SetStyle(_, tt)
	if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
		if tt.NineSlice then
			self:CreateShadow(tt.NineSlice)
		end

		if tt.widgetContainer then
			if tt.TopOverlay then
				tt.TopOverlay:StripTextures()
			end
			if tt.BottomOverlay then
				tt.BottomOverlay:StripTextures()
			end
			if tt.NineSlice then
				self:StripEdgeTextures(tt.NineSlice)
			end
			tt:SetTemplate("Transparent")
		end
	end
end

function S:TooltipFrames()
	if not self:CheckDB("tooltip", "tooltips") then
		return
	end

	local tooltips = {
		E.ConfigTooltip,
		E.SpellBookTooltip,
		_G.AceConfigDialogTooltip,
		_G.AceGUITooltip,
		_G.BattlePetTooltip,
		_G.BattlePetTooltip,
		_G.DataTextTooltip,
		_G.ElvUIConfigTooltip,
		_G.ElvUISpellBookTooltip,
		_G.EmbeddedItemTooltip,
		_G.FloatingBattlePetTooltip,
		_G.FloatingPetBattleAbilityTooltip,
		_G.FriendsTooltip,
		_G.GameSmallHeaderTooltip,
		_G.GameTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ItemRefTooltip,
		_G.LibDBIconTooltip,
		_G.PetBattlePrimaryAbilityTooltip,
		_G.PetBattlePrimaryUnitTooltip,
		_G.QuestScrollFrame.CampaignTooltip,
		_G.QuestScrollFrame.StoryTooltip,
		_G.QuickKeybindTooltip,
		_G.ReputationParagonTooltip,
		_G.SettingsTooltip,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.WarCampaignTooltip,
	}

	for _, tt in pairs(tooltips) do
		if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
			self:CreateShadow(tt.NineSlice)
		end
	end

	self:CreateBackdropShadow(_G.GameTooltipStatusBar)

	self:SecureHook(TT, "SetStyle", "TT_SetStyle")
	self:SecureHook(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
		if tt.StatusBar and tt.StatusBar.backdrop then
			self:CreateBackdropShadow(tt.StatusBar)
		end
	end)
	self:SecureHook(_G.QueueStatusFrame, "Update", "CreateShadow")
	self:SecureHook(_G.GameTooltip, "Show", "StyleTooltipsIcons")
end

local function styleIconString(text)
	if not text or not strfind(text, "|T.+|t") then
		return
	end

	text = gsub(text, "|T([^:]+):0|t", function(texture)
		if strfind(texture, "Addons") or texture == "0" then
			return format("|T%s:0|t", texture)
		else
			return format("|T%s:0:0:0:0:64:64:5:59:5:59|t", texture)
		end
	end)

	return text
end

local function styleIconsInLine(line)
	if line then
		local styledText = styleIconString(line:GetText())
		if styledText then
			line:SetText(styledText)
		end
	end
end

function S:StyleTooltipsIcons(tt)
	for i = 2, tt:NumLines() do
		styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
		styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
	end
end

S:AddCallback("TooltipFrames")
