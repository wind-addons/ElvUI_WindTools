local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local DI = W:NewModule("DeleteItem", "AceEvent-3.0")
local S = W.Modules.Skins ---@type Skins
local C = W.Utilities.Color

local _G = _G
local strmatch = strmatch
local strsplit = strsplit
local pairs = pairs

local CreateFrame = CreateFrame
local StaticPopupDialogs = _G.StaticPopupDialogs
local StaticPopup_ForEachShownDialog = _G.StaticPopup_ForEachShownDialog

local DELETE_ITEM_CONFIRM_STRING = DELETE_ITEM_CONFIRM_STRING

local dialogs = {
	["DELETE_ITEM"] = true,
	["DELETE_GOOD_ITEM"] = true,
	["DELETE_QUEST_ITEM"] = true,
	["DELETE_GOOD_QUEST_ITEM"] = true,
}

function DI:AddKeySupport(dialog)
	local targetFrame = dialog

	if self.db.fillIn == "AUTO" and dialog.EditBox then
		targetFrame = dialog.EditBox
	end

	-- 添加说明
	if dialog.which ~= "DELETE_ITEM" then
		local msg = dialog.Text:GetText()
		local msgTable = { strsplit("\n\n", msg) }

		msg = ""

		for k, v in pairs(msgTable) do
			if (v ~= "") and (not strmatch(v, DELETE_ITEM_CONFIRM_STRING)) then
				msg = msg .. v .. "\n\n"
			end
		end

		msg = msg .. L["Press the |cffffd200Delete|r key as confirmation."]
		dialog.Text:SetText(msg)
	end

	-- 按键删除
	targetFrame:SetScript("OnKeyDown", function(self, key)
		if key == "DELETE" then
			dialog:GetButton1():Enable()
		end
	end)

	targetFrame:HookScript("OnHide", function(self)
		self:SetScript("OnKeyDown", nil)
	end)
end

function DI:ShowFillInButton(dialog)
	local editBoxFrame = dialog.EditBox
	local yesButton = dialog:GetButton1()
	if not editBoxFrame or not yesButton then
		return
	end

	-- 初始化填入按钮
	if not self.fillInButton then
		local button = CreateFrame("Button", "MyButton", E.UIParent, "UIPanelButtonTemplate")
		button:SetFrameStrata("TOOLTIP")
		S:Proxy("HandleButton", button)
		self.fillInButton = button
	end

	-- 覆盖住
	editBoxFrame:Hide()
	self.fillInButton:SetPoint("TOPLEFT", editBoxFrame, "TOPLEFT", -2, -4)
	self.fillInButton:SetPoint("BOTTOMRIGHT", editBoxFrame, "BOTTOMRIGHT", 2, 4)

	-- 点击后填入 Delete
	self.fillInButton:SetText(C.StringByTemplate(L["Click to confirm"], "rose-500"))
	self.fillInButton:SetScript("OnClick", function(self)
		yesButton:Enable()
		self:SetText("|cff2ecc71" .. L["Confirmed"] .. "|r")
	end)
	self.fillInButton:Show()
end

function DI.HideFillInButton()
	if DI.fillInButton then
		DI.fillInButton:Hide()
		DI.fillInButton:SetScript("OnClick", nil)
	end
end

function DI:DELETE_ITEM_CONFIRM()
	StaticPopup_ForEachShownDialog(function(dialog)
		local type = dialog.which
		if not dialogs[type] then
			return
		end

		if self.db.delKey then
			self:AddKeySupport(dialog)
		end

		-- Delete 填入
		if StaticPopupDialogs[type].hasEditBox == 1 then
			if self.db.fillIn == "CLICK" then
				self:ShowFillInButton(dialog)
				dialog:HookScript("OnHide", DI.HideFillInButton)
			elseif self.db.fillIn == "AUTO" then
				dialog.EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
			end
		end
	end)
end

function DI:Initialize()
	if not E.db.WT.item.delete.enable then
		return
	end

	self.db = E.db.WT.item.delete

	self:RegisterEvent("DELETE_ITEM_CONFIRM")
end

function DI:ProfileUpdate()
	if not E.db.WT.item.delete.enable then
		self:UnregisterEvent("DELETE_ITEM_CONFIRM")
	else
		self:Initialize()
	end
end

W:RegisterModule(DI:GetName())
