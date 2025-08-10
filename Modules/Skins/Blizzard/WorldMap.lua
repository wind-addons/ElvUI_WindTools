local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

function S:WorldMapFrame()
	if not self:CheckDB("worldmap", "worldMap") then
		return
	end

	self:CreateBackdropShadow(_G.WorldMapFrame)

	local QuestMapFrame = _G.QuestMapFrame

	if QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.ScrollFrame then
		local QuestScrollFrame = QuestMapFrame.QuestsFrame.ScrollFrame
		if QuestScrollFrame.Background then
			QuestScrollFrame.Background:Kill()
		end
	end

	if QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame then
		local DetailsFrame = QuestMapFrame.QuestsFrame.DetailsFrame
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
				if RewardsFrame.backdrop then
					S:Reposition(RewardsFrame.backdrop, RewardsFrame, 0, -12, 0, 0, 3)

					if DetailsFrame.backdrop then
						DetailsFrame.backdrop:Point("TOPLEFT", 0, 5)
						DetailsFrame.backdrop:Point("BOTTOMRIGHT", RewardsFrame.backdrop, "TOPRIGHT", -3, 5)
					end
				end
			end
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		self:CreateBackdropShadow(dialog)
	end)

	local tabs = {
		QuestMapFrame.QuestsTab,
		QuestMapFrame.EventsTab,
		QuestMapFrame.MapLegendTab,
	}
	for i, tab in pairs(tabs) do
		if tab.backdrop then
			self:CreateBackdropShadow(tab)
			tab.backdrop:SetTemplate("Transparent")
		end

		if i > 1 then
			F.MoveFrameWithOffset(tab, 0, -2)
		end
	end

	if QuestMapFrame.QuestsTab then
		QuestMapFrame.QuestsTab:ClearAllPoints()
		QuestMapFrame.QuestsTab.__SetPoint = QuestMapFrame.QuestsTab.SetPoint
		QuestMapFrame.QuestsTab.SetPoint = E.noop
		QuestMapFrame.QuestsTab:__SetPoint("TOPLEFT", QuestMapFrame, "TOPRIGHT", 13, -30)
	end
end

S:AddCallback("WorldMapFrame")
