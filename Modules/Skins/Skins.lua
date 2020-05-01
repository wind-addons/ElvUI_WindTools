local _, NameSpace = ...
local W, F, DB, E, L, V, P, G = unpack(NameSpace)
local LSM = E.Libs.LSM
local S = W:NewModule('Skins','AceTimer-3.0','AceHook-3.0','AceEvent-3.0')

local _G = _G
local xpcall = xpcall
local CreateFrame = CreateFrame

S.allowBypass = {}
S.addonsToLoad = {}
S.nonAddonsToLoad = {}

function S:CreateShadow(frame, size, r, g, b)
    if frame.shadow then return end
    -- 材质类型将阴影附着于父框架
    if frame:GetObjectType() == "Texture" then frame = frame:GetParent() end

    local shadow = CreateFrame('Frame', nil, frame)
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetOutside(frame, size or 4, size or 4)
    shadow:SetBackdrop({edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(size or 5)})
    shadow:SetBackdropColor(r, g, b, 0)
    shadow:SetBackdropBorderColor(r, g, b, size and 0.9 or 0.4)
end

function S:HandleFrame(frame)
end

function S:AddCallback(name, func, position)
	local load = (name == 'function' and name) or (not func and S[name])
	S:RegisterSkin('ElvUI', load or func, nil, nil, position)
end

function S:AddCallbackForAddon(addonName, name, func, forceLoad, bypass, position) -- arg2: name is 'given name'; see example above.
	local load = (name == 'function' and name) or (not func and (S[name] or S[addonName]))
	S:RegisterSkin(addonName, load or func, forceLoad, bypass, position)
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function S:RegisterSkin(addonName, func, forceLoad, bypass, position)
	if bypass then
		self.allowBypass[addonName] = true
	end

	if forceLoad then
		xpcall(func, errorhandler)
		self.addonsToLoad[addonName] = nil
	elseif addonName == 'ElvUI' then
		if position then
			tinsert(self.nonAddonsToLoad, position, func)
		else
			tinsert(self.nonAddonsToLoad, func)
		end
	else
		local addon = self.addonsToLoad[addonName]
		if not addon then
			self.addonsToLoad[addonName] = {}
			addon = self.addonsToLoad[addonName]
		end

		if position then
			tinsert(addon, position, func)
		else
			tinsert(addon, func)
		end
	end
end

function S:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler)
	end

	self.addonsToLoad[addonName] = nil
end

function S:ADDON_LOADED(_, addonName)
	if not self.allowBypass[addonName] and not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		S:CallLoadedAddon(addonName, object)
	end
end

function S:OnInitialize()
	for index, func in next, self.nonAddonsToLoad do
		xpcall(func, errorhandler)
		self.nonAddonsToLoad[index] = nil
	end

	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			S:CallLoadedAddon(addonName, object)
		end
	end
	C_Timer.After(2, function()
		print("Skins Loaded")
	end)
end

S:RegisterEvent('ADDON_LOADED')