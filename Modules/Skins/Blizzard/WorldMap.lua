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
		local DetailsFrame = QuestMapFrame.DetailsFrame
		local RewardsFrameContainer = DetailsFrame.RewardsFrameContainer
		if DetailsFrame.backdrop then
			DetailsFrame.backdrop:SetTemplate("Transparent")
		end
		if RewardsFrameContainer and RewardsFrameContainer.RewardsFrame then
			local RewardsFrame = RewardsFrameContainer.RewardsFrame
			if RewardsFrame.backdrop then
				RewardsFrame.backdrop:SetTemplate("Transparent")
			else
				RewardsFrame:CreateBackdrop("Transparent")
				S:Reposition(RewardsFrame.backdrop, RewardsFrame, 0, -12, 0, 0, 3)

				DetailsFrame.backdrop:Point("TOPLEFT", 0, 5)
				DetailsFrame.backdrop:Point("BOTTOMRIGHT", RewardsFrame.backdrop, "TOPRIGHT", -3, 5)
			end
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		self:CreateBackdropShadow(dialog)
	end)
end

S:AddCallback("WorldMapFrame")
