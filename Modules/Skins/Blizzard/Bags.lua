local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES

function S:ContainerFrame()
    if E.private.bags.enable or not self:CheckDB("bags") then
        return
    end

    for bagID = 1, NUM_CONTAINER_FRAMES do
        local container = _G["ContainerFrame" .. bagID]
        if container and container.template then
            self:CreateShadow(container)
        end
    end

    self:CreateShadow(_G.ContainerFrameCombinedBags)
end

S:AddCallback("ContainerFrame")
