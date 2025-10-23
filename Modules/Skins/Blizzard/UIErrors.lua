local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local C = W.Utilities.Color

local _G = _G
local pairs = pairs

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

	_G.UIErrorsFrame:Width(E.private.WT.skins.uiErrors.width)

	hooksecurefunc(_G.UIErrorsFrame, "SetWidth", function(frame)
		frame:Width(E.private.WT.skins.uiErrors.width)
	end)

	hooksecurefunc(_G.UIErrorsFrame, "SetSize", function(frame)
		frame:Width(E.private.WT.skins.uiErrors.width)
	end)

	W:RegisterUIErrorHandler(function(params)
		if params.r == nil or params.g == nil or params.b == nil then
			local db = E.private.WT.skins.uiErrors
			if db.normalTextClassColor then
				params.r, params.g, params.b = E.myClassColor:GetRGBA()
				params.a = 1
			else
				params.r, params.g, params.b, params.a =
					db.normalTextColor.r, db.normalTextColor.g, db.normalTextColor.b, db.normalTextColor.a
			end
		else
			local color = { r = params.r, g = params.g, b = params.b }
			for _, targetColor in pairs(BlizzardColors) do
				if C.IsRGBEqual(color, targetColor) then
					local colorConfig = E.private.WT.skins.uiErrors[targetColor[1] .. "TextColor"]
					if colorConfig then
						params.r, params.g, params.b = colorConfig.r, colorConfig.g, colorConfig.b
					end
					break
				end
			end
		end
	end)
end

S:AddCallback("UIErrors")
