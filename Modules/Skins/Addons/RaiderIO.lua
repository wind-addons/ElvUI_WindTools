local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind

local skinned = false

function S:RaiderIO_DelayedSkinning()
	if skinned then
		return
	end

	skinned = true
	if _G.RaiderIO_ProfileTooltip then
		TT:SetStyle(_G.RaiderIO_ProfileTooltip)
		F.InternalizeMethod(_G.RaiderIO_ProfileTooltip, "SetPoint")
		hooksecurefunc(_G.RaiderIO_ProfileTooltip, "SetPoint", function()
			F.Move(_G.RaiderIO_ProfileTooltip, 4, 0)
		end)
	end

	if _G.RaiderIO_SearchFrame then
		_G.RaiderIO_SearchFrame:StripTextures()
		_G.RaiderIO_SearchFrame:SetTemplate("Transparent")
		self:CreateShadow(_G.RaiderIO_SearchFrame)
		self:Proxy("HandleCloseButton", _G.RaiderIO_SearchFrame.close)

		for _, child in pairs({ _G.RaiderIO_SearchFrame:GetChildren() }) do
			local numRegions = child:GetNumRegions()
			if numRegions == 9 then
				if child and child:GetObjectType() == "EditBox" then
					if not child.IsSkinned then
						child:DisableDrawLayer("BACKGROUND")
						child:DisableDrawLayer("BORDER")
						self:Proxy("HandleEditBox", child)
						child:SetTextInsets(2, 2, 2, 2)
						child:SetHeight(30)

						if child:GetNumPoints() == 1 then
							local point, relativeTo, relativePoint, xOffset, yOffset = child:GetPoint(1)
							yOffset = -3
							child:ClearAllPoints()
							child:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
						end

						child.IsSkinned = true
					end
				end
			end
		end
	end

	local configFrame

	for _, frame in pairs({ _G.UIParent:GetChildren() }) do
		if frame.scrollbar and frame.scrollframe then
			for _, child in pairs({ frame:GetChildren() }) do
				if child ~= frame.scrollbar and child ~= frame.scrollframe then
					local numChildren = child.GetNumChildren and child:GetNumChildren()
					if numChildren then
						if numChildren == 1 then
							frame.titleFrame = child
							local title = child:GetChildren()
							local titleText = title and title.text and title.text:GetText()
							if titleText and strfind(titleText, "Raider.IO") then
								configFrame = frame
							end
						elseif numChildren == 3 then
							frame.buttonFrame = child
						end
					end
				end
			end
		end
	end

	if configFrame then
		configFrame:SetTemplate("Transparent")
		self:CreateShadow(configFrame)

		self:Proxy("HandleScrollBar", configFrame.scrollbar)

		for _, frame in pairs({ configFrame.buttonFrame:GetChildren() }) do
			if frame:IsObjectType("Button") then
				frame:SetScript("OnEnter", nil)
				frame:SetScript("OnLeave", nil)
				F.SetFont(frame.text)
				self:Proxy("HandleButton", frame)
				frame.Center:Show()
			end
		end

		if configFrame.scrollframe and configFrame.scrollframe.content then
			for _, line in pairs({ configFrame.scrollframe.content:GetChildren() }) do
				for _, child in pairs({ line:GetChildren() }) do
					if child:IsObjectType("CheckButton") then
						self:Proxy("HandleCheckBox", child)
					end
				end
			end
		end
	end
end

function S:RaiderIO_GuildWeeklyFrame()
	E:Delay(0.15, function()
		if _G.RaiderIO_GuildWeeklyFrame then
			local frame = _G.RaiderIO_GuildWeeklyFrame
			frame:StripTextures()
			frame:SetTemplate("Transparent")
			F.SetFont(frame.Title)
			frame.Title:SetShadowColor(0, 0, 0, 0)
			F.SetFont(frame.SubTitle)
			frame.SubTitle:SetShadowColor(0, 0, 0, 0)
			frame.SwitchGuildBest:SetSize(18, 18)
			self:Proxy("HandleCheckBox", frame.SwitchGuildBest)
		end
	end)
end

function S:RaiderIO()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.raiderIO then
		return
	end

	self:DisableAddOnSkin("RaiderIO")
	self:AddCallbackForEnterWorld("RaiderIO_DelayedSkinning")
	self:SecureHook(_G.PVEFrame, "Show", "RaiderIO_GuildWeeklyFrame")

	if _G.RaiderIO_SettingsPanel then
		for _, child in pairs({ _G.RaiderIO_SettingsPanel:GetChildren() }) do
			if child:GetObjectType("Button") then
				self:Proxy("HandleButton", child)
			end
		end
	end
end

S:AddCallbackForAddon("RaiderIO")
