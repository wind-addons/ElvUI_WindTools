local W, F, E, L = unpack(select(2, ...))
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded

local SystemCache = {
    ["Header"] = {
        r = _G.OBJECTIVE_TRACKER_COLOR["Header"].r,
        g = _G.OBJECTIVE_TRACKER_COLOR["Header"].g,
        b = _G.OBJECTIVE_TRACKER_COLOR["Header"].b
    },
    ["HeaderHighlight"] = {
        r = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].r,
        g = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].g,
        b = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].b
    }
}

local classColor = _G.RAID_CLASS_COLORS[E.myclass]

function OT:UpdateHeaderFont()
    local frame = _G.ObjectiveTrackerFrame.MODULES
    local config = self.db.header

    if not config or not frame then
        return
    end

    for _, module in pairs(frame) do
        if module.Header then
			F.SetFontWithDB(module.Header.Text, config)
		end
	end
end

function OT:UpdateColorOfTitle()
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then
        return
    end

    local config = self.db.titleColor
    if not config then
        return
    end

    if config.enable and not self.titleColorChanged then
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {
            r = config.useClassColor and classColor.r or config.customColorNormal.r,
            g = config.useClassColor and classColor.g or config.customColorNormal.g,
            b = config.useClassColor and classColor.b or config.customColorNormal.b
        }

        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {
            r = config.useClassColor and classColor.r or config.customColorHighlight.r,
            g = config.useClassColor and classColor.g or config.customColorHighlight.g,
            b = config.useClassColor and classColor.b or config.customColorHighlight.b
        }

        self.titleColorChanged = true
    elseif not config.enable and self.titleColorChanged then
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {
            r = SystemCache["Header"].r,
            g = SystemCache["Header"].g,
            b = SystemCache["Header"].b
        }

        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {
            r = SystemCache["HeaderHighlight"].r,
            g = SystemCache["HeaderHighlight"].g,
            b = SystemCache["HeaderHighlight"].b
        }

        self.titleColorChanged = false
    end
end

function OT:Initialize()
    self.db = E.db.WT.quest.objectiveTracker
    if not self.db.enable or self.initialized then
        return
    end

    self:SecureHook("ObjectiveTracker_Update", "UpdateHeaderFont")

    self.initialized = true

    self:UpdateColorOfTitle()
end

function OT:ProfileUpdate()
    self:Initialize()
    self:UpdateColorOfTitle()
end

W:RegisterModule(OT:GetName())
