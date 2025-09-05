local W ---@type WindTools
local F ---@class Functions
local E ---@type ElvUI
W, F, E = unpack((select(2, ...)))

---@cast W WindTools
---@cast F Functions

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

---Pretty print any object with table structure visualization
---Modified from https://www.cnblogs.com/leezj/p/4230271.html
---@param object any The object to print (table, string, number, etc.)
function F.Developer.Print(object)
	if type(object) == "table" then
		---@type table<string, boolean> Cache to prevent infinite recursion
		local cache = {}
		---Print table structure recursively
		---@param subject any The current object to print
		---@param indent string Current indentation string
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

---Custom error handler with WindTools branding
---@param ... string Error message parts
function F.Developer.ThrowError(...)
	local message = strjoin(" ", ...)
	_G.geterrorhandler()(format("%s |cffff2457[ERROR]|r\n%s", W.Title, message))
end

---Custom logger for warning messages
---@param ... string Message parts
function F.Developer.LogWarning(...)
	if E.global.WT.developer.logLevel < 2 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cfffdc600[WARNING]|r %s", W.Title, message))
end

---Custom logger for info messages
---@param ... string Message parts
function F.Developer.LogInfo(...)
	if E.global.WT.developer.logLevel < 3 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff00a4f3[INFO]|r %s", W.Title, message))
end

---Custom logger for debug messages
---@param ... string Message parts
function F.Developer.LogDebug(...)
	if E.global.WT.developer.logLevel < 4 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff00d3bc[DEBUG]|r %s", W.Title, message))
end

---Inject logger methods into a module
---@param module table|string Module object or module name string
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

			local richMessage = format("%s %s", W.Utilities.Color.StringByTemplate(self.name, "amber-500"), message)
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

---Inspect object with DevTool addon
---https://github.com/brittyazel/DevTool
---@param obj any Object to inspect
---@param name string? Name for the object (optional)
function F.Developer.DevTool(obj, name)
	if _G.DevTool and _G.DevTool.AddData then
		_G.DevTool:AddData(obj, name)
	end
end
