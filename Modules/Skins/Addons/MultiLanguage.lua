local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

local TT = E:GetModule("Tooltip")

local function reskinTooltip(tt)
	if not tt or tt.__windSkin then
		return
	end

	tt:SetTemplate("Transparent")
	S:CreateShadow(tt)

	F.InternalizeMethod(tt, "SetPoint")
	hooksecurefunc(tt, "SetPoint", function(tooltip, ...)
		if tooltip ~= tt then
			return
		end

		local args = { ... }

		if #args ~= 3 or not args[1] == "TOPLEFT" or not args[3] then
			return
		end

		local isAttachedAtTop = args[3] and args[3] > 0
		local isHealthBarAtTop = TT.db.healthBar.statusPosition ~= "BOTTOM"

		local parent = tooltip:GetParent()
		if parent and parent.StatusBar and parent.StatusBar:IsShown() then
			local statusBarHeight = parent.StatusBar:GetHeight()
			local barYOffset = E.db.WT.tooltips.elvUITweaks.healthBar.barYOffset

			if isAttachedAtTop and isHealthBarAtTop and args[3] > 0 then
				args[3] = args[3] + statusBarHeight + barYOffset
				tooltip:ClearAllPoints()
				F.CallMethod(tooltip, "SetPoint", unpack(args))
				return
			end

			if not isAttachedAtTop and not isHealthBarAtTop and args[3] < 0 then
				args[3] = args[3] - statusBarHeight + barYOffset
				tooltip:ClearAllPoints()
				F.CallMethod(tooltip, "SetPoint", unpack(args))
				return
			end
		end
	end)

	tt.__windSkin = true
end

local function reskinQuest(tt)
	if not tt or tt.__windSkin then
		return
	end

	tt:SetTemplate("Transparent")
	S:CreateShadow(tt)

	tt.__windSkin = true
end

local function reskinOptionFrame(frame)
	if not frame or frame.__windSkin then
		return
	end

	local children = { frame:GetChildren() }
	local scrollFrame
	for _, child in pairs(children) do
		if child:IsObjectType("ScrollFrame") then
			scrollFrame = child
			break
		end
	end

	if not scrollFrame then
		return
	end

	if scrollFrame.ScrollBar then
		S:Proxy("HandleScrollBar", scrollFrame.ScrollBar)
	end

	local scrollTarget
	for _, child in pairs({ scrollFrame:GetChildren() }) do
		if child ~= scrollFrame.ScrollBar and child:IsObjectType("Frame") then
			scrollTarget = child
			break
		end
	end

	if not scrollTarget then
		return
	end

	for _, child in pairs({ scrollTarget:GetChildren() }) do
		if child:IsObjectType("CheckButton") then
			S:Proxy("HandleCheckBox", child)
		elseif child:IsObjectType("Button") then
			S:Proxy("HandleButton", child)
		elseif child.Button and child.Icon then
			S:Proxy("HandleDropDownBox", child, nil, nil, true)
		end
	end

	frame.__windSkin = true
end

function S:MultiLanguage()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.multiLanguage then
		return
	end

	reskinTooltip(_G.TranslationTooltipFrame)
	reskinQuest(_G.QuestTranslationFrame)
	reskinOptionFrame(_G.MultiLanguageOptionsPanel)
end

S:AddCallbackForAddon("MultiLanguage")
