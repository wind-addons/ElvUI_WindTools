local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _
local _G = _G
local pairs = pairs

function S:Blizzard_GarrisonUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.AdventureMap) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.adventureMap) then
        return
    end

    local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
    local childFrame = AdventureMapQuestChoiceDialog.Details.Child

    S:CreateShadow(AdventureMapQuestChoiceDialog)
    AdventureMapQuestChoiceDialog.shadow:SetFrameStrata("LOW")

    F.SetFontOutline(childFrame.TitleHeader)
    F.SetFontOutline(childFrame.DescriptionText)
    F.SetFontOutline(childFrame.ObjectivesHeader)
    F.SetFontOutline(childFrame.ObjectivesText)
    F.SetFontOutline(AdventureMapQuestChoiceDialog.RewardsHeader)
end

S:AddCallbackForAddon("Blizzard_GarrisonUI")
