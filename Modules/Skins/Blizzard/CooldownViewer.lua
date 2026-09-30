local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM
local C = W.Utilities.Color

local _G = _G
local ceil = ceil
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local pairs = pairs

local data = S:AddCallbackForAddon("Blizzard_CooldownViewer", nil, "cooldownManager", "cooldownViewer")

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

function data:AcquireItemFrame(frame) -- self is the cooldown viewer container, not data
	local container = self
	if not container or not container.itemFramePool then
		return
	end

	RemoveDebuffBorder(frame)

	local db = S.db.cooldownViewer

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
			if not Icon.Icon.__windSkin and db.general.iconShadow then
				S:CreateBackdropShadow(Icon.Icon)
				Icon.Icon.__windSkin = true
			end
		end

		local Bar = frame.Bar
		if Bar then
			if not Bar.__windSkin and db.general.barShadow then
				for _, region in pairs({ Bar:GetRegions() }) do
					if region:IsObjectType("Texture") and region.backdrop then
						S:CreateBackdropShadow(region)
						break
					end
				end
				Bar.__windSkin = true
			end

			local statusBarTex = Bar:GetStatusBarTexture() --[[@as Texture]]
			statusBarTex:SetTexture(LSM:Fetch("statusbar", db.buffBar.barTexture))
			statusBarTex:SetGradient(
				"HORIZONTAL",
				C.CreateColorFromTable(db.buffBar.colorLeft),
				C.CreateColorFromTable(db.buffBar.colorRight)
			)
			statusBarTex:ClearTextureSlice()
			statusBarTex:SetTextureSliceMode(0)
		end
	else
		return
	end
end

function data:HandleViewer(element)
	if not S:IsHooked(element, "OnAcquireItemFrame") then
		S:SecureHook(element, "OnAcquireItemFrame", data.AcquireItemFrame)
	end

	for frame in element.itemFramePool:EnumerateActive() do
		data.AcquireItemFrame(element, frame)
	end
end

---Entry point kept on the module for Options
---@param element Frame The cooldown viewer container
function S:CooldownManager_HandleViewer(element)
	data:HandleViewer(element)
end

function data:HandleEnabledViewers()
	local db = S.db.cooldownViewer
	if not db.enable then
		return
	end

	if db.utility.enable then
		data:HandleViewer(_G.UtilityCooldownViewer)
	end

	if db.buffBar.enable then
		data:HandleViewer(_G.BuffBarCooldownViewer)
	end

	if db.buffIcon.enable then
		data:HandleViewer(_G.BuffIconCooldownViewer)
	end

	if db.essential.enable then
		data:HandleViewer(_G.EssentialCooldownViewer)
	end
end

local buttonOffset = 1
function data:PositionViewerTab(_, _, _, x, y) -- self is the tab, not data
	if x ~= buttonOffset or y ~= -10 then
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", _G.CooldownViewerSettings, "TOPRIGHT", buttonOffset, -10)
	end
end

do
	-- ElvUI captures `data.PositionViewerTab` with hooksecurefunc when its loader runs (after every addon file
	-- is parsed), so replacing the exported function here lets WindTools own the tab anchor without both hooks
	-- fighting inside `SetPoint`.
	local elvuiData = S:GetElvUISkinData("Blizzard_CooldownViewer")
	if elvuiData then
		elvuiData.PositionViewerTab = data.PositionViewerTab
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

			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", CooldownViewerSettings, "TOPRIGHT", 3, -10)
		else
			F.Move(tab, 0, -2)
		end
	end

	data:HandleEnabledViewers()
end
