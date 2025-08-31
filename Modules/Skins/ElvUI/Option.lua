local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local InCombatLockdown = InCombatLockdown

function S:ElvUI_SkinOptions()
	if not InCombatLockdown() then
		self:CreateShadow(E:Config_GetWindow())
	end
end

function S:ElvUI_SkinInstall()
	if not InCombatLockdown() then
		self:CreateShadow(_G.ElvUIInstallFrame)
	end
end

function S:ElvUI_SkinMoverPopup()
	if not _G.ElvUIMoverPopupWindow then
		return
	end

	self:CreateShadow(_G.ElvUIMoverPopupWindow)
	self:CreateShadow(_G.ElvUIMoverPopupWindow.header)
end

function S:ElvUI_Options()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.option) then
		return
	end

	-- 设定
	self:SecureHook(E, "ToggleOptions", "ElvUI_SkinOptions")

	-- 安装
	if _G.ElvUIInstallFrame then
		self:CreateShadow(_G.ElvUIInstallFrame)
	else
		self:SecureHook(E, "Install", "ElvUI_SkinInstall")
	end

	-- 调整位置
	self:SecureHook(E, "ToggleMoveMode", "ElvUI_SkinMoverPopup")

	-- Key Binds
	self:CreateShadow(_G.ElvUIBindPopupWindowHeader)
end

S:AddCallback("ElvUI_Options")
