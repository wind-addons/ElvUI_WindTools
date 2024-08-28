local W, F, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G
local format = format
local pairs = pairs
local print = print
local strjoin = strjoin
local strlen = strlen
local strlower = strlower
local strrep = strrep
local tostring = tostring
local type = type

F.Developer = {}

--[[
    Print pretty
    -- modified from https://www.cnblogs.com/leezj/p/4230271.html
    @param {Any} Any Object
]]
function F.Developer.Print(object)
	if type(object) == "table" then
		local cache = {}
		local function printLoop(subject, indent)
			if cache[tostring(subject)] then
				print(indent .. "*" .. tostring(subject))
			else
				cache[tostring(subject)] = true
				if type(subject) == "table" then
					for pos, val in pairs(subject) do
						if type(val) == "table" then
							print(indent .. "[" .. pos .. "] => " .. tostring(subject) .. " {")
							printLoop(val, indent .. strrep(" ", strlen(pos) + 8))
							print(indent .. strrep(" ", strlen(pos) + 6) .. "}")
						elseif type(val) == "string" then
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
		if type(object) == "table" then
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
	local message = strjoin(" ", ...)
	_G.geterrorhandler()(format("%s |cffff3860[ERROR]|r\n%s", W.Title, message))
end

--[[
    Custom Logger [WARNING]
    @param ...string Message
]]
function F.Developer.LogWarning(...)
	if E.global.WT.core.logLevel < 2 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cffffdd57[WARNING]|r %s", W.Title, message))
end

--[[
    Custom Logger [INFO]
    @param ...string Message
]]
function F.Developer.LogInfo(...)
	if E.global.WT.core.logLevel < 3 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff209cee[INFO]|r %s", W.Title, message))
end

--[[
    Custom Logger [DEBUG]
    @param ...string Message
]]
function F.Developer.LogDebug(...)
	if E.global.WT.core.logLevel < 4 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff00d1b2[DEBUG]|r %s", W.Title, message))
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
			if not level or type(level) ~= "string" then
				F.Developer.ThrowError("Invalid log level.")
				return
			end

			if not message or type(message) ~= "string" then
				F.Developer.ThrowError("Invalid log message.")
				return
			end

			level = strlower(level)

			local richMessage = format("|cfff6781d[%s]|r %s", self:GetName(), message)
			if level == "info" then
				F.Developer.LogInfo(richMessage)
			elseif level == "warning" then
				F.Developer.LogWarning(richMessage)
			elseif level == "debug" then
				F.Developer.LogDebug(richMessage)
			else
				F.Developer.ThrowError("Logger level should be info, warning or debug.")
			end
		end
	end
end

--[[
    Set delay for module initialization
    @param table module
    @param number delay
]]
function F.Developer.DelayInit(module, delay)
	delay = delay or 2
	if module.Initialize then
		module.Initialize_ = module.Initialize
		module.Initialize = function(self, ...)
			E:Delay(delay, self.Initialize_, self, ...)
		end
	end
end

--[[
	Inspect object with https://github.com/brittyazel/DevTool
	@param any obj
	@param string name
]]
function F.Developer.DT(obj, name)
	if _G.DevTool and _G.DevTool.AddData then
		_G.DevTool:AddData(obj, name)
	end
end
