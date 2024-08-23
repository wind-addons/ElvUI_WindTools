local W, F, E, L = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local WS = W:NewModule("WidgetSkins", "AceHook-3.0", "AceEvent-3.0")
S.Widgets = WS

local abs = abs
local pairs = pairs
local pcall = pcall
local strlower = strlower
local type = type
local wipe = wipe

WS.LazyLoadTable = {}

function WS.IsUglyYellow(...)
	local r, g, b = ...
	return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function WS:Ace3_RegisterAsWidget(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "Button" or widgetType == "Button-ElvUI" then
		self:HandleButton(nil, widget)
	end
end

function WS:Ace3_RegisterAsContainer(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "TreeGroup" then
		self:HandleTreeGroup(widget)
	end
end

function WS:IsReady()
	return E.private and E.private.WT and E.private.WT.skins and E.private.WT.skins.widgets
end

function WS:RegisterLazyLoad(frame, func)
	if not frame then
		self:Log("debug", "frame is nil.")
		return
	end

	if type(func) ~= "function" then
		if self[func] and type(self[func]) == "function" then
			func = self[func]
		else
			self:Log("debug", func .. " is not a function.")
			return
		end
	end

	self.LazyLoadTable[frame] = func
end

function WS:LazyLoad()
	for frame, func in pairs(self.LazyLoadTable) do
		if frame and func then
			pcall(func, self, frame)
		end
	end

	wipe(self.LazyLoadTable)
end

function WS:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:LazyLoad()
end

WS:SecureHook(ES, "Ace3_RegisterAsWidget")
WS:SecureHook(ES, "Ace3_RegisterAsContainer")
WS:RegisterEvent("PLAYER_ENTERING_WORLD")
