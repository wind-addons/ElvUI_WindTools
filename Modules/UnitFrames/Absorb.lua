local W, F, E, L = unpack(select(2, ...))
local UF = E.UnitFrames
local A = W:NewModule("Absorb", "AceHook-3.0")

local _G = _G
local LSM = E.Libs.LSM

local pairs = pairs
local UnitIsConnected = UnitIsConnected
local hooksecurefunc = hooksecurefunc

local framePool = {}

function A:ConstructTextures(frame)
    if not frame or not frame.HealthPrediction then
        return
    end

    if not frame.HealthPrediction.windAbsorbOverlay then
        local overlay = frame.HealthPrediction.absorbBar:CreateTexture(nil, "OVERLAY", 11)
        overlay:SetTexture("Interface/RaidFrame/Shield-Overlay", true, true)
        frame.HealthPrediction.windAbsorbOverlay = overlay
    end

    if not frame.HealthPrediction.windOverAbsorbGlow then
        local glow = frame.Health:CreateTexture(nil, "OVERLAY", 10)
        glow:SetTexture("Interface/RaidFrame/Shield-Overshield")
        glow:SetBlendMode("ADD")
        frame.HealthPrediction.windOverAbsorbGlow = glow
    end
end

function A:ConfigureTextures(frame)
    if not (frame and frame.db and frame.db.healPrediction and frame.db.healPrediction.enable) then
        return
    end

    local pred = frame.HealthPrediction
    local overlay = pred.windAbsorbOverlay
    local glow = pred.windOverAbsorbGlow

    if not frame.db.health or not frame.Health then
        overlay:Hide()
        glow:Hide()
    else
        local isHorizontal = frame.Health:GetOrientation() == "HORIZONTAL"
        local isReverse = frame.Health:GetReverseFill()

        glow:ClearAllPoints()
        glow:SetHeight(16)

        local offset = frame.Health:GetReverseFill() and -3 or 3

        if isHorizontal then
            do
                local anchor = isReverse and "RIGHT" or "LEFT"
                overlay.SetOverlaySize = function(self, percent)
                    self:SetWidth(frame.Health:GetWidth() * percent)
                    self:SetTexCoord(0, overlay:GetWidth() / 32, 0, overlay:GetHeight() / 32)
                end
                overlay:SetPoint("TOP" .. anchor, pred.absorbBar, "TOP" .. anchor)
                overlay:SetPoint("BOTTOM" .. anchor, pred.absorbBar, "BOTTOM" .. anchor)
            end
            do
                local anchor = isReverse and "LEFT" or "RIGHT"
                glow:SetPoint("TOP", frame.Health, "TOP" .. anchor, offset, 2)
                glow:SetPoint("BOTTOM", frame.Health, "BOTTOM" .. anchor, offset, -2)
            end
        else
            do
                local anchor = isReverse and "TOP" or "BOTTOM"

                overlay.SetOverlaySize = function(self, percent)
                    self:SetHeight(frame.Health:GetHeight() * percent)
                    self:SetTexCoord(0, overlay:GetWidth() / 32, 0, overlay:GetHeight() / 32)
                end
                overlay:SetPoint(anchor .. "LEFT", pred.absorbBar, anchor .. "LEFT")
                overlay:SetPoint(anchor .. "RIGHT", pred.absorbBar, anchor .. "RIGHT")
            end
            do
                local anchor = isReverse and "BOTTOM" or "TOP"
                glow:SetPoint("LEFT", frame.Health, anchor .. "LEFT", -2, offset)
                glow:SetPoint("RIGHT", frame.Health, anchor .. "RIGHT", 2, offset)
            end
        end

        glow:Show()
    end
end

function A:HealthPrediction_OnUpdate(object, unit, _, _, absorb, _, hasOverAbsorb, _, health, maxHealth)
    if not self.db or not self.db.enable then
        return
    end

    local frame = object.frame
    local pred = frame.HealthPrediction

    local frameDB = frame and frame.db and frame.db.healPrediction
    if not frameDB or not frameDB.enable or not framePool[frame] then
        return
    end

    frame.windSmoothTweakBar:AddWork(
        function()
            local overlay = pred.windAbsorbOverlay
            local glow = pred.windOverAbsorbGlow

            if not self.db.blizzardAbsorbOverlay or maxHealth == health or absorb == 0 or not UnitIsConnected(unit) then
                overlay:Hide()
            else
                if maxHealth > health + absorb then
                    overlay:SetOverlaySize(absorb / maxHealth)
                    overlay:Show()
                elseif self.db.blizzardOverAbsorbGlow then
                    if health == maxHealth and frameDB.absorbStyle == "OVERFLOW" then
                        pred.absorbBar:SetValue(0)
                    end
                    overlay:SetOverlaySize((maxHealth - health) / maxHealth)
                    overlay:Show()
                else
                    overlay:Hide()
                end
            end

            if self.db.blizzardOverAbsorbGlow and hasOverAbsorb and UnitIsConnected(unit) then
                if health == maxHealth and frameDB.absorbStyle == "NORMAL" then
                    pred.absorbBar:SetValue(0)
                end
                glow:Show()
            else
                glow:Hide()
            end
        end
    )
end

function A:SetupFrame(frame)
    if not frame or framePool[frame] or not frame.HealthPrediction then
        return
    end

    self:SmoothTweak(frame)
    self:ConstructTextures(frame)
    self:ConfigureTextures(frame)

    if frame.HealthPrediction.PostUpdate then
        self:SecureHook(frame.HealthPrediction, "PostUpdate", "HealthPrediction_OnUpdate")
    end

    framePool[frame] = true
end

function A:CleanupFrame(frame)
    if not frame or not frame.HealthPrediction then
        return
    end

    frame.HealthPrediction.totalAbsorbOverlay:Hide()
    frame.HealthPrediction.overAbsorbGlow:Hide()
end

function A:WaitForUnitframesLoad(triedTimes)
    triedTimes = triedTimes or 0

    if triedTimes > 10 then
        F.DebugMessage(self:GetName(), "Failed to load unitframes after 10 times, please try again later.")
        return
    end

    if not UF.unitstoload and not UF.unitgroupstoload and not UF.headerstoload then
        for unit in pairs(UF.units) do
            self:SetupFrame(UF[unit])
        end

        for unit in pairs(UF.groupunits) do
            self:SetupFrame(UF[unit])
        end

        for group, header in pairs(UF.headers) do
            if header.GetChildren and header:GetNumChildren() > 0 then
                for _, child in pairs {header:GetChildren()} do
                    if child.groupName and child.GetChildren and child:GetNumChildren() > 0 then
                        for _, subChild in pairs {child:GetChildren()} do
                            self:SetupFrame(subChild)
                        end
                    end
                end
            end
        end
        -- Refresh all frames to make sure the replacing of textures
        UF:Update_AllFrames()
    else
        E:Delay(0.5, self.WaitForUnitframesLoad, self, triedTimes + 1)
    end
end

function A:SmoothTweak(frame)
    if frame.windSmoothTweakBar then
        return
    end

    frame.windSmoothTweakBar = CreateFrame("statusbar", nil, E.UIParent)
    frame.windSmoothTweakBar.SetValue = function(self)
        if self.work then
            self.work()
            self.work = nil
        end
    end

    frame.windSmoothTweakBar.AddWork = function(self, work)
        if UF and UF.db and UF.db.smoothbars then
            self.work = work
            self:SetValue(0)
        else
            work()
        end
    end

    E:SetSmoothing(frame.windSmoothTweakBar, true)
end

function A:SetTexture_HealComm(module, obj, texture)
    local func = self.hooks[module].SetTexture_HealComm

    if self.db and self.db.enable then
        if self.db.texture.blizzardStyle then
            texture = "Interface/RaidFrame/Shield-Fill"
        elseif self.db.texture.elvui then
            texture = LSM:Fetch("statusbar", self.db.texture.elvui)
        end
    end

    print(texture)
    return self.hooks[module].SetTexture_HealComm(module, obj, texture)
end

function A:Initialize()
    self.db = E.db.WT.unitFrames.absorb
    if not self.db or not self.db.enable then
        return
    end

    if self.initialized then
        return
    end

    self:RawHook(UF, "SetTexture_HealComm")
    self:WaitForUnitframesLoad()

    self.initialized = true
end

function A:ProfileUpdate()
    self:Initialize()

    if not self.db or not self.db.enable then
        for frame in pairs(framePool) do
            self:CleanupFrame(frame)
        end
    end
end

W:RegisterModule(A:GetName())
