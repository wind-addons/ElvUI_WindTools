---@meta

---@class RGB
---@field r number
---@field g number
---@field b number

---@class RGBA : RGB
---@field a number

---@alias AnchorPoint "TOPLEFT"|"TOP"|"TOPRIGHT"|"LEFT"|"CENTER"|"RIGHT"|"BOTTOMLEFT"|"BOTTOM"|"BOTTOMRIGHT"

---@class LibItemEnchant
local LibItemEnchant = {}

---Gets enchantment spell ID from item link
---@param itemLink string Item link
---@return number|nil spellID Enchantment spell ID, or nil if not found
---@return number|nil enchantID Enchantment ID, or nil if not found
function LibItemEnchant:GetEnchantSpellID(itemLink) end

---Gets enchantment item ID from item link
---@param itemLink string Item link
---@return number|nil itemID Enchantment item ID, or nil if not found
---@return number|nil enchantID Enchantment ID, or nil if not found
function LibItemEnchant:GetEnchantItemID(itemLink) end
