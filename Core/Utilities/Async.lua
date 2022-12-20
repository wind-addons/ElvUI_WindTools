local W, F, E, L, V, P, G = unpack(select(2, ...))

W.Utilities.Async = {}
local U = W.Utilities.Async

local cache = {
    item = {},
    spell = {}
}

function U.WithItem(itemID, callback)
    if type(itemID) ~= "number" then
        return
    end

    if not callback then
        callback = function()
        end
    end

    if type(callback) ~= "function" then
        return
    end

    if cache.item[itemID] then
        callback(cache.item[itemID])
        return cache.item[itemID]
    end

    local itemInstance = Item:CreateFromItemID(itemID)
    if itemInstance:IsItemEmpty() then
        F.Developer.LogDebug("Failed to create item instance for itemID: " .. itemID)
        return
    end

    itemInstance:ContinueOnItemLoad(
        function()
            callback(itemInstance)
        end
    )

    cache.item[itemID] = itemInstance

    return itemInstance
end

function U.WithSpell(spellID, callback)
    if type(spellID) ~= "number" then
        return
    end

    if not callback then
        callback = function()
        end
    end

    if type(callback) ~= "function" then
        return
    end

    if cache.spell[spellID] then
        callback(cache.spell[spellID])
        return cache.spell[spellID]
    end

    local spellInstance = Spell:CreateFromSpellID(spellID)

    if spellInstance:IsSpellEmpty() then
        F.Developer.LogDebug("Failed to create spell instance for spellID: " .. spellID)
        return
    end

    spellInstance:ContinueOnSpellLoad(
        function()
            callback(spellInstance)
        end
    )

    cache.spell[spellID] = spellInstance

    return spellInstance
end

function U.WithItemTable(itemIDTable, tType, callback)
    if type(itemIDTable) ~= "table" then
        return
    end

    if not callback then
        callback = function()
        end
    end

    if type(callback) ~= "function" then
        return
    end

    if type(tType) ~= "string" then
        tType = "value"
    end

    if tType == "list" then
        for _, itemID in ipairs(itemIDTable) do
            U.WithItem(itemID, callback)
        end
    end

    if tType == "value" then
        for _, itemID in pairs(itemIDTable) do
            U.WithItem(itemID, callback)
        end
    end

    if tType == "key" then
        for itemID, _ in pairs(itemIDTable) do
            U.WithItem(itemID, callback)
        end
    end
end

function U.WithSpellTable(spellIDTable, tType, callback)
    if type(spellIDTable) ~= "table" then
        return
    end

    if not callback then
        callback = function()
        end
    end

    if type(callback) ~= "function" then
        return
    end

    if type(tType) ~= "string" then
        tType = "value"
    end

    if tType == "list" then
        for _, spellID in ipairs(spellIDTable) do
            U.WithSpell(spellID, callback)
        end
    end

    if tType == "value" then
        for _, spellID in pairs(spellIDTable) do
            U.WithSpell(spellID, callback)
        end
    end

    if tType == "key" then
        for spellID, _ in pairs(spellIDTable) do
            U.WithSpell(spellID, callback)
        end
    end
end
