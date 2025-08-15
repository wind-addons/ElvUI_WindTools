local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local abs = abs
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs

local function ReskinScrollFrameItems(frame, template)
	if template == "SimpleAddonManagerAddonItem" or template == "SimpleAddonManagerCategoryItem" then
		for _, btn in pairs(frame.buttons) do
			if not btn.__windSkin then
				F.SetFontOutline(btn.Name)
				S:Proxy("HandleCheckBox", btn.EnabledButton)
				local btnCheckTex = btn.EnabledButton.CheckedTexture
				if btnCheckTex then
					btnCheckTex.__windColorOverride = function(r, g, b)
						-- Because SAM uses 1, 1, 1 for the check color
						if r == 1 and g == 1 and b == 1 then
							return "DEFAULT"
						end

						if abs(r - 0.4) < 0.01 and g == 1 and abs(r - 0.4) < 0.01 then
							return {
								r = 0.75,
								g = 0.75,
								b = 0.75,
							}
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

local function ReskinSizer(frame)
	if not frame then
		return
	end

	for _, region in next, { frame:GetRegions() } do
		if region:IsObjectType("Texture") then
			region:SetTexture(E.Media.Textures.ArrowUp)
			region:SetTexCoord(0, 1, 0, 1)
			region:SetRotation(-2.35)
			region:SetAllPoints()
			break
		end
	end

	frame:Size(24)
	frame:Point("BOTTOMRIGHT", 1, -1)
	frame:SetFrameLevel(200)
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
	frame.OkButton:SetPoint("RIGHT", frame.CancelButton, "LEFT", -2, 0)
	frame.DisableAllButton:ClearAllPoints()
	frame.DisableAllButton:SetPoint("LEFT", frame.EnableAllButton, "RIGHT", 2, 0)
	ReskinSizer(frame.Sizer)

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
	frame.CategoryFrame.NewButton:SetHeight(20)
	frame.CategoryFrame.NewButton:SetPoint("BOTTOMLEFT", frame.CategoryFrame.SelectAllButton, "TOPLEFT", 0, 2)
	frame.CategoryFrame.NewButton:SetPoint("BOTTOMRIGHT", frame.CategoryFrame.ClearSelectionButton, "TOPRIGHT", 0, 2)

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

	local edd = _G.LibStub("ElioteDropDownMenu-1.0", true)
	if edd then
		hooksecurefunc(edd, "UIDropDownMenu_CreateFrames", function(level)
			if _G["ElioteDDM_DropDownList" .. level] and not _G["ElioteDDM_DropDownList" .. level].__windSkin then
				_G["ElioteDDM_DropDownList" .. level .. "Backdrop"]:SetTemplate("Transparent")
				_G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"]:SetTemplate("Transparent")
				self:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "Backdrop"])
				self:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"])
				_G["ElioteDDM_DropDownList" .. level].__windSkin = true
			end
		end)
	end
end

S:AddCallbackForAddon("SimpleAddonManager")
