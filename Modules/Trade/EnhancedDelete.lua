-- 原创模块

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule('WindTools');
local ED = E:NewModule("Wind_EnhancedDelete", "AceEvent-3.0", "AceHook-3.0")
local S = E:GetModule('Skins')
local strsplit = strsplit

ED.hookDeleteDialogs = {
	["DELETE_ITEM"] = true,
	["DELETE_GOOD_ITEM"] = true,
	["DELETE_QUEST_ITEM"] = true,
	["DELETE_GOOD_QUEST_ITEM"] = true,
}

function ED:ShowFillInButton(editBoxFrame)
	if not editBoxFrame then return end

	-- 初始化一个按钮
	if not self.fillInButton then
		local button = CreateFrame("Button", "MyButton", UIParent, "UIPanelButtonTemplate")
		button:SetFrameStrata("TOOLTIP")
		S:HandleButton(button) -- ElvUI 按钮美化
		self.fillInButton = button
	end
	
	-- 覆盖住
	self.fillInButton:SetPoint("TOPLEFT", editBoxFrame, "TOPLEFT", -2, -4)
	self.fillInButton:SetPoint("BOTTOMRIGHT", editBoxFrame, "BOTTOMRIGHT", 2, 4)

	-- 点击后填入 Delete
	self.fillInButton:SetText("|cffe74c3c"..L["Click to confirm"].."|r")
	self.fillInButton:SetScript("OnClick", function(self)
		editBoxFrame:SetText(DELETE_ITEM_CONFIRM_STRING)
		self:SetText("|cff2ecc71"..L["Confirmed"].."|r")
	end)
	self.fillInButton:Show()
end

function ED:HideFillInButton()
	if self.fillInButton then
		self.fillInButton:Hide()
		self.fillInButton:SetScript("OnClick", nil)
	end
end

function ED:DELETE_ITEM_CONFIRM(event)
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialog = _G["StaticPopup" .. i]
		local type = dialog.which
		if self.hookDeleteDialogs[type] then
			if self.db.use_delete_key then
				-- 添加说明
				local msg = dialog.text:GetText()
				local msgTable = {strsplit("\n\n", msg)}
				msg = ""
				for k, v in pairs(msgTable) do
					if (v ~= "") and (not strmatch(v, DELETE_ITEM_CONFIRM_STRING)) then
						msg = msg..v.."\n\n"
					end
				end
				msg = msg..L["You may also press the |cffffd200Delete|r key as confirmation."]
				dialog.text:SetText(msg)

				-- 按键删除
				dialog:SetScript("OnKeyDown", function(self, key) if key == "DELETE" then DeleteCursorItem() end end)
				dialog:HookScript("OnHide", function(self) self:SetScript("OnKeyDown", nil) end)
			end
			-- 点击填入
			if self.db.click_button_delete and StaticPopupDialogs[type].hasEditBox == 1 then
				self:ShowFillInButton(dialog.editBox)
				dialog:HookScript("OnHide", function(self) ED:HideFillInButton() end)
				dialog.editBox:ClearFocus()
			end
		end
	end
end

function ED:Initialize()
	self.db = E.db.WindTools["Trade"]["Enhanced Delete"]
	if not self.db.enabled then return end

	self:RegisterEvent("DELETE_ITEM_CONFIRM")
end

local function InitializeCallback()
    ED:Initialize()
end

E:RegisterModule(ED:GetName(), InitializeCallback)