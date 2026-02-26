local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local RunNextFrame = RunNextFrame

local function ReskinChangelogFrame()
	if not _G.MapNotesChangelogFrame then
		return
	end

	local frame = _G.MapNotesChangelogFrame
	frame:StripTextures()

	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleCloseButton", frame.CloseButton)
	S:Proxy("HandleCheckBox", frame.CheckButton)
	S:Proxy("HandleCheckBox", frame.checkbox)
	S:Proxy("HandleButton", frame.closeButton)
	F.Move(frame.closeButton, 0, 15)

	local ScrollBar = frame.scrollFrame and frame.scrollFrame.ScrollBar
	if ScrollBar then
		S:Proxy("HandleScrollBar", ScrollBar)
	end
end

function S:HandyNotes_MapNotes()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.handyNotesMapNotes then
		return
	end

	E:Delay(0.01, function()
		-- Must after MapNotes async loading
		RunNextFrame(ReskinChangelogFrame)
	end)
end

S:AddCallbackForAddon("HandyNotes_MapNotes")
