local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')
local B = E:GetModule('DataBars')

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ElvUI_DataBars()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.databars) then return end

    local bars = {_G.ElvUI_AzeriteBar, _G.ElvUI_ExperienceBar, _G.ElvUI_ReputationBar, _G.ElvUI_HonorBar}

    for _, bar in pairs(bars) do if bar then S:CreateShadow(bar) end end

    -- 后续进行配置更新时进行添加
    hooksecurefunc(B, "CreateBar", function(_, name)
        print(name)
        if _G[name] then S:CreateShadow(_G[name]) end
    end)
end

S:AddCallback('ElvUI_DataBars')
