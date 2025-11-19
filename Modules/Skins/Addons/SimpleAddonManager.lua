local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local abs = abs
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs

local function ReskinScrollFrameItems(frame, template)
	if template == "SimpleAddonManagerAddonItem" or template == "SimpleAddonManagerCategoryItem" then
		for _, btn in pairs(frame.buttons) do
			if not btn.__windSkin then
				F.SetFont(btn.Name)
				S:Proxy("HandleCheckBox", btn.EnabledButton)
				local btnCheckTex = btn.EnabledButton.CheckedTexture
				if btnCheckTex then
					btnCheckTex.__windColorOverride = function(r, g, b)
						-- Because SAM uses 1, 1, 1 for the check color
						if r == 1 and g == 1 and b == 1 then
							return "DEFAULT"
						end

						if abs(r - 0.4) < 0.01 and g == 1 and abs(r - 0.4) < 0.01 then
							return { r = 0.75, g = 0.75, b = 0.75 }
						end
					end
				end
				if btn.ExpandOrCollapseButton then
					S:Proxy("HandleCollapseTexture", btn.ExpandOrCollapseButton)
				end
				btn.__windSkin = true
			end
		end
	end
end

local function SAMDropDownSkin(frame)
	frame:Width(200)
	frame:Height(32)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:Point("TOPLEFT", 20, 1)
	frame.backdrop:Point("BOTTOMRIGHT", frame.Button, "BOTTOMRIGHT", 2, -2)
	S:Proxy("HandleNextPrevButton", frame.Button, "down")
	frame.Text:ClearAllPoints()
	frame.Text:Point("RIGHT", frame.Button, "LEFT", -2, 0)
end

local function ReskinModules(frame)
	-- MainFrame
	S:Proxy("HandleButton", frame.OkButton)
	S:Proxy("HandleButton", frame.CancelButton)
	S:Proxy("HandleButton", frame.EnableAllButton)
	S:Proxy("HandleButton", frame.DisableAllButton)
	SAMDropDownSkin(frame.CharacterDropDown)

	frame.OkButton:ClearAllPoints()
	frame.OkButton:Point("RIGHT", frame.CancelButton, "LEFT", -2, 0)
	frame.DisableAllButton:ClearAllPoints()
	frame.DisableAllButton:Point("LEFT", frame.EnableAllButton, "RIGHT", 2, 0)
	S:HandleResizeButton(frame.Sizer)
	frame.Sizer:ClearAllPoints()
	frame.Sizer:Point("BOTTOMRIGHT", 1, -1)
	frame.Sizer:SetFrameLevel(200)

	-- SearchBox
	S:Proxy("HandleEditBox", frame.SearchBox)
	S:Proxy("HandleNextPrevButton", frame.ResultOptionsButton, "down")

	-- AddonListFrame
	S:Proxy("HandleScrollBar", frame.AddonListFrame.ScrollFrame.ScrollBar)

	-- CategoryFrame
	S:Proxy("HandleButton", frame.CategoryFrame.NewButton)
	S:Proxy("HandleButton", frame.CategoryFrame.SelectAllButton)
	S:Proxy("HandleButton", frame.CategoryFrame.ClearSelectionButton)
	S:Proxy("HandleButton", frame.CategoryButton)
	S:Proxy("HandleScrollBar", frame.CategoryFrame.ScrollFrame.ScrollBar)

	frame.CategoryFrame.NewButton:ClearAllPoints()
	frame.CategoryFrame.NewButton:Height(20)
	frame.CategoryFrame.NewButton:Point("BOTTOMLEFT", frame.CategoryFrame.SelectAllButton, "TOPLEFT", 0, 2)
	frame.CategoryFrame.NewButton:Point("BOTTOMRIGHT", frame.CategoryFrame.ClearSelectionButton, "TOPRIGHT", 0, 2)

	-- Profile
	S:Proxy("HandleButton", frame.SetsButton)
	S:Proxy("HandleButton", frame.ConfigButton)

	-- Misc
	hooksecurefunc("HybridScrollFrame_CreateButtons", ReskinScrollFrameItems)
	ReskinScrollFrameItems(frame.AddonListFrame.ScrollFrame, "SimpleAddonManagerAddonItem")
	ReskinScrollFrameItems(frame.CategoryFrame.ScrollFrame, "SimpleAddonManagerCategoryItem")
end

function S:SimpleAddonManager()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.simpleAddonManager then
		return
	end

	if not _G.SimpleAddonManager then
		return
	end

	hooksecurefunc(_G.SimpleAddonManager, "Initialize", ReskinModules)

	_G.SimpleAddonManager:StripTextures(true)
	_G.SimpleAddonManager:SetTemplate("Transparent")
	self:CreateShadow(_G.SimpleAddonManager)
	self:Proxy("HandleCloseButton", _G.SimpleAddonManager.CloseButton)
end

S:AddCallbackForAddon("SimpleAddonManager")
