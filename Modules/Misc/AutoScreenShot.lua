local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc
local CA = W:GetModule("CombatAlert")

local _G = _G
local hooksecurefunc = hooksecurefunc

local GenerateClosure = GenerateClosure
local RunNextFrame = RunNextFrame

local alertFrame

local allianceAchievements = {
	-- https://www.wowhead.com/achievements/guild-achievements#0-2+7;side=Alliance
	4912, -- 公會等級25
	5014, -- 北裂境地城公會英雄
	5031, -- 部落殺手
	5111, -- 英雄:勇士試煉公會團
	5126, -- 地城外交官
	5129, -- 大使
	5130, -- 外交手段
	5131, -- 艾澤拉斯戰爭
	5151, -- 人類職業狂
	5152, -- 優異表現
	5153, -- 夜精靈職業狂
	5154, -- 地精職業狂
	5155, -- 矮人職業狂
	5156, -- 德萊尼職業狂
	5157, -- 狼人職業狂
	5167, -- 獸人殺手
	5168, -- 牛頭人殺手
	5169, -- 不死族殺手
	5170, -- 食人妖殺手
	5171, -- 血精靈殺手
	5172, -- 哥布林殺手
	5195, -- 主城攻擊好手
	5432, -- 公會指揮官
	5434, -- 公會元帥
	5436, -- 公會戰場元帥
	5438, -- 公會總元帥
	5441, -- 公會戰鬥大師
	5812, -- 聯合國
	6532, -- 熊貓人殺手
	6624, -- 全職的熊貓人
	6644, -- 熊貓人大使館
	7448, -- 事件總結
	13320, -- 達薩亞洛之戰公會團
}

local hordeAchievements = {
	-- https://www.wowhead.com/achievements/guild-achievements#0-2+7;side=Horde
	5110, -- 英雄:勇士試煉公會團
	5124, -- 北裂境地城公會英雄
	5128, -- 艾澤拉斯戰爭
	5145, -- 地城外交官
	5158, -- 優異表現
	5160, -- 獸人職業狂
	5161, -- 牛頭人職業狂
	5162, -- 食人妖職業狂
	5163, -- 血精靈職業狂
	5164, -- 不死族職業狂
	5165, -- 哥布林職業狂
	5173, -- 人類殺手
	5174, -- 夜精靈殺手
	5175, -- 矮人殺手
	5176, -- 地精殺手
	5177, -- 德萊尼殺手
	5178, -- 狼人殺手
	5179, -- 聯盟殺手
	5194, -- 主城攻擊好手
	5433, -- 公會勇士
	5435, -- 公會將軍
	5437, -- 公會督軍
	5439, -- 公會高階督軍
	5440, -- 公會戰鬥大師
	5492, -- 公會等級25
	5892, -- 聯合國
	6533, -- 熊貓人殺手
	6625, -- 全職的熊貓人
	6664, -- 熊貓人大使館
	7449, -- 事件總結
	7843, -- 外交手段
	7844, -- 大使
	13319, -- 達薩亞洛之戰公會團
}

local achievements = {}

for _, id in pairs(allianceAchievements) do
	achievements[id] = "A"
end

for _, id in pairs(hordeAchievements) do
	achievements[id] = "H"
end

local function isAlertFrameShown()
	if alertFrame and alertFrame.IsShown and alertFrame:IsShown() then
		alertFrame = nil
		return true
	end
	return false
end

local function withHidingCombatAlert(f)
	local handle = CA and CA.db and CA.db.enable and CA.alert and CA.alert:IsShown()
	if handle then
		CA.alert:Hide()
	end

	RunNextFrame(f)

	if handle then
		E:Delay(0.2, CA.alert.Show, CA.alert)
	end
end

function M:DelayScreenshot(_, id, _, tried)
	-- cross-faction achievements bug
	if id and achievements[id] then
		return
	end

	tried = tried or 0

	if tried <= 4 then
		E:Delay(1, function()
			if isAlertFrameShown() then
				withHidingCombatAlert(function()
					_G.Screenshot()
					RunNextFrame(GenerateClosure(F.Print, L["Screenshot has been automatically taken."]))
				end)
			else
				self:DelayScreenshot(nil, nil, nil, tried + 1)
			end
		end)
	end
end

function M:AutoScreenShot()
	if E.private.WT.misc.autoScreenshot then
		self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")

		hooksecurefunc(_G.AchievementAlertSystem:GetAlertContainer(), "AddAlertFrame", function(_, frame)
			alertFrame = frame
			E:Delay(
				3, -- wait for 3 seconds
				function()
					if frame == alertFrame then
						alertFrame = nil
					end
				end
			)
		end)
	end
end

M:AddCallback("AutoScreenShot")
