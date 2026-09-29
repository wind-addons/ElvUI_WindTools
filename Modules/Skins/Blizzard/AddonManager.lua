local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("AddonList")
data.toggle = "addonManager"

local _G = _G
local pairs = pairs

function S:Blizzard_AddonList_Update()
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
	self:SecureHook("AddonList_Update", "Blizzard_AddonList_Update")
end

