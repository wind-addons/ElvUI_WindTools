local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local hooksecurefunc = hooksecurefunc
local tinsert = tinsert
local tremove = tremove

local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local function SetClassColor(icon, class)
   local color = E:ClassColor(class, false)
   icon:SetVertexColor(color.r, color.g, color.b)
end

function M:LFGRoleIcons()
   if E.private.WT.misc.lfgRoleIcons then
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
                     icon:SetTexture(W.Media.Icons.lynUITank)
                     SetClassColor(icon, cache.TANK[1])
                     tremove(cache.TANK, 1)
                  elseif #cache.HEALER > 0 then
                     icon:SetTexture(W.Media.Icons.lynUIHealer)
                     SetClassColor(icon, cache.HEALER[1])
                     tremove(cache.HEALER, 1)
                  elseif #cache.DAMAGER > 0 then
                     icon:SetTexture(W.Media.Icons.lynUIDPS)
                     SetClassColor(icon, cache.DAMAGER[1])
                     tremove(cache.DAMAGER, 1)
                  else
                     icon:SetTexture(nil)
                  end
               end
            end
         end
      )
   end
end

M:AddCallback("LFGRoleIcons")
