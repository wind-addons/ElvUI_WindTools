local W ---@class WindTools
local F, E ---@type Functions, ElvUI
W, F, E = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI

local _G = _G
local ipairs = ipairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local DEFAULT_HANDLER_PRIORITY = 1000

---@class UIErrorHandlerParams
---@field frame UIErrorsFrame
---@field msg string
---@field r number
---@field g number
---@field b number
---@field a number

---@alias UIErrorHandlerFunc fun(params: UIErrorHandlerParams)

---@class UIErrorHandler
---@field priority number
---@field handler UIErrorHandlerFunc

W.UIErrorHandlers = W.UIErrorHandlers or {} ---@type UIErrorHandler[]

function W:HookUIError()
	if self:IsHooked(_G.UIErrorsFrame, "AddMessage") then
		return
	end

	self:RawHook(_G.UIErrorsFrame, "AddMessage", function(frame, message, r, g, b, a)
		local params = { frame = frame, msg = message, r = r, g = g, b = b, a = a } ---@type UIErrorHandlerParams
		for _, handlerData in ipairs(self.UIErrorHandlers) do
			if not xpcall(handlerData.handler, F.Developer.ThrowError, params) then
				return
			end
		end

		self.hooks[_G.UIErrorsFrame].AddMessage(params.frame, params.msg, params.r, params.g, params.b, params.a)
	end, true)
end

---@param handler UIErrorHandlerFunc
---@param priority? number
function W:RegisterUIErrorHandler(handler, priority)
	if type(handler) ~= "function" then
		return
	end

	local handlerPriority = priority or DEFAULT_HANDLER_PRIORITY
	local newHandler = { priority = handlerPriority, handler = handler }
	local insertIndex = #self.UIErrorHandlers + 1
	for index, handlerData in ipairs(self.UIErrorHandlers) do
		if handlerData.priority > handlerPriority then
			insertIndex = index
			break
		end
	end

	tinsert(self.UIErrorHandlers, insertIndex, newHandler)
end
