local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

local hooksecurefunc = hooksecurefunc

function S:AngryKeystones()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.angryKeystones then
        return
    end

    hooksecurefunc(
        "Scenario_ChallengeMode_ShowBlock",
        function()
            local block = _G.ScenarioChallengeModeBlock
            if block and block.TimerFrame and not block.TimerFrame.windStyle then
                block.TimerFrame.Bar2:SetTexture(E.media.blankTex)
                block.TimerFrame.Bar2:SetWidth(2)
                block.TimerFrame.Bar2:SetAlpha(0.618)
                block.TimerFrame.Bar3:SetTexture(E.media.blankTex)
                block.TimerFrame.Bar3:SetWidth(2)
                block.TimerFrame.Bar3:SetAlpha(0.618)
                block.TimerFrame.windStyle = true
            end
        end
    )
end

S:AddCallbackForAddon("AngryKeystones")
