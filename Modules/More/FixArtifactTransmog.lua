-- 原作：FixTransmogOutfits
-- 原作者：zaCade(https://www.curseforge.com/wow/addons/fixtransmogoutfits)

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local FAT = E:NewModule('Wind_FixArtifactTransmog')

function FAT:Initialize()
	if not E.db.WindTools["More Tools"]["Fix Artifact Transmog"]["enabled"] then return end
	function WardrobeOutfitDropDownMixin:IsOutfitDressed()
		if ( not self.selectedOutfitID ) then
			return true;
		end
		local appearanceSources, mainHandEnchant, offHandEnchant = C_TransmogCollection.GetOutfitSources(self.selectedOutfitID);
		if ( not appearanceSources ) then
			return true;
		end

		for i = 1, #TRANSMOG_SLOTS do
			if ( TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE ) then
				local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, LE_TRANSMOG_TYPE_APPEARANCE);
				local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot);
				if ( sourceID ~= NO_TRANSMOG_SOURCE_ID and sourceID ~= appearanceSources[slotID] ) then
					if ( appearanceSources[slotID] ~= NO_TRANSMOG_SOURCE_ID ) then
						return false;
					end
				end
			end
		end
		local mainHandSourceID = self:GetSlotSourceID("MAINHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION);
		if ( mainHandSourceID ~= mainHandEnchant ) then
			return false;
		end
		local offHandSourceID = self:GetSlotSourceID("SECONDARYHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION);
		if ( offHandSourceID ~= offHandEnchant ) then
			return false;
		end
		return true;
	end

	-- WardrobeOutfits.lua @ #122
	function WardrobeOutfitDropDownMixin:CheckOutfitForSave(name)
		local sources = { };
		local mainHandEnchant, offHandEnchant;
		local pendingSources = { };
		local hadInvalidSources = false;

		for i = 1, #TRANSMOG_SLOTS do
			local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, TRANSMOG_SLOTS[i].transmogType);
			if ( sourceID ~= NO_TRANSMOG_SOURCE_ID ) then
				if ( TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE ) then
					local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot);
					local isValidSource = C_TransmogCollection.PlayerKnowsSource(sourceID);
					if ( not isValidSource ) then
						local isInfoReady, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID);
						if ( isInfoReady ) then
							if ( canCollect ) then
								isValidSource = true;
							end
						else
							-- saving the "slot" for the sourceID
							pendingSources[sourceID] = slotID;
						end
					end
					if ( isValidSource ) then
						sources[slotID] = sourceID;
					end
				elseif ( TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_ILLUSION ) then
					if ( TRANSMOG_SLOTS[i].slot == "MAINHANDSLOT" ) then
						mainHandEnchant = sourceID;
					else
						offHandEnchant = sourceID;
					end
				end
			end
		end

		-- store the state for this save
		WardrobeOutfitFrame.sources = sources;
		WardrobeOutfitFrame.mainHandEnchant = mainHandEnchant;
		WardrobeOutfitFrame.offHandEnchant = offHandEnchant;
		WardrobeOutfitFrame.pendingSources = pendingSources;
		WardrobeOutfitFrame.hadInvalidSources = hadInvalidSources;
		WardrobeOutfitFrame.name = name;
		-- save the dropdown
		WardrobeOutfitFrame.popupDropDown = self;

		WardrobeOutfitFrame:EvaluateSaveState();
	end
end

local function InitializeCallback()
	FAT:Initialize()
end
E:RegisterModule(FAT:GetName(), InitializeCallback)