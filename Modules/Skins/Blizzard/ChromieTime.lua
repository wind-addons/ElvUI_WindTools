local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ChromieTimeUI()
	if not self:CheckDB("chromieTime") then
		return
	end

	self:CreateShadow(_G.ChromieTimeFrame)
	F.SetFontOutline(_G.ChromieTimeFrame.Title.Text)
	F.SetFontOutline(_G.ChromieTimeFrame.SelectButton.Text)
end

S:AddCallbackForAddon("Blizzard_ChromieTimeUI")
