local W ---@class WindTools
local F, E
W, F, E = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI

local _G = _G
local ipairs = ipairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

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
local suppressedExternally = false

local function IsWTUIErrorEnabled()
	return E.private.WT.skins.enable and E.private.WT.skins.uiErrors and E.private.WT.skins.uiErrors.enable
end

local function SyncVisibility(showNative)
	if not (_G.UIErrorsFrame and W.UIErrorsFrame) then
		return
	end

	syncing = true
	if showNative then
		_G.UIErrorsFrame:Show()
		W.UIErrorsFrame:Hide()
	else
		_G.UIErrorsFrame:Hide()
		W.UIErrorsFrame:Show()
	end
	syncing = false
end

local function HandleNativeShown()
	suppressedExternally = false

	if IsWTUIErrorEnabled() then
		SyncVisibility(false)
	end
end

local function HandleNativeHidden()
	if syncing then
		return
	end

	suppressedExternally = true

	if IsWTUIErrorEnabled() then
		syncing = true
		W.UIErrorsFrame:Hide()
		syncing = false
	end
end

local function ShouldSkipMessage(message)
	return message and (message == W.UIERRORFRAME_IGNORE_PATTERN or message == "")
end

function W:UpdateVisibility()
	if suppressedExternally then
		syncing = true
		_G.UIErrorsFrame:Hide()
		W.UIErrorsFrame:Hide()
		syncing = false
		return
	end

	SyncVisibility(not IsWTUIErrorEnabled())
end

function W:HookUIError()
	if not (_G.UIErrorsFrame and _G.WTUIErrorsFrame) then
		return
	end

	W.UIErrorsFrame = _G.WTUIErrorsFrame
	W.UIErrorsFrame.flashingFontStrings = W.UIErrorsFrame.flashingFontStrings or {}

	if not self:IsHooked(_G.UIErrorsFrame, "AddMessage") then
		self:SecureHook(_G.UIErrorsFrame, "AddMessage", function(_, message, r, g, b, a, ...)
			if not IsWTUIErrorEnabled() or suppressedExternally then
				return
			end

			W.UIErrorsFrame:AddMessage(message, r, g, b, a, ...)
			SyncVisibility(false)
		end)
	end

	if not self:IsHooked(_G.UIErrorsFrame, "OnShow") then
		self:SecureHookScript(_G.UIErrorsFrame, "OnShow", HandleNativeShown)
	end

	if not self:IsHooked(_G.UIErrorsFrame, "SetShown") then
		self:SecureHook(_G.UIErrorsFrame, "SetShown", function(_, shown)
			if shown then
				HandleNativeShown()
			else
				HandleNativeHidden()
			end
		end)
	end

	if not self:IsHooked(_G.UIErrorsFrame, "Hide") then
		self:SecureHook(_G.UIErrorsFrame, "Hide", HandleNativeHidden)
	end

	if not self:IsHooked(_G.UIErrorsFrame, "OnHide") then
		self:SecureHookScript(_G.UIErrorsFrame, "OnHide", HandleNativeHidden)
	end

	if not self:IsHooked(W.UIErrorsFrame, "AddMessage") then
		self:RawHook(W.UIErrorsFrame, "AddMessage", function(frame, message, r, g, b, a, ...)
			if ShouldSkipMessage(message) then
				return
			end

			local params = { frame = frame, message = message, r = r, g = g, b = b, a = a } ---@type UIErrorHandlerParams
			for _, handlerData in ipairs(self.UIErrorHandlers) do
				local success, result = xpcall(handlerData.handler, F.Developer.ThrowError, params)
				if not success then
					return
				end

				if type(result) == "string" and result == "skip" then
					return
				end
			end

			self.hooks[W.UIErrorsFrame].AddMessage(
				params.frame,
				params.message,
				params.r,
				params.g,
				params.b,
				params.a,
				...
			)
		end, true)
	end

	if _G.UIErrorsFrame:IsShown() then
		HandleNativeShown()
	else
		HandleNativeHidden()
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
