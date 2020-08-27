local W, F, E, L, V, P, G = unpack(select(2, ...))
local strrep, type = strrep, type

F.Developer = {}

local format, tostring, type, print, pairs, strrep = format, tostring, type, print, pairs, strrep

local key = ""
function F.Developer.Print(object, level)
    if not level then
        key = ""
        level = 0
    end
    
    local indent = strrep(" ", level * 2)

    if type(object) == "table" then
        if key ~= "" then
            print(indent .. key .. " " .. "=" .. " " .. "{")
        else
            print(indent .. "{")
        end

        key = ""
        for k, v in pairs(object) do
            if type(v) == "table" then
                key = k
                F.Developer.Print(v, level + 1)
            else
                local content = format("%s%s = %s", indent .. "  ", tostring(k), tostring(v))
                print(content)
            end
        end
        print(indent .. "}")
    else
        print(indent .. tostring(object))
    end
end
