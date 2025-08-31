local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local type = type
local select = select

function S:ReskinLibQTip(lib)
	for _, tt in lib:IterateTooltips() do
		TT:SetStyle(tt)
		if tt.SetCell and not self:IsHooked(tt, "SetCell") then
			self:RawHook(tt, "SetCell", function(tooltip, ...)
				local lineNum, colNum, value = select(1, ...)

				-- Only style if we have valid parameters and string value
				if type(lineNum) == "number" and type(colNum) == "number" and type(value) == "string" then
					local styledValue = self:StyleTextureString(value)
					if styledValue ~= value then
						-- Replace the value in the argument list
						return self.hooks[tt].SetCell(tooltip, lineNum, colNum, styledValue, select(4, ...))
					end
				end

				-- Call original with all original parameters
				return self.hooks[tt].SetCell(tooltip, ...)
			end)
		end
	end
end

function S:LibQTip(lib)
	if lib.Acquire then
		self:SecureHook(lib, "Acquire", "ReskinLibQTip")
	end
end

S:AddCallbackForLibrary("LibQTip-1.0", "LibQTip")
S:AddCallbackForLibrary("LibQTip-1.0RS", "LibQTip")
