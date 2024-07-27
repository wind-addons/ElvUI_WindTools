local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

-- We must wait for ElvUI to create the backdrop before we can skin it
local function SkinFrame(frame, times)
    local t = times or 0

    if t >= 5 then
        return
    end

    if not frame.backdrop then
        E:Delay(
            0.1,
            function()
                SkinFrame(frame, times + 1)
            end
        )
    end

    S:CreateBackdropShadow(frame)
end

local function OpenMenu(manager)
    local menu = manager:GetOpenMenu()
    if menu then
        SkinFrame(menu)
    end
end

function S:Blizzard_Menu()
    if not self:CheckDB("misc") then
        return
    end

    local manager = _G.Menu.GetManager()
    hooksecurefunc(manager, "OpenMenu", OpenMenu)
    hooksecurefunc(manager, "OpenContextMenu", OpenMenu)
end

S:AddCallbackForAddon("Blizzard_Menu")
