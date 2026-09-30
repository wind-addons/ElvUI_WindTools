local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local data = S:AddCallback("AddonList", "addonManager")

function data:AddonList_Update() -- self is the first argument of AddonList_Update, not data
	local targets = _G.AddonList.ScrollBox.ScrollTarget
	for _, target in pairs({ targets:GetChildren() }) do
		if not target.__windSkin and target.Title and target.Status and target.Reload then
			F.SetFont(target.Title)
			F.SetFont(target.Status)
			F.SetFont(target.Reload)
			target.__windSkin = true
		end
	end
end

function S:AddonList()
	self:CreateShadow(_G.AddonList)
	self:SecureHook("AddonList_Update", data.AddonList_Update)
end
