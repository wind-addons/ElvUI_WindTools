local W, F, E, L = unpack(select(2, ...))
local CT = W:NewModule("Contacts", "AceEvent-3.0")
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G

function CT:ConstructFrame()
    local frame = CreateFrame("Frame", "WTContacts", _G.SendMailFrame)
    frame:Point("TOPLEFT", _G.MailFrame, "TOPRIGHT", 3, -1)
    frame:Point("BOTTOMRIGHT", _G.MailFrame, "BOTTOMRIGHT", 153, 1)
    frame:CreateBackdrop("Transparent")

    frame:EnableMouse(true)

    if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
        S:CreateShadow(frame.backdrop)
    end

    -- Register move frames
    if E.private.WT.misc.moveBlizzardFrames then
        local MF = W:GetModule("MoveFrames")
        MF:HandleFrame("WTContacts", "MailFrame")
    end
end

function CT:Initialize()
    self.altsTable = E.global.WT.item.contacts.alts

    if not self.altsTable[E.myrealm] then
        self.altsTable[E.myrealm] = {}
    end

    if not self.altsTable[E.myrealm][E.myname] then
        self.altsTable[E.myrealm][E.myname] = true
    end

    self.db = E.db.WT.item.contacts
    if not self.db.enable then
        return
    end

    self.customTable = E.global.WT.item.contacts.custom
end

function CT:ProfileUpdate()
    self.db = E.db.WT.item.contacts
end

W:RegisterModule(CT:GetName())
