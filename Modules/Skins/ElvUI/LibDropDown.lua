local W, F, E, L = unpack((select(2, ...)))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ES_SkinLibDropDownMenu(_, prefix)
	-- If ElvUI did't load WindTools DB
	if not E.private.WT then
		self:AddCallback("SkinLibDropDown" .. prefix, function()
			self:ES_SkinLibDropDownMenu(nil, prefix)
		end)
		return
	end

	if _G[prefix .. "_UIDropDownMenu_CreateFrames"] then
		local bd = _G[prefix .. "_DropDownList1Backdrop"]
		local mbd = _G[prefix .. "_DropDownList1MenuBackdrop"]
		if bd and bd.template then
			self:CreateShadow(bd)
		end
		if mbd and mbd.template then
			self:CreateShadow(bd)
		end

		S[prefix .. "_UIDropDownMenuSkinned"] = true
		hooksecurefunc(prefix .. "_UIDropDownMenu_CreateFrames", function()
			local lvls = _G[(prefix == "Lib" and "LIB" or prefix) .. "_UIDROPDOWNMENU_MAXLEVELS"]
			local ddbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "Backdrop"]
			local ddmbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "MenuBackdrop"]
			if ddbd and ddbd.template then
				self:CreateShadow(bd)
			end
			if ddmbd and ddmbd.template then
				self:CreateShadow(bd)
			end
		end)
	end
end

do
	local hooked = {}
	function S:ES_SkinDropDownMenu(_, prefix)
		if hooked[prefix] then
			return
		end

		hooked[prefix] = true

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			local listFrameName = _G[prefix .. level]:GetName()
			local backdrop = _G[listFrameName .. "Backdrop"]
			if backdrop and backdrop.template then
				self:CreateShadow(backdrop)
			end

			local menuBackdrop = _G[listFrameName .. "MenuBackdrop"]
			if menuBackdrop and menuBackdrop.template then
				self:CreateShadow(menuBackdrop)
			end
		end)
	end
end

S:SecureHook(ES, "SkinLibDropDownMenu", "ES_SkinLibDropDownMenu")
S:SecureHook(ES, "SkinDropDownMenu", "ES_SkinDropDownMenu")
