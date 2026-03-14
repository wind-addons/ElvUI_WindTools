---@meta

---@class RGB
---@field r number
---@field g number
---@field b number

---@class RGBA : RGB
---@field a number

---@alias AnchorPoint "TOPLEFT"|"TOP"|"TOPRIGHT"|"LEFT"|"CENTER"|"RIGHT"|"BOTTOMLEFT"|"BOTTOM"|"BOTTOMRIGHT"

--- Midnight APIs
---@class LuaCurveObjectBase
---@class LuaCurveObject : LuaCurveObjectBase
---@class AbbreviateConfig


---[Documentation](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetText)
---@param text string
---@param colorR? number
---@param colorG? number
---@param colorB? number
---@param alpha? number
---@param wrap? boolean
function GameTooltip:SetText(text, colorR, colorG, colorB, alpha, wrap) end

---@class AceLocale-3.0
local AceLocale = {}

---@param application string Unique name of addon / module
---@param locale? string|boolean Locale to get, defaults to the current locale
---@param silent? boolean If true, the locale is optional, silently return nil if it's not found (defaults to false, optional)
---@return table<string, string> locale The locale table for the current language.
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0#title-1)
function AceLocale:GetLocale(application, locale, silent) end
