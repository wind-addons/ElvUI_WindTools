local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local pairs = pairs

function S:AceGUI(lib)
	self:SecureHook(lib, "RegisterWidgetType", "HandleAceGUIWidget")
	for name, constructor in pairs(lib.WidgetRegistry) do
		self:HandleAceGUIWidget(lib, name, constructor)
	end
end

function S:AceConfigDialog(lib)
	F.WaitFor(function()
		return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
	end, function()
		if E.private.WT.skins and E.private.WT.skins.libraries.ace3 then
			self:CreateShadow(lib.popup)
			E:GetModule("Tooltip"):SetStyle(lib.tooltip)
		end
	end)
end

function S:Ace3_Frame(widget)
	self:CreateShadow(widget.frame)
end

function S:Ace3_DropdownPullout(widget)
	if self.db.libraries.ace3Dropdown then
		widget.frame:SetTemplate("Transparent")
	end
	self:CreateShadow(widget.frame)
end

S:AddCallbackForLibrary("AceGUI-3.0", "AceGUI")
S:AddCallbackForLibrary("AceConfigDialog-3.0", "AceConfigDialog")
S:AddCallbackForLibrary("AceConfigDialog-3.0-ElvUI", "AceConfigDialog")
S:AddCallbackForAceGUIWidget("Frame", "Ace3_Frame", function(db)
	return db.libraries.ace3 and db.shadow
end)
S:AddCallbackForAceGUIWidget("Window", "Ace3_Frame", function(db)
	return db.libraries.ace3 and db.shadow
end)
S:AddCallbackForAceGUIWidget("Dropdown-Pullout", "Ace3_DropdownPullout", function(db)
	return db.libraries.ace3 and (db.libraries.ace3Dropdown or db.shadow)
end)
