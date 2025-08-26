local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function reskinLib(lib)
	for _, tt in lib:IterateTooltips() do
		TT:SetStyle(tt)
		if tt.SetCell and not S:IsHooked(tt, "SetCell") then
			S:RawHook(tt, "SetCell", function(tt, lineNum, colNum, value, ...)
				if type(value) == "string" then
					value = S:StyleTextureString(value)
				end
				S.hooks[tt].SetCell(tt, lineNum, colNum, value, ...)
			end)
		end
	end
end

function S:LibQTip()
	local libNames = { "LibQTip-1.0", "LibQTip-1.0RS" }

	for _, libName in ipairs(libNames) do
		local lib = _G.LibStub(libName, true)
		if lib then
			hooksecurefunc(lib, "Acquire", reskinLib)
		end
	end
end

S:AddCallback("LibQTip")
