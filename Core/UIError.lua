local W ---@class WindTools
local F, E
W, F, E = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI

local _G = _G
local ipairs = ipairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local FrameUtil_RegisterForTopLevelParentChanged = FrameUtil.RegisterForTopLevelParentChanged
local GenerateFlatClosure = GenerateFlatClosure

local DEFAULT_HANDLER_PRIORITY = 1000

---@class UIErrorHandlerParams
---@field frame MessageFrame
---@field message string
---@field r number
---@field g number
---@field b number
---@field a number

---@alias UIErrorHandlerFunc fun(params: UIErrorHandlerParams): string?

---@class UIErrorHandler
---@field priority number
---@field handler UIErrorHandlerFunc

W.UIERRORFRAME_IGNORE_PATTERN = "WINDTOOLS_IGNORE"
W.UIErrorHandlers = W.UIErrorHandlers or {} ---@type UIErrorHandler[]

local syncing = false
local function SyncVisibility(isShown)
	if syncing then
		return
	end

	syncing = true

	_G.UIErrorsFrame:SetShown(not isShown)
	W.UIErrorsFrame:SetShown(isShown)

	syncing = false
end

function W:HookUIError()
	W.UIErrorsFrame = _G.WTUIErrorsFrame

	if not (E.private.WT.skins.enable and E.private.WT.skins.uiErrors and E.private.WT.skins.uiErrors.enable) then
		W.UIErrorsFrame:Hide()
		return
	end

	FrameUtil_RegisterForTopLevelParentChanged(W.UIErrorsFrame)

	W.UIErrorsFrame.flashingFontStrings = {}

	if not self:IsHooked(_G.UIErrorsFrame, "AddMessage") then
		self:SecureHook(_G.UIErrorsFrame, "AddMessage", function(frame, message, r, g, b, a, ...)
			if message and (message == W.UIERRORFRAME_IGNORE_PATTERN or message == "") then
				return
			end

			---@type UIErrorHandlerParams
			local params = { frame = frame, message = message, r = r, g = g, b = b, a = a }
			for _, handlerData in ipairs(self.UIErrorHandlers) do
				local success, result = xpcall(handlerData.handler, F.Developer.ThrowError, params)
				if not success then
					return
				end

				if type(result) == "string" and result == "skip" then
					return
				end
			end

			W.UIErrorsFrame:AddMessage(params.message, params.r, params.g, params.b, params.a, ...)

			SyncVisibility(true)
		end)
	end

	if not self:IsHooked(_G.UIErrorsFrame, "Show") then
		self:SecureHook(_G.UIErrorsFrame, "Show", GenerateFlatClosure(SyncVisibility, true))
	end

	if not self:IsHooked(_G.UIErrorsFrame, "Hide") then
		self:SecureHook(_G.UIErrorsFrame, "Hide", GenerateFlatClosure(SyncVisibility, false))
	end

	if not self:IsHooked(_G.UIErrorsFrame, "SetShown") then
		self:SecureHook(_G.UIErrorsFrame, "SetShown", function(_, shown)
			SyncVisibility(shown)
		end)
	end

	W.Modules.Skins:UIErrors()
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
