local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

function S:Blizzard_DebugTools()
	if not self:CheckDB("debug", "debugTools") then
		return
	end

	self:CreateShadow(_G.TableAttributeDisplay)
	self:SecureHook(_G.TableInspectorMixin, "OnLoad", "CreateBackdropShadow")

	local developerConfig = E.global.WT.developer.tableAttributeDisplay
	if not developerConfig.enable then
		return
	end
	local diffWidth = developerConfig.width - 500
	local diffHeight = developerConfig.height - 400

	_G.TableAttributeDisplay:Size(500 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.TitleButton:Size(360 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.TitleButton.Text:Size(360 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.LinesScrollFrame:Size(430 + diffWidth, 300 + diffHeight)
	hooksecurefunc(_G.TableAttributeDisplay.dataProviders[2], "RefreshData", function(self)
		local scrollFrame = self.LinesScrollFrame or _G.TableAttributeDisplay.LinesScrollFrame
		if not scrollFrame then
			return
		end
		for _, child in next, { scrollFrame.LinesContainer:GetChildren() } do
			if child.ValueButton and not child.ValueButton.__wind then
				child.ValueButton:Size(310 + diffWidth, 16)
				child.ValueButton.Text:Size(310 + diffWidth, 16)
				F.SetFontOutline(child.ValueButton.Text)
				child.ValueButton.__wind = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_DebugTools")
