local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local pairs = pairs
local MuteSoundFile = MuteSoundFile

local MountSE = {
    [45693] = {
        -- 彌米倫之首
        568252, -- sound/spells/summongyrocopter.ogg
        551385, -- sound/creature/gyrocopter/gyrocoptershuffleleftorright1.ogg
        551382, -- sound/creature/gyrocopter/gyrocoptershuffleleftorright2.ogg
        551392, -- sound/creature/gyrocopter/gyrocoptershuffleleftorright3.ogg
        551384, -- sound/creature/gyrocopter/gyrocoptergearshift1.ogg
        551391, -- sound/creature/gyrocopter/gyrocoptergearshift2.ogg
        551387, -- sound/creature/gyrocopter/gyrocoptergearshift3.ogg
        595100, -- sound/creature/mimironheadmount/mimironheadmount_walk.ogg
        555364, -- sound/creature/mimironheadmount/mimironheadmount_run.ogg
        595103, -- sound/creature/mimironheadmount/mimironheadmount_jumpstart.ogg
        595097 -- sound/creature/mimironheadmount/mimironheadmount_jumpend.ogg

    }
}

function M:Mute()
    if not E.private.WT.misc.mute.enable then
        return
    end

    for mountID, soundIDs in pairs(MountSE) do
        if E.private.WT.misc.mute.mount[mountID] then
            for _, soundID in pairs(soundIDs) do
                MuteSoundFile(soundID)
            end
        end
    end
end

M:AddCallback("Mute")
