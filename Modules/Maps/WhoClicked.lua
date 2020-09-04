local W, F, E, L = unpack(select(2, ...))
local WC = W:NewModule("WhoClicked", "AceEvent-3.0")

local _G = _G

local max = max
local select = select

local UnitClass = UnitClass
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown

local C_Timer_After = C_Timer.After

local hideTimes = 0
function WC:TryFadeOut()
    -- 保证最后一个点击可维持完整时间
    if hideTimes == 1 then
        E:UIFrameFadeOut(self.text, self.db.fadeOutTime, 1, 0)
    end
    hideTimes = max(hideTimes - 1, 0)
end

function WC:MINIMAP_PING(_, unit)
    if self.db and self.db.onlyOnCombat and not InCombatLockdown() then
        return
    end

    local englishClass = select(2, UnitClass(unit))
    local name, realm = UnitName(unit)

    if self.db.addRealm and realm ~= E.myrealm then
        name = name .. " - " .. realm
    end

    if self.db.classColor then
        name = F.CreateClassColorString(name, englishClass)
    else
        name = F.CreateColorString(name, self.db.customColor)
    end

    self.text:SetText(name)
    E:UIFrameFadeIn(self.text, WC.db.fadeInTime, 0, 1)
    hideTimes = hideTimes + 1

    C_Timer_After(
        WC.db.stayTime,
        function()
            WC:TryFadeOut()
        end
    )
end

function WC:UpdateText()
    if not self.text then
        local text = _G.Minimap:CreateFontString(nil, "OVERLAY")
        self.text = text
    end

    F.SetFontWithDB(self.text, self.db.font)
    self.text:Point("BOTTOM", _G.Minimap, "BOTTOM", self.db.xOffset, self.db.yOffset)
end

function WC:Initialize()
    self.db = E.db.WT.maps.whoClicked
    if not self.db or not self.db.enable then
        return
    end

    self:UpdateText()
    self:RegisterEvent("MINIMAP_PING")
    self.Initialized = true
end

function WC:ProfileUpdate()
    self.db = E.db.WT.maps.whoClicked

    if self.db and self.db.enable then
        self:UpdateText()
        if not self.Initialized then
            self:RegisterEvent("MINIMAP_PING")
            self.Initialized = true
        end
    else
        if self.Initialized then
            self:UnregisterEvent("MINIMAP_PING")
            self.Initialized = false
        end
    end
end

W:RegisterModule(WC:GetName())
