local W, F, E, L, V, P, G = unpack(select(2, ...))

local format = format
local print = print
local tonumber = tonumber

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", W.Media.Icons.accept)

local function UpdateMessage(text, from)
    if isFirstLine then
        isFirstLine = false
        F.PrintGradientLine()
        F.Print(L["Update"])
    end

    print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, W.Version) .. DONE_ICON)
end

function W:ForPreReleaseUser()
end

function W:UpdateScripts()
    W:ForPreReleaseUser()
    local currentVersion = tonumber(W.Version) -- installed WindTools Version
    local globalVersion = tonumber(E.global.WT.version or "0") -- version in ElvUI Global

    -- changelog display
    if globalVersion == 0 or globalVersion ~= currentVersion then
        self.showChangeLog = true
    end

    -- from old updater
    if globalVersion == 0 then
        globalVersion = tonumber(E.global.WT.Version or "0")
        E.global.WT.Version = nil
    end

    local profileVersion = tonumber(E.db.WT.version or globalVersion) -- Version in ElvUI Profile
    local privateVersion = tonumber(E.private.WT.version or globalVersion) -- Version in ElvUI Private

    if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
        return
    end

    isFirstLine = true

    -- Clear the history of move frames.
    if privateVersion >= 2.27 and privateVersion <= 2.31 then
        E.private.WT.misc.framePositions = {}
        UpdateMessage(L["Move Frames"] .. " - " .. L["Clear History"], globalVersion)
    end

    -- Copy old move frames options to its new db.
    if privateVersion <= 2.33 then
        local miscDB = E.private.WT.misc
        miscDB.moveFrames.enable = miscDB.moveBlizzardFrames or miscDB.moveFrames.enable
        miscDB.moveFrames.elvUIBags = miscDB.moveElvUIBags or miscDB.moveFrames.elvUIBags
        miscDB.moveFrames.rememberPositions = miscDB.rememberPositions or miscDB.moveFrames.rememberPositions
        miscDB.moveFrames.framePositions = miscDB.framePositions or miscDB.moveFrames.framePositions

        miscDB.moveBlizzardFrames = nil
        miscDB.moveElvUIBags = nil
        miscDB.rememberPositions = nil
        miscDB.framePositions = nil

        UpdateMessage(L["Move Frames"] .. " - " .. L["Update Database"], globalVersion)
    end

    if profileVersion <= 2.34 then
        local miscDB = E.db.WT.misc
        miscDB.automation.hideBagAfterEnteringCombat =
            miscDB.autoHideBag or miscDB.automation.hideBagAfterEnteringCombat
        miscDB.automation.hideWorldMapAfterEnteringCombat =
            miscDB.autoHideWorldMap or miscDB.automation.hideWorldMapAfterEnteringCombat

        miscDB.autoHideBag = nil
        miscDB.autoHideWorldMap = nil

        UpdateMessage(L["Automation"] .. " - " .. L["Update Database"], profileVersion)
    end

    if not isFirstLine then
        F.PrintGradientLine()
    end

    E.global.WT.version = W.Version
    E.db.WT.version = W.Version
    E.private.WT.version = W.Version
end
