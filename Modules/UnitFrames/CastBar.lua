local W, F, E, L = unpack(select(2, ...))
local CB = W:NewModule("CastBar", "AceHook-3.0", "AceEvent-3.0")

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local _G = _G
local pairs = pairs

local configKey = {
    ElvUF_Player = "player",
    ElvUF_Target = "target",
    ElvUF_Pet = "pet",
    ElvUF_Focus = "focus",
    ElvUF_Boss1 = "boss",
    ElvUF_Boss2 = "boss",
    ElvUF_Boss3 = "boss",
    ElvUF_Boss4 = "boss",
    ElvUF_Boss5 = "boss",
    ElvUF_Arena1 = "arena",
    ElvUF_Arena2 = "arena",
    ElvUF_Arena3 = "arena",
    ElvUF_Arena4 = "arena",
    ElvUF_Arena5 = "arena"
}

function CB:StyleAfterConfigure(_, unitFrame)
    local name = unitFrame and unitFrame:GetName()

    if not name then
        return
    end

    local db = configKey[name] and self.db[configKey[name]]
    local castBar = unitFrame.Castbar

    if castBar and db and db.enable and db.text and db.time then
        castBar.Text:ClearAllPoints()
        castBar.Text:Point(db.text.anchor, castBar, db.text.anchor, db.text.offsetX, db.text.offsetY)
        F.SetFontWithDB(castBar.Text, db.text.font)

        castBar.Time:ClearAllPoints()
        castBar.Time:Point(db.time.anchor, castBar, db.time.anchor, db.time.offsetX, db.time.offsetY)
        F.SetFontWithDB(castBar.Time, db.time.font)
    else
        UF:Configure_FontString(castBar.Text)
        UF:Configure_FontString(castBar.Time)
    end
end

function CB:ResetStyleWithElvUI(frameName)
    local frame = _G[frameName]
    if frame then
        UF:Configure_Castbar(frame)
    end
end

function CB:Refresh(key)
    for frame, theKey in pairs(configKey) do
        if not key or key == theKey then
            self:ResetStyleWithElvUI(frame)
        end
    end
end

function CB:Initialize()
    self.db = E.db.WT.unitFrames.castBar
    if not E.private.unitframe.enable or not self.db or not self.db.enable then
        return
    end

    self:SecureHook(UF, "Configure_Castbar", "StyleAfterConfigure")
end

function CB:ProfileUpdate()
    self.db = E.db.WT.unitFrames.castBar

    if self.db.enable then
        if not self.IsHooked(UF, "Configure_Castbar") then
            self:SecureHook(UF, "Configure_Castbar", "StyleAfterConfigure")
        end
        self:Refresh()
    else
        if self.IsHooked(UF, "Configure_Castbar") then
            self:Unhook(UF, "Configure_Castbar")
            self:Refresh()
        end
    end
end

W:RegisterModule(CB:GetName())
