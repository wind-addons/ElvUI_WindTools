local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local type = type
local select = select

local data = S:AddCallbackForLibrary("LibQTip-1.0", "LibQTip")
S:AddCallbackForLibrary("LibQTip-1.0RS", "LibQTip")

function data:UpdateScrolling(...) -- self is the LibQTip tooltip, not data
	local tooltip = self
	local slider = tooltip and tooltip.slider
	if slider and not slider.__windSkin then
		S:Proxy("HandleSliderFrame", slider)
	end
	S.hooks[tooltip].UpdateScrolling(tooltip, ...)
end

function data:SetCell(...) -- self is the LibQTip tooltip, not data
	local tooltip = self
	local setCell = S.hooks[tooltip] and S.hooks[tooltip].SetCell
	if not setCell then
		return
	end

	local lineNum, colNum, value, arg = select(1, ...)

	-- Only style if we have valid parameters and string value
	if type(lineNum) == "number" and type(colNum) == "number" then
		if type(value) == "string" then
			local styledValue = S:StyleTextureString(value)
			if styledValue ~= value then
				-- Replace the value in the argument list
				return setCell(tooltip, lineNum, colNum, styledValue, select(4, ...))
			end
		elseif arg and type(arg) == "table" and type(arg.AcquireCell) == "function" then
			if not arg.__windSkin then
				local AcquireCell = arg.AcquireCell
				arg.AcquireCell = function(prototype, ...)
					local cell = AcquireCell(prototype, ...)
					if cell and cell.texture and not cell.__windSkin then
						S:TryCropTexture(cell.texture)
						cell.__windSkin = true
					end
					return cell
				end

				arg.__windSkin = true
			end

			return setCell(tooltip, lineNum, colNum, value, arg, select(5, ...))
		end
	end

	-- Fall back to original method
	return setCell(tooltip, ...)
end

function data:ReskinLibQTip() -- self is the LibQTip library, not data
	local lib = self
	for _, tt in lib:IterateTooltips() do
		F.WaitFor(function()
			return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
		end, function()
			if not E.private.WT.skins.libraries.libQTip then
				return
			end

			TT:SetStyle(tt)

			if tt.UpdateScrolling and not S:IsHooked(tt, "UpdateScrolling") then
				S:RawHook(tt, "UpdateScrolling", data.UpdateScrolling)
			end

			if tt.SetCell and not S:IsHooked(tt, "SetCell") then
				S:RawHook(tt, "SetCell", data.SetCell)
			end
		end)
	end
end

function S:LibQTip(lib)
	if lib.Acquire then
		self:SecureHook(lib, "Acquire", data.ReskinLibQTip)
	end
end
