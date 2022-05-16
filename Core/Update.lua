local W, F, E, L, V, P, G = unpack(select(2, ...))

local format = format
local print = print
local tonumber = tonumber

local isFirstLine = true

local doneIcon = format(" |T%s:0|t", W.Media.Icons.accept)

local function UpdateMessage(text, from, to)
    if isFirstLine then
        isFirstLine = false
        F.PrintGradientLine()
        F.Print(L["Update"])
    end

    print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%.2f|r)...", from, to) .. doneIcon)
end

function W:ForBetaUser()
    local miscDB = E.db.WT.misc
    miscDB.automation.hideBagAfterEnteringCombat = miscDB.autoHideBag or miscDB.automation.hideBagAfterEnteringCombat
    miscDB.automation.hideWorldMapAfterEnteringCombat =
        miscDB.autoHideWorldMap or miscDB.automation.hideWorldMapAfterEnteringCombat

    miscDB.autoHideBag = nil
    miscDB.autoHideWorldMap = nil
end

function W:UpdateScripts()
    local cv = tonumber(W.Version) -- Installed WindTools Version
    local gv = tonumber(E.global.WT.version or "0") -- Version in ElvUI Global

    -- from old updater
    if gv == 0 then
        gv = tonumber(E.global.WT.Version or "0")
        E.global.WT.Version = nil
    end

    local dv = tonumber(E.db.WT.version or gv) -- Version in ElvUI Profile
    local pv = tonumber(E.private.WT.version or gv) -- Version in ElvUI Private

    if gv == cv and dv == cv and pv == cv then
        return
    end

    isFirstLine = true

    -- Clear the history of move frames.
    if gv >= 2.27 and gv <= 2.31 then
        E.private.WT.misc.framePositions = {}
        UpdateMessage(L["Move Frames"] .. " - " .. L["Clear History"], gv, cv)
    end

    -- Copy old move frames options to its new db.
    if gv <= 2.33 then
        local miscDB = E.private.WT.misc
        miscDB.moveFrames.enable = miscDB.moveBlizzardFrames or miscDB.moveFrames.enable
        miscDB.moveFrames.elvUIBags = miscDB.moveElvUIBags or miscDB.moveFrames.elvUIBags
        miscDB.moveFrames.rememberPositions = miscDB.rememberPositions or miscDB.moveFrames.rememberPositions
        miscDB.moveFrames.framePositions = miscDB.framePositions or miscDB.moveFrames.framePositions

        miscDB.moveBlizzardFrames = nil
        miscDB.moveElvUIBags = nil
        miscDB.rememberPositions = nil
        miscDB.framePositions = nil

        UpdateMessage(L["Move Frames"] .. " - " .. L["Update Database"], gv, cv)
    end

    if dv <= 2.34 then
        local miscDB = E.db.WT.misc
        miscDB.automation.hideBagAfterEnteringCombat =
            miscDB.autoHideBag or miscDB.automation.hideBagAfterEnteringCombat
        miscDB.automation.hideWorldMapAfterEnteringCombat =
            miscDB.autoHideWorldMap or miscDB.automation.hideWorldMapAfterEnteringCombat

        miscDB.autoHideBag = nil
        miscDB.autoHideWorldMap = nil

        UpdateMessage(L["Automation"] .. " - " .. L["Update Database"], dv, cv)
    end

    if not isFirstLine then
        F.PrintGradientLine()
    end

    E.global.WT.version = W.Version
    E.db.WT.version = W.Version
    E.private.WT.version = W.Version
end
