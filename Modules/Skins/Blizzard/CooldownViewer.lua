local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_CooldownViewer")
data.toggle = "cooldownManager"
data.private = "cooldownViewer"
local LSM = E.Libs.LSM
local C = W.Utilities.Color

local _G = _G
local ceil = ceil
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs

local function UpdateFrameAndStrata(frame, config)
	frame:SetFrameStrata(S.db.cooldownViewer[config].frameStrata)
	frame:SetFrameLevel(S.db.cooldownViewer[config].frameLevel)
end

local iconHandlers = {}
local hookedIcons = {}

local function UpdateIcon(frame, config)
	local Icon = frame.Icon
	if Icon then
		if Icon and not Icon.__windSkin and S.db.cooldownViewer.general.iconShadow then
			S:CreateBackdropShadow(Icon)
			Icon.__windSkin = true
		end

		if not iconHandlers[config] then
			iconHandlers[config] = function(self)
				local width = self:GetWidth()
				local iconHeightRatio = S.db.cooldownViewer[config].iconHeightRatio
				local newHeight = ceil(width * iconHeightRatio + 0.5)
				self:Height(newHeight)
				self.Icon:SetTexCoord(E:CropRatio(width, newHeight))
			end
		end

		if not hookedIcons[frame] then
			hooksecurefunc(frame, "SetWidth", iconHandlers[config])
			hooksecurefunc(frame, "SetSize", iconHandlers[config])
			hookedIcons[frame] = true
		end

		iconHandlers[config](frame)
	end

	local ChargeCountText = frame.ChargeCount and frame.ChargeCount.Current
		or frame.Applications and frame.Applications.Applications
	if ChargeCountText then
		F.SetFontWithDB(ChargeCountText, S.db.cooldownViewer[config].chargeCountText)
		ChargeCountText:SetJustifyH(S.db.cooldownViewer[config].chargeCountText.justifyH)
		ChargeCountText:ClearAllPoints()
		ChargeCountText:Point(
			S.db.cooldownViewer[config].chargeCountText.point,
			frame,
			S.db.cooldownViewer[config].chargeCountText.relativePoint,
			S.db.cooldownViewer[config].chargeCountText.offsetX,
			S.db.cooldownViewer[config].chargeCountText.offsetY
		)
	end
end

local function RemoveDebuffBorder(frame)
	if not S.db.cooldownViewer.general.removeDebuffBorder then
		return
	end

	if frame.DebuffBorder then
		frame.DebuffBorder:SetAlpha(0)
	end
end

function S:CooldownManager_AcquireItemFrame(container, frame)
	if not container or not container.itemFramePool then
		return
	end

	RemoveDebuffBorder(frame)

	if container == _G.EssentialCooldownViewer then
		UpdateFrameAndStrata(frame, "essential")
		UpdateIcon(frame, "essential")
	elseif container == _G.UtilityCooldownViewer then
		UpdateFrameAndStrata(frame, "utility")
		UpdateIcon(frame, "utility")
	elseif container == _G.BuffIconCooldownViewer then
		UpdateFrameAndStrata(frame, "buffIcon")
		UpdateIcon(frame, "buffIcon")
	elseif container == _G.BuffBarCooldownViewer then
		UpdateFrameAndStrata(frame, "buffBar")

		local Icon = frame.Icon
		if Icon and Icon.Icon then
			if not Icon.Icon.__windSkin and self.db.cooldownViewer.general.iconShadow then
				S:CreateBackdropShadow(Icon.Icon)
				Icon.Icon.__windSkin = true
			end
		end

		local Bar = frame.Bar
		if Bar then
			if not Bar.__windSkin and self.db.cooldownViewer.general.barShadow then
				for _, region in pairs({ Bar:GetRegions() }) do
					if region:IsObjectType("Texture") and region.backdrop then
						self:CreateBackdropShadow(region)
						break
					end
				end
				Bar.__windSkin = true
			end

			local statusBarTex = Bar:GetStatusBarTexture() --[[@as Texture]]
			statusBarTex:SetTexture(LSM:Fetch("statusbar", self.db.cooldownViewer.buffBar.barTexture))
			statusBarTex:SetGradient(
				"HORIZONTAL",
				C.CreateColorFromTable(self.db.cooldownViewer.buffBar.colorLeft),
				C.CreateColorFromTable(self.db.cooldownViewer.buffBar.colorRight)
			)
			statusBarTex:ClearTextureSlice()
			statusBarTex:SetTextureSliceMode(0)
		end
	else
		return
	end
end

function S:CooldownManager_HandleViewer(element)
	if not self:IsHooked(element, "OnAcquireItemFrame") then
		self:SecureHook(element, "OnAcquireItemFrame", "CooldownManager_AcquireItemFrame")
	end

	for frame in element.itemFramePool:EnumerateActive() do
		self:CooldownManager_AcquireItemFrame(element, frame)
	end
end

function S:Blizzard_CooldownViewer_Modification()
	if not self.db.cooldownViewer.enable then
		return
	end

	if self.db.cooldownViewer.utility.enable then
		self:CooldownManager_HandleViewer(_G.UtilityCooldownViewer)
	end

	if self.db.cooldownViewer.buffBar.enable then
		self:CooldownManager_HandleViewer(_G.BuffBarCooldownViewer)
	end

	if self.db.cooldownViewer.buffIcon.enable then
		self:CooldownManager_HandleViewer(_G.BuffIconCooldownViewer)
	end

	if self.db.cooldownViewer.essential.enable then
		self:CooldownManager_HandleViewer(_G.EssentialCooldownViewer)
	end
end

local buttonOffset = 1

local function SetViewerTabPoint(tab)
	-- Frame method, not the hooked SetPoint, so ElvUI's position hook does not run again.
	local setPoint = getmetatable(tab).__index.SetPoint
	tab:ClearAllPoints()
	setPoint(tab, "TOPLEFT", _G.CooldownViewerSettings, "TOPRIGHT", buttonOffset, -10)
end

local function PositionViewerTab(tab, _, _, _, x, y)
	if x ~= buttonOffset or y ~= -10 then
		SetViewerTabPoint(tab)
	end
end

function S:Blizzard_CooldownViewer()
	local CooldownViewerSettings = _G.CooldownViewerSettings
	if not CooldownViewerSettings then
		return
	end

	self:CreateShadow(CooldownViewerSettings)

	for i, tab in ipairs({ CooldownViewerSettings.SpellsTab, CooldownViewerSettings.AurasTab }) do
		if tab.backdrop then
			self:CreateBackdropShadow(tab)
			tab.backdrop:SetTemplate("Transparent")
		end

		if i == 1 then
			buttonOffset = 3

			if not tab.__windPositionHook then
				hooksecurefunc(tab, "SetPoint", PositionViewerTab)
				tab.__windPositionHook = true
			end

			SetViewerTabPoint(tab)
		else
			F.Move(tab, 0, -2)
		end
	end

	self:Blizzard_CooldownViewer_Modification()
end

