local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:BlizzardMiscFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.misc) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.misc) then return end

    -- 一些菜单框体
    local miscFrames = {
		"GameMenuFrame",
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"AutoCompleteBox",
		"ReadyCheckFrame",
		"QueueStatusFrame",
		"LFDReadyCheckPopup",
	}

    for _, frame in pairs(miscFrames) do
        S:CreateShadow(_G[frame])
    end

    -- 跳过剧情
    hooksecurefunc('CinematicFrame_OnDisplaySizeChanged', function(f)
        if f and f.CloseDialog then
            S:CreateShadow(f.CloseDialog)
		end
    end)
    
    hooksecurefunc('MovieFrame_PlayMovie', function(f)
        if f and f.CloseDialog then
            S:CreateShadow(f.CloseDialog)
		end
    end)

    -- 聊天菜单
    local chatMenus = {
		"ChatMenu",
		"EmoteMenu",
		"LanguageMenu",
		"VoiceMacroMenu",
    }
    
    for _, menu in pairs(chatMenus) do
        _G[menu]:HookScript("OnShow", function(f)
            if f then S:CreateShadow(f) end
        end)
	end
end

S:AddCallback('BlizzardMiscFrames')