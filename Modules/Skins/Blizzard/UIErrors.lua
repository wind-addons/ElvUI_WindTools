local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local C = W.Utilities.Color

local _G = _G
local pairs = pairs

local UnitClass = UnitClass
local GetClassColor = GetClassColor

local RED_FONT_COLOR = RED_FONT_COLOR
local YELLOW_FONT_COLOR = YELLOW_FONT_COLOR

local BlizzardColors = {
	{ "red", r = 1.0, g = 0.1, b = 0.1 },
	{ "yellow", r = 1.0, g = 1.0, b = 0.1 },
	{ "red", r = RED_FONT_COLOR.r, g = RED_FONT_COLOR.g, b = RED_FONT_COLOR.b },
	{ "yellow", r = YELLOW_FONT_COLOR.r, g = YELLOW_FONT_COLOR.g, b = YELLOW_FONT_COLOR.b },
}

function S:UIErrors()
	if not self:CheckDB(nil, "uiErrors") then
		return
	end

	if not _G.UIErrorsFrame then
		return
	end

	self:RawHook(_G.UIErrorsFrame, "AddMessage", function(frame, message, r, g, b, a)
		if r == nil or g == nil or b == nil then
			local db = E.private.WT.skins.uiErrors
			if db.normalTextClassColor then
				r, g, b = GetClassColor(E.myclass)
				a = 1
			else
				r, g, b, a = db.normalTextColor.r, db.normalTextColor.g, db.normalTextColor.b, db.normalTextColor.a
			end
		else
			local color = { r = r, g = g, b = b }
			for _, targetColor in pairs(BlizzardColors) do
				if C.IsRGBEqual(color, targetColor) then
					local colorConfig = E.private.WT.skins.uiErrors[targetColor[1] .. "TextColor"]
					if colorConfig then
						r, g, b = colorConfig.r, colorConfig.g, colorConfig.b
					end
					break
				end
			end
		end

		self.hooks[_G.UIErrorsFrame]["AddMessage"](frame, message, r, g, b, a)
	end, true)
end

S:AddCallback("UIErrors")
