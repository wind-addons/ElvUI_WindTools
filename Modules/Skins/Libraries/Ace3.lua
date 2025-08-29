local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G


function S:AceGUI(lib)
	S:SecureHook(lib, "RegisterWidgetType", "HandleAceGUIWidget")
	for name, constructor in pairs(lib.WidgetRegistry) do
		S:HandleAceGUIWidget(lib, name, constructor)
	end
end

function S:AceConfigDialog(lib)
	self:CreateShadow(lib.popup)
end



function S:Ace3_Frame(Constructor)
	if not (E.private.WT.skins.enable and E.private.WT.skins.libraries.ace3 and E.private.WT.skins.shadow) then
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
	if not (E.private.WT.skins.enable and E.private.WT.skins.libraries.ace3) then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		if E.private.WT.skins.libraries.ace3DropdownBackdrop then
			widget.frame:SetTemplate("Transparent")
		end
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function S:Ace3_Window(Constructor)
	if not (E.private.WT.skins.enable and E.private.WT.skins.libraries.ace3 and E.private.WT.skins.shadow) then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

S:AddCallbackForLibrary("AceGUI-3.0", "AceGUI")
S:AddCallbackForLibrary("AceConfigDialog-3.0", "AceConfigDialog")
S:AddCallbackForAceGUIWidget("Frame", S.Ace3_Frame)
S:AddCallbackForAceGUIWidget("Dropdown-Pullout", S.Ace3_DropdownPullout)
S:AddCallbackForAceGUIWidget("Window", S.Ace3_Window)
