local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_AddonList_Update()
    for i = 1, _G.MAX_ADDONS_DISPLAYED do
        local entry = _G["AddonListEntry" .. i]
        local string = _G["AddonListEntry" .. i .. "Title"]
        F.SetFontOutline(string)
        F.SetFontOutline(entry.Status)
        F.SetFontOutline(entry.Reload)
    end
end

function S:AddonList()
    if not self:CheckDB("addonManager") then
        return
    end

    self:CreateShadow(_G.AddonList)
    self:SecureHook("AddonList_Update", "Blizzard_AddonList_Update")
end

S:AddCallback("AddonList")
