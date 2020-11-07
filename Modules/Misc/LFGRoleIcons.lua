local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local type = type

local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local function ReskinIcon(parent, icon, role, class)
   -- Same role icon with ElvUI
   if role then
      icon:SetTexture(W.Media.Textures.ROLES)
      icon:SetTexCoord(F.GetRoleTexCoord(role))
      icon:Size(16)
      icon:SetAlpha(0.9)
   else
      icon:SetAlpha(0)
   end

   -- Create bar in class color behind
   if not icon.back then
      local back = parent:CreateTexture(nil, "ARTWORK")
      back:SetTexture("Interface/Buttons/WHITE8X8")
      back:Size(16, 3)
      back:Point("TOP", icon, "BOTTOM", 0, -1)
      icon.back = back
   end

   if class then
      local color = E:ClassColor(class, false)
      icon.back:SetVertexColor(color.r, color.g, color.b)
      icon.back:SetAlpha(0.618)
   else
      icon.back:SetAlpha(0)
   end
end

function M:LFGRoleIcons()
   if not E.private.WT.misc.lfgRoleIcons then
      return
   end

   -- Raw hook for NetEase Meeting Stone libs
   if IsAddOnLoaded("MeetingStone") or IsAddOnLoaded("MeetingStonePlus") then
      local NetEaseEnv = LibStub("NetEaseEnv-1.0")

      for k in pairs(NetEaseEnv._NSInclude) do
         if type(k) == "table" then
            local module = k.Addon and k.Addon.GetClass and k.Addon:GetClass("MemberDisplay")
            if module and module.SetActivity then
               local original = module.SetActivity
               module.SetActivity = function(self, activity)
                  self.resultID = activity and activity.GetID and activity:GetID() or nil
                  original(self, activity)
               end
            end
         end
      end
   end

   hooksecurefunc(
      "LFGListGroupDataDisplayEnumerate_Update",
      function(Enumerate)
         local button = Enumerate:GetParent():GetParent()
         if not button.resultID then
            return
         end

         local result = C_LFGList_GetSearchResultInfo(button.resultID)

         if not result then
            return
         end

         local cache = {
            TANK = {},
            HEALER = {},
            DAMAGER = {}
         }

         for i = 1, result.numMembers do
            local role, class = C_LFGList_GetSearchResultMemberInfo(button.resultID, i)
            tinsert(cache[role], class)
         end

         for i = 5, 1, -1 do -- The index of icon starts from right
            local icon = Enumerate["Icon" .. i]
            if icon and icon.SetTexture then
               if #cache.TANK > 0 then
                  ReskinIcon(Enumerate, icon, "TANK", cache.TANK[1])
                  tremove(cache.TANK, 1)
               elseif #cache.HEALER > 0 then
                  ReskinIcon(Enumerate, icon, "HEALER", cache.HEALER[1])
                  tremove(cache.HEALER, 1)
               elseif #cache.DAMAGER > 0 then
                  ReskinIcon(Enumerate, icon, "DAMAGER", cache.DAMAGER[1])
                  tremove(cache.DAMAGER, 1)
               else
                  ReskinIcon(Enumerate, icon)
               end
            end
         end
      end
   )
end

M:AddCallback("LFGRoleIcons")
