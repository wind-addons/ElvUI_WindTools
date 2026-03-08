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