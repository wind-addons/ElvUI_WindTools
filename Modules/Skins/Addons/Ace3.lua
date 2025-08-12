local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Ace3_Frame(Constructor)
	if not (E.private.WT.skins.enable and E.private.WT.skins.addons.ace3 and E.private.WT.skins.shadow) then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function S:Ace3_DropdownPullout(Constructor)
	if not (E.private.WT.skins.enable and E.private.WT.skins.addons.ace3 and E.private.WT.skins.shadow) then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		if E.private.WT.skins.addons.ace3DropdownBackdrop then
			widget.frame:SetTemplate("Transparent")
		end
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function S:Ace3_Window(Constructor)
	if not (E.private.WT.skins.enable and E.private.WT.skins.addons.ace3 and E.private.WT.skins.shadow) then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function S:AceConfigDialog()
	local lib = _G.LibStub("AceConfigDialog-3.0")
	self:CreateShadow(lib.popup)
end

S:AddCallbackForAceGUIWidget("Frame", S.Ace3_Frame)
S:AddCallbackForAceGUIWidget("Dropdown-Pullout", S.Ace3_DropdownPullout)
S:AddCallbackForAceGUIWidget("Window", S.Ace3_Window)
