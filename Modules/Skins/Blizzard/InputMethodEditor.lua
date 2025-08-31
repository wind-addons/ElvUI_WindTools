local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

function S:InputMethodEditor()
	if not self:CheckDB(nil, "inputMethodEditor") then
		return
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local editBox = _G["ChatFrame" .. i .. "EditBox"]
		local langIcon = _G["ChatFrame" .. i .. "EditBoxLanguage"]

		if editBox then
			self:CreateShadow(editBox)
			if langIcon then
				langIcon:StripTextures()
				langIcon:SetTemplate("Transparent")
				self:CreateShadow(langIcon)
				langIcon:Size(32, 22)
				langIcon:ClearAllPoints()
				langIcon:Point("TOPLEFT", editBox, "TOPRIGHT", 7, 0)

				self:SecureHook(editBox, "Show", function()
					for _, region in pairs({ langIcon:GetRegions() }) do
						if region:GetObjectType() == "FontString" then
							F.SetFontOutline(region)
							region:ClearAllPoints()
							region:SetPoint("CENTER", langIcon, "CENTER", 0, 0)
							self:Unhook(editBox, "Show")
						end
					end
				end)
			end
		end
	end

	local IMECandidatesFrame = _G.IMECandidatesFrame
	if not IMECandidatesFrame then
		return
	end

	IMECandidatesFrame:StripTextures()
	IMECandidatesFrame:SetTemplate(E.private.WT.skins.ime.transparentBackdrop and "Transparent")
	self:CreateShadow(IMECandidatesFrame)

	for i = 1, 10 do
		local cf = IMECandidatesFrame["c" .. i]
		if cf then
			F.SetFontWithDB(cf.label, E.private.WT.skins.ime.label)
			F.SetFontWithDB(cf.candidate, E.private.WT.skins.ime.candidate)
			cf.candidate:Width(1000) -- Show full candidate text
		end
	end
end

S:AddCallback("InputMethodEditor")
