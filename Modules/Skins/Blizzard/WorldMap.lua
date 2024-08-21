local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:WorldMapFrame()
	if not self:CheckDB("worldmap", "worldMap") then
		return
	end

	self:CreateBackdropShadow(_G.WorldMapFrame)

	local QuestScrollFrame = _G.QuestScrollFrame
	if QuestScrollFrame.Background then
		QuestScrollFrame.Background:Kill()
	end
	if QuestScrollFrame.DetailFrame and QuestScrollFrame.DetailFrame.backdrop then
		QuestScrollFrame.DetailFrame.backdrop:SetTemplate("Transparent")
	end

	local QuestMapFrame = _G.QuestMapFrame
	if QuestMapFrame.DetailsFrame then
		if QuestMapFrame.DetailsFrame.backdrop then
			QuestMapFrame.DetailsFrame.backdrop:SetTemplate("Transparent")
		end
		local RewardsFrameContainer = QuestMapFrame.DetailsFrame.RewardsFrameContainer
		if RewardsFrameContainer and RewardsFrameContainer.RewardsFrame then
			if RewardsFrameContainer.RewardsFrame.backdrop then
				RewardsFrameContainer.RewardsFrame.backdrop:SetTemplate("Transparent")
			else
				RewardsFrameContainer.RewardsFrame:CreateBackdrop("Transparent")
			end
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		self:CreateBackdropShadow(dialog)
	end)
end

S:AddCallback("WorldMapFrame")
