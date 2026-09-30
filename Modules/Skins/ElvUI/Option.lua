local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local InCombatLockdown = InCombatLockdown

local data = S:AddCallback("ElvUI_Options", S:CreateElvUICheck("option"))

function data:SkinOptions() -- self is ElvUI (E), not data
	if not InCombatLockdown() then
		S:CreateShadow(E:Config_GetWindow())
	end
end

function data:SkinInstall() -- self is ElvUI (E), not data
	if not InCombatLockdown() then
		S:CreateShadow(_G.ElvUIInstallFrame)
	end
end

function data:SkinMoverPopup() -- self is ElvUI (E), not data
	if not _G.ElvUIMoverPopupWindow then
		return
	end

	S:CreateShadow(_G.ElvUIMoverPopupWindow)
	S:CreateShadow(_G.ElvUIMoverPopupWindow.header)
end

function S:ElvUI_Options()
	-- 设定
	self:SecureHook(E, "ToggleOptions", data.SkinOptions)

	-- 安装
	if _G.ElvUIInstallFrame then
		self:CreateShadow(_G.ElvUIInstallFrame)
	else
		self:SecureHook(E, "Install", data.SkinInstall)
	end

	-- 调整位置
	self:SecureHook(E, "ToggleMoveMode", data.SkinMoverPopup)

	-- Key Binds
	self:CreateShadow(_G.ElvUIBindPopupWindowHeader)
end
