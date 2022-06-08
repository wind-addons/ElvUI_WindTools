local W, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local format = format
local pairs = pairs
local print = print
local strlen = strlen
local strrep = strrep
local tostring = tostring
local type = type

F.Developer = {}

local function isDebugMode()
    if E.global and E.global.WT and E.global.WT.core.debugMode then
        return true
    end

    return false
end

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
                    print(indent .. tostring(subject))
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

--[[
    Custom Error Handler
    @param ...string Error Message
]]
function F.Developer.ThrowError(...)
    if not isDebugMode() then
        return
    end

    local message = strjoin(" ", ...)
    _G.geterrorhandler()(format("%s |cffff3860%s|r\n", W.Title, "[ERROR]") .. message)
end

--[[
    Custom Logger [INFO]
    @param ...string Message
]]
function F.Developer.LogInfo(...)
    if not isDebugMode() then
        return
    end

    local message = strjoin(" ", ...)
    print(format("%s |cff209cee%s|r ", W.Title, "[INFO]") .. message)
end

--[[
    Custom Logger [WARNING]
    @param ...string Message
]]
function F.Developer.LogWarning(...)
    if not isDebugMode() then
        return
    end

    local message = strjoin(" ", ...)
    print(format("%s |cffffdd57%s|r ", W.Title, "[WARNING]") .. message)
end

--[[
    Custom Logger [DEBUG]
    @param ...string Message
]]
function F.Developer.LogDebug(...)
    if not isDebugMode() then
        return
    end

    local message = strjoin(" ", ...)
    print(format("%s |cff00d1b2%s|r ", W.Title, "[DEBUG]") .. message)
end


--[[
    Custom Logger Injection
    @param table Module | string Module Name
]]
function F.Developer.InjectLogger(module)
    if type(module) == "string" then
        module = W:GetModule(module)
    end

    if not module or type(module) ~= "table" then
        F.Developer.ThrowError("Module logger injection: Invalid module.")
        return
    end

    if not module.Log then
        module.Log = function(self, level, message)
            local richMessage = format("|cfff6781d[%s]|r %s", self:GetName(), message)
            if level == "info" then
                F.Developer.LogInfo(richMessage)
            elseif level == "warning" then
                F.Developer.LogWarning(richMessage)
            elseif level == "debug" then
                F.Developer.LogDebug(richMessage)
            end
        end
    end
end