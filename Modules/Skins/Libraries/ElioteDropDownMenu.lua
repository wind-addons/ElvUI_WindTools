local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local handledFrames = {}

function S:ElioteDropDownMenu(lib)
	if not lib or not lib.UIDropDownMenu_CreateFrames then
		return
	end

	self:SecureHook(lib, "UIDropDownMenu_CreateFrames", function(level)
		F.WaitFor(function()
			return E.private.WT and E.private.WT.skins and E.private.WT.skins.libraries
		end, function()
			if not E.private.WT.skins.libraries.elioteDropDownMenu then
				return
			end

			local name = "ElioteDDM_DropDownList" .. level
            local frame = _G[name]
            if not frame or handledFrames[frame] then
                return
            end

			_G[name .. "Backdrop"]:SetTemplate("Transparent")
			_G[name .. "MenuBackdrop"]:SetTemplate("Transparent")
			self:CreateShadow(_G[name .. "Backdrop"])
			self:CreateShadow(_G[name .. "MenuBackdrop"])

			handledFrames[frame] = true
		end)
	end)
end

S:AddCallbackForLibrary("ElioteDropDownMenu-1.0", "ElioteDropDownMenu")
