local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

-- Most part is copied from NDui
local function Skin_WeakAuras(f, fType)
    if fType == "icon" then
        if not f.windStyle then
            f.icon:SetTexCoord(unpack(E.TexCoords))
            f.icon.SetTexCoord = E.noop
            f:CreateBackdrop()
            S:CreateShadow(f.backdrop)
            f.backdrop:SetFrameLevel(0)
            f.backdrop.icon = f.icon
            f.backdrop:HookScript("OnUpdate", function(self)
                self:SetAlpha(self.icon:GetAlpha())
                if self.shadow then
                    self.shadow:SetAlpha(self.icon:GetAlpha())
                end
            end)

            f.windStyle = true
        end
    elseif fType == "aurabar" then
        if not f.windStyle then
            f:CreateBackdrop()
            S:CreateShadow(f.backdrop)
            f.backdrop:SetFrameLevel(0)
            f.icon:SetTexCoord(unpack(E.TexCoords))
            f.icon.SetTexCoord = E.noop
            f.iconFrame:SetAllPoints(f.icon)
            f.iconFrame:CreateBackdrop()

            f.windStyle = true
        end
    end
end

function S:WeakAuras()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
        return
    end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" or regions.regionType == "aurabar" then
			Skin_WeakAuras(regions.region, regions.regionType)
		end
	end
end

S:AddCallbackForAddon("WeakAuras")
