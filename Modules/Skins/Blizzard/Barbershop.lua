local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:Blizzard_CharacterCustomize()
	if not self:CheckDB("barber", "barberShop") then
		return
	end
	local frame = _G.CharCustomizeFrame

	self:CreateBackdropShadow(frame.SmallButtons.ResetCameraButton)
	self:CreateBackdropShadow(frame.SmallButtons.ZoomOutButton)
	self:CreateBackdropShadow(frame.SmallButtons.ZoomInButton)
	self:CreateBackdropShadow(frame.SmallButtons.RotateLeftButton)
	self:CreateBackdropShadow(frame.SmallButtons.RotateRightButton)

	hooksecurefunc(frame, "SetSelectedCategory", function(list)
		if list.selectionPopoutPool then
			for popout in list.selectionPopoutPool:EnumerateActive() do
				if not popout.__windSkin then
					self:CreateBackdropShadow(popout.Button)
					self:CreateShadow(popout.Button.Popout)
					if popout.Label then
						F.SetFontOutline(popout.Label)
					end
					popout.__windSkin = true
				end
			end
		end

		local optionPool = list.pools and list.pools:GetPool("CharCustomizeOptionCheckButtonTemplate")
		if optionPool then
			for button in optionPool:EnumerateActive() do
				if not button.__windSkin then
					self:CreateBackdropShadow(button.Button)
					if button.Label then
						F.SetFontOutline(button.Label)
					end
					button.__windSkin = true
				end
			end
		end
	end)
end

function S:Blizzard_BarbershopUI()
	if not self:CheckDB("barber", "barberShop") then
		return
	end

	local frame = _G.BarberShopFrame

	self:CreateBackdropShadow(frame.ResetButton)
	self:CreateBackdropShadow(frame.CancelButton)
	self:CreateBackdropShadow(frame.AcceptButton)
end

S:AddCallbackForAddon("Blizzard_CharacterCustomize")
S:AddCallbackForAddon("Blizzard_BarbershopUI")
