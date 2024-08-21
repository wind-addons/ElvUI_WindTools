local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local DB = E:GetModule("DataBars")

local _G = _G
local pairs = pairs

function S:ElvUI_SkinDataBar(_, name)
	self:CreateBackdropShadow(_G[name], true)
end

function S:ElvUI_DataBars()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.dataBars) then
		return
	end

	local bars = {
		_G.ElvUI_AzeriteBarHolder,
		_G.ElvUI_ExperienceBarHolder,
		_G.ElvUI_ReputationBarHolder,
		_G.ElvUI_HonorBarHolder,
		_G.ElvUI_ThreatBarHolder,
	}
	for _, bar in pairs(bars) do
		if bar then
			self:CreateShadow(bar)
		end
	end

	-- 后续进行配置更新时进行添加
	self:SecureHook(DB, "CreateBar", "ElvUI_SkinDataBar")
end

S:AddCallback("ElvUI_DataBars")
