local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:LossOfControlFrame()
	if not self:CheckDB("losscontrol", "lossOfControl") then
		return
	end

	S:SecureHook(_G.LossOfControlFrame, "SetUpDisplay", function(s)
		if not s then
			return
		end
		s.Icon:ClearAllPoints()
		s.Icon:Point("LEFT", s, "LEFT", 0, 0)

		if not s.Icon.backdrop then
			s.Icon:CreateBackdrop()
		end
		self:CreateBackdropShadow(s.Icon, true)

		s.AbilityName:ClearAllPoints()
		s.AbilityName:Point("TOPLEFT", s.Icon, "TOPRIGHT", 10, 0)

		-- 时间归位
		s.TimeLeft:ClearAllPoints()
		s.TimeLeft.NumberText:ClearAllPoints()
		s.TimeLeft.NumberText:Point("BOTTOMLEFT", s.Icon, "BOTTOMRIGHT", 10, 0)

		s.TimeLeft.SecondsText:ClearAllPoints()
		s.TimeLeft.SecondsText:Point("TOPLEFT", s.TimeLeft.NumberText, "TOPRIGHT", 3, 0)

		s:Size(s.Icon:GetWidth() + 10 + s.AbilityName:GetWidth(), s.Icon:GetHeight())
	end)
end

S:AddCallback("LossOfControlFrame")
