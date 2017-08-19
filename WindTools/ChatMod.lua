-- Tab切换频道
-- 来源：EUI
-- 修改：houshuu

local E, _, DF = unpack(ElvUI)

local _G = _G
local CreateFrame = CreateFrame
local tostring = tostring
local GetNumSubgroupMembers = GetNumSubgroupMembers
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local IsInInstance = IsInInstance
local ChatEdit_UpdateHeader = ChatEdit_UpdateHeader
local IsInGuild = IsInGuild
local CanEditOfficerNote = CanEditOfficerNote
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local format = string.format
local hooksecurefunc = hooksecurefunc


function ChatEdit_CustomTabPressed(self) 
if strsub(tostring(self:GetText()), 1, 1) == "/" then return end 
   if  (self:GetAttribute("chatType") == "SAY")  then 
      if (GetNumSubgroupMembers()>0) then 
         self:SetAttribute("chatType", "PARTY"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
         ChatEdit_UpdateHeader(self); 
      elseif (GetNumGroupMembers()>0 and IsInRaid()) then 
         self:SetAttribute("chatType", "RAID"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         return; 
      end 
   elseif (self:GetAttribute("chatType") == "PARTY") then 
         if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
              ChatEdit_UpdateHeader(self); 
        elseif (GetNumGroupMembers()>0 and IsInRaid() ) then 
              self:SetAttribute("chatType", "RAID"); 
              ChatEdit_UpdateHeader(self); 
        elseif (IsInGuild()) then 
              self:SetAttribute("chatType", "GUILD"); 
              ChatEdit_UpdateHeader(self); 
         elseif (CanEditOfficerNote()) then 
              self:SetAttribute("chatType", "OFFICER"); 
              ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end         
   elseif (self:GetAttribute("chatType") == "INSTANCE_CHAT") then 
      if (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "RAID") then 
      if (IsInGuild) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "GUILD") then 
      if (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
          self:SetAttribute("chatType", "SAY"); 
          ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "OFFICER") then 
       self:SetAttribute("chatType", "SAY"); 
       ChatEdit_UpdateHeader(self); 
--密语切换开始 不需要的请从这删除 
--   elseif (self:GetAttribute("chatType") == "WHISPER") then 
--       self:SetAttribute("chatType", "SAY"); 
--       ChatEdit_UpdateHeader(self); 
--密语切换结束 删除到这里 
   elseif (self:GetAttribute("chatType") == "CHANNEL") then 
      if (GetNumSubgroupMembers()>0) then 
         self:SetAttribute("chatType", "PARTY"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
         ChatEdit_UpdateHeader(self); 
      elseif (GetNumGroupMembers()>0 and IsInRaid() ) then 
         self:SetAttribute("chatType", "RAID"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   end 
end 

local chatmod = CreateFrame("Frame")
chatmod:RegisterEvent("ADDON_LOADED")
chatmod:SetScript("OnEvent", function(self, event, ...)
	local addon = ...
	if event == "ADDON_LOADED" then
		self:UnregisterEvent("ADDON_LOADED")
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = format("ChatFrame%s",i)
			local box = _G[chat.."EditBox"]
			local lang = _G[chat.."EditBoxLanguage"]
			lang:ClearAllPoints()
			lang:SetPoint("LEFT", box, "RIGHT", E:Scale(3), 0)
			hooksecurefunc(lang, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset)
				if point ~= 'LEFT' or attachTo ~= box or anchorPoint ~= 'RIGHT' or xOffset ~= E:Scale(3) or yOffset ~= 0 then
					lang:SetPoint("LEFT", box, "RIGHT", E:Scale(3), 0)
				end
			end)
			lang:Size(box:GetHeight()-6)
			lang:StripTextures()
			lang:SetTemplate("Default", true)
		end
	end
end)