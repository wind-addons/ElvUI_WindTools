---@diagnostic disable: duplicate-doc-field
---@meta

-- ElvUI Extended API Methods
-- These methods are added to various WoW UI objects via mixin

---@class Frame : Region
local Frame = {}

---@class Texture : Region
local Texture = {}

---@class FontString : Region
local FontString = {}

---@class Button : Frame
local Button = {}

---@class ScrollFrame : Frame
local ScrollFrame = {}

---@class MaskTexture : Region
local MaskTexture = {}

---@class StatusBar : Frame
local StatusBar = {}

---@alias ElvUI_FrameTemplate string
---| 'Default'
---| 'ClassColor'
---| 'Transparent'
---| 'NoBackdrop'

-- ============================================================================
-- CORE FRAME METHODS
-- ============================================================================

---Completely disables and hides an object
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
function Frame:Kill() end

---Sets the size of a frame with ElvUI scaling applied
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param width number Width in pixels (will be scaled)
---@param height? number Height in pixels (will be scaled, defaults to width)
---@param ... any Additional arguments passed to SetSize
function Frame:Size(width, height, ...) end

---Sets the width of a frame with ElvUI scaling applied
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param width number Width in pixels (will be scaled)
---@param ... any Additional arguments passed to SetWidth
function Frame:Width(width, ...) end

---Sets the height of a frame with ElvUI scaling applied
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param height number Height in pixels (will be scaled)
---@param ... any Additional arguments passed to SetHeight
function Frame:Height(height, ...) end

-- ============================================================================
-- POSITIONING METHODS
-- ============================================================================

---Sets a point with ElvUI scaling applied to numeric values
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param point AnchorPoint|string The anchor point
---@param relativeTo? Frame|Region|string Relative frame (defaults to parent)
---@param relativePoint? AnchorPoint|string Relative anchor point
---@param xOfs? number X offset (will be scaled)
---@param yOfs? number Y offset (will be scaled)
---@param ... any Additional arguments passed to SetPoint
---@overload fun(self: Frame, point: AnchorPoint|string, xOfs: number, yOfs: number, ...: any)
function Frame:Point(point, relativeTo, relativePoint, xOfs, yOfs, ...) end

---Gets point information, handling both numeric and string point values
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param pointValue? number|string Point index or point name to get
---@return AnchorPoint|string point The anchor point
---@return Frame|Region|string relativeTo The relative frame
---@return AnchorPoint|string relativePoint The relative anchor point
---@return number xOfs X offset
---@return number yOfs Y offset
function Frame:GrabPoint(pointValue) end

---Adjusts an existing point by nudging it with scaled offsets
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param xAxis? number X offset to nudge (will be scaled, defaults to 0)
---@param yAxis? number Y offset to nudge (will be scaled, defaults to 0)
---@param noScale? boolean If true, don't apply ElvUI scaling
---@param pointValue? number|string Point to nudge (defaults to first point)
---@param clearPoints? boolean If true, clear all points before setting
function Frame:NudgePoint(xAxis, yAxis, noScale, pointValue, clearPoints) end

---Sets position with X/Y offsets, replacing existing offsets
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param xOffset? number X offset (will be scaled)
---@param yOffset? number Y offset (will be scaled)
---@param noScale? boolean If true, don't apply ElvUI scaling
---@param pointValue? number|string Point to modify (defaults to first point)
---@param clearPoints? boolean If true, clear all points before setting
function Frame:PointXY(xOffset, yOffset, noScale, pointValue, clearPoints) end

---Positions the frame outside another frame with optional offsets
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param anchor? Frame|Region|string Anchor frame (defaults to parent)
---@param xOffset? number X offset (defaults to E.Border)
---@param yOffset? number Y offset (defaults to E.Border)
---@param anchor2? Frame|Region|string Second anchor for BOTTOMRIGHT (defaults to anchor)
---@param noScale? boolean If true, don't apply ElvUI scaling
function Frame:SetOutside(anchor, xOffset, yOffset, anchor2, noScale) end

---Positions the frame inside another frame with optional offsets
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param anchor? Frame|Region|string Anchor frame (defaults to parent)
---@param xOffset? number X offset (defaults to E.Border)
---@param yOffset? number Y offset (defaults to E.Border)
---@param anchor2? Frame|Region|string Second anchor for BOTTOMRIGHT (defaults to anchor)
---@param noScale? boolean If true, don't apply ElvUI scaling
function Frame:SetInside(anchor, xOffset, yOffset, anchor2, noScale) end

-- ============================================================================
-- STYLING METHODS
-- ============================================================================

---Applies ElvUI styling template to a frame
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param template? (ElvUI_FrameTemplate | boolean?)|nil Template type: 'Default', 'ClassColor', 'Transparent', 'NoBackdrop'
---@param glossTex? string|Texture Gloss texture file or texture object
---@param ignoreUpdates? boolean If true, don't register for template updates
---@param forcePixelMode? boolean Force pixel mode styling
---@param isUnitFrameElement? boolean If true, use unit frame styling
---@param isNamePlateElement? boolean If true, use nameplate styling
---@param noScale? boolean If true, don't apply ElvUI scaling
function Frame:SetTemplate(template, glossTex, ignoreUpdates, forcePixelMode, isUnitFrameElement, isNamePlateElement, noScale) end

---Creates a backdrop frame for the given frame
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param template? string Template name for the backdrop
---@param glossTex? string|Texture Gloss texture file or texture object
---@param ignoreUpdates? boolean If true, don't register for template updates
---@param forcePixelMode? boolean Force pixel mode styling
---@param isUnitFrameElement? boolean If true, use unit frame styling
---@param isNamePlateElement? boolean If true, use nameplate styling
---@param noScale? boolean If true, don't apply ElvUI scaling
---@param allPoints? boolean|Frame If true or frame, set all points
---@param frameLevel? boolean|number Frame level for backdrop
function Frame:CreateBackdrop(template, glossTex, ignoreUpdates, forcePixelMode, isUnitFrameElement, isNamePlateElement, noScale, allPoints, frameLevel) end

---Creates a shadow effect around the frame
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param size? number Shadow size (defaults to 3)
---@param pass? boolean If true, return shadow frame instead of storing it
---@return Frame? shadow The shadow frame (only if pass is true)
function Frame:CreateShadow(size, pass) end

---Disables edit mode features on an object
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
function Frame:KillEditMode() end

---Applies ElvUI's font template styling to a FontString object
---@param self FontString
---@param font? FontFile|string Font file path or font object (defaults to E.media.normFont)
---@param size? number Font size in points (defaults to profile fontSize setting)
---@param style? string Font style flags like 'SHADOW', 'OUTLINE', 'THICKOUTLINE', 'NONE' (defaults to profile fontStyle setting)
---@param skip? boolean If true, skips updating font templates and doesn't store font properties (defaults to false)
function FontString:FontTemplate(font, size, style, skip) end

---Removes all textures from a frame and its children
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param kill? boolean If true, kill textures instead of clearing them
---@param zero? boolean If true, set alpha to 0 instead of clearing
function Frame:StripTextures(kill, zero) end

---Removes all text from a frame and its children
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param kill? boolean If true, kill text instead of clearing it
---@param zero? boolean If true, set alpha to 0 instead of clearing
function Frame:StripTexts(kill, zero) end

---Styles a button with hover, pushed, and checked textures
---@param self Button
---@param noHover? boolean If true, don't create hover texture
---@param noPushed? boolean If true, don't create pushed texture
---@param noChecked? boolean If true, don't create checked texture
function Button:StyleButton(noHover, noPushed, noChecked) end

---Adjusts the frame level of a frame relative to another frame
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param offset? number Level offset (defaults to 0)
---@param secondary? Frame|Region Secondary frame to get level from (defaults to self)
function Frame:OffsetFrameLevel(offset, secondary) end

---Creates a close button for a frame
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param size? number Button size (defaults to 16)
---@param offset? number Offset from corner (defaults to -6)
---@param texture? string|Texture Close button texture (defaults to E.Media.Textures.Close)
---@param backdrop? boolean If true, create backdrop for button
function Frame:CreateCloseButton(size, offset, texture, backdrop) end

---Gets a child frame by name with optional index
---@param self Frame|Texture|FontString|Button|ScrollFrame|StatusBar|MaskTexture
---@param child string Child frame name
---@param index? string|number Child frame index
---@param debug? boolean If true, use debug name
---@return Frame|Region|nil childFrame The child frame or nil if not found
function Frame:GetChild(child, index, debug) end

return {
    Frame = Frame,
    Texture = Texture,
    FontString = FontString,
    Button = Button,
    ScrollFrame = ScrollFrame,
    MaskTexture = MaskTexture,
    StatusBar = StatusBar
}