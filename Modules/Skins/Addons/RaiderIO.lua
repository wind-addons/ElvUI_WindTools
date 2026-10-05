local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local unpack = unpack

local data = S:AddCallbackForAddon("RaiderIO", nil, S:CreateAddonCheck("raiderIO"))
S:AddCallbackForAddon("Blizzard_PlayerSpells", "RaiderIO_TalentFrameShortcut", S:CreateAddonCheck("raiderIO"))
S:AddCallbackForAddon("Blizzard_EncounterJournal", "RaiderIO_EncounterJournalShortcut", S:CreateAddonCheck("raiderIO"))

local skinned = false

---@param button Button?
local function SkinTalentBuildsShortcut(button)
	if not button or button.__windSkin then
		return
	end

	S:Proxy("HandleButton", button)

	button.__windSkin = true
end

local function TalentBuildsButton_SetBackdropFocus(button)
	button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
end

local function TalentBuildsButton_ClearBackdropFocus(button)
	button:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

---@param button Button
local function SkinTalentBuildsButton(button)
	if not button.isInit or button.__windSkin then
		return
	end

	button:SetTemplate("Transparent")
	button.SetBackdropFocus = TalentBuildsButton_SetBackdropFocus
	button.ClearBackdropFocus = TalentBuildsButton_ClearBackdropFocus
	button:UpdateBackdropFocus()

	button.__windSkin = true
end

---@param frame Frame
local function SkinTalentBuildsFrame(frame)
	if frame.__windSkin then
		return
	end

	S:Proxy("HandlePortraitFrame", frame)
	S:CreateShadow(frame)

	for _, menu in pairs({ frame.InstanceMenu, frame.DifficultyMenu, frame.WeaponMenu, frame.SpeedMenu }) do
		S:Proxy("HandleDropDownBox", menu, menu:GetWidth())
	end

	if frame.ScrollBar then
		S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	end

	if frame.ScrollBox then
		frame.ScrollBox:ForEachFrame(SkinTalentBuildsButton)
		hooksecurefunc(frame.ScrollBox, "Update", function(box)
			box:ForEachFrame(SkinTalentBuildsButton)
		end)
	end

	frame.__windSkin = true
end

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
						child:Height(30)

						if child:GetNumPoints() == 1 then
							local point, relativeTo, relativePoint, xOffset, yOffset = child:GetPoint(1)
							yOffset = -3
							child:ClearAllPoints()
							child:Point(point, relativeTo, relativePoint, xOffset, yOffset)
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

function data:GuildWeeklyFrame() -- self is PVEFrame, not data
	E:Delay(0.15, function()
		if _G.RaiderIO_GuildWeeklyFrame then
			local frame = _G.RaiderIO_GuildWeeklyFrame
			frame:StripTextures()
			frame:SetTemplate("Transparent")
			F.SetFont(frame.Title)
			frame.Title:SetShadowColor(0, 0, 0, 0)
			F.SetFont(frame.SubTitle)
			frame.SubTitle:SetShadowColor(0, 0, 0, 0)
			frame.SwitchGuildBest:Size(18)
			S:Proxy("HandleCheckBox", frame.SwitchGuildBest)
		end
	end)
end

function S:RaiderIO_TalentFrameShortcut()
	local dropdown = _G.PlayerSpellsFrame
		and _G.PlayerSpellsFrame.TalentsFrame
		and _G.PlayerSpellsFrame.TalentsFrame.LoadSystem
		and _G.PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown
	if not dropdown then
		return
	end

	-- the shortcut button is created lazily by RaiderIO, so check again whenever the dropdown is shown
	SkinTalentBuildsShortcut(_G.RaiderIO_TalentBuildsTalentFrameShortcut)
	self:SecureHookScript(dropdown, "OnShow", function()
		SkinTalentBuildsShortcut(_G.RaiderIO_TalentBuildsTalentFrameShortcut)
	end)
end

function S:RaiderIO_EncounterJournalShortcut()
	local dropdown = _G.EncounterJournalEncounterFrameInfoDifficulty
	if not dropdown then
		return
	end

	SkinTalentBuildsShortcut(_G.RaiderIO_TalentBuildsEncounterJournalShortcut)
	self:SecureHookScript(dropdown, "OnShow", function()
		SkinTalentBuildsShortcut(_G.RaiderIO_TalentBuildsEncounterJournalShortcut)
	end)
end

function S:RaiderIO()
	self:DisableAddOnSkin("RaiderIO")
	self:AddCallbackForEnterWorld("RaiderIO_DelayedSkinning")
	self:SecureHook(_G.PVEFrame, "Show", data.GuildWeeklyFrame)

	-- the talent builds frame is created on first use, skin it once its content has been set up
	if _G.RaiderIO_TalentBuildsFrame then
		SkinTalentBuildsFrame(_G.RaiderIO_TalentBuildsFrame)
	else
		self:SecureHook("ButtonFrameTemplate_HidePortrait", function(frame)
			if frame:GetName() ~= "RaiderIO_TalentBuildsFrame" then
				return
			end

			self:Unhook("ButtonFrameTemplate_HidePortrait")
			frame:HookScript("OnShow", SkinTalentBuildsFrame)
		end)
	end

	if _G.RaiderIO_SettingsPanel then
		for _, child in pairs({ _G.RaiderIO_SettingsPanel:GetChildren() }) do
			if child:GetObjectType("Button") then
				self:Proxy("HandleButton", child)
			end
		end
	end
end
