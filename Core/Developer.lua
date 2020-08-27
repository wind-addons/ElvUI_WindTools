local W, F, E, L, V, P, G = unpack(select(2, ...))
local strrep, type = strrep, type

F.Developer = {}

local type, pairs, print, tostring = type, pairs, print, tostring
local format, strrep, strlen = format, strrep, strlen

--[[
    高级打印函数
    -- 参考自 https://www.cnblogs.com/leezj/p/4230271.html
    @param {Any} object 随意变量或常量
]]
function F.Developer.Print(object)
    if type(object) == "table" then
        local cache = {}
        local function printLoop(subject, indent)
            if (cache[tostring(subject)]) then
                print(indent .. "*" .. tostring(subject))
            else
                cache[tostring(subject)] = true
                if (type(subject) == "table") then
                    for pos, val in pairs(subject) do
                        if (type(val) == "table") then
                            print(indent .. "[" .. pos .. "] => " .. tostring(subject) .. " {")
                            printLoop(val, indent .. strrep(" ", strlen(pos) + 8))
                            print(indent .. strrep(" ", strlen(pos) + 6) .. "}")
                        elseif (type(val) == "string") then
                            print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                        else
                            print(indent .. "[" .. pos .. "] => " .. tostring(val))
                        end
                    end
                else
                    print(indent .. tostring(t))
                end
            end
        end
        if (type(object) == "table") then
            print(tostring(object) .. " {")
            printLoop(object, "  ")
            print("}")
        else
            printLoop(object, "  ")
        end
        print()
    elseif type(object) == "string" then
        print('(string) "' .. object .. '"')
    else
        print("(" .. type(object) .. ") " .. tostring(object))
    end
end
