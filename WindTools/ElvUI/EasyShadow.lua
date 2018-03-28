local E = unpack(ElvUI);
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G
-- 选择你喜欢的颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- 阴影函数

function CreateMyShadow(frame, size)
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
FrameListSize3 = {
	"GameTooltip", -- 鼠标提示
}

for i, frameName in ipairs(FrameListSize3) do
    local tempFrame = _G[frameName]
    CreateMyShadow(tempFrame, 3)
end

FrameListSize5 = {
	"MMHolder", -- 小地图
	"GameMenuFrame", -- 游戏菜单
	"SplashFrame", -- 全新特色
	"InterfaceOptionsFrame", -- 界面选项
	"VideoOptionsFrame", -- 系统选项
}

for i, frameName in ipairs(FrameListSize5) do
    local tempFrame = _G[frameName]
    CreateMyShadow(tempFrame, 5)
end