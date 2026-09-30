local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local DB = E:GetModule("DataBars")

local _G = _G
local pairs = pairs

local data = S:AddCallback("ElvUI_DataBars", S:CreateElvUICheck("dataBars"))

function data:SkinDataBar(name) -- self is the DataBars module, not data
	S:CreateBackdropShadow(_G[name], true)
end

function S:ElvUI_DataBars()
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
	self:SecureHook(DB, "CreateBar", data.SkinDataBar)
end
