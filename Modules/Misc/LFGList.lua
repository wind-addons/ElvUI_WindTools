local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local LL = W:NewModule("LFGList", "AceHook-3.0")
local LSM = E.Libs.LSM

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local type = type

local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local RoleIconTextures = {
    FFXIV = {
        TANK = W.Media.Icons.ffxivTank,
        HEALER = W.Media.Icons.ffxivHealer,
        DAMAGER = W.Media.Icons.ffxivDPS
    },
    HEXAGON = {
        TANK = W.Media.Icons.hexagonTank,
        HEALER = W.Media.Icons.hexagonHealer,
        DAMAGER = W.Media.Icons.hexagonDPS
    },
    SUNUI = {
        TANK = W.Media.Icons.sunUITank,
        HEALER = W.Media.Icons.sunUIHealer,
        DAMAGER = W.Media.Icons.sunUIDPS
    },
    LYNUI = {
        TANK = W.Media.Icons.lynUITank,
        HEALER = W.Media.Icons.lynUIHealer,
        DAMAGER = W.Media.Icons.lynUIDPS
    },
    DEFAULT = {
        TANK = E.Media.Textures.Tank,
        HEALER = E.Media.Textures.Healer,
        DAMAGER = E.Media.Textures.DPS
    }
}

local function HandleMeetingStone()
    if IsAddOnLoaded("MeetingStone") or IsAddOnLoaded("MeetingStonePlus") then
        local NetEaseEnv = LibStub("NetEaseEnv-1.0")

        for k in pairs(NetEaseEnv._NSInclude) do
            if type(k) == "table" then
                local module = k.Addon and k.Addon.GetClass and k.Addon:GetClass("MemberDisplay")
                if module and module.SetActivity then
                    local original = module.SetActivity
                    module.SetActivity = function(self, activity)
                        self.resultID = activity and activity.GetID and activity:GetID() or nil
                        original(self, activity)
                    end
                end
            end
        end
    end
end

function LL:ReskinIcon(parent, icon, role, class)
    -- Beautiful square icons
    if role then
        if self.db.icon.reskin then
            if not self.db.icon.custom then
                icon:SetTexture(W.Media.Textures.ROLES)
                icon:SetTexCoord(F.GetRoleTexCoord(role))
            else
                icon:SetTexture(RoleIconTextures[self.db.icon.pack][role])
                icon:SetTexCoord(0, 1, 0, 1)
            end
        end

        icon:Size(self.db.icon.size)

        if self.db.icon.border and not icon.backdrop then
            icon:CreateBackdrop("Transparent")
        end

        icon:SetAlpha(self.db.icon.alpha)
    else
        icon:SetAlpha(0)
    end

    -- Create bar in class color behind
    if self.db.line.enable then
        if not icon.line then
            local line = parent:CreateTexture(nil, "ARTWORK")
            line:SetTexture(LSM:Fetch("statusbar", self.db.line.tex) or E.media.normTex)
            line:Size(self.db.line.width, self.db.line.height)
            line:Point("TOP", icon, "BOTTOM", self.db.line.offsetX, self.db.line.offsetY)
            icon.line = line
        end

        if class then
            local color = E:ClassColor(class, false)
            icon.line:SetVertexColor(color.r, color.g, color.b)
            icon.line:SetAlpha(self.db.line.alpha)
        else
            icon.line:SetAlpha(0)
        end
    end
end

function LL:UpdateEnumerate(Enumerate)
    local button = Enumerate:GetParent():GetParent()
    if not button.resultID then
        return
    end

    local result = C_LFGList_GetSearchResultInfo(button.resultID)

    if not result then
        return
    end

    local cache = {
        TANK = {},
        HEALER = {},
        DAMAGER = {}
    }

    for i = 1, result.numMembers do
        local role, class = C_LFGList_GetSearchResultMemberInfo(button.resultID, i)
        tinsert(cache[role], class)
    end

    for i = 5, 1, -1 do -- The index of icon starts from right
        local icon = Enumerate["Icon" .. i]
        if icon and icon.SetTexture then
            if #cache.TANK > 0 then
                self:ReskinIcon(Enumerate, icon, "TANK", cache.TANK[1])
                tremove(cache.TANK, 1)
            elseif #cache.HEALER > 0 then
                self:ReskinIcon(Enumerate, icon, "HEALER", cache.HEALER[1])
                tremove(cache.HEALER, 1)
            elseif #cache.DAMAGER > 0 then
                self:ReskinIcon(Enumerate, icon, "DAMAGER", cache.DAMAGER[1])
                tremove(cache.DAMAGER, 1)
            else
                self:ReskinIcon(Enumerate, icon)
            end
        end
    end
end

function LL:Initialize()
    self.db = E.private.WT.misc.lfgList
    if not self.db.enable then
        return
    end
    
    HandleMeetingStone()
    self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
end

W:RegisterModule(LL:GetName())
