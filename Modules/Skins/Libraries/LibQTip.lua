local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local type = type
local select = select

function S:LibQTip_SetCell(tooltip, ...)
	local setCell = self.hooks[tooltip] and self.hooks[tooltip].SetCell
	if not setCell then
		return
	end

	local lineNum, colNum, value = select(1, ...)

	-- Only style if we have valid parameters and string value
	if type(lineNum) == "number" and type(colNum) == "number" and type(value) == "string" then
		local styledValue = self:StyleTextureString(value)
		if styledValue ~= value then
			-- Replace the value in the argument list
			return setCell(tooltip, lineNum, colNum, styledValue, select(4, ...))
		end
	end

	-- Fall back to original method
	return setCell(tooltip, ...)
end

function S:ReskinLibQTip(lib)
	for _, tt in lib:IterateTooltips() do
		F.WaitFor(function()
			return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
		end, function()
			if not E.private.WT.skins.libraries.libQTip then
				return
			end

			TT:SetStyle(tt)
			if tt.SetCell and not self:IsHooked(tt, "SetCell") then
				self:RawHook(tt, "SetCell", "LibQTip_SetCell")
			end
		end)
	end
end

function S:LibQTip(lib)
	if lib.Acquire then
		self:SecureHook(lib, "Acquire", "ReskinLibQTip")
	end
end

S:AddCallbackForLibrary("LibQTip-1.0", "LibQTip")
S:AddCallbackForLibrary("LibQTip-1.0RS", "LibQTip")
