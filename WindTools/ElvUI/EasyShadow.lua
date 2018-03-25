local E = unpack(ElvUI);
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G
-- 选择你喜欢的颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- 阴影函数
local function CreateMyShadow(frame, size)
	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop( {
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(5),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.8)
	frame.shadow = shadow
end

-- 创建阴影
local minimapFrame = _G["MMHolder"]
local gameTooltipFrame = _G["GameTooltip"]
local gameMenuFrame = _G["GameMenuFrame"]
CreateMyShadow(minimapFrame, 5)
CreateMyShadow(gameTooltipFrame, 3)
CreateMyShadow(gameMenuFrame, 5)