---@meta

---@class LibAnim
---@field _LibAnim number Library version number
LibAnim = {}

---@class LibAnimEasingType
---| "linear"
---| "in" # Alias for in-quadratic
---| "out" # Alias for out-quadratic
---| "inout" # Alias for inout-quadratic
---| "in-quadratic"
---| "out-quadratic"
---| "inout-quadratic"
---| "in-cubic"
---| "out-cubic"
---| "inout-cubic"
---| "in-quartic"
---| "out-quartic"
---| "inout-quartic"
---| "in-quintic"
---| "out-quintic"
---| "inout-quintic"
---| "in-sinusoidal"
---| "out-sinusoidal"
---| "inout-sinusoidal"
---| "in-exponential"
---| "out-exponential"
---| "inout-exponential"
---| "in-circular"
---| "out-circular"
---| "inout-circular"
---| "in-bounce"
---| "out-bounce"
---| "inout-bounce"
---| "in-elastic"
---| "out-elastic"
---| "inout-elastic"

---@alias LibAnimAnimationType
---| "move"
---| "fade"
---| "height"
---| "width"
---| "color"
---| "progress"
---| "number"
---| "sleep"

---@alias LibAnimColorType
---| "backdrop"
---| "border"
---| "statusbar"
---| "text"
---| "texture"
---| "vertex"

---@alias LibAnimScriptHandler
---| "OnPlay"
---| "OnPause"
---| "OnResume"
---| "OnStop"
---| "OnReset"
---| "OnFinished"

---@class AnimationBase
---@field Paused boolean
---@field Playing boolean
---@field Stopped boolean
---@field Type LibAnimAnimationType
---@field Group AnimationGroup
---@field Parent Frame|any
---@field Order number
---@field Duration number
---@field Easing LibAnimEasingType
---@field Timer number
---@field children? table<number, Frame>
---@field mainChild? Frame
local AnimationBase = {}

---Starts playing the animation
function AnimationBase:Play() end

---Checks if the animation is currently playing
---@return boolean
function AnimationBase:IsPlaying() end

---Pauses the animation
function AnimationBase:Pause() end

---Checks if the animation is paused
---@return boolean
function AnimationBase:IsPaused() end

---Stops the animation
---@param reset? boolean If true, resets the animation to its starting state
function AnimationBase:Stop(reset) end

---Checks if the animation is stopped
---@return boolean
function AnimationBase:IsStopped() end

---Sets the easing function for the animation
---@param easing LibAnimEasingType
function AnimationBase:SetEasing(easing) end

---Gets the current easing function
---@return LibAnimEasingType
function AnimationBase:GetEasing() end

---@deprecated Use SetEasing instead
---@param easing LibAnimEasingType
function AnimationBase:SetSmoothing(easing) end

---@deprecated Use GetEasing instead
---@return LibAnimEasingType
function AnimationBase:GetSmoothing() end

---Sets the duration of the animation in seconds
---@param duration number
function AnimationBase:SetDuration(duration) end

---Gets the duration of the animation in seconds
---@return number
function AnimationBase:GetDuration() end

---Gets the current timer progress
---@return number
function AnimationBase:GetProgressByTimer() end

---Sets the execution order within the animation group
---@param order number
function AnimationBase:SetOrder(order) end

---Gets the execution order
---@return number
function AnimationBase:GetOrder() end

---Gets the parent frame
---@return Frame|any
function AnimationBase:GetParent() end

---Adds a child frame to be animated together
---@param child Frame
---@param mainChild? Frame Optional main child to use for initial values
function AnimationBase:AddChild(child, mainChild) end

---Removes a child frame
---@param child Frame|number Child frame or index to remove
function AnimationBase:RemoveChild(child) end

---Sets a script handler callback
---@param handler LibAnimScriptHandler
---@param func fun(self: LibAnimAnimation)
function AnimationBase:SetScript(handler, func) end

---Gets a script handler callback
---@param handler LibAnimScriptHandler
---@return fun(self: LibAnimAnimation)?
function AnimationBase:GetScript(handler) end

---Resets the animation to its starting state
function AnimationBase:Reset() end

---@class MoveAnimation : AnimationBase
---@field XSetting number
---@field YSetting number
---@field XOffset number
---@field YOffset number
---@field IsRounded boolean
---@field A1 string
---@field P Frame|string
---@field A2 string
---@field StartX number
---@field StartY number
---@field EndX number
---@field EndY number
---@field XChange number
---@field YChange number
---@field ModTimer number
local MoveAnimation = {}

---Sets the offset for the movement animation
---@param x number
---@param y number
function MoveAnimation:SetOffset(x, y) end

---Gets the movement offset
---@return number x
---@return number y
function MoveAnimation:GetOffset() end

---Sets whether to use rounded movement (circular arc)
---@param flag boolean
function MoveAnimation:SetRounded(flag) end

---Gets the rounded movement setting
---@return boolean
function MoveAnimation:GetRounded() end

---Gets the current progress of the animation
---@return number xOffset
---@return number yOffset
function MoveAnimation:GetProgress() end

---@class FadeAnimation : AnimationBase
---@field EndAlphaSetting number
---@field StartAlpha number
---@field EndAlpha number
---@field Change number
---@field AlphaOffset number
local FadeAnimation = {}

---Sets the target alpha value
---@param alpha number
function FadeAnimation:SetChange(alpha) end

---Gets the target alpha value
---@return number
function FadeAnimation:GetChange() end

---Gets the current alpha offset
---@return number
function FadeAnimation:GetProgress() end

---@class HeightAnimation : AnimationBase
---@field EndHeightSetting number
---@field StartHeight number
---@field EndHeight number
---@field HeightChange number
---@field HeightOffset number
local HeightAnimation = {}

---Sets the target height value
---@param height number
function HeightAnimation:SetChange(height) end

---Gets the target height value
---@return number
function HeightAnimation:GetChange() end

---Gets the current height offset
---@return number
function HeightAnimation:GetProgress() end

---@class WidthAnimation : AnimationBase
---@field EndWidthSetting number
---@field StartWidth number
---@field EndWidth number
---@field WidthChange number
---@field WidthOffset number
local WidthAnimation = {}

---Sets the target width value
---@param width number
function WidthAnimation:SetChange(width) end

---Gets the target width value
---@return number
function WidthAnimation:GetChange() end

---Gets the current width offset
---@return number
function WidthAnimation:GetProgress() end

---@class ColorAnimation : AnimationBase
---@field EndRSetting number
---@field EndGSetting number
---@field EndBSetting number
---@field StartR number
---@field StartG number
---@field StartB number
---@field EndR number
---@field EndG number
---@field EndB number
---@field ColorType LibAnimColorType
---@field ColorOffset number
local ColorAnimation = {}

---Sets the target RGB color values
---@param r number Red (0-1)
---@param g number Green (0-1)
---@param b number Blue (0-1)
function ColorAnimation:SetChange(r, g, b) end

---Gets the target RGB color values
---@return number r
---@return number g
---@return number b
function ColorAnimation:GetChange() end

---Sets the type of color to animate
---@param region LibAnimColorType
function ColorAnimation:SetColorType(region) end

---Gets the type of color being animated
---@return LibAnimColorType
function ColorAnimation:GetColorType() end

---Gets the current color offset progress
---@return number
function ColorAnimation:GetProgress() end

---@class ProgressAnimation : AnimationBase
---@field EndValueSetting number
---@field StartValue number
---@field EndValue number
---@field ProgressChange number
---@field ValueOffset number
local ProgressAnimation = {}

---Sets the target progress value
---@param value number
function ProgressAnimation:SetChange(value) end

---Gets the target progress value
---@return number
function ProgressAnimation:GetChange() end

---Gets the current value offset
---@return number
function ProgressAnimation:GetProgress() end

---@class NumberAnimation : AnimationBase
---@field EndNumberSetting number
---@field StartNumber number
---@field EndNumber number
---@field NumberChange number
---@field Prefix string
---@field Postfix string
---@field NumberOffset number
local NumberAnimation = {}

---Sets the target number value
---@param value number
function NumberAnimation:SetChange(value) end

---Gets the target number value
---@return number
function NumberAnimation:GetChange() end

---Sets the starting number value
---@param value number
function NumberAnimation:SetStart(value) end

---Gets the starting number value
---@return number
function NumberAnimation:GetStart() end

---Sets the text prefix
---@param text string
function NumberAnimation:SetPrefix(text) end

---Gets the text prefix
---@return string
function NumberAnimation:GetPrefix() end

---Sets the text postfix
---@param text string
function NumberAnimation:SetPostfix(text) end

---Gets the text postfix
---@return string
function NumberAnimation:GetPostfix() end

---Gets the current number offset
---@return number
function NumberAnimation:GetProgress() end

---@class SleepAnimation : AnimationBase
local SleepAnimation = {}

---Gets the current timer progress
---@return number
function SleepAnimation:GetProgress() end

---@alias LibAnimAnimation MoveAnimation|FadeAnimation|HeightAnimation|WidthAnimation|ColorAnimation|ProgressAnimation|NumberAnimation|SleepAnimation

---@class LibAnimAnimationGroup
---@field Animations table<number, LibAnimAnimation>
---@field Parent Frame|any
---@field Playing boolean
---@field Paused boolean
---@field Stopped boolean
---@field Order number
---@field MaxOrder number
---@field Looping boolean
local AnimationGroup = {}

---Starts playing all animations in the current order
function AnimationGroup:Play() end

---Checks if the animation group is currently playing
---@return boolean
function AnimationGroup:IsPlaying() end

---Pauses all animations in the current order
function AnimationGroup:Pause() end

---Checks if the animation group is paused
---@return boolean
function AnimationGroup:IsPaused() end

---Stops all animations and resets to order 1
function AnimationGroup:Stop() end

---Checks if the animation group is stopped
---@return boolean
function AnimationGroup:IsStopped() end

---Sets whether the animation group should loop
---@param shouldLoop boolean
function AnimationGroup:SetLooping(shouldLoop) end

---Gets the looping setting
---@return boolean
function AnimationGroup:GetLooping() end

---Gets the parent frame
---@return Frame|any
function AnimationGroup:GetParent() end

---Sets a script handler callback for the group
---@param handler LibAnimScriptHandler
---@param func fun(self: LibAnimAnimationGroup)
function AnimationGroup:SetScript(handler, func) end

---Gets a script handler callback
---@param handler LibAnimScriptHandler
---@return fun(self: LibAnimAnimationGroup)?
function AnimationGroup:GetScript(handler) end

---Creates a new animation of the specified type
---@param style LibAnimAnimationType
---@return LibAnimAnimation?
function AnimationGroup:CreateAnimation(style) end

---@type fun(parent: Frame|any): LibAnimAnimationGroup
CreateAnimationGroup = function(parent) end

---Adds a custom animation type to the library
---@param name string The name of the animation type
---@param init fun(self: LibAnimAnimation) Initialization function
---@param update fun(self: LibAnimAnimation, elapsed: number, i: number) Update function
LibAnimAddType = function(name, init, update) end

---Internal updater frame (exposed for advanced usage)
---@type Frame
LibAnimUpdater = nil

---Internal function to start updating an animation (exposed for custom animations)
---@type fun(anim: LibAnimAnimation)
LibAnimStartUpdating = function(anim) end