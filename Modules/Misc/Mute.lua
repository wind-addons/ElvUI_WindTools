local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local pairs = pairs
local MuteSoundFile = MuteSoundFile
local UnmuteSoundFile = UnmuteSoundFile

local MountSE = {
    [63796] = {
        -- 彌米倫之首
        568252, -- sound/spells/summongyrocopter.ogg
        595100, -- sound/creature/mimironheadmount/mimironheadmount_walk.ogg
        555364, -- sound/creature/mimironheadmount/mimironheadmount_run.ogg
        595103, -- sound/creature/mimironheadmount/mimironheadmount_jumpstart.ogg
        595097 -- sound/creature/mimironheadmount/mimironheadmount_jumpend.ogg
    },
    [229385] = {
        -- 班盧，宗師良伴
        1593212,-- sound/creature/ban-lu/vo_72_ban-lu_01_m.ogg
        1593213,-- sound/creature/ban-lu/vo_72_ban-lu_02_m.ogg
        1593214,-- sound/creature/ban-lu/vo_72_ban-lu_03_m.ogg
        1593215,-- sound/creature/ban-lu/vo_72_ban-lu_04_m.ogg
        1593216,-- sound/creature/ban-lu/vo_72_ban-lu_05_m.ogg
        1593217,-- sound/creature/ban-lu/vo_72_ban-lu_06_m.ogg
        1593218,-- sound/creature/ban-lu/vo_72_ban-lu_07_m.ogg
        1593219,-- sound/creature/ban-lu/vo_72_ban-lu_08_m.ogg
        1593220,-- sound/creature/ban-lu/vo_72_ban-lu_09_m.ogg
        1593221,-- sound/creature/ban-lu/vo_72_ban-lu_10_m.ogg
        1593222,-- sound/creature/ban-lu/vo_72_ban-lu_11_m.ogg
        1593223,-- sound/creature/ban-lu/vo_72_ban-lu_12_m.ogg
        1593224,-- sound/creature/ban-lu/vo_72_ban-lu_13_m.ogg
        1593225,-- sound/creature/ban-lu/vo_72_ban-lu_14_m.ogg
        1593226,-- sound/creature/ban-lu/vo_72_ban-lu_15_m.ogg
        1593227,-- sound/creature/ban-lu/vo_72_ban-lu_16_m.ogg
        1593228,-- sound/creature/ban-lu/vo_72_ban-lu_17_m.ogg
        1593229,-- sound/creature/ban-lu/vo_72_ban-lu_18_m.ogg
        1593230,-- sound/creature/ban-lu/vo_72_ban-lu_19_m.ogg
        1593231,-- sound/creature/ban-lu/vo_72_ban-lu_20_m.ogg
        1593232,-- sound/creature/ban-lu/vo_72_ban-lu_21_m.ogg
        1593233,-- sound/creature/ban-lu/vo_72_ban-lu_22_m.ogg
        1593234,-- sound/creature/ban-lu/vo_72_ban-lu_23_m.ogg
        1593235,-- sound/creature/ban-lu/vo_72_ban-lu_24_m.ogg
        1593236,-- sound/creature/ban-lu/vo_72_ban-lu_25_m.ogg
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
        else
            for _, soundID in pairs(soundIDs) do
                UnmuteSoundFile(soundID)
            end
        end
    end
end

M:AddCallback("Mute")
